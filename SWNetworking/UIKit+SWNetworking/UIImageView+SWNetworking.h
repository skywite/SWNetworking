//
//  UIImageView+SWNetworking.h
//  SWNetworking
//
//  Created by Saman Kumara on 5/14/15.
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

#if TARGET_OS_IOS || TARGET_OS_TV

#import <UIKit/UIKit.h>
#import "SWRequest.h"

/**
 *  THis is for category for UIImageView. IT wil help to load image from  GET request.
 */
@interface UIImageView (SWNetworking)
/**
 *  The complete block when done the download.
 */
@property(nonatomic, copy) void (^complete)(UIImage *image) ;
/**
 *  The GET request that use to download image.
 */
@property (nonatomic, strong) SWGETRequest *imageRequest;

/**
 *  This method will help to downlaod image from URL.
 *
 *  @param url      The url that user want to downlaod.
 */
- (void)loadWithURLString:(NSString *)url;
/**
 *  This method will help to downlaod image without complete block.
 *
 *  @param url      The url that user want to downlaod.
 *  @param status   IF yes, image will load from cache first. Then will load from downloading.
 */
- (void)loadWithURLString:(NSString *)url loadFromCacheFirst:(BOOL)status;

/**
 *  This method will help to downlaod image with complete block. Block response will be an image.
 *
 *  @param url      The url that user want to downlaod.
 *  @param complete Complete block as an image
 */
- (void)loadWithURLString:(NSString *)url complete:(void(^)(UIImage *image))complete;

/**
 *  This method will help to downlaod image with complete block. Block response will be an image.
 *
 *  @param url      The url that user want to downlaod.
 *  @param status   IF yes, image will load from cache first. Then will load from downloading.
 *  @param complete Complete block as an image
 */
- (void)loadWithURLString:(NSString *)url loadFromCacheFirst:(BOOL)status complete:(void(^)(UIImage *image))complete;

/**
 *  This method can use to cancle image downloading.
 */
- (void)cancelLoading;

@end

#endif
