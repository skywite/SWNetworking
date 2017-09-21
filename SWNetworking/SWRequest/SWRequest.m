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
 #import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "SWRequest.h"
#import "SWOfflineRequestManger.h"
#import "SWReachability.h"

@interface SWRequest() <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate> {}

@property (readwrite, nonatomic, retain) NSMutableURLRequest    *request;
@property (readwrite, nonatomic, strong) NSHTTPURLResponse      *response;
@property (readwrite, nonatomic, strong) NSMutableData          *responseData;
@property(readwrite, nonatomic, assign) int                     statusCode;
@property (nonatomic, retain) NSURLConnection                   *connection;
@property (nonatomic, retain) NSString                          *method;
@property (nonatomic, retain) NSSet                             *availableInURLMethods;
@property (readwrite, nonatomic, strong) NSError                *error;

#if TARGET_OS_IOS || TARGET_OS_TV
@property (nonatomic, retain) UIView                            *backgroundView;
#elif TARGET_OS_MAC
@property (nonatomic, retain) NSView                            *backgroundView;
#endif
@property (nonatomic, assign) BOOL                              isMultipart;
@property (nonatomic, retain) NSArray                           *files;
@property (nonatomic, strong) NSURLSessionTask                  *sessionTask;
@property (readwrite, nonatomic, assign) TaskType               taskType;

@property(nonatomic, copy) void (^uploadProgressBlock)(long long  bytesWritten,  long long totalBytesExpectedToWrite);
@property(nonatomic, copy) void (^downloadProgressBlock)(long long  bytesWritten, long long totalBytesWritten,  long long totalBytesExpectedToWrite);
@property(nonatomic, copy) void (^failBlock)(NSURLSessionTask *dataTask,  NSError *error);
@property(nonatomic, copy) void (^downloadSuccessBlock)(NSURLSessionDownloadTask *uploadTask, NSURL *location);
@property(nonatomic, copy) void (^uploadSuccessBlock)(NSURLSessionUploadTask *uploadTask, id responseObject);
@property(nonatomic, copy) void (^dataSuccessBlock)(NSURLSessionDataTask *dataTask, id responseObject);
@property(nonatomic, copy) void (^cacheBlock)(NSCachedURLResponse *response,  id responseObject);

- (NSString *)responseString;

@end

@implementation SWRequest


- (void)cancel {
    if (self.sessionTask.state == NSURLSessionTaskStateRunning) {
        [self.sessionTask cancel];
        self.responseData = [NSMutableData data];
    }
}

- (id)init{
    if(self = [super init]){
        self.request = [[NSMutableURLRequest alloc] init];
        self.responseData = [NSMutableData data];
        self.availableInURLMethods = [NSSet setWithObjects:@"GET", @"HEAD", @"DELETE", nil];
        self.responseDataType = [SWResponseDataType type];
        self.requestDataType = [SWRequestFormData type];
        self.isMultipart = NO;
        self.sendRequestLaterWhenOnline = NO;
        self.timeOut = 60;
        self.wantToUseQueue = NO;

    }
    return self;
}

- (void)showNetworkActivityIndicator:(BOOL)show {
    #if TARGET_OS_IOS || TARGET_OS_WATCH
	if ( ![[UIApplication class] respondsToSelector:@selector(sharedApplication) ] ) {
		return;
	}
	UIApplication *application = [[UIApplication class] performSelector:@selector(sharedApplication)];
	application.networkActivityIndicatorVisible = show;
    #endif
}

- (void)createSession{
	[self showNetworkActivityIndicator:YES];
    
    SharedManager * manager = [SharedManager sharedManager];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    if (manager.configuration) {
        configuration = manager.configuration;
    }
    if (!manager.currentSession) {
        manager.currentSession = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:manager.operationQueue];
    }
    
    if (self.taskType == UploadTask) {
        self.sessionTask = [manager.currentSession uploadTaskWithRequest:self.request fromData:[self.requestDataType getRequestBodyData]];
    }else if (self.taskType == DownloadTask) {
        self.sessionTask = [manager.currentSession downloadTaskWithRequest:self.request];
    }else {
        self.sessionTask = [manager.currentSession dataTaskWithRequest:self.request];
    }
    self.responseData = [NSMutableData data];
    [self.sessionTask setSwRequest:self];
    [self.sessionTask resume];
    [manager.runningTasks setObject:self.sessionTask forKey:@(self.sessionTask.taskIdentifier)];
}

