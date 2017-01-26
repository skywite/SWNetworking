//
//  SWOfflineRequestManger.h
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

#import <Foundation/Foundation.h>
#import "SWRequest.h"
@interface SWOfflineRequestManger : NSObject

/**
 *  This method need to trigger before start offline request.
 *
 *  @param seconds afte given secon saved request will be deleted automatically
 *
 *  @return return SWOfflineRequestManger object instance
 */
+ (instancetype)requestExpireTime:(long) seconds;

/**
 *  User can get shared instance using this
 *
 *  @return return SWOfflineRequestManger object instance
 */
+ (instancetype)sharedInstance;


/**
 *  users can get currently saved offline requests using this method
 *
 *  @return return NSArray will return NSArray object
 */
- (NSArray *)offlineOparations;

/**
 *  If you want to request to send later you can use this method
 *
 *  @param requestOperation the operation request that you want to save
 *
 *  @return return BOOL will return operation save status
 */
- (BOOL)addRequestForSendLater:(SWRequest *)requestOperation;

/**
 *  if you want to delete reqeust from saved list you need to call this method
 *
 *  @param requestOperation requestOperation the operation request that you want to delete
 */
- (void)removeRequest:(SWRequest *)requestOperation;

/**
 *  Calling this method all the saved request will be deleted
 */
- (void)removeAllRequests;

/**
 *  If you want to catch request when success/fail you need to call this method. you need to set tag relevent reqeust to identify request
 *
 *  @param success success success block
 *  @param fail    fail fail block
 */
- (void)requestSuccessBlock:(void (^)(SWRequest *oparation, id responseObject))success requestFailBlock:(void (^)(SWRequest *oparation,  NSError *error))fail;
@end
