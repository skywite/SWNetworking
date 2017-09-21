//
//  SWRequest.h
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
#if TARGET_OS_IOS || TARGET_OS_TV
#import <UIKit/UIKit.h>
#endif
#import "SWResponseDataType.h"
#import "SWRequestDataType.h"
#import "SWMedia.h"

@class SWResponseDataType;
@class SWRequest;

/**
 This is Enum for the Task type
 */
typedef enum {
    DataTask,
    DownloadTask,
    UploadTask
} TaskType;


/**
 * SWRequest created for handle send multiple type request (eg: GET, POST, DELETE, etc). It sub class for NSObject.. It will help to create task.
 */
@interface SWRequest : NSObject< NSCoding, NSCopying>

/**
 This is generated task
 */
@property (readonly,nonatomic, strong) NSURLSessionTask *sessionTask;

/**
 This is read only property. it will assing according to the tast type
 */
@property (readonly, nonatomic, assign) TaskType taskType;

/**
 The request used by the task
 */
@property (readonly, nonatomic, retain) NSMutableURLRequest *request;


/**
 The user can pass custom object to append response
 */
@property(nonatomic, retain) id userObject;


/**
 Response will store to the this object
 */
@property (readonly, nonatomic, strong) NSHTTPURLResponse *response;

/**
 Response will append to the response object
 */
@property (readonly, nonatomic, strong) NSMutableData *responseData;

/**
 *  Response statuscdoe
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

#if TARGET_OS_IOS || TARGET_OS_TV
/**
 *  this is only use for add loading view
 */
@property (nonatomic, retain) UIView    *parentView;

#elif TARGET_OS_MAC
@property (nonatomic, retain) NSView    *parentView;
#endif
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
- (NSString *)responseString;

/**
 *  When calling this method user can see response as a string
 *  @param encoding NSStringEncoding type
 *  @return response as NSString
 */
- (NSString *)responseStringWithEncoding:(NSStringEncoding) encoding;

/**
 *  This method will create session task with parameters and URL
 */
- (void)createSession;

/**
 * when calling this method task will cancel
 */
- (void)cancel;

#pragma mark request methods
/**
 *  This method can use to set Upload progress block
 *
 *  @param uploadProgressBlock Response will be bytesWritten and total bytes expected
 */
- (void)setUploadProgressBlock:(void (^)(long long  bytesWritten,  long long totalBytesExpectedToWrite)) uploadProgressBlock;
/**
 *  This method can use to set Download progress block
 *
 *  @param downloadProgressBlock Response will be bytesWritten , totalBytesWritten and total bytes expected
 */
- (void)setDownloadProgressBlock:(void (^)(long long  bytesWritten, long long totalBytesWritten,  long long totalBytesExpectedToWrite)) downloadProgressBlock;

/**
 *  This method can use cath the upload success and failure
 *  @param success    success block
 *  @param failure    failure block
 */
- (void)setUploadSuccess:(void (^)(NSURLSessionUploadTask *uploadTask, id responseObject))success
                failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;

/**
 *  This method can use to set success and failure block for the data task
 *
 *  @param success    success block
 *  @param failure    failure block
 */
- (void)setDataSuccess:(void (^)(NSURLSessionDataTask *uploadTask, id responseObject))success
              failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;

/**
 *  This method can use to set success and failure block for the Download task
 *
 *  @param success    success block
 *  @param failure    failure block
 */
- (void)setDownloadSuccess:(void (^)(NSURLSessionDownloadTask *uploadTask, NSURL *location))success
                  failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;


/**
 *  This method will help to generate request with different parameters
 *
 *  @param resumeData The resume Data
 *  @param success    success block
 *  @param failure    failure block
 */
- (void)startDownloadwithResumeData:(NSData *) resumeData
                            success:(void (^)(NSURLSessionDownloadTask *uploadTask, NSURL *location))success
                            failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;

/**
 *  This method will help to generate request with different parameters
 *
 *  @param url        The request URL
 *  @param parameters The parameters. This should be NSDictionray or String.
 *  @param success    success block
 *  @param failure    failure block
 */