- (void)addLoadingView {
#if TARGET_OS_IOS || TARGET_OS_TV
    self.backgroundView = [[UIView alloc]initWithFrame:self.parentView.frame];
    self.backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    UIView *roundedView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    roundedView.backgroundColor = [UIColor blackColor];
    
    [[roundedView layer] setCornerRadius:5.0];
    [[roundedView layer] setMasksToBounds:YES];
    [[roundedView layer] setBorderWidth:1.0];
    [[roundedView layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    
    UIActivityIndicatorView * indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicator startAnimating];
    [indicator setCenter:CGPointMake(roundedView.frame.size.width /2, ((roundedView.frame.size.height/2)))];

    NSArray *nib = nil;
    BOOL found = YES;
    @try {
        nib = [[NSBundle mainBundle] loadNibNamed:@"sw_loadingView" owner:self options:nil];
    }
    @catch (NSException *exception) {
        found = NO;
    }
    @finally {
        if (found) {
            roundedView = [nib objectAtIndex:0];
            self.backgroundView.center = self.parentView.center;
        }else{
            [roundedView addSubview:indicator];
        }
        roundedView.center = self.parentView.center;
        [self.backgroundView addSubview:roundedView];
        [self.parentView insertSubview:self.backgroundView atIndex:1000];
    }
#elif TARGET_OS_MAC
    self.backgroundView = [[NSView alloc]initWithFrame:self.parentView.frame];
    [self.backgroundView setWantsLayer:YES];
    self.backgroundView.layer.backgroundColor = [[NSColor colorWithRed:0 green:0 blue:0 alpha:0.5]CGColor];
    NSView *roundedView = [[NSView alloc]initWithFrame:CGRectMake((self.backgroundView.frame.size.width /2 - 50), (self.backgroundView.frame.size.height/2 - 50), 100, 100)];
    [roundedView setWantsLayer:YES];

    roundedView.layer.backgroundColor = [[NSColor blackColor]CGColor];
    
    [[roundedView layer] setCornerRadius:5.0];
    [[roundedView layer] setMasksToBounds:YES];
    [[roundedView layer] setBorderWidth:1.0];
    [[roundedView layer] setBorderColor:[[NSColor whiteColor] CGColor]];
    
    NSProgressIndicator* indicator = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect((roundedView.frame.size.width /2 - 15), (roundedView.frame.size.height/2 - 15), 30, 30)];
    [indicator setStyle:NSProgressIndicatorSpinningStyle];
    [indicator startAnimation:nil];
    CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
    [lighten setDefaults];
    [lighten setValue:@1 forKey:@"inputBrightness"];
    [indicator setContentFilters:[NSArray arrayWithObjects:lighten, nil]];
    
     [roundedView addSubview:indicator];
    
    [self.backgroundView addSubview:roundedView];
    [self.parentView addSubview:self.backgroundView];
#endif
}

