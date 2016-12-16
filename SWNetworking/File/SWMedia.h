//
//  SWMedia.h
//  SWNetworking
//
//  Created by Saman Kumara on 4/21/15.
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

/**
 *  This interface will help to send mulitipart request with some files. before and file need to create files.
 */
@interface SWMedia : NSObject
/**
 *  File name will return from this
 */
@property (readonly, nonatomic, retain) NSString    *fileName;

/**
 *  Request key will return from this
 */
@property (readonly, nonatomic, retain) NSString    *key;
/**
 *  Request File mine tipe will return from this
 */
@property (readonly, nonatomic, retain) NSString    *MIMEType;

/**
 *  Request file Data will return from this
 */
@property (readonly, nonatomic, retain) NSData      *data;


/**
 *  When user create with commen file types user can use this method.
 *
 *  @param name file name
 *  @param key  request key
 *  @param data file data
 *
 *  @return SWMedia object will return
 */
- (id)initWithFileName:(NSString*)name key:(NSString*)key data:(NSData *)data;

/**
 *  When user create with custom file types user can use this method.
 *
 *  @param name file name
 *  @param key  request key
 *  @param type Custom Mine Type
 *  @param data file data
 *
 *  @return SWMedia object will return
 */
- (id)initWithFileName:(NSString *)name key:(NSString *)key mineType:(NSString *)type  data:(NSData *)data;
@end
