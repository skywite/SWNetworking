//
//  SWReachability.m
//  SWNetworking
//
//  Created by Saman Kumara on 5/22/15.
//  Copyright (c) 2015 Saman Kumara. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFT

#import <ifaddrs.h>
#import <netdb.h>
#import <sys/socket.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <objc/runtime.h>

#import "SWReachability.h"


@interface SWReachabilityHandler : NSObject

@property (nonatomic , copy) void (^changedStatus)(SWNetworingReachabilityStatus changedStatus);

@end


@implementation SWReachabilityHandler


- (void) checkNetworkStatus:(NSNotification *)notice{
    
    self.changedStatus([SWReachability getCurrentNetworkStatus]);
    
}


@end

NSString *kSWReachabilityChangedNotification = @"kSWReachabilityChangedNotification";
static const char KConnectionHandler;

static void SWReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)

{
    
    NSCAssert(info != NULL, @"info was NULL in SWReachabilityCallback");
    
    [[NSNotificationCenter defaultCenter] postNotificationName: kSWReachabilityChangedNotification object: nil];
    
}



@interface SWReachability(){
}
@property (nonatomic, assign)  SCNetworkReachabilityRef reachability;
;
@property (readwrite, nonatomic, assign) SWNetworingReachabilityStatus networkReachabilityStatus;

@end
@implementation SWReachability

+(SWNetworingReachabilityStatus)getCurrentNetworkStatus{
    SWReachability *reachability = [[SWReachability alloc]init];
    return [reachability getCurrentNetworkStatus];
}

+(BOOL)connected{
    SWReachability *reachability = [[SWReachability alloc]init];
    return [reachability connected];
}

+(void)checkCurrentStatus:(void (^)(SWNetworingReachabilityStatus currentStatus)) currentStatus statusChange:(void (^)(SWNetworingReachabilityStatus changedStatus))changedStatus{
    
    SWReachabilityHandler *handler = [[SWReachabilityHandler alloc]init];
    
    objc_setAssociatedObject(self, &KConnectionHandler, handler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    handler.changedStatus = changedStatus;
    
    [[NSNotificationCenter defaultCenter] addObserver:handler
                                             selector:@selector(checkNetworkStatus:) name:kSWReachabilityChangedNotification object:nil];
    

    SWReachability *reachability = [[SWReachability alloc]init];

    currentStatus([reachability getCurrentNetworkStatus]);
    

    [reachability startNotifying];

}

-(BOOL)connected{
    if ([self getCurrentNetworkStatus] == SWNetworkReachabilityStatusNotReachable) {
        return NO;
    }
    return YES;
}

-(SWNetworingReachabilityStatus)getCurrentNetworkStatus{
    
    struct sockaddr_in zeroAddress;
    
    bzero(&zeroAddress, sizeof(zeroAddress));
    
    zeroAddress.sin_len = sizeof(zeroAddress);
    
    zeroAddress.sin_family = AF_INET;
    
    self.reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    
    
    if(self.reachability != NULL) {
        //NetworkStatus retVal = NotReachable;
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(self.reachability, &flags)) {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0){
                // if target host is not reachable
                self.networkReachabilityStatus = SWNetworkReachabilityStatusNotReachable;
                return self.networkReachabilityStatus;
            }
            
            self.networkReachabilityStatus = SWNetworkReachabilityStatusNotReachable;
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0){
                // if target host is reachable and no connection is required
                //  then we'll assume (for now) that your on Wi-Fi
                self.networkReachabilityStatus = SWNetworkReachabilityStatusReachableViaWiFi;
            }
            
            
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)){
                // ... and the connection is on-demand (or on-traffic) if the
                //     calling application is using the CFSocketStream or higher APIs
                
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0){
                    // ... and no [user] intervention is needed wifi
                    //self.networkReachabilityStatus = SWNetworkReachabilityStatusReachableViaWiFi;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN){
                // ... but WWAN connections are OK if the calling application
                //     is using the CFNetwork (CFSocketStream?) APIs.
                self.networkReachabilityStatus = SWNetworkReachabilityStatusReachableViaWWAN;
            }
        }
    }
    
    return self.networkReachabilityStatus;
}

-(void)startNotifying{
    

    SCNetworkReachabilityContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
        
    if (SCNetworkReachabilitySetCallback(self.reachability, SWReachabilityCallback, &context)){
        
        SCNetworkReachabilityScheduleWithRunLoop(self.reachability, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    }
}
- (void)stopNotifying

{
    if (self.reachability != NULL){
        
        SCNetworkReachabilityUnscheduleFromRunLoop(self.reachability, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    }
    
}


@end
