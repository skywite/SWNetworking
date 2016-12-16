//
//  SWResponseDataType.h
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

#import <Foundation/Foundation.h>
#import <TargetConditionals.h>


#if TARGET_OS_IOS || TARGET_OS_TV
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import <Cocoa/Cocoa.h>
#endif

/**
 *  SWResponseDataType protocol
 */
@protocol SWResponseDataType <NSObject>

@end

@interface SWResponseDataType : NSObject<SWResponseDataType>
/**
 *  user can see their response status code using this parameter
 */
@property(nonatomic, assign) int responseCode;

/**
 *  The Response Data Type class
 *
 *  @return ResponseDataType will return
 */

+ (instancetype)type;

/**
 *  The Response Data Type class
 *
 *  @return ResponseDataType will return
 */
- (id)responseOjbect:(NSHTTPURLResponse *) response data:(NSData *)data;

/**
 *  The Response Data Type class
 *
 *  @return ResponseDataType will return
 */
- (id)responseOjbectFromdData:(NSData *)data;

@end


/**
 This Interface type use JSON as response type. Interface will sublass from SWresponseDataType
 */
@interface SWResponseJSONDataType : SWResponseDataType

/**
 *  Using this method user can set reading optios for the JSON request
 *
 *  @param readingOptions NSJSONReadingOptions object need to pass
 *
 *  @return SWResponseJSONDataType object
 */
- (instancetype)initWithJSONResponseWithReadingOptions:(NSJSONReadingOptions)readingOptions;


@end

/**
 This Interface type use XML as response type. Interface will sublass from SWresponseDataType
 */
@interface SWResponseXMLDataType : SWResponseDataType

@end


/**
 This Interface type use NSString as response type. Interface will sublass from SWresponseDataType
 */
@interface SWResponseStringDataType : SWResponseDataType


/**
If someone want to change encoding method this is the method the set the encoding
 */
@property (nonatomic, assign) NSStringEncoding encoding;

/**
 *  The Response Data Type class
 *
 *  @param encoding typeWithEncoding type need to pass
 *
 *  @return ResponseDataType will return
 */

+ (instancetype)typeWithEncoding:(NSStringEncoding)encoding;

@end


/**
 This Interface type use UIImage as response type. Interface will sublass from SWresponseDataType
 */
@interface SWResponseImageType : SWResponseDataType

@end