- (void)startDownloadTaskWithURL:(NSString *)url
                     parameters:(id)parameters
                        success:(void (^)(NSURLSessionDownloadTask *uploadTask, NSURL *location))success
                        failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;
/**
 *  This method will help to generate request with different parameters
 *
 *  @param url        The request URL
 *  @param parameters The parameters. This should be NSDictionray or String.
 *  @param parentView parent view. This will help to add loading view.
 *  @param success    success block
 *  @param failure    failure block
 */
- (void)startDownloadTaskWithURL:(NSString *)url
                     parameters:(id)parameters
                     parentView:(id)parentView
                        success:(void (^)(NSURLSessionDownloadTask *uploadTask, NSURL *location))success
                        failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;

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
- (void)startDownloadTaskWithURL:(NSString *)url
                     parameters:(id)parameters
                     parentView:(id)parentView
                     cachedData:(void (^)(NSCachedURLResponse *response, id responseObject))cache
                        success:(void (^)(NSURLSessionDownloadTask *uploadTask, NSURL *location))success
                        failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;

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
- (void)startDownloadTaskWithURL:(NSString *)url
                     parameters:(id)parameters
                     parentView:(id)parentView
             sendLaterIfOffline:(BOOL)sendLater
                     cachedData:(void (^)(NSCachedURLResponse *response, id responseObject))cache
                        success:(void (^)(NSURLSessionDownloadTask *uploadTask, NSURL *location))success
                        failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;



#pragma mark starting data task

/**
 *  This method will help to generate request with different parameters
 *
 *  @param url        The request URL
 *  @param parameters The parameters. This should be NSDictionray or String.
 *  @param success    success block
 *  @param failure    failure block
 */
- (void)startDataTaskWithURL:(NSString *)url
                 parameters:(id)parameters
                    success:(void (^)(NSURLSessionDataTask *uploadTask, id responseObject))success
                    failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;
/**
 *  This method will help to generate request with different parameters
 *
 *  @param url        The request URL
 *  @param parameters The parameters. This should be NSDictionray or String.
 *  @param parentView parent view. This will help to add loading view.
 *  @param success    success block
 *  @param failure    failure block
 */
- (void)startDataTaskWithURL:(NSString *)url
                 parameters:(id)parameters
                 parentView:(id)parentView
                    success:(void (^)(NSURLSessionDataTask *uploadTask, id responseObject))success
                    failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;

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
- (void)startDataTaskWithURL:(NSString *)url
                 parameters:(id)parameters
                 parentView:(id)parentView
                 cachedData:(void (^)(NSCachedURLResponse *response, id responseObject))cache
                    success:(void (^)(NSURLSessionDataTask *uploadTask, id responseObject))success
                    failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;

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
- (void)startDataTaskWithURL:(NSString *)url
                 parameters:(id)parameters
                 parentView:(id)parentView
         sendLaterIfOffline:(BOOL)sendLater
                 cachedData:(void (^)(NSCachedURLResponse *response, id responseObject))cache
                    success:(void (^)(NSURLSessionDataTask *uploadTask, id responseObject))success
                    failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;



@end

/**
 This interface can use send get reuqest. The super calss is SWRequest
 */

@interface SWGETRequest : SWRequest

@end


/**
 This interface can use send POST reuqest with mulitpart form data. The super calss is SWRequest
 */

@interface SWMultPartRequest : SWRequest

/**
 *  This method will help to generate multipart request with different parameters
 *
 *  @param url        The request URL
 *  @param files      The files array. This array should be SWMedia
 *  @param parameters The parameters. This should be NSDictionray or String.
 *  @param success    success block
 *  @param failure    failure block
 */
