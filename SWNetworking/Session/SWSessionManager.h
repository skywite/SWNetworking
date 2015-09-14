//
//  SWSessionManager.h
//  SWNetworking
//
//  Created by Saman Kumara on 7/17/15.
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
#import "SWResponseDataType.h"
#import "SWRequestDataType.h"

/**
 * SWSessionManager interface will handle all the session that you want.
 */
@interface SWSessionManager : NSObject

/**
 * NSURLSession ojbect
 */
@property (readonly, nonatomic, strong) NSURLSession *session;

/**
 *  SWSessionManager response data type.
 */
@property (nonatomic, retain) SWResponseDataType <SWResponseDataType> *responseDataType;

/**
 *  SWSessionManager request data type
 */
@property (nonatomic, retain) SWRequestDataType <SWRequestDataType> *requestDataType;

/**
 *  init method with custmo congifuration.
 *
 *  @param configuration NSURLSessionConfiguration object
 *
 *  @return SWSessionManager object will return
 */
-(id)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration;

#pragma mark NSURLSessionUploadTask method

/**
 *  NSURLSessionUploadTask will start with Post HTTP method . progress, success, failue block.
 *
 *  @param url       upload url
 *  @param paramters parameters (NSDictionary or NSString)
 *  @param files     files array that user want to upload (SWMedia object need to include)
 *  @param success   success block
 *  @param failure   failure block
 *
 *  @return NSURLSessionUploadTask object will return
 */
-(NSURLSessionUploadTask *)uploadTaskWithPostURL:(NSString *)url
                                      parameters:(id)paramters
                                           files:(NSArray *)files
                                         success:(void (^)(NSURLSessionUploadTask *uploadTask, id responseObject))success
                                         failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;

/**
 *  NSURLSessionUploadTask will start with put HTTP method . progress, success, failue block.
 *
 *  @param url       upload url
 *  @param paramters parameters (NSDictionary or NSString)
 *  @param files     files array that user want to upload (SWMedia object need to include)
 *  @param success   success block
 *  @param failure   failure block
 *
 *  @return NSURLSessionUploadTask object will return
 */
-(NSURLSessionUploadTask *)uploadTaskWithPutURL:(NSString *)url
                                     parameters:(id)paramters
                                          files:(NSArray *)files
                                        success:(void (^)(NSURLSessionUploadTask *uploadTask, id responseObject))success
                                        failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;

/**
 *  NSURLSessionUploadTask will start with Patch HTTP method . progress, success, failue block.
 *
 *  @param url       upload url
 *  @param paramters parameters (NSDictionary or NSString)
 *  @param files     files array that user want to upload (SWMedia object need to include)
 *  @param success   success block
 *  @param failure   failure block
 *
 *  @return NSURLSessionUploadTask object will return
 */
-(NSURLSessionUploadTask *)uploadTaskWithPatchURL:(NSString *)url
                                       parameters:(id)paramters
                                            files:(NSArray *)files
                                          success:(void (^)(NSURLSessionUploadTask *uploadTask, id responseObject))success
                                          failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;


#pragma mark NSURLSessionUploadTask method

/**
 *  NSURLSessionDataTask will start with get HTTP method . progress, success, failue block.
 *
 *  @param url       data download url
 *  @param paramters parameters (NSDictionary or NSString)
 *  @param success   success block
 *  @param failure   failure block
 *
 *  @return NSURLSessionDataTask object will return
 */
-(NSURLSessionDataTask *)dataTaskWithGetURL:(NSString *)url
                                 parameters:(id)paramters
                                    success:(void (^)(NSURLSessionDataTask *uploadTask, id responseObject))success
                                    failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;

/**
 *  NSURLSessionDataTask will start with post HTTP method . progress, success, failue block.
 *
 *  @param url       data download url
 *  @param paramters parameters (NSDictionary or NSString)
 *  @param success   success block
 *  @param failure   failure block
 *
 *  @return NSURLSessionDataTask object will return
 */
-(NSURLSessionDataTask *)dataTaskWithPostURL:(NSString *)url
                                  parameters:(id)paramters
                                     success:(void (^)(NSURLSessionDataTask *uploadTask, id responseObject))success
                                     failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;

/**
 *  NSURLSessionDataTask will start with put HTTP method . progress, success, failue block.
 *
 *  @param url       data download url
 *  @param paramters parameters (NSDictionary or NSString)
 *  @param success   success block
 *  @param failure   failure block
 *
 *  @return NSURLSessionDataTask object will return
 */
