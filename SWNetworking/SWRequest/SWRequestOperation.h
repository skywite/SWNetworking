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
//https://github.com/skywite
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SWResponseDataType.h"
#import "SWRequestDataType.h"
#import "SWMedia.h"

@class SWResponseDataType;
@class SWRequestOperation;

/**
 * SWRequestOperation created for handle send multiple type request (eg: GET, POST, DELETE, etc). It sub class for NSOperation.. It will help to create nsoperation quere.
 */
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

/**
 *  This is tag. Can assing int value
 */
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

/**
 *  This time will use to save reqeuest send time
 */
@property (nonatomic, retain) NSDate *requestSavedDate;

/**
 *  set custom time out (seconds) default 60 seconds
 */
@property (nonatomic, assign) int timeOut;

/**
 *  Bool value need to set YES if some one want to use queue
 */
@property (nonatomic, assign) BOOL wantToUseQueue;

/**
 *  This one need to set for generate html body
 */
@property (nonatomic, retain) SWRequestDataType <SWRequestDataType> *requestDataType;

/**
 *  When calling this method user can see response as a string
 *
 *  @return response as NSString
 */
-(NSString *)responseString;

/**
 *  This method will create connection with parameters and URL
 */
-(void)createConnection;


#pragma mark request methods
/**
 *  This method can use to set Upload progress block
 *
 *  @param uploadProgressBlock Response will be byetes , total bytes(uploaded) and total bytes expected
 */
-(void)setUploadProgressBlock:(void (^)(long long  bytes,  long long totalBytes,  long long totalBytesExpected)) uploadProgressBlock;
/**
 *  This method can use to set Download progress block
 *
 *  @param downloadProgressBlock Response will be byetes , total bytes(downloaded) and total bytes expected
 */
-(void)setDownloadProgressBlock:(void (^)(long long  bytes,  long long totalBytes,  long long totalBytesExpected)) downloadProgressBlock;
/**
 *  This method can use to set success and failure block
 *
 *  @param success    success block
 *  @param failure    failure block
 */
-(void)setSuccess:(void (^)(SWRequestOperation *operation, id responseObject))success
failure:(void (^)(SWRequestOperation *operation, NSError *error))failure;

/**
 *  This method will help to generate request with different parameters
 *
 *  @param url        The request URL
 *  @param parameters The parameters. This should be NSDictionray or String.
 *  @param success    success block
 *  @param failure    failure block
 */
-(void)startWithURL:(NSString *)url
         parameters:(id)parameters
            success:(void (^)(SWRequestOperation *operation, id responseObject))success
            failure:(void (^)(SWRequestOperation *operation, NSError *error))failure;
/**
 *  This method will help to generate request with different parameters
 *
 *  @param url        The request URL
 *  @param parameters The parameters. This should be NSDictionray or String.
 *  @param parentView parent view. This will help to add loading view.
 *  @param success    success block
 *  @param failure    failure block
 */
-(void)startWithURL:(NSString *)url
         parameters:(id)parameters
         parentView:(UIView *)parentView
            success:(void (^)(SWRequestOperation *operation, id responseObject))success
            failure:(void (^)(SWRequestOperation *operation, NSError *error))failure;

/**
 *  This method will help to generate request with different parameters
 *
 *  @param url        The request URL
 *  @param parameters The parameters. This should be NSDictionray or String.
 *  @param parentView parent view. This will help to add loading view.
 *  @param cache      Cache response block.
 *  @param success    success block
 *  @param failure    failure block
 */
-(void)startWithURL:(NSString *)url
         parameters:(id)parameters
         parentView:(UIView *)parentView
         cachedData:(void (^)(NSCachedURLResponse *response, id responseObject))cache
            success:(void (^)(SWRequestOperation *operation, id responseObject))success
            failure:(void (^)(SWRequestOperation *operation, NSError *error))failure;

/**
 *  This method will help to generate request with different parameters
 *
 *  @param url        The request URL
 *  @param parameters The parameters. This should be NSDictionray or String.
 *  @param parentView parent view. This will help to add loading view.
 *  @param sendLater  To send offline request, User need to set YES.
 *  @param cache      Cache response block.
 *  @param success    success block
 *  @param failure    failure block
 */
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
 This interface can use send POST reuqest with mulitpart form data. The super calss is SWRequestOperation
 */

@interface SWMultPartRequest : SWRequestOperation

/**
 *  This method will help to generate multipart request with different parameters
 *
 *  @param url        The request URL
 *  @param files      The files array. This array should be SWMedia
 *  @param parameters The parameters. This should be NSDictionray or String.
 *  @param success    success block
 *  @param failure    failure block
 */
-(void)startMultipartWithURL:(NSString *)url
                       files:(NSArray *)files
                  parameters:(id)parameters
                     success:(void (^)(SWRequestOperation *operation, id responseObject))success
                     failure:(void (^)(SWRequestOperation *operation, NSError *error))failure;

/**
 *  This method will help to generate multipart request with different parameters
 *
 *  @param url        The request URL
 *  @param files      The files array. This array should be SWMedia.
 *  @param parameters The parameters. This should be NSDictionray or String.
 *  @param parentView parent view. This will help to add loading view.
 *  @param success    success block
 *  @param failure    failure block
 */
-(void)startMultipartWithURL:(NSString *)url
                       files:(NSArray *)files
                  parameters:(id)parameters
                  parentView:(UIView *)parentView
                     success:(void (^)(SWRequestOperation *operation, id responseObject))success
                     failure:(void (^)(SWRequestOperation *operation, NSError *error))failure;

/**
 *  This method will help to generate multipart request with different parameters
 *
 *  @param url        The request URL
 *  @param files      The files array. This array should be SWMedia.
 *  @param parameters The parameters. This should be NSDictionray or String.
 *  @param parentView parent view. This will help to add loading view.
 *  @param cache      Cache response block.
 *  @param success    success block
 *  @param failure    failure block
 */
-(void)startMultipartWithURL:(NSString *)url
                       files:(NSArray *)files
                  parameters:(id)parameters
                  parentView:(UIView *)parentView
                  cachedData:(void (^)(NSCachedURLResponse *response, id responseObject))cache
                     success:(void (^)(SWRequestOperation *operation, id responseObject))success
                     failure:(void (^)(SWRequestOperation *operation, NSError *error))failure;

/**
 *  This method will help to generate multipart request with different parameters
 *
 *  @param url        The request URL
 *  @param files      The files array. This array should be SWMedia.
 *  @param parameters The parameters. This should be NSDictionray or String.
 *  @param parentView parent view. This will help to add loading view.
 *  @param sendLater  To send offline request, User need to set YES.
 *  @param cache      Cache response block.
 *  @param success    success block
 *  @param failure    failure block
 */
-(void)startMultipartWithURL:(NSString *)url
                       files:(NSArray *)files
                  parameters:(id)parameters
                  parentView:(UIView *)parentView
          sendLaterIfOffline:(BOOL)sendLater
                  cachedData:(void (^)(NSCachedURLResponse *response, id responseObject))cache
                     success:(void (^)(SWRequestOperation *operation, id responseObject))success
                     failure:(void (^)(SWRequestOperation *operation, NSError *error))failure;
@end

/**
 This interface can use send POST reuqest. The super calss is SWMultPartRequest
 */

@interface SWPOSTRequest : SWMultPartRequest

@end


/**
 This interface can use send PUT reuqest. The super calss is SWMultPartRequest
 */

@interface SWPUTRequest : SWMultPartRequest

@end

/**
 This interface can use send PATCH reuqest. The super calss is SWMultPartRequest
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