- (void)startUploadTaskWithURL:(NSString *)url
                        files:(NSArray *)files
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionUploadTask *uploadTask, id responseObject))success
                      failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;

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
- (void)startUploadTaskWithURL:(NSString *)url
                        files:(NSArray *)files
                   parameters:(id)parameters
                   parentView:(id)parentView
                      success:(void (^)(NSURLSessionUploadTask *uploadTask, id responseObject))success
                      failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;

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
- (void)startUploadTaskWithURL:(NSString *)url
                        files:(NSArray *)files
                   parameters:(id)parameters
                   parentView:(id)parentView
                   cachedData:(void (^)(NSCachedURLResponse *response, id responseObject))cache
                      success:(void (^)(NSURLSessionUploadTask *uploadTask, id responseObject))success
                      failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;

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
- (void)startUploadTaskWithURL:(NSString *)url
                        files:(NSArray *)files
                   parameters:(id)parameters
                   parentView:(id)parentView
           sendLaterIfOffline:(BOOL)sendLater
                   cachedData:(void (^)(NSCachedURLResponse *response, id responseObject))cache
                      success:(void (^)(NSURLSessionUploadTask *uploadTask, id responseObject))success
                      failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;
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
 This interface can use send DELETE reuqest. The super calss is SWRequest
 */

@interface SWDELETERequest : SWRequest

@end

/**
 This interface can use send HEAD reuqest. The super calss is SWRequest
 */

@interface SWHEADRequest : SWRequest

@end


/**
 This is Interface that use for shared property
 */
@interface SharedManager : NSObject

/**
 The session object that can shared
 */
@property (nonatomic, strong) NSURLSession                  *currentSession;
/**
 The runnig task dictionaray
 */
@property (nonatomic, strong) NSMutableDictionary           *runningTasks;
/**
 The Queue that used for for session
 */
@property (nonatomic, strong) NSOperationQueue              *operationQueue;

/**
 The Session Configuration for Session
 */
@property (nonatomic, strong) NSURLSessionConfiguration       *configuration;

/**
 The maxium request count
 */
@property (nonatomic, assign) int                             maxConcurrentRequestCount;

/**
 Singletons object will retrun when call this method 
 */
+ (id)sharedManager;
@end

/**
 * NSURLSessionTask category for handle blocks
 */
@interface NSURLSessionTask (SessionCategory)

/**
 *  class method to get block handler
 *
 *  @return SessionBlockHandler object
 */
- (SWRequest *)swRequest;

/**
 *  set bockhandler method
 *
 *  @param obj SessionBlockHandler object
 */
- (void)setSwRequest:(SWRequest *)obj;

/**
 *  failure block set method
 *
 *  @param failure block
 */
- (void)setFailureBlock:(void (^)(NSURLSessionTask *task, NSError *error))failure;

@end

/**
 * NSURLSessionDownloadTask category for handle blocks
 */
@interface NSURLSessionDownloadTask (SessionDownloadCategory)

/**
 *  Using this method user can set download progress block
 *
 *  @param downloadProgressBlock block
 */
- (void)setDownloadProgressBlock:(void (^)(long long bytesWritten,long long totalBytesWritten,  long long totalBytesExpectedToWrite)) downloadProgressBlock;

/**
 *  Using this method user can set download success block
 *
 *  @param success block
 */
- (void)setDownloadSuccessBlock:(void (^)(NSURLSessionDownloadTask *uploadTask, NSURL *location))success;

@end

/**
 * NSURLSessionDataTask category for handle blocks
 
 */
@interface NSURLSessionDataTask (SessionDataCategory)

/**
 *  Using this method user can set data success block
 *
 *  @param success block
 */
- (void)setDataSuccessBlock:(void (^)(NSURLSessionDataTask *uploadTask, id responseObject))success;

@end

/**
 * NSURLSessionUploadTask category for handle blocks
 */
@interface NSURLSessionUploadTask (SessionDownloadCategory)

/**
 *  Using this method user can set file upload progress block
 *
 *  @param downloadProgressBlock block
 */
- (void)setUploadProgressBlock:(void (^)(long long bytesWritten,  long long totalBytesExpectedToWrite)) downloadProgressBlock;

/**
 *  Using this method user can set file upload success block
 *
 *  @param success block
 */
- (void)setUploadSuccessBlock:(void (^)(NSURLSessionUploadTask *uploadTask, id responseObject))success;

@end