-(NSURLSessionDataTask *)dataTaskWithPutURL:(NSString *)url
                                 parameters:(id)paramters
                                    success:(void (^)(NSURLSessionDataTask *uploadTask, id responseObject))success
                                    failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;

/**
 *  NSURLSessionDataTask will start with patch HTTP method . progress, success, failue block.
 *
 *  @param url       data download url
 *  @param paramters parameters (NSDictionary or NSString)
 *  @param success   success block
 *  @param failure   failure block
 *
 *  @return NSURLSessionDataTask object will return
 */
-(NSURLSessionDataTask *)dataTaskWithPatchURL:(NSString *)url
                                   parameters:(id)paramters
                                      success:(void (^)(NSURLSessionDataTask *uploadTask, id responseObject))success
                                      failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;

/**
 *  NSURLSessionDataTask will start with delete HTTP method . progress, success, failue block.
 *
 *  @param url       data download url
 *  @param paramters parameters (NSDictionary or NSString)
 *  @param success   success block
 *  @param failure   failure block
 *
 *  @return NSURLSessionDataTask object will return
 */
-(NSURLSessionDataTask *)dataTaskWithDeleteURL:(NSString *)url
                                    parameters:(id)paramters
                                       success:(void (^)(NSURLSessionDataTask *uploadTask, id responseObject))success
                                       failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;

/**
 *  NSURLSessionDataTask will start with head HTTP method . progress, success, failue block.
 *
 *  @param url       data download url
 *  @param paramters parameters (NSDictionary or NSString)
 *  @param success   success block
 *  @param failure   failure block
 *
 *  @return NSURLSessionDataTask object will return
 */
-(NSURLSessionDataTask *)dataTaskWithHeadURL:(NSString *)url
                                  parameters:(id)paramters
                                     success:(void (^)(NSURLSessionDataTask *uploadTask, id responseObject))success
                                     failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;

#pragma mark NSURLSessionDownloadTask method

/**
 *  NSURLSessionDownloadTask will start with get HTTP method . progress, success, failue block.
 *
 *  @param url         download url
 *  @param paramters   parameters (NSDictionary or NSString)
 *  @param downloadUrl the url that use want to download
 *  @param success     success block
 *  @param failure     failure block
 *
 *  @return NSURLSessionDownloadTask object will return
 */
-(NSURLSessionDownloadTask *)downloadTaskWithGetURL:(NSString *)url
                                         parameters:(id)paramters
                                         dowloadURL:(NSURL *)downloadUrl
                                            success:(void (^)(NSURLSessionDownloadTask *uploadTask, NSURL *location))success
                                            failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;

/**
 *  NSURLSessionDownloadTask will start with post HTTP method . progress, success, failue block.
 *
 *  @param url         download url
 *  @param paramters   parameters (NSDictionary or NSString)
 *  @param downloadUrl the url that use want to download
 *  @param success     success block
 *  @param failure     failure block
 *
 *  @return NSURLSessionDownloadTask object will return
 */
-(NSURLSessionDownloadTask *)downloadTaskWithPostURL:(NSString *)url
                                          parameters:(id)paramters
                                          dowloadURL:(NSURL *)downloadUrl
                                             success:(void (^)(NSURLSessionDownloadTask *uploadTask, NSURL *location))success
                                             failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;

/**
 *  NSURLSessionDownloadTask will start with put HTTP method . progress, success, failue block.
 *
 *  @param url         download url
 *  @param paramters   parameters (NSDictionary or NSString)
 *  @param downloadUrl the url that use want to download
 *  @param success     success block
 *  @param failure     failure block
 *
 *  @return NSURLSessionDownloadTask object will return
 */
-(NSURLSessionDownloadTask *)downloadTaskWithPutURL:(NSString *)url
                                         parameters:(id)paramters
                                         dowloadURL:(NSURL *)downloadUrl
                                            success:(void (^)(NSURLSessionDownloadTask *uploadTask, NSURL *location))success
                                            failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;

/**
 *  NSURLSessionDownloadTask will start with patch HTTP method . progress, success, failue block.
 *
 *  @param url         download url
 *  @param paramters   parameters (NSDictionary or NSString)
 *  @param downloadUrl the url that use want to download
 *  @param success     success block
 *  @param failure     failure block
 *
 *  @return NSURLSessionDownloadTask object will return
 */
