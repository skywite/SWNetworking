//
//  SWResponseDataType.m
//  SWNetworking
//
//  Created by Saman Kumara on 4/7/15.
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



#import "SWResponseDataType.h"


@implementation SWResponseDataType


- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    return self;
}

+ (instancetype)type {

    return [[self alloc] init];
}

- (id)responseOjbect:(NSHTTPURLResponse *) response data:(NSData *)data{
    if (response) {
        self.responseCode = (int)[response statusCode];
    }
    return data;
}

- (id)responseOjbectFromdData:(NSData *)data{
    return data;
}


#pragma mark serialize


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]) {
        self.responseCode = [aDecoder decodeIntForKey:@"responseCode"];
    }
    
    return self ;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:self.responseCode forKey:@"responseCode"];
}

- (id)copyWithZone:(NSZone *)zone {
    
    SWResponseDataType *responseDataType = [[self.class allocWithZone:zone] init];
    responseDataType->_responseCode = self.responseCode;
    
    return responseDataType;
}


@end




@interface SWResponseJSONDataType()

@property (nonatomic, assign) NSJSONReadingOptions readingOptions;
@property (nonatomic, assign) BOOL removeNullValues;
@end

@implementation SWResponseJSONDataType


- (instancetype)initWithJSONResponseWithReadingOptions:(NSJSONReadingOptions)readingOptions removeNullValueKeys:(BOOL)removeStatus {
    
    self                    = [SWResponseJSONDataType type];
    self.removeNullValues   = removeStatus;
    self.readingOptions     = readingOptions;
    
    return self;
}
- (instancetype)initWithJSONResponseWithReadingOptions:(NSJSONReadingOptions)readingOptions {
    
    return [self initWithJSONResponseWithReadingOptions:readingOptions removeNullValueKeys:NO];
}

- (id)responseOjbect:(NSHTTPURLResponse *) response data:(NSData *)data {
    
    if (response) {
        self.responseCode = (int)[response statusCode];
    }
    
    return [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error:nil];
}
- (id)responseOjbectFromdData:(NSData *)data {
    
    return [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error:nil];
}

@end


@implementation SWResponseXMLDataType

@end


@implementation SWResponseStringDataType

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.encoding = NSUTF8StringEncoding;
    return self;
}
+ (instancetype)typeWithEncoding:(NSStringEncoding)encoding {
    SWResponseStringDataType *stringType    = [[self alloc] init];
    stringType.encoding                     = encoding;
    
    return stringType;
}

- (NSString *)responseOjbect:(NSHTTPURLResponse *) response data:(NSData *)data {
    
    if (response) {
        self.responseCode = (int)[response statusCode];
    }

    NSString *responseString = @"";
    if (data) {
        responseString = [[NSString alloc]initWithData:data encoding:self.encoding];
    }
    
    if (!responseString) {
        responseString = @"NSUTF8StringEncoding doens't support for your response. Please use esponseStringWithEncoding:(NSStringEncoding) encoding";
    }
    return responseString;
}
- (NSString *)responseOjbectFromdData:(NSData *)data{
    
    NSString *responseString = @"";
    if (data) {
        responseString = [[NSString alloc]initWithData:data encoding:self.encoding];
    }
    
    if (!responseString) {
        responseString = @"NSUTF8StringEncoding doens't support for your response. Please use esponseStringWithEncoding:(NSStringEncoding) encoding";
    }
    
    return responseString;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        self.encoding = [aDecoder decodeIntForKey:@"encoding"];
    }
    
    return self ;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
    [encoder encodeInt64:self.encoding forKey:@"encoding"];
}

- (id)copyWithZone:(NSZone *)zone {
    SWResponseStringDataType *responseDataType = [super copyWithZone:zone];
    responseDataType->_encoding = self.encoding;
    
    return responseDataType;
}


@end


@implementation SWResponseImageType

- (id)responseOjbect:(NSHTTPURLResponse *) response data:(NSData *)data {
    
    if (response) {
        self.responseCode = (int)[response statusCode];
    }
#if TARGET_OS_IOS || TARGET_OS_TV
    return [UIImage imageWithData:data];
#elif TARGET_OS_MAC
    return  [[NSImage alloc] initWithData:data];
#endif
    return nil;
}
- (id)responseOjbectFromdData:(NSData *)data {
#if TARGET_OS_IOS || TARGET_OS_TV
    return [UIImage imageWithData:data];
#elif TARGET_OS_MAC
    return  [[NSImage alloc] initWithData:data];
#endif
    return nil;
}

@end
