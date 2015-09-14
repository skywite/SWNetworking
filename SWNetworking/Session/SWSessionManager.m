//
//  SWSessionManager.m
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

#import <objc/runtime.h>
#import "SWSessionManager.h"
#import "SWRequestDataType.h"

@interface SWSessionManager()<NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate, NSCoding, NSCopying>

@property (readwrite, nonatomic, strong) NSURLSession                   *session;
@property (readwrite, nonatomic, strong) NSOperationQueue               *operationQueue;
@property (readwrite, nonatomic, strong) NSURLSessionConfiguration      *sessionConfiguration;
@property (nonatomic, retain) NSSet                                     *availableInURLMethods;
@property (nonatomic,strong) NSMutableDictionary                        *runningTasks;

@end
@implementation SWSessionManager

-(NSMutableURLRequest *)getRequestFromMethod:(NSString *)method url:(NSString *)url{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = method;

    return request;
}
-(id)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration{
    if (self = [super init]) {
        if (!configuration) {
            configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        }
        self.sessionConfiguration = configuration;
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.operationQueue.maxConcurrentOperationCount = 1;
        
        self.session = [NSURLSession sessionWithConfiguration:self.sessionConfiguration delegate:self delegateQueue:self.operationQueue];
        self.runningTasks = [[NSMutableDictionary alloc]init];
        self.requestDataType = [SWRequestFormData type];
        self.availableInURLMethods = [NSSet setWithObjects:@"GET", @"HEAD", @"DELETE", nil];

    }
    
    return self;
}


-(NSURLSessionUploadTask *)uploadTaskWithURL:(NSString *)url
                                      method:(NSString *)method
                                  parameters:(id)paramters
                                       files:(NSArray *)files
                                     success:(void (^)(NSURLSessionUploadTask *uploadTask, id responseObject))success
                                     failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure{
    
    NSMutableURLRequest *request = [self getRequestFromMethod:method url:url];
    
    [self.requestDataType dataWithFile:files paremeters:paramters];
    
    if (![self.availableInURLMethods containsObject:[request HTTPMethod]]) {
        [request setValue:[self.requestDataType getContentType] forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[request.HTTPBody length]] forHTTPHeaderField:@"Content-Length"];
    }
    
    NSURLSessionUploadTask * task = [self.session uploadTaskWithRequest:request fromData:[self.requestDataType getRequestBodyData]];
    
    SessionBlockHandler *handler    = [[SessionBlockHandler alloc]init];
    handler.responseDataType        = self.responseDataType;
    
    [task setFailureBlock:failure];
    [task setBlockHandler:handler];
    [task setUploadSuccessBlock:success];
    

    [self.runningTasks setObject:task forKey:@(task.taskIdentifier)];

    return task;

}


-(NSURLSessionUploadTask *)uploadTaskWithPostURL:(NSString *)url
                                      parameters:(id)paramters
                                           files:(NSArray *)files
                                         success:(void (^)(NSURLSessionUploadTask *uploadTask, id responseObject))success
                                         failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure{
    
    return [self uploadTaskWithURL:url method:@"POST" parameters:paramters files:files success:success failure:failure];
}


-(NSURLSessionUploadTask *)uploadTaskWithPutURL:(NSString *)url
                                     parameters:(id)paramters
                                          files:(NSArray *)files
                                        success:(void (^)(NSURLSessionUploadTask *uploadTask, id responseObject))success
                                        failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure{

    return [self uploadTaskWithURL:url method:@"PUT" parameters:paramters files:files success:success failure:failure];
}

-(NSURLSessionUploadTask *)uploadTaskWithPatchURL:(NSString *)url
                                       parameters:(id)paramters
                                            files:(NSArray *)files
                                          success:(void (^)(NSURLSessionUploadTask *uploadTask, id responseObject))success
                                          failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure{

    return [self uploadTaskWithURL:url method:@"PATCH" parameters:paramters files:files success:success failure:failure];
}



