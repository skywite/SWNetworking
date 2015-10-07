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


#import "SWRequestOperation.h"
#import "SWReachability.h"
#import "SWOfflineRequestManger.h"

//NSString * const SW_MULTIPART_REQUEST_BOUNDARY = @"boundary-swnetworking-----------14737809831466499882746641449";

@interface SWRequestOperation(){
    BOOL        executing;
    BOOL        finished;
}

@property (readwrite, nonatomic, retain) NSMutableURLRequest    *request;
@property (readwrite, nonatomic, strong) NSHTTPURLResponse      *response;
@property (readwrite, nonatomic, strong) NSMutableData          *responseData;

@property(readwrite, nonatomic, assign) int                     statusCode;

@property (nonatomic, retain) NSURLConnection                   *connection;
@property (nonatomic, retain) NSString                          *method;
@property (nonatomic, retain) NSSet                             *availableInURLMethods;

@property(nonatomic, copy) void (^successBlock)(SWRequestOperation *oparation, id responseObject);
@property(nonatomic, copy) void (^failBlock)(SWRequestOperation *oparation,  NSError *error);
@property(nonatomic, copy) void (^cacheBlock)(NSCachedURLResponse *response,  id responseObject);

@property (readwrite, nonatomic, strong) NSError                *error;


@property (nonatomic, retain) UIView *backgroundView;


@property (nonatomic, assign) BOOL      isMultipart;

@property (nonatomic, retain) NSArray   *files;

@property (nonatomic, assign) long long expectedBytes;

@property (nonatomic, assign) long long  receivedData;

@property(nonatomic, copy) void (^uploadProgressBlock)(long long  bytes, long long  totalBytes,  long long totalBytesExpected);

@property(nonatomic, copy) void (^downloadProgressBlock)(long long bytes, long long totalBytes,  long long totalBytesExpected);

-(NSString *)responseString;

@end

@implementation SWRequestOperation

- (void)start {
    
    // Always check for cancellation before launching the task.
    
    if ([self isCancelled]){
        // Must move the operation to the finished state if it is canceled.
        
        [self willChangeValueForKey:@"isFinished"];
        
        finished = YES;
        
        [self didChangeValueForKey:@"isFinished"];
        
        return;
        
    }
    
    // If the operation is not canceled, begin executing the task.
    
    [self willChangeValueForKey:@"isExecuting"];
    
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    
    executing = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    
}

- (BOOL)isConcurrent {
    
    return YES;
    
}



- (BOOL)isExecuting {
    
    return executing;
    
}



- (BOOL)isFinished {
    
    return finished;
    
}

- (void)main {
    
    @try {
        [self completeOperation];
    }
    
    @catch(...) {
        
        // Do not rethrow exceptions.
    }
    
}
- (void)completeOperation {
    
    [self willChangeValueForKey:@"isFinished"];
    
    [self willChangeValueForKey:@"isExecuting"];
    
    executing = NO;
    
    finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    
    [self didChangeValueForKey:@"isFinished"];
}

-(void)cancel{
    if(self.connection){
        [self.connection cancel];
        self.connection = nil;
    }
}

-(id)init{
   
    if(self = [super init]){
        
        self.request = [[NSMutableURLRequest alloc] init];
        self.responseData = [NSMutableData data];
        self.availableInURLMethods = [NSSet setWithObjects:@"GET", @"HEAD", @"DELETE", nil];
        executing = NO;
        finished = NO;
        self.responseDataType = [SWResponseDataType type];
        self.requestDataType = [SWRequestFormData type];
        self.isMultipart = NO;
        self.sendRequestLaterWhenOnline = NO;
        self.timeOut = 60;
        self.wantToUseQueue = NO;

    }
    return self;
}

//-(void)setDownloadProgressBlock:(void (^)(long  bytes,  long totalBytes,  long totalBytesExpected)) downloadProgressBlock;


-(void)createConnection{
#if  !TARGET_OS_TV
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
#endif
    self.connection = [[NSURLConnection alloc]initWithRequest:self.request delegate:self startImmediately:YES];
    [self start];
}