-(NSURLSessionDownloadTask *)downloadTaskWithPatchURL:(NSString *)url
                                           parameters:(id)paramters
                                           dowloadURL:(NSURL *)downloadUrl
                                              success:(void (^)(NSURLSessionDownloadTask *uploadTask, NSURL *location))success
                                              failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;

/**
 *  NSURLSessionDownloadTask will start with delete HTTP method . progress, success, failue block.
 *
 *  @param url         download url
 *  @param paramters   parameters (NSDictionary or NSString)
 *  @param downloadUrl the url that use want to download
 *  @param success     success block
 *  @param failure     failure block
 *
 *  @return NSURLSessionDownloadTask object will return
 */
-(NSURLSessionDownloadTask *)downloadTaskWithDeleteURL:(NSString *)url
                                            parameters:(id)paramters
                                            dowloadURL:(NSURL *)downloadUrl
                                               success:(void (^)(NSURLSessionDownloadTask *uploadTask, NSURL *location))success
                                               failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;

/**
 *  NSURLSessionDownloadTask will start with head HTTP method . progress, success, failue block.
 *
 *  @param url         download url
 *  @param paramters   parameters (NSDictionary or NSString)
 *  @param downloadUrl the url that use want to download
 *  @param success     success block
 *  @param failure     failure block
 *
 *  @return NSURLSessionDownloadTask object will return
 */
-(NSURLSessionDownloadTask *)downloadTaskWithHeadURL:(NSString *)url
                                          parameters:(id)paramters
                                          dowloadURL:(NSURL *)downloadUrl
                                             success:(void (^)(NSURLSessionDownloadTask *uploadTask, NSURL *location))success
                                             failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure;

@end

/**
 * SessionBlockHandler interface will handle all the blocks and relevent objects
 */
@interface SessionBlockHandler : NSObject

/**
 * Upload progress block
 */
@property(nonatomic, strong) void (^uploadProgressBlock)(long long  bytesWritten,  long long totalBytesExpectedToWrite);

/**
 *  Download prgress block
 */
@property(nonatomic, strong) void (^downloadProgressBlock)(long long bytesWritten,  long long totalBytesExpectedToWrite);

/**
 *  Download success block
 */
@property(nonatomic, strong) void (^downloadSuccessBlock)(NSURLSessionDownloadTask *uploadTask, NSURL *location);

/**
 *  Data success block
 */
@property(nonatomic, strong) void (^dataSuccessBlock)(NSURLSessionDataTask *uploadTask, id responseObject);

/**
 *  upload success block
 */
@property(nonatomic, strong) void (^uploadSuccessBlock)(NSURLSessionUploadTask *uploadTask, id responseObject);

/**
 *  fail block
 */
@property(nonatomic, strong) void (^failureBlock)(NSURLSessionTask *task, NSError *error);

/**
 *  Response data(NSMutableData type)
 */
@property(nonatomic, strong) NSMutableData *responseData;

/**
 *  Response data type . SWResponseDataType object
 */
@property (nonatomic, retain) SWResponseDataType <SWResponseDataType> *responseDataType;


@end



@class SessionBlockHandler;
/**
 * NSURLSessionTask category for handle blocks
 */
@interface NSURLSessionTask (SessionCategory)

/**
 *  class method to get block handler
 *
 *  @return SessionBlockHandler object
 */
-(SessionBlockHandler *)blockHandler;

/**
 *  set bockhandler method
 *
 *  @param obj SessionBlockHandler object
 */
-(void)setBlockHandler:(SessionBlockHandler *)obj;

/**
 *  failure block set method
 *
 *  @param failure block
 */
-(void)setFailureBlock:(void (^)(NSURLSessionTask *task, NSError *error))failure;

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
-(void)setDownloadProgressBlock:(void (^)(long long bytesWritten,  long long totalBytesExpectedToWrite)) downloadProgressBlock;

/**
 *  Using this method user can set download success block
 *
 *  @param success block
 */
-(void)setDownloadSuccessBlock:(void (^)(NSURLSessionDownloadTask *uploadTask, NSURL *location))success;

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
-(void)setDataSuccessBlock:(void (^)(NSURLSessionDataTask *uploadTask, id responseObject))success;

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
-(void)setUploadProgressBlock:(void (^)(long long bytesWritten,  long long totalBytesExpectedToWrite)) downloadProgressBlock;

/**
 *  Using this method user can set file upload success block
 *
 *  @param success block
 */
-(void)setUploadSuccessBlock:(void (^)(NSURLSessionUploadTask *uploadTask, id responseObject))success;

@end

