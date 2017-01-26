//
//  UIProgressView+SWNetworking.h
//  Example
//
//  Created by Saman Kumara on 7/11/15.
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
 *  This category created to use UIProgressView with upload and download request.
 */
@interface UIProgressView (SWNetworking)

/**
 *  Using this method will set download progress block on the SWReqeustOperation request
 *
 *  @param request Then download request
 */
- (void)setRequestForDownload:(SWRequest *) request;

/**
 *  Using this method will set Upload progress block on the SWReqeustOperation request
 *
 *  @param request Then download request
 */
- (void)setRequestForUpload:(SWRequest *) request;

/**
 *  Using this method will set download progress block on the NSURLSessionDownloadTask task
 *
 *  @param downloadTask task
 */
- (void)setDownloadTask:(NSURLSessionDownloadTask *)downloadTask;

/**
 *  Using this method will set Upload progress block on the NSURLSessionUploadTask task
 *
 *  @param uploadTask task
 */
- (void)setUploadTask:(NSURLSessionUploadTask *)downloadTask;

@end
#endif