- (void )startWithURL:(NSString *)url
          parameters:(id)parameters {
    
    [self.request setHTTPMethod:self.method];
    
    if (url.length> 0) {
        [self.request setURL:[[NSURL alloc]initWithString:url]];
    }else{
        NSParameterAssert(url);
    }
    
    [self.requestDataType dataWithFile:self.files paremeters:parameters];

    if (![self.availableInURLMethods containsObject:[[self.request HTTPMethod] uppercaseString]]) {
        
        if (![self.request valueForHTTPHeaderField:@"Content-Type"]) {
            [self.request setValue:[self.requestDataType getContentType] forHTTPHeaderField:@"Content-Type"];
        }
        [self.request setHTTPBody:[self.requestDataType getRequestBodyData]];

    }else{
        NSString *quearyString = [(SWRequestFormData *)self.requestDataType getQueryString];
		if (quearyString.length > 0) {
			if (!([url rangeOfString:@"?"].location == NSNotFound)) {
				[self.request setURL:[[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@&%@",url,quearyString]]];
			}else{
				[self.request setURL:[[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@?%@",url,quearyString]]];
			}
		}
    }

    [self.request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    [self.request setTimeoutInterval:self.timeOut];
    [self.request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[self.request.HTTPBody length]] forHTTPHeaderField:@"Content-Length"];
    
    if (self.responseDataType) {
        self.responseDataType = self.responseDataType;
    }else{
        self.responseDataType = [SWResponseStringDataType type];
    }
    
    if (self.cacheBlock) {
        NSURLCache *urlCache = [NSURLCache sharedURLCache];
        if (urlCache) {
            NSCachedURLResponse *cachedResponse = [urlCache cachedResponseForRequest:self.request];
            if (cachedResponse) {
                self.cacheBlock(cachedResponse, [self.responseDataType responseOjbectFromdData:cachedResponse.data]);
            }
        }
    }
    
    if ([SWReachability getCurrentNetworkStatus] == SWNetworkingReachabilityStatusNotReachable) {
        if (self.sendRequestLaterWhenOnline) {
            [[SWOfflineRequestManger sharedInstance] addRequestForSendLater:self];
        }
        
        self.error = [NSError errorWithDomain:@"Connection not available" code:NSURLErrorNotConnectedToInternet userInfo:nil];
        
        if (self.failBlock) {
            self.failBlock(self.sessionTask, self.error);
        }
        return;
    }
    
    if (self.parentView) {
        [self addLoadingView];
    }
    
    if (!self.wantToUseQueue) {
        [self createSession];
    }
}



- (void)setUploadSuccess:(void (^)(NSURLSessionUploadTask *uploadTask, id responseObject))success
                failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure {
    self.uploadSuccessBlock = success;
    self.failBlock          = failure;
}
#pragma mark starting download task

- (void)setDownloadSuccess:(void (^)(NSURLSessionDownloadTask *uploadTask, NSURL *location))success
                  failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure {
    self.downloadSuccessBlock   = success;
    self.failBlock              = failure;
}

- (void)startDownloadwithResumeData:(NSData *) resumeData
                            success:(void (^)(NSURLSessionDownloadTask *uploadTask, NSURL *location))success
                            failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure {
    self.taskType               = DownloadTask;
    [self setDownloadSuccess:success failure:failure];
    [self showNetworkActivityIndicator:YES];
    
    SharedManager * manager = [SharedManager sharedManager];
    if (!manager.currentSession) {
        manager.currentSession = [NSURLSession sessionWithConfiguration:manager.configuration delegate:self delegateQueue:manager.operationQueue];
    }
    self.sessionTask            = [[[SharedManager sharedManager] currentSession] downloadTaskWithResumeData:resumeData];
    [self.sessionTask setSwRequest:self];
    
    [self.sessionTask resume];
    [manager.runningTasks setObject:self.sessionTask forKey:@(self.sessionTask.taskIdentifier)];}

- (void)startDownloadTaskWithURL:(NSString *)url
                     parameters:(id)parameters
                        success:(void (^)(NSURLSessionDownloadTask *uploadTask, NSURL *location))success
                        failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure {
    
    [self setDownloadSuccess:success failure:failure];
    self.taskType = DownloadTask;
    [self startWithURL:url parameters:parameters];
}

- (void)startDownloadTaskWithURL:(NSString *)url
                     parameters:(id)parameters
                     parentView:(id)parentView
                        success:(void (^)(NSURLSessionDownloadTask *uploadTask, NSURL *location))success
                        failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure {
    
#if TARGET_OS_IOS || TARGET_OS_TV
    self.parentView = (UIView *)parentView;
#elif TARGET_OS_MAC
    self.parentView = (NSView *)parentView;
#endif
    [self startDownloadTaskWithURL:url parameters:parameters success:success failure:failure];
}

- (void)startDownloadTaskWithURL:(NSString *)url
                     parameters:(id)parameters
                     parentView:(id)parentView
                     cachedData:(void (^)(NSCachedURLResponse *response, id responseObject))cache
                        success:(void (^)(NSURLSessionDownloadTask *uploadTask, NSURL *location))success
                        failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure {
    
    self.cacheBlock = cache;
    [self startDownloadTaskWithURL:url parameters:parameters parentView:parentView success:success failure:failure];
}

- (void)startDownloadTaskWithURL:(NSString *)url
                     parameters:(id)parameters
                     parentView:(id)parentView
             sendLaterIfOffline:(BOOL)offlineRequestStatus
                     cachedData:(void (^)(NSCachedURLResponse *response, id responseObject))cache
                        success:(void (^)(NSURLSessionDownloadTask *uploadTask, NSURL *location))success
                        failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure {
    
    self.sendRequestLaterWhenOnline = offlineRequestStatus;
    [self startDownloadTaskWithURL:url parameters:parameters parentView:parentView cachedData:cache success:success failure:failure];
}

#pragma mark starting data task

- (void)setDataSuccess:(void (^)(NSURLSessionDataTask *uploadTask, id responseObject))success
              failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure {
    self.dataSuccessBlock   = success;
    self.failBlock          = failure;
}


- (void)startDataTaskWithURL:(NSString *)url
                 parameters:(id)parameters
                    success:(void (^)(NSURLSessionDataTask *uploadTask, id responseObject))success
                    failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure {
    self.taskType = DataTask;
    [self setDataSuccess:success failure:failure];
    [self startWithURL:url parameters:parameters];
}

- (void)startDataTaskWithURL:(NSString *)url
                 parameters:(id)parameters
                 parentView:(id)parentView
                    success:(void (^)(NSURLSessionDataTask *uploadTask, id responseObject))success
                    failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure {
    
    #if TARGET_OS_IOS || TARGET_OS_TV
    self.parentView = (UIView *)parentView;
    #elif TARGET_OS_MAC
    self.parentView = (NSView *)parentView;
    #endif
    [self startDataTaskWithURL:url parameters:parameters success:success failure:failure];
}

- (void)startDataTaskWithURL:(NSString *)url
                 parameters:(id)parameters
                 parentView:(id)parentView
                 cachedData:(void (^)(NSCachedURLResponse *response, id responseObject))cache
                    success:(void (^)(NSURLSessionDataTask *uploadTask, id responseObject))success
                    failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure {
    
    self.cacheBlock = cache;
    [self startDataTaskWithURL:url parameters:parameters parentView:parentView success:success failure:failure];
}

- (void)startDataTaskWithURL:(NSString *)url
                 parameters:(id)parameters
                 parentView:(id)parentView
         sendLaterIfOffline:(BOOL)offlineRequestStatus
                 cachedData:(void (^)(NSCachedURLResponse *response, id responseObject))cache
                    success:(void (^)(NSURLSessionDataTask *uploadTask, id responseObject))success
                    failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure {
    
    self.sendRequestLaterWhenOnline = offlineRequestStatus;
    [self startDataTaskWithURL:url parameters:parameters parentView:parentView cachedData:cache success:success failure:failure];
}

- (int)statusCode {
    if (self.responseDataType) {
        return self.responseDataType.responseCode;
    }
    
    return 0;
}

- (NSString *)responseString {
    NSString *responseString = @"";
    if (self.responseData) {
        responseString = [[NSString alloc]initWithData:self.responseData encoding:NSUTF8StringEncoding];
    }
    
    if (!responseString) {
        responseString = @"NSUTF8StringEncoding doens't support for your response. Please use esponseStringWithEncoding:(NSStringEncoding) encoding";
    }
    
    return responseString;
}

- (NSString *)responseStringWithEncoding:(NSStringEncoding) encoding {
    return[[NSString alloc]initWithData:self.responseData encoding:encoding];
}

#pragma mark NSCordering

- (id)initWithCoder:(NSCoder *)coder{
    self = [self init];
    _request        = [coder decodeObjectForKey:@"request"];
    _timeOut        = [coder decodeIntForKey:@"timeOut"];
    _method         = [coder decodeObjectForKey:@"method"];
    _availableInURLMethods = [coder decodeObjectForKey:@"availableInURLMethods"];
    _isMultipart    = [coder decodeBoolForKey:@"isMultipart"];
    _requestSavedDate = [coder decodeObjectForKey:@"requestSavedDate"];
    _tag            = [coder decodeIntForKey:@"tag"];
    _sendRequestLaterWhenOnline = [coder decodeBoolForKey:@"sendRequestLaterWhenOnline"];
    _responseDataType = [coder decodeObjectForKey:@"responseDataType"];
    _userObject     = [coder decodeObjectForKey:@"userObject"];
    _requestDataType= [coder decodeObjectForKey:@"requestDataType"];
    _taskType       = [coder decodeIntForKey:@"taskType"];
    _sessionTask    = [coder decodeObjectForKey:@"sessionTask"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    
    if (self.request != nil) [coder encodeObject:self.request forKey:@"request"];
    
    [coder encodeInt:self.timeOut forKey:@"timeOut"];
    
    if (self.method != nil) [coder encodeObject:self.method forKey:@"method"];
    
    [coder encodeObject:self.availableInURLMethods forKey:@"availableInURLMethods"];
    [coder encodeBool:self.isMultipart forKey:@"isMultipart"];
    
    if (self.requestSavedDate != nil) [coder encodeObject:self.requestSavedDate forKey:@"requestSavedDate"];
    
    [coder encodeInt:self.tag forKey:@"tag"];
    [coder encodeBool:self.sendRequestLaterWhenOnline forKey:@"sendRequestLaterWhenOnline"];
    
    if (self.responseDataType != nil) [coder encodeObject:self.responseDataType forKey:@"responseDataType"];
    if (self.userObject != nil) [coder encodeObject:self.userObject forKey:@"userObject"];
    
    [coder encodeObject:self.requestDataType forKey:@"requestDataType"];

    [coder encodeInt:self.taskType forKey:@"taskType"];
    
    [coder encodeObject:self.sessionTask forKey:@"sessionTask"];
}


- (id)copyWithZone:(NSZone *)zone {
    
    SWRequest *operation = [[self.class allocWithZone:zone]init];

    operation->_request         = self.request;
    operation->_timeOut         = self.timeOut;
    operation->_method          = self.method;
    operation->_availableInURLMethods = self.availableInURLMethods;
    operation->_isMultipart     = self.isMultipart;
    operation->_requestSavedDate= self.requestSavedDate;
    operation->_tag             = self.tag;
    operation->_sendRequestLaterWhenOnline = self.sendRequestLaterWhenOnline;
    operation->_responseDataType= self.responseDataType;
    operation->_userObject      = self.userObject;
    operation->_requestDataType = self.requestDataType;
    operation->_taskType        = self.taskType;
    operation->_sessionTask     = self.sessionTask;
    return operation;
}

#pragma mark NSURLSessionUploadTask delegates
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    
    if (task.swRequest && task.swRequest.uploadProgressBlock) {
        task.swRequest.uploadProgressBlock(totalBytesSent, totalBytesExpectedToSend);
    }
}

#pragma mark NSURLSessionDownloadTask delegates

- (void)URLSession:(__unused NSURLSession *)session downloadTask:(__unused NSURLSessionDownloadTask *)downloadTask
      didWriteData:(__unused int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    if (downloadTask.swRequest && downloadTask.swRequest.downloadProgressBlock) {
        downloadTask.swRequest.downloadProgressBlock(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    }
}

- (void)URLSession:(__unused NSURLSession *)session downloadTask:(__unused NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(__unused int64_t)fileOffset
expectedTotalBytes:(int64_t)totalBytesExpectedToWrite {
    
    if (downloadTask.swRequest && downloadTask.swRequest.downloadProgressBlock) {
        downloadTask.swRequest.downloadProgressBlock(0, 0, totalBytesExpectedToWrite);
    }
}

- (void)URLSession:(NSURLSession * )session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL * )location{
    
    if (downloadTask.swRequest && downloadTask.swRequest.downloadSuccessBlock) {
        SharedManager * manager = [SharedManager sharedManager];
        [manager.runningTasks removeObjectForKey:@(downloadTask.taskIdentifier)];
        downloadTask.swRequest.downloadSuccessBlock(downloadTask, location);
    }
}

#pragma mark NSURLSessionDataTask delegates



- (void)URLSession:(NSURLSession * )session dataTask:(NSURLSessionDataTask * )dataTask
didBecomeDownloadTask:(NSURLSessionDownloadTask * )downloadTask {
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask * )dataTask didReceiveData:(NSData * )data {
    if (!dataTask.swRequest) {
        dataTask.swRequest = [[SWRequest alloc]init];
    }
    if (!dataTask.swRequest.responseData) {
        dataTask.swRequest.responseData = [[NSMutableData alloc]initWithData:data];
    }else{
        [dataTask.swRequest.responseData appendData:data];
    }
}

#pragma NSURLSessionTaskDelegate mark

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        SharedManager * manager = [SharedManager sharedManager];
        [manager.runningTasks removeObjectForKey:@(task.taskIdentifier)];
        if (task.swRequest) {
            [task.swRequest.backgroundView removeFromSuperview];
            [task.swRequest 	showNetworkActivityIndicator:NO];
        }
        if (error) {
            if (task.swRequest) {
                task.swRequest.failBlock(task, error);
            }
        }else{
            NSURLCache *urlCache = [NSURLCache sharedURLCache];
            if (urlCache) {
                if (task.response) {
                    [urlCache storeCachedResponse:[[NSCachedURLResponse alloc]initWithResponse:task.response data:task.swRequest.responseData] forRequest:task.swRequest.request];
                }
            }
            if (task.swRequest && task.swRequest.dataSuccessBlock) {
                task.swRequest.dataSuccessBlock((NSURLSessionDataTask *)task, [task.swRequest.responseDataType responseOjbect:(NSHTTPURLResponse *)task.response data:task.swRequest.responseData]);
                task.swRequest.dataSuccessBlock = nil;
            }
            if (task.swRequest && task.swRequest.uploadSuccessBlock) {
                task.swRequest.uploadSuccessBlock((NSURLSessionUploadTask *)task, [task.swRequest.responseDataType responseOjbect:(NSHTTPURLResponse *)task.response data:task.swRequest.responseData]);
                task.swRequest.uploadProgressBlock = nil;
            }
        }
    });
}


@end


#pragma mark SWGETRequest methods


@implementation SWGETRequest


- (void )startWithURL:(NSString *)url
          parameters:(id)parameters {

    self.method = @"GET";
    
    [super startWithURL:url parameters:parameters];
}


@end


#pragma mark SWPOSTRequest methods


@implementation SWMultPartRequest

- (void )startWithURL:(NSString *)url
          parameters:(id)parameters {
    
    [super startWithURL:url parameters:parameters];
}


- (void)startUploadTaskWithURL:(NSString *)url
                        files:(NSArray *)files
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionUploadTask *uploadTask, id responseObject))success
                      failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure {
    
    self.uploadSuccessBlock = success;
    self.failBlock          = failure;
    self.isMultipart        = YES;
    self.files              = files;
    self.requestDataType    = [SWRequestMulitFormData type];
    self.taskType           = UploadTask;

    [self startWithURL:url parameters:parameters];
}

- (void)startUploadTaskWithURL:(NSString *)url
                        files:(NSArray *)files
                   parameters:(id)parameters
                   parentView:(id)parentView
                      success:(void (^)(NSURLSessionUploadTask *uploadTask, id responseObject))success
                      failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure {
#if TARGET_OS_IOS || TARGET_OS_TV
    self.parentView = parentView;
#endif
    [self startUploadTaskWithURL:url files:files parameters:parameters success:success failure:failure];
    
}


- (void)startUploadTaskWithURL:(NSString *)url
                        files:(NSArray *)files
                   parameters:(id)parameters
                   parentView:(id)parentView
                   cachedData:(void (^)(NSCachedURLResponse *response, id responseObject))cache
                      success:(void (^)(NSURLSessionUploadTask *uploadTask, id responseObject))success
                      failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure {
    
    self.cacheBlock = cache;
    
    [self startUploadTaskWithURL:url files:files parameters:parameters parentView:parentView success:success failure:failure];
    
}


- (void)startUploadTaskWithURL:(NSString *)url
                        files:(NSArray *)files
                   parameters:(id)parameters
                   parentView:(id)parentView
           sendLaterIfOffline:(BOOL)sendLater
                   cachedData:(void (^)(NSCachedURLResponse *response, id responseObject))cache
                      success:(void (^)(NSURLSessionUploadTask *uploadTask, id responseObject))success
                      failure:(void (^)(NSURLSessionTask *uploadTask, NSError *error))failure {
    
    self.sendRequestLaterWhenOnline = sendLater;
    
    [self startUploadTaskWithURL:url files:files parameters:parameters parentView:parentView cachedData:cache success:success failure:failure];
}

@end


@implementation SWPOSTRequest

- (void )startWithURL:(NSString *)url
          parameters:(id)parameters {
    
    self.method = @"POST";
    
    [super startWithURL:url parameters:parameters];
}

@end

@implementation SWPUTRequest

- (void )startWithURL:(NSString *)url
          parameters:(id)parameters {
    
    self.method = @"PUT";
    
    [super startWithURL:url parameters:parameters];
}

@end


@implementation SWHEADRequest

- (void )startWithURL:(NSString *)url
          parameters:(id)parameters {
    
    self.method = @"HEAD";
    
    [super startWithURL:url parameters:parameters];
}

@end


@implementation SWDELETERequest

- (void )startWithURL:(NSString *)url
          parameters:(id)parameters {
    
    self.method = @"DELETE";
    
    [super startWithURL:url parameters:parameters];
}

@end



@implementation SWPATCHRequest

- (void )startWithURL:(NSString *)url
          parameters:(id)parameters {
    
    self.method = @"PATCH";
    
    [super startWithURL:url parameters:parameters];
}


@end

@implementation SharedManager

+ (id)sharedManager {
    static SharedManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager                   = [[self alloc] init];
        sharedManager.operationQueue    = [[NSOperationQueue alloc] init];
        sharedManager.configuration     = [NSURLSessionConfiguration defaultSessionConfiguration];
    });
    return sharedManager;
}

