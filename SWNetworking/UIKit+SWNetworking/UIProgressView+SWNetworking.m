//
//  UIProgressView+SWNetworking.m
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

#import "UIProgressView+SWNetworking.h"


#if TARGET_OS_IOS || TARGET_OS_TV
@implementation UIProgressView (SWNetworking)

- (void)setRequestForDownload:(SWRequest *) request{
    [request setDownloadProgressBlock:^(long long bytesWritten,long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        if ([NSThread isMainThread]) {
            self.progress = ((float)totalBytesWritten / totalBytesExpectedToWrite);
        }else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.progress = ((float)totalBytesWritten / totalBytesExpectedToWrite);
            });
        }
    }];
}
- (void)setRequestForUpload:(SWRequest *) request{
    [request setUploadProgressBlock:^(long long bytesWritten, long long totalBytesExpectedToWrite) {
        self.progress = ((float)bytesWritten / totalBytesExpectedToWrite);
    }];
}

- (void)setDownloadTask:(NSURLSessionDownloadTask *)downloadTask{
    
    [downloadTask setDownloadProgressBlock:^(long long  bytesWritten, long long totalBytesWritten,  long long totalBytesExpectedToWrite) {
        if ([NSThread isMainThread]) {
            self.progress = ((float)totalBytesWritten / totalBytesExpectedToWrite);
        }else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.progress = ((float)totalBytesWritten / totalBytesExpectedToWrite);
            });
        }
    }];
}

- (void)setUploadTask:(NSURLSessionUploadTask *)downloadTask{
    [downloadTask setUploadProgressBlock:^(long long bytesWritten, long long totalBytesExpectedToWrite) {
         self.progress = ((float)bytesWritten / totalBytesExpectedToWrite);
    }];
}

@end
#endif