#pragma mark NSURLSessionUploadTask method
-(NSURLSessionDataTask *)dataTaskWithURL:(NSString *)url
                                  method:(NSString *)method
                              parameters:(id)paramters
                                 success:(void (^)(NSURLSessionDataTask *uploadTask, id responseObject))success
                                 failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure{
    
    NSMutableURLRequest *request = [self getRequestFromMethod:method url:url];

    [self.requestDataType dataWithFile:nil paremeters:paramters];
    
    if (![self.availableInURLMethods containsObject:[request HTTPMethod]]) {
        [request setValue:[self.requestDataType getContentType] forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:[self.requestDataType getRequestBodyData]];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[request.HTTPBody length]] forHTTPHeaderField:@"Content-Length"];
    }else{
        NSString *quearyString = [(SWRequestFormData *)self.requestDataType getQueryString];
        
        if ([url localizedCaseInsensitiveContainsString:@"?"]) {
            [request setURL:[[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@&%@",url,quearyString]]];
        }else{
            [request setURL:[[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@?%@",url,quearyString]]];
        }
    }
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request];
    
    SessionBlockHandler *handler    = [[SessionBlockHandler alloc]init];
    handler.responseDataType        = self.responseDataType;
    
    [task setBlockHandler:handler];
    [task setFailureBlock:failure];
    
    [self.runningTasks setObject:task forKey:@(task.taskIdentifier)];
    
    return task;
}

-(NSURLSessionDataTask *)dataTaskWithGetURL:(NSString *)url
                                 parameters:(id)paramters
                                    success:(void (^)(NSURLSessionDataTask *uploadTask, id responseObject))success
                                    failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure{
    return [self dataTaskWithURL:url method:@"GET" parameters:paramters success:success failure:failure];
}

-(NSURLSessionDataTask *)dataTaskWithPostURL:(NSString *)url
                                  parameters:(id)paramters
                                     success:(void (^)(NSURLSessionDataTask *uploadTask, id responseObject))success
                                     failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure{
    return [self dataTaskWithURL:url method:@"POST" parameters:paramters success:success failure:failure];
}

-(NSURLSessionDataTask *)dataTaskWithPutURL:(NSString *)url
                                 parameters:(id)paramters
                                    success:(void (^)(NSURLSessionDataTask *uploadTask, id responseObject))success
                                    failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure{
    return [self dataTaskWithURL:url method:@"PUT" parameters:paramters success:success failure:failure];
}

-(NSURLSessionDataTask *)dataTaskWithPatchURL:(NSString *)url
                                   parameters:(id)paramters
                                      success:(void (^)(NSURLSessionDataTask *uploadTask, id responseObject))success
                                      failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure{
    return [self dataTaskWithURL:url method:@"PATCH" parameters:paramters success:success failure:failure];
}

-(NSURLSessionDataTask *)dataTaskWithDeleteURL:(NSString *)url
                                    parameters:(id)paramters
                                       success:(void (^)(NSURLSessionDataTask *uploadTask, id responseObject))success
                                       failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure{
    return [self dataTaskWithURL:url method:@"DELETE" parameters:paramters success:success failure:failure];

}

-(NSURLSessionDataTask *)dataTaskWithHeadURL:(NSString *)url
                                  parameters:(id)paramters
                                     success:(void (^)(NSURLSessionDataTask *uploadTask, id responseObject))success
                                     failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure{
    return [self dataTaskWithURL:url method:@"HEAD" parameters:paramters success:success failure:failure];

}



#pragma mark NSURLSessionDownloadTask method

-(NSURLSessionDownloadTask *)downloadTaskWithURL:(NSString *)url
                                             method:(NSString *)method
                                         parameters:(id)paramters
                                         dowloadURL:(NSURL *)downloadUrl
                                            success:(void (^)(NSURLSessionDownloadTask *uploadTask, NSURL *location))success
                                            failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure{
    
    NSMutableURLRequest *request = [self getRequestFromMethod:method url:url];

    [self.requestDataType dataWithFile:nil paremeters:paramters];
    
    if (![self.availableInURLMethods containsObject:[request HTTPMethod]]) {
        [request setValue:[self.requestDataType getContentType] forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:[self.requestDataType getRequestBodyData]];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[request.HTTPBody length]] forHTTPHeaderField:@"Content-Length"];
    }else{
        NSString *quearyString = [(SWRequestFormData *)self.requestDataType getQueryString];
        
        if ([url localizedCaseInsensitiveContainsString:@"?"]) {
            [request setURL:[[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@&%@",url,quearyString]]];
        }else{
            [request setURL:[[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@?%@",url,quearyString]]];
        }
    }
    
    NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithRequest:request];
    
    SessionBlockHandler *handler    = [[SessionBlockHandler alloc]init];
    handler.responseDataType        = self.responseDataType;
    
    [downloadTask setBlockHandler:handler];
    [downloadTask setDownloadSuccessBlock:success];
    [downloadTask setFailureBlock:failure];
    
   [self.runningTasks setObject:downloadTask forKey:@(downloadTask.taskIdentifier)];

    return downloadTask;
}

-(NSURLSessionDownloadTask *)downloadTaskWithGetURL:(NSString *)url
                                         parameters:(id)paramters
                                         dowloadURL:(NSURL *)downloadUrl
                                            success:(void (^)(NSURLSessionDownloadTask *uploadTask, NSURL *location))success
                                            failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure{
    return [self downloadTaskWithURL:url method:@"GET" parameters:paramters dowloadURL:downloadUrl success:success failure:failure];
    
}

-(NSURLSessionDownloadTask *)downloadTaskWithPostURL:(NSString *)url
                                          parameters:(id)paramters
                                          dowloadURL:(NSURL *)downloadUrl
                                             success:(void (^)(NSURLSessionDownloadTask *uploadTask, NSURL *location))success
                                             failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure{
    return [self downloadTaskWithURL:url method:@"POST" parameters:paramters dowloadURL:downloadUrl success:success failure:failure];
}

-(NSURLSessionDownloadTask *)downloadTaskWithPutURL:(NSString *)url
                                         parameters:(id)paramters
                                         dowloadURL:(NSURL *)downloadUrl
                                            success:(void (^)(NSURLSessionDownloadTask *uploadTask, NSURL *location))success
                                            failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure{
    return [self downloadTaskWithURL:url method:@"PUT" parameters:paramters dowloadURL:downloadUrl success:success failure:failure];
}

-(NSURLSessionDownloadTask *)downloadTaskWithPatchURL:(NSString *)url
                                           parameters:(id)paramters
                                           dowloadURL:(NSURL *)downloadUrl
                                              success:(void (^)(NSURLSessionDownloadTask *uploadTask, NSURL *location))success
                                              failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure{
    return [self downloadTaskWithURL:url method:@"PATCH" parameters:paramters dowloadURL:downloadUrl success:success failure:failure];
}

-(NSURLSessionDownloadTask *)downloadTaskWithDeleteURL:(NSString *)url
                                            parameters:(id)paramters
                                            dowloadURL:(NSURL *)downloadUrl
                                               success:(void (^)(NSURLSessionDownloadTask *uploadTask, NSURL *location))success
                                               failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure{
    return [self downloadTaskWithURL:url method:@"DELETE" parameters:paramters dowloadURL:downloadUrl success:success failure:failure];
}

-(NSURLSessionDownloadTask *)downloadTaskWithHeadURL:(NSString *)url
                                          parameters:(id)paramters
                                          dowloadURL:(NSURL *)downloadUrl
                                             success:(void (^)(NSURLSessionDownloadTask *uploadTask, NSURL *location))success
                                             failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure{
    return [self downloadTaskWithURL:url method:@"HEAD" parameters:paramters dowloadURL:downloadUrl success:success failure:failure];
}

#pragma mark NSCordering

- (id)initWithCoder:(NSCoder *)coder{
    self = [self init];
    _session = [coder decodeObjectForKey:@"session"];
    _requestDataType= [coder decodeObjectForKey:@"requestDataType"];
    _responseDataType = [coder decodeObjectForKey:@"responseDataType"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    
    if (self.session != nil) [coder encodeObject:self.session forKey:@"session"];
    if (self.requestDataType != nil) [coder encodeObject:self.requestDataType forKey:@"requestDataType"];
    if (self.responseDataType != nil) [coder encodeObject:self.responseDataType forKey:@"responseDataType"];
    
}

- (id)copyWithZone:(NSZone *)zone {
    SWSessionManager *manager = [[self.class allocWithZone:zone]init];
    manager -> _session = self.session;
    manager -> _requestDataType = self.requestDataType;
    manager -> _responseDataType = self.responseDataType;
    return manager;
}

#pragma mark NSURLSessionUploadTask delegates
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
                                didSendBodyData:(int64_t)bytesSent
                                 totalBytesSent:(int64_t)totalBytesSent
                       totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    
    if (task.blockHandler && task.blockHandler.uploadProgressBlock) {
        task.blockHandler.uploadProgressBlock(totalBytesSent, totalBytesExpectedToSend);
    }
}


#pragma mark NSURLSessionDownloadTask delegates

- (void)URLSession:(__unused NSURLSession *)session downloadTask:(__unused NSURLSessionDownloadTask *)downloadTask
                                                    didWriteData:(__unused int64_t)bytesWritten
                                               totalBytesWritten:(int64_t)totalBytesWritten
                                       totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    if (downloadTask.blockHandler && downloadTask.blockHandler.downloadProgressBlock) {
        downloadTask.blockHandler.downloadProgressBlock(bytesWritten, totalBytesExpectedToWrite);
    }
}

- (void)URLSession:(__unused NSURLSession *)session downloadTask:(__unused NSURLSessionDownloadTask *)downloadTask
                                               didResumeAtOffset:(__unused int64_t)bytesWritten
                                              expectedTotalBytes:(int64_t)totalBytesExpectedToWrite {
    
    if (downloadTask.blockHandler && downloadTask.blockHandler.downloadProgressBlock) {
        downloadTask.blockHandler.downloadProgressBlock(bytesWritten, totalBytesExpectedToWrite);
    }
}

- (void)URLSession:(NSURLSession * )session downloadTask:(NSURLSessionDownloadTask *)downloadTask
                               didFinishDownloadingToURL:(NSURL * )location{
    
    if (downloadTask.blockHandler && downloadTask.blockHandler.downloadSuccessBlock) {
        downloadTask.blockHandler.downloadSuccessBlock(downloadTask, location);
    }
}

#pragma mark NSURLSessionDataTask delegates



- (void)URLSession:(NSURLSession * )session dataTask:(NSURLSessionDataTask * )dataTask
                               didBecomeDownloadTask:(NSURLSessionDownloadTask * )downloadTask{

}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask * )dataTask didReceiveData:(NSData * )data{
    
    if (!dataTask.blockHandler) {
        dataTask.blockHandler = [[SessionBlockHandler alloc]init];
    }
    if (dataTask.blockHandler.responseData) {
        dataTask.blockHandler.responseData = [[NSMutableData alloc]initWithData:data];
    }else{
        [dataTask.blockHandler.responseData appendData:data];
    }
}

#pragma NSURLSessionTaskDelegate mark

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
    NSLog(@"%@", error);
    if (error) {
        if (task.blockHandler) {
            task.blockHandler.failureBlock(task, error);
        }
    }else{
        if (task.blockHandler && task.blockHandler.dataSuccessBlock) {
            task.blockHandler.dataSuccessBlock((NSURLSessionDataTask *)task, [task.blockHandler.responseDataType responseOjbectFromdData:task.blockHandler.responseData]);
            task.blockHandler.dataSuccessBlock = nil;
        }
        if (task.blockHandler && task.blockHandler.uploadSuccessBlock) {
            task.blockHandler.uploadSuccessBlock((NSURLSessionUploadTask *)task, [task.blockHandler.responseDataType responseOjbectFromdData:task.blockHandler.responseData]);
            task.blockHandler.uploadProgressBlock = nil;
        }
    }
}


@end


@implementation SessionBlockHandler


@end


@interface NSURLSessionTask ()

@property (nonatomic, strong) SessionBlockHandler *blockHandler;

@end



@implementation NSObject (SessionDownloadCategory)

-(void)setFailureBlock:(void (^)(NSURLSessionTask *task, NSError *error))failure{
    
    NSURLSessionTask *task = (NSURLSessionTask *)self;
    if(task.blockHandler){
        task.blockHandler.failureBlock = failure;
    }else{
        SessionBlockHandler *handler  = [[SessionBlockHandler alloc]init];
        handler.failureBlock = failure;
        task.blockHandler = handler;
    }
}
-(void)setDownloadProgressBlock:(void (^)(long long bytesWritten,  long long totalBytesExpectedToWrite)) downloadProgressBlock{
    
    NSURLSessionDownloadTask *task = (NSURLSessionDownloadTask *)self;
    if(task.blockHandler){
        task.blockHandler.downloadProgressBlock = downloadProgressBlock;
    }else{
        SessionBlockHandler *handler  = [[SessionBlockHandler alloc]init];
        handler.downloadProgressBlock = downloadProgressBlock;
        task.blockHandler = handler;
    }
}


-(void)setDownloadSuccessBlock:(void (^)(NSURLSessionDownloadTask *uploadTask, NSURL *location))success{
    
    NSURLSessionDataTask *task = (NSURLSessionDataTask *)self;
    if(task.blockHandler){
        task.blockHandler.downloadSuccessBlock = success;
    }else{
        SessionBlockHandler *handler  = [[SessionBlockHandler alloc]init];
        handler.downloadSuccessBlock = success;
        task.blockHandler = handler;
    }
}

-(void)setDataSuccessBlock:(void (^)(NSURLSessionDataTask *uploadTask, id responseObject))success{
    
    NSURLSessionDataTask *task = (NSURLSessionDataTask *)self;
    if(task.blockHandler){
        task.blockHandler.dataSuccessBlock = success;
    }else{
        SessionBlockHandler *handler  = [[SessionBlockHandler alloc]init];
        handler.dataSuccessBlock = success;
        task.blockHandler = handler;
    }
}

-(void)setUploadProgressBlock:(void (^)(long long bytesWritten,  long long totalBytesExpectedToWrite)) uploadProgressBlock{
    
    NSURLSessionUploadTask *task = (NSURLSessionUploadTask *)self;
    if(task.blockHandler){
        task.blockHandler.uploadProgressBlock = uploadProgressBlock;
    }else{
        SessionBlockHandler *handler  = [[SessionBlockHandler alloc]init];
        handler.uploadProgressBlock = uploadProgressBlock;
        task.blockHandler = handler;
    }
}

-(void)setUploadSuccessBlock:(void (^)(NSURLSessionUploadTask *uploadTask, id responseObject))success{
    
    NSURLSessionUploadTask *task = (NSURLSessionUploadTask *)self;
    if(task.blockHandler){
        task.blockHandler.uploadSuccessBlock = success;
    }else{
        SessionBlockHandler *handler  = [[SessionBlockHandler alloc]init];
        handler.uploadSuccessBlock = success;
        task.blockHandler = handler;
    }
}

-(void)setUploadFailureBlock:(void (^)(NSURLSessionUploadTask *task, NSError *error))failure{
    NSURLSessionUploadTask *task = (NSURLSessionUploadTask *)self;
    if(task.blockHandler){
        task.blockHandler.uploadFailureBlock = failure;
    }else{
        SessionBlockHandler *handler  = [[SessionBlockHandler alloc]init];
        handler.uploadSuccessBlock = failure;
        task.blockHandler = handler;
    }
}
-(SessionBlockHandler *)blockHandler{
    return objc_getAssociatedObject(self, @selector(blockHandler));
}

-(void)setBlockHandler:(SessionBlockHandler *)obj{
    objc_setAssociatedObject(self, @selector(blockHandler), obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