-(void)setMaxConcurrentRequestCount:(int)maxRequestCount {
    self.configuration.HTTPMaximumConnectionsPerHost = maxRequestCount;
}

@end


@interface NSURLSessionTask ()

@property (nonatomic, strong) SWRequest *swRequest;

@end



@implementation NSObject (SessionDownloadCategory)
- (void)setFailureBlock:(void (^)(NSURLSessionTask *task, NSError *error))failure {
    
    NSURLSessionTask *task = (NSURLSessionTask *)self;
    if(task.swRequest){
        task.swRequest.failureBlock = failure;
    }else{
        SWRequest *handler  = [[SWRequest alloc]init];
        handler.failureBlock = failure;
        task.swRequest = handler;
    }
}
- (void)setDownloadProgressBlock:(void (^)(long long bytesWritten, long long totalBytesWritten,  long long totalBytesExpectedToWrite)) downloadProgressBlock {
    
    NSURLSessionDownloadTask *task = (NSURLSessionDownloadTask *)self;
    if(task.swRequest){
        task.swRequest.downloadProgressBlock = downloadProgressBlock;
    }else{
        SWRequest *handler  = [[SWRequest alloc]init];
        handler.downloadProgressBlock = downloadProgressBlock;
        task.swRequest = handler;
    }
}


