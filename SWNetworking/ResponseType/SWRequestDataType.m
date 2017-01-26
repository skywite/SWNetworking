//
//  SWRequestDataType.m
//  SWNetworkingExample
//
//  Created by Saman Kumara on 7/14/15.
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

#import "SWRequestDataType.h"
#import "SWMedia.h"

NSString * const SW_MULTIPART_REQUEST_BOUNDARY = @"boundary-swnetworking-----------14737809831466499882746641449";

static NSString * SWEscapedQueryStringKeyFromStringWithEncoding(NSString *string) {
    NSMutableCharacterSet *charset = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [charset removeCharactersInString:@"!*'();:@&=+$,/?%#"];
    return [string stringByAddingPercentEncodingWithAllowedCharacters:charset];
}

static NSString * SWEscapedQueryStringValueFromStringWithEncoding(NSString *string) {
    NSMutableCharacterSet *charset = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [charset removeCharactersInString:@"!*'();:@&=+$,/?%#[]"];
    return [string stringByAddingPercentEncodingWithAllowedCharacters:charset];
}

@interface SWRequestDataType()

@property (nonatomic, strong) NSData *bodyData;


@end
@implementation SWRequestDataType

- (id)init {
    if(self = [super init]) {
    }
    return self;
}
+ (instancetype)type {
    
    return [[self alloc] init];
}

- (void)dataWithFile:(NSArray *)array paremeters:(id)data {
 
}

- (NSData *)getRequestBodyData {
    return self.bodyData;
}

- (NSString *)getContentType {
    return nil;
}

- (NSString *)getQueryString {
    return nil;
}

#pragma mark serialize


- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init])
    {
        self.bodyData = [aDecoder decodeObjectForKey:@"bodyData"];
    }
    
    return self ;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.bodyData forKey:@"bodyData"];
}

- (id)copyWithZone:(NSZone *)zone {
    
    SWRequestDataType *resquestDataType = [[self.class allocWithZone:zone] init];
    resquestDataType->_bodyData = self.bodyData;
    
    return resquestDataType;
}


@end

@interface SWRequestFormData ()

@property (nonatomic, strong) id parameters;

@end

/**
 *  This interface will use to generate form body
 */
@implementation SWRequestFormData

- (NSString *)getContentType {
    return @"application/x-www-form-urlencoded";
}

- (void)dataWithFile:(NSArray *)array paremeters:(id)data {
    self.parameters = data;
    self.bodyData   = [(NSString *)[self getQueryString] dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
}


- (NSString *)getQueryString {
    
    NSString *retunString = nil;
    if ([self.parameters isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *param = (NSDictionary *)self.parameters;
        NSMutableArray *paramArray = [[NSMutableArray alloc]init];
        
        for (NSString *key in param.allKeys) {
            [paramArray addObject:[NSString stringWithFormat:@"%@=%@", SWEscapedQueryStringKeyFromStringWithEncoding(key) , SWEscapedQueryStringValueFromStringWithEncoding([param objectForKey:key])]];
        }
        
        retunString = [paramArray componentsJoinedByString:@"&"];
        
    }else{
        retunString = self.parameters;
    }
    return retunString;
}

@end

/**
 *  This interface will use to generate mulitpart form body
 */
@interface SWRequestMulitFormData()
@property (nonatomic, strong) NSArray *files;
@end

@implementation SWRequestMulitFormData

- (void)dataWithFile:(NSArray *)array paremeters:(id)data {
    
    self.files      = array;
    self.bodyData   = [self getBodyDataWithParameters:data];
 
}

- (NSString *)getContentType {
    return [NSString stringWithFormat:@"multipart/form-data; boundary=%@", SW_MULTIPART_REQUEST_BOUNDARY];
}

- (NSMutableData *)getBodyDataWithParameters:(NSDictionary *)parameters {
    
    
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


@end



@implementation SWRequestJSONData


- (NSString *)getContentType {
    return @"application/json";
}

- (void)dataWithFile:(NSArray *)array paremeters:(id)data {
    NSError *error = nil;
    self.bodyData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
}

@end
