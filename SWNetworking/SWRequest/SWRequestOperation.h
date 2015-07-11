//
//  SWRequestOperation.h
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
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SWResponseDataType.h"
#import "SWMedia.h"

@class SWResponseDataType;
@class SWRequestOperation;

@protocol SWRequestOperationDelegate <NSObject>

-(void)successWithOperation:(SWRequestOperation *)operation;
-(void)failWithOperation:(SWRequestOperation *)operation;

@end

@interface SWRequestOperation : NSOperation<NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSCoding, NSCopying>

/**
 The request used by the operation's connection.
 */

@property (readonly, nonatomic, retain) NSMutableURLRequest *request;


/**
 The user can pass custom object to append response
 */
@property(nonatomic, retain) id userObject;


/**
 response will store to the this object
 */
@property (readonly, nonatomic, strong) NSHTTPURLResponse *response;

/**
 User can get resonse to delegeate object
 */
@property(nonatomic, retain) id delegate;


/**
 Response will append to the response object
 */
@property (readonly, nonatomic, strong) NSMutableData *responseData;


/**
 *  response statuscdoe
 */
@property(readonly, nonatomic, assign) int statusCode;


@property(nonatomic, assign) int tag;

/**
 The error, if any, that occurred in the lifecycle of the request.
 */
@property (readonly, nonatomic, strong) NSError *error;

/**
 *  using this paramter user can send request automatically when connection awailable.
 */
@property (nonatomic, assign) BOOL sendRequestLaterWhenOnline;

/**
 *  response data type
 */
@property (nonatomic, retain) SWResponseDataType <SWResponseDataType> *responseDataType;

/**
 *  this is only use for add loading view
 */
@property (nonatomic, retain) UIView    *parentView;


@property (nonatomic, retain) NSDate *requestSavedDate;
/**
 *  set custom time out (seconds) default 60 seconds
 */
@property (nonatomic, assign) int timeOut;

@property (nonatomic, assign) BOOL wantToUseQueue;


-(NSString *)responseString;

-(void)createConnection;


#pragma mark request methods

-(void)setUploadProgressBlock:(void (^)(long  bytes,  long totalBytes,  long totalBytesExpected)) duploadProgressBlock;
-(void)setDownloadProgressBlock:(void (^)(long  bytes,  long totalBytes,  long totalBytesExpected)) downloadProgressBlock;

-(void)setSuccess:(void (^)(SWRequestOperation *operation, id responseObject))success
failure:(void (^)(SWRequestOperation *operation, NSError *error))failure;

-(void)startWithURL:(NSString *)url
         parameters:(id)parameters
            success:(void (^)(SWRequestOperation *operation, id responseObject))success
            failure:(void (^)(SWRequestOperation *operation, NSError *error))failure;

-(void)startWithURL:(NSString *)url
         parameters:(id)parameters
         parentView:(UIView *)parentView
            success:(void (^)(SWRequestOperation *operation, id responseObject))success
            failure:(void (^)(SWRequestOperation *operation, NSError *error))failure;


-(void)startWithURL:(NSString *)url
         parameters:(id)parameters
         parentView:(UIView *)parentView
         cachedData:(void (^)(NSCachedURLResponse *response, id responseObject))cache
            success:(void (^)(SWRequestOperation *operation, id responseObject))success
            failure:(void (^)(SWRequestOperation *operation, NSError *error))failure;


-(void)startWithURL:(NSString *)url
         parameters:(id)parameters
         parentView:(UIView *)parentView
 sendLaterIfOffline:(BOOL)sendLater
         cachedData:(void (^)(NSCachedURLResponse *response, id responseObject))cache
            success:(void (^)(SWRequestOperation *operation, id responseObject))success
            failure:(void (^)(SWRequestOperation *operation, NSError *error))failure;


@end

/**
 This interface can use send get reuqest. The super calss is SWRequestOperation
 */

@interface SWGETRequest : SWRequestOperation

@end



/**
 This interface can use send POST reuqest. The super calss is SWRequestOperation
 */

@interface SWMultPartRequest : SWRequestOperation

-(void)startMultipartWithURL:(NSString *)url
                       files:(NSArray *)files
                  parameters:(id)parameters
                     success:(void (^)(SWRequestOperation *operation, id responseObject))success
                     failure:(void (^)(SWRequestOperation *operation, NSError *error))failure;

-(void)startMultipartWithURL:(NSString *)url
                       files:(NSArray *)files
                  parameters:(id)parameters
                  parentView:(UIView *)parentView
                     success:(void (^)(SWRequestOperation *operation, id responseObject))success
                     failure:(void (^)(SWRequestOperation *operation, NSError *error))failure;


-(void)startMultipartWithURL:(NSString *)url
                       files:(NSArray *)files
                  parameters:(id)parameters
                  parentView:(UIView *)parentView
                  cachedData:(void (^)(NSCachedURLResponse *response, id responseObject))cache
                     success:(void (^)(SWRequestOperation *operation, id responseObject))success
                     failure:(void (^)(SWRequestOperation *operation, NSError *error))failure;


-(void)startMultipartWithURL:(NSString *)url
                       files:(NSArray *)files
                  parameters:(id)parameters
                  parentView:(UIView *)parentView
          sendLaterIfOffline:(BOOL)sendLater
                  cachedData:(void (^)(NSCachedURLResponse *response, id responseObject))cache
                     success:(void (^)(SWRequestOperation *operation, id responseObject))success
                     failure:(void (^)(SWRequestOperation *operation, NSError *error))failure;
@end



@interface SWPOSTRequest : SWMultPartRequest

@end


/**
 This interface can use send PUT reuqest. The super calss is SWRequestOperation
 */

@interface SWPUTRequest : SWMultPartRequest

@end

/**
 This interface can use send PATCH reuqest. The super calss is SWRequestOperation
 */

@interface SWPATCHRequest : SWMultPartRequest

@end

/**
 This interface can use send DELETE reuqest. The super calss is SWRequestOperation
 */

@interface SWDELETERequest : SWRequestOperation

@end

/**
 This interface can use send HEAD reuqest. The super calss is SWRequestOperation
 */

@interface SWHEADRequest : SWRequestOperation

@end