- (void)setDownloadSuccessBlock:(void (^)(NSURLSessionDownloadTask *uploadTask, NSURL *location))success {
    
    NSURLSessionDataTask *task = (NSURLSessionDataTask *)self;
    if(task.swRequest){
        task.swRequest.downloadSuccessBlock = success;
    }else{
        SWRequest *handler  = [[SWRequest alloc]init];
        handler.downloadSuccessBlock = success;
        task.swRequest = handler;
    }
}

- (void)setDataSuccessBlock:(void (^)(NSURLSessionDataTask *uploadTask, id responseObject))success {
    
    NSURLSessionDataTask *task = (NSURLSessionDataTask *)self;
    if(task.swRequest){
        task.swRequest.dataSuccessBlock = success;
    }else{
        SWRequest *handler  = [[SWRequest alloc]init];
        handler.dataSuccessBlock = success;
        task.swRequest = handler;
    }
}

- (void)setUploadProgressBlock:(void (^)(long long bytesWritten,  long long totalBytesExpectedToWrite)) uploadProgressBlock {
    
    NSURLSessionUploadTask *task = (NSURLSessionUploadTask *)self;
    if(task.swRequest){
        task.swRequest.uploadProgressBlock = uploadProgressBlock;
    }else{
        SWRequest *handler  = [[SWRequest alloc]init];
        handler.uploadProgressBlock = uploadProgressBlock;
        task.swRequest = handler;
    }
}

- (void)setUploadSuccessBlock:(void (^)(NSURLSessionUploadTask *uploadTask, id responseObject))success {
    
    NSURLSessionUploadTask *task = (NSURLSessionUploadTask *)self;
    if(task.swRequest){
        task.swRequest.uploadSuccessBlock = success;
    }else{
        SWRequest *handler  = [[SWRequest alloc]init];
        handler.uploadSuccessBlock = success;
        task.swRequest = handler;
    }
}

- (void)setUploadFailureBlock:(void (^)(NSURLSessionUploadTask *task, NSError *error))failure {
    NSURLSessionUploadTask *task = (NSURLSessionUploadTask *)self;
    if(task.swRequest){
        task.swRequest.uploadFailureBlock = failure;
    }else{
        SWRequest *handler  = [[SWRequest alloc]init];
        handler.uploadSuccessBlock = failure;
        task.swRequest = handler;
    }
}

- (SWRequest *)swRequest {
    return objc_getAssociatedObject(self, @selector(swRequest));
}

- (void)setSwRequest:(SWRequest *)obj {
    objc_setAssociatedObject(self, @selector(swRequest), obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
