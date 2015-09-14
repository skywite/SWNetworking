//
//  SWOperationManger.h
//  SWNetworking
//
//  Created by Saman Kumara on 4/6/15.
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
#import "SWRequestOperation.h"

/**
 *  SWOperationManger created for handle operation queue
 */
@interface SWOperationManger : NSObject

/**
 *  NSOperationQueue object
 */
@property (nonatomic, strong) NSOperationQueue *operationQueue;

/**
 *  Operation Count on NSOperationQueue
 */
@property (readonly) NSUInteger operationCount NS_AVAILABLE(10_6, 4_0);

/**
 *  This need to YES if you want to send offline request
 */
@property (readonly, assign) BOOL sendOfflineRequestLater;

/**
 * SWResponseDataType object need to set to response serialization. Default is SWResponseStringDataType type  
 */
@property (nonatomic, retain) SWResponseDataType <SWResponseDataType> *responseDataType;

/**
 *  When calling this method user can get all the running operations
 *
 *  @return SWRequestOperation object array
 */
-(NSArray *)getOperations;

/**
 *  Calling this user can get operation count
 *
 *  @return operation count
 */
-(NSInteger)getOperationCount;
/**
 *  User can add new opearation to operation manger. SWRequestOperation property (wantToUseQueue) need to YES before add this manager.
 *
 *  @param block Opearation bolck
 */
-(void)addOperationWithBlock:(void (^)(void))block NS_AVAILABLE(10_6, 4_0);

/**
 *  Set max operation count for the NSOperationQueue
 *
 *  @param count NSInteger count
 */
-(void)setMaxOperationCount:(NSInteger )count;

/**
*  User can add new opearation to operation manger. SWRequestOperation property (wantToUseQueue) need to YES before add this manager.
 *
 *  @param operation NSOperation object (SWRequestOperation)
 */
-(void)addOperation:(NSOperation *) operation;

@end