-(void)addLoadingView{
    
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
}
/*

-(NSMutableData *)getBodyDataWithParameters:(NSDictionary *)parameters{
    
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", SW_MULTIPART_REQUEST_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSString *endoundary = [NSString stringWithFormat:@"\r\n--%@\r\n",SW_MULTIPART_REQUEST_BOUNDARY];
    int i=0;
    for (NSString *key in parameters.allKeys) {
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",[parameters objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        i++;
        
        if ((i != [parameters.allKeys count]) || ([self.files count] > 0)) { //Only add the boundary if this is not the last item in the post body
            [body appendData:[endoundary dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    i=0;
    
    for (SWMedia *file in self.files) {
        
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", file.key, file.fileName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", file.MIMEType] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:file.data];
        i++;
        
        // Only add the boundary if this is not the last item in the post body
        if (i != [self.files count]) {
            [body appendData:[endoundary dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",SW_MULTIPART_REQUEST_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return body;
}

*/
-(void )startWithURL:(NSString *)url
          parameters:(id)parameters{
    
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
        if (!([url rangeOfString:@"?"].location == NSNotFound)) {
            [self.request setURL:[[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@&%@",url,quearyString]]];
        }else{
            [self.request setURL:[[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@?%@",url,quearyString]]];
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
    
    if ([SWReachability getCurrentNetworkStatus] == SWNetworkReachabilityStatusNotReachable) {
        
        if (self.sendRequestLaterWhenOnline) {
            [[SWOfflineRequestManger sharedInstance] addRequestForSendLater:self];
        }
        
        self.error = [NSError errorWithDomain:@"Connection not available" code:NSURLErrorNotConnectedToInternet userInfo:nil];
        if (self.failBlock) {
            self.failBlock(self, self.error);
        }
        return;

    }
    
    if (self.parentView) {
        [self addLoadingView];
    }
    
    if (!self.wantToUseQueue) {
        [self createConnection];
    }
}



-(void)setSuccess:(void (^)(SWRequestOperation *operation, id responseObject))success
          failure:(void (^)(SWRequestOperation *operation, NSError *error))failure{
    self.successBlock = success;
    self.failBlock = failure;
}


-(void)startWithURL:(NSString *)url
         parameters:(id)parameters
            success:(void (^)(SWRequestOperation *operation, id responseObject))success
            failure:(void (^)(SWRequestOperation *operation, NSError *error))failure{
    
    self.successBlock = success;
    self.failBlock = failure;
    
    [self startWithURL:url parameters:parameters];
}

-(void)startWithURL:(NSString *)url
         parameters:(id)parameters
         parentView:(UIView *)parentView
            success:(void (^)(SWRequestOperation *operation, id responseObject))success
            failure:(void (^)(SWRequestOperation *operation, NSError *error))failure{
    
    self.parentView = parentView;
    
    [self startWithURL:url parameters:parameters success:success failure:failure];
}


-(void)startWithURL:(NSString *)url
         parameters:(id)parameters
         parentView:(UIView *)parentView
         cachedData:(void (^)(NSCachedURLResponse *response, id responseObject))cache
            success:(void (^)(SWRequestOperation *operation, id responseObject))success
            failure:(void (^)(SWRequestOperation *operation, NSError *error))failure{
    
    self.cacheBlock = cache;
    
    [self startWithURL:url parameters:parameters parentView:parentView success:success failure:failure];
}


-(void)startWithURL:(NSString *)url
         parameters:(id)parameters
         parentView:(UIView *)parentView
 sendLaterIfOffline:(BOOL)offlineRequestStatus
         cachedData:(void (^)(NSCachedURLResponse *response, id responseObject))cache
            success:(void (^)(SWRequestOperation *operation, id responseObject))success
            failure:(void (^)(SWRequestOperation *operation, NSError *error))failure{
   
    self.sendRequestLaterWhenOnline = offlineRequestStatus;
    
    [self startWithURL:url parameters:parameters parentView:parentView cachedData:cache success:success failure:failure];
}



-(NSString *)responseString{
    return[[NSString alloc]initWithData:self.responseData encoding:NSUTF8StringEncoding];
}


#pragma mark - NSURLConnection delegate

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)space {
    return NO;
}

- (void)connection:(NSURLConnection __unused *)connection didReceiveResponse:(NSURLResponse *)response  {
    self.response =  (NSHTTPURLResponse*)response;
    self.statusCode = (int)[self.response statusCode];
    [self.responseData setLength:0];
    self.expectedBytes = [response expectedContentLength];
}

- (void)connection:(NSURLConnection __unused *)connection didReceiveData:(NSData *)data{
    [self.responseData appendData:data];
    self.receivedData = [self.responseData length];

    if (self.downloadProgressBlock) {
        self.downloadProgressBlock([data length], self.receivedData, self.expectedBytes);
    }
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    if (self.uploadProgressBlock) {
        self.uploadProgressBlock(bytesWritten, totalBytesExpectedToWrite, totalBytesExpectedToWrite);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection __unused *)connection {
#if  !TARGET_OS_TV 
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
#endif
    [self.backgroundView removeFromSuperview];
    if (self.successBlock) {
        self.successBlock(self, [self.responseDataType responseOjbect:self.response data:self.responseData]);
    }
    [self completeOperation];

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    self.error = error;
    [self.backgroundView removeFromSuperview];
#if  !TARGET_OS_TV
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
#endif
    if (self.failBlock) {
        self.failBlock(self, self.error);
    }
}

-(NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse{
   
    NSURLCache *urlCache = [NSURLCache sharedURLCache];

    if (urlCache) {
        if (cachedResponse) {
            [urlCache storeCachedResponse:cachedResponse forRequest:self.request];
        }
    }
    return nil;

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

    
}


- (id)copyWithZone:(NSZone *)zone {
    
    SWRequestOperation *operation = [[self.class allocWithZone:zone]init];

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
    
    return operation;
}

@end


#pragma mark SWGETRequest methods


@implementation SWGETRequest


-(void )startWithURL:(NSString *)url
          parameters:(id)parameters{

    self.method = @"GET";
    
    [super startWithURL:url parameters:parameters];
}


@end


#pragma mark SWPOSTRequest methods


@implementation SWMultPartRequest

-(void )startWithURL:(NSString *)url
          parameters:(id)parameters{
        
    [super startWithURL:url parameters:parameters];
}


-(void)startMultipartWithURL:(NSString *)url
                       files:(NSArray *)files
                  parameters:(id)parameters
                     success:(void (^)(SWRequestOperation *operation, id responseObject))success
                     failure:(void (^)(SWRequestOperation *operation, NSError *error))failure{
    
    self.successBlock = success;
    self.failBlock = failure;
    self.isMultipart = YES;
    self.files = files;
    self.requestDataType = [SWRequestMulitFormData type];
    [self startWithURL:url parameters:parameters];
}

-(void)startMultipartWithURL:(NSString *)url
                       files:(NSArray *)files
                  parameters:(id)parameters
                  parentView:(UIView *)parentView
                     success:(void (^)(SWRequestOperation *operation, id responseObject))success
                     failure:(void (^)(SWRequestOperation *operation, NSError *error))failure{
    
    self.parentView = parentView;
    
    [self startMultipartWithURL:url files:files parameters:parameters success:success failure:failure];

}


-(void)startMultipartWithURL:(NSString *)url
                       files:(NSArray *)files
                  parameters:(id)parameters
                  parentView:(UIView *)parentView
                  cachedData:(void (^)(NSCachedURLResponse *response, id responseObject))cache
                     success:(void (^)(SWRequestOperation *operation, id responseObject))success
                     failure:(void (^)(SWRequestOperation *operation, NSError *error))failure{
    
    self.cacheBlock = cache;
    
    [self startMultipartWithURL:url files:files parameters:parameters parentView:parentView success:success failure:failure];

}


-(void)startMultipartWithURL:(NSString *)url
                       files:(NSArray *)files
                  parameters:(id)parameters
                  parentView:(UIView *)parentView
          sendLaterIfOffline:(BOOL)sendLater
                  cachedData:(void (^)(NSCachedURLResponse *response, id responseObject))cache
                     success:(void (^)(SWRequestOperation *operation, id responseObject))success
                     failure:(void (^)(SWRequestOperation *operation, NSError *error))failure{
    
    self.sendRequestLaterWhenOnline = sendLater;
    
    [self startMultipartWithURL:url files:files parameters:parameters parentView:parentView cachedData:cache success:success failure:failure];
}

@end


@implementation SWPOSTRequest

-(void )startWithURL:(NSString *)url
          parameters:(id)parameters{
    
    self.method = @"POST";
    
    [super startWithURL:url parameters:parameters];
}

@end

@implementation SWPUTRequest

-(void )startWithURL:(NSString *)url
          parameters:(id)parameters{
    
    self.method = @"PUT";
    
    [super startWithURL:url parameters:parameters];
}

@end


@implementation SWHEADRequest

-(void )startWithURL:(NSString *)url
          parameters:(id)parameters{
    
    self.method = @"HEAD";
    
    [super startWithURL:url parameters:parameters];
}

@end


@implementation SWDELETERequest

-(void )startWithURL:(NSString *)url
          parameters:(id)parameters{
    
    self.method = @"DELETE";
    
    [super startWithURL:url parameters:parameters];
}

@end



@implementation SWPATCHRequest

-(void )startWithURL:(NSString *)url
          parameters:(id)parameters{
    
    self.method = @"PATCH";
    
    [super startWithURL:url parameters:parameters];
}


@end


