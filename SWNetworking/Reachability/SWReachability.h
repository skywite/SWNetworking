//
//  SWReachability.h
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
//https://github.com/skywite
//

#import <Foundation/Foundation.h>




extern NSString *kSWReachabilityChangedNotification;

/**
 *  Reachamitly status, three states available.SWNetworkReachabilityStatusNotReachable,SWNetworkReachabilityStatusReachableViaWWAN,SWNetworkReachabilityStatusReachableViaWiFi are the status
 */

typedef NS_ENUM(NSInteger, SWNetworkingReachabilityStatus) {
    SWNetworkingReachabilityStatusNotReachable = 0,
    SWNetworkingReachabilityStatusReachableViaWWAN = 1,
    SWNetworkingReachabilityStatusReachableViaWiFi = 2,
};

@interface SWReachability : NSObject

/**
 *  Reachamitly status, three states available.SWNetworkReachabilityStatusNotReachable,SWNetworkReachabilityStatusReachableViaWWAN,SWNetworkReachabilityStatusReachableViaWiFi are the status
 */
@property (readonly, nonatomic, assign) SWNetworkingReachabilityStatus networkReachabilityStatus;

/**
 *  Calling this current status will return - Class methods
 *
 *  @return Currnt Status
 */
+ (SWNetworkingReachabilityStatus)getCurrentNetworkStatus;

/**
 *  Check simply network availabily - Class methods
 *
 *  @return If network available will return YES, else NO
 */
+ (BOOL)connected;

/**
 *  This will work like notification. When Change states this will automatically comes to the block - Class methods
 *
 *  @param currentStatus current network status
 *  @param changedStatus changed network status
 */
+ (void)checkCurrentStatus:(void (^)(SWNetworkingReachabilityStatus currentStatus)) currentStatus statusChange:(void (^)(SWNetworkingReachabilityStatus changedStatus))changedStatus;


/**
 *  Check simply network availabily - Instance methods
 *
 *  @return If network available will return YES, else NO
 */
- (BOOL)connected;

/**
 *  Calling this current status will return - Instance methods
 *
 *  @return Currnt Status
 */
- (SWNetworkingReachabilityStatus)getCurrentNetworkStatus;

/**
 *  calling this method will start notification will start .
 */
- (void)startNotifying;

@end
