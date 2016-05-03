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


- (instancetype)init{
    self = [super init];
    if (!self) {
        return nil;
    }
    return self;
}

+ (instancetype)type{

    return [[self alloc] init];
}

-(id)responseOjbect:(NSHTTPURLResponse *) response data:(NSData *)data{
    return data;
}

-(id)responseOjbectFromdData:(NSData *)data{
    return data;
}


#pragma mark serialize


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.responseCode = [aDecoder decodeIntForKey:@"responseCode"];
    }
    
    return self ;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
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


- (instancetype)initWithJSONResponseWithReadingOptions:(NSJSONReadingOptions)readingOptions removeNullValueKeys:(BOOL)removeStatus{
    
    self = [SWResponseJSONDataType type];
    self.removeNullValues = removeStatus;
    self.readingOptions = readingOptions;
    
    return self;
}
- (instancetype)initWithJSONResponseWithReadingOptions:(NSJSONReadingOptions)readingOptions{
    
    return [self initWithJSONResponseWithReadingOptions:readingOptions removeNullValueKeys:NO];
    
}

-(id)responseOjbect:(NSHTTPURLResponse *) response data:(NSData *)data{
    
    self.responseCode = (int)[response statusCode];
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error:nil];

    return jsonObject;
}
-(id)responseOjbectFromdData:(NSData *)data{
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error:nil];
    
    return jsonObject;
}

@end


@implementation SWResponseXMLDataType

@end


@implementation SWResponseStringDataType

-(id)responseOjbect:(NSHTTPURLResponse *) response data:(NSData *)data{
    
    self.responseCode = (int)[response statusCode];
    
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
}
-(id)responseOjbectFromdData:(NSData *)data{
    
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

@end


@implementation SWResponseImageType

-(id)responseOjbect:(NSHTTPURLResponse *) response data:(NSData *)data{
    self.responseCode = (int)[response statusCode];
#if TARGET_OS_IOS || TARGET_OS_TV
    return [UIImage imageWithData:data];
#elif TARGET_OS_MAC
    return  [[NSImage alloc] initWithData:data];
#endif
    return nil;
}
-(id)responseOjbectFromdData:(NSData *)data{
#if TARGET_OS_IOS || TARGET_OS_TV
    return [UIImage imageWithData:data];
#elif TARGET_OS_MAC
    return  [[NSImage alloc] initWithData:data];
#endif
    return nil;
}

@end