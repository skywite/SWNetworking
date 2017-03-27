//
//  SWOfflineRequestManger.m
//  SWNetworking
//
//  Created by Saman Kumara on 4/13/15.
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
// THE SOFTWARE.
//https://github.com/skywite
//

#import "SWOfflineRequestManger.h"
#import "SWReachability.h"
#import "SWRequest.h"

NSString *const USER_DEFAULT_KEY = @"SWOfflineReqeustsOnUserDefault";

@interface SWOfflineRequestManger()

@property(nonatomic, assign) long expireTime;

@property(nonatomic, copy) void (^requestSuccessBlock)(SWRequest *oparation, id responseObject);

@property(nonatomic, copy) void (^requestFailBlock)(SWRequest *oparation,  NSError *error);

@end

static SWOfflineRequestManger *instance = nil;

static dispatch_once_t onceToken;

@implementation SWOfflineRequestManger

+ (instancetype)requestExpireTime:(long) seconds {
    dispatch_once(&onceToken, ^{
        instance = [[SWOfflineRequestManger alloc] init];
    });
    instance.expireTime = seconds;
    [instance startReachabilityStatus];
    return instance;
}

+ (instancetype)sharedInstance {
    dispatch_once(&onceToken, ^{
        instance = [[SWOfflineRequestManger alloc] init];
    });
    return instance;
}


- (void)requestSuccessBlock:(void (^)(SWRequest *oparation, id responseObject))success requestFailBlock:(void (^)(SWRequest *oparation,  NSError *error))fail {
    self.requestSuccessBlock    = success;
    self.requestFailBlock       = fail;
}
- (void)startReachabilityStatus {
    [SWReachability checkCurrentStatus:^(SWNetworkingReachabilityStatus currentStatus) {
        if (currentStatus != SWNetworkingReachabilityStatusNotReachable) {
            [self createOperations];
        }
    } statusChange:^(SWNetworkingReachabilityStatus changedStatus) {
        
        if (changedStatus != SWNetworkingReachabilityStatusNotReachable) {
            [self createOperations];
        }
    }];
}

- (void)createOperations {
    for (SWRequest *operetion in [self offlineOparations]) {
         __weak SWRequest *weakOperation = operetion;
        [operetion createSession];
        if (operetion.taskType == UploadTask) {
            [operetion setUploadSuccess:^(NSURLSessionUploadTask *uploadTask, id responseObject) {
                if (self.requestSuccessBlock) {
                    self.requestSuccessBlock(uploadTask.swRequest,responseObject);
                }
                [self removeRequest:weakOperation];
            } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
                if (self.requestFailBlock) {
                    self.requestFailBlock(uploadTask.swRequest, error);
                }
            }];
        }else if (operetion.taskType == DownloadTask) {
            [operetion setDownloadSuccess:^(NSURLSessionDownloadTask *downloadTask, NSURL *location) {
                if (self.requestSuccessBlock) {
                    self.requestSuccessBlock(downloadTask.swRequest,nil);
                }
                [self removeRequest:weakOperation];
            } failure:^(NSURLSessionTask *downloadTask, NSError *error) {
                if (self.requestFailBlock) {
                    self.requestFailBlock(downloadTask.swRequest, error);
                }
            }];
        }else {
            [operetion setDataSuccess:^(NSURLSessionDataTask *dataTask, id responseObject) {
                if (self.requestSuccessBlock) {
                    self.requestSuccessBlock(dataTask.swRequest,responseObject);
                }
                [self removeRequest:weakOperation];
            } failure:^(NSURLSessionTask *dataTask, NSError *error) {
                if (self.requestFailBlock) {
                    self.requestFailBlock(dataTask.swRequest, error);
                }
            }];
        }
    }
}

- (void)removeRequest:(SWRequest *)requestOperation {
    NSData *selectedData;
    for (NSData *data in [self getSavedArray]) {
        SWRequest * operation = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([operation.requestSavedDate timeIntervalSinceReferenceDate] == [requestOperation.requestSavedDate timeIntervalSinceReferenceDate]){
            selectedData = data;
            break;
        }
    }
    
    if (selectedData) {
        NSMutableArray *array = [self getSavedArray];
        [array removeObject:selectedData];
        
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:USER_DEFAULT_KEY];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}
- (NSArray *)offlineOparations {
    NSMutableArray  *array = [[NSMutableArray alloc]init];
    for (NSData *data in [self getSavedArray]) {
        SWRequest * operation = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([operation.requestSavedDate timeIntervalSinceReferenceDate] > self.expireTime){
            [array addObject:operation];
        }
    }    
    return array;
}

- (void)removeAllRequests {
    [self saveRequests:[[NSMutableArray alloc]init]];
}
- (void)saveRequests:(NSMutableArray *)list {
    NSMutableArray  *array = [[NSMutableArray alloc]init];
    for (SWRequest *operation in list) {
        NSData* archivedOperation = [NSKeyedArchiver archivedDataWithRootObject:operation];
        [array addObject:archivedOperation];
    }
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:USER_DEFAULT_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (BOOL)addRequestForSendLater:(SWRequest *)requestOperation {
    requestOperation.requestSavedDate = [NSDate new];
    NSMutableArray *array = [self getSavedArray];
    NSData* archivedOperation = [NSKeyedArchiver archivedDataWithRootObject:requestOperation];
    [array addObject:archivedOperation];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:USER_DEFAULT_KEY];
    
    return [[NSUserDefaults standardUserDefaults]synchronize];
}

- (NSMutableArray *)getSavedArray {
    if ([[NSUserDefaults standardUserDefaults]objectForKey:USER_DEFAULT_KEY]) {
        return [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:USER_DEFAULT_KEY]];
    }else{
        return [[NSMutableArray alloc]init];
    }
}



@end
