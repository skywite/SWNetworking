//
//  SWRequestDataType.h
//  SWNetworkingExample
//
//  Created by Saman Kumara on 7/14/15.
//  Copyright (c) 2015 Saman Kumara. All rights reserved.

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
/**
 * SWRequestDataType use to generate HTTPBody on the request.
 */
@protocol SWRequestDataType <NSObject>

@end
/**
 * SWRequestDataType use to generate HTTPBody on the request.
 */
@interface SWRequestDataType : NSObject<SWRequestDataType>

/**
 *  when calling this method SWRequestDataType instance will return
 *
 *  @return SWRequestDataType will return
 */
+ (instancetype)type;

/**
 *  When calling this method can get Content Type
 *
 *  @return Content Type an a NSString
 */
- (NSString *)getContentType;

/**
 *  This method use set request body. If want to custom datatype user can overide this method
 *
 *  @param array files array to submit. (this is multipart body)
 *  @param data  The parameters will me NSDictionary or NSString
 */
- (void)dataWithFile:(NSArray *)array paremeters:(id)data;

/**
 *  Calling this method can get HTTPBody data
 *
 *  @return BodyData as NSData
 */
- (NSData *)getRequestBodyData;

@end

/**
 *  SWRequestFormData use to generate HTTPBody as FormData on the request.
 */
@interface SWRequestFormData : SWRequestDataType

/**
 *  SWRequestFormData use to get query string
 */
- (NSString *)getQueryString;
@end

/**
 *  SWRequestFormData use to generate HTTPBody as Multipart FormData on the request.
 */
@interface SWRequestMulitFormData : SWRequestDataType

@end
/**
 *  SWRequestJSONData use to generate HTTPBody as JSON on the request.
 */
@interface SWRequestJSONData : SWRequestDataType

@end

