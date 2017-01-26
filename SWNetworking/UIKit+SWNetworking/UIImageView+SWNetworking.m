//
//  UIImageView+SWNetworking.m
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

#import <objc/runtime.h>

#if TARGET_OS_IOS || TARGET_OS_TV
#import "UIImageView+SWNetworking.h"

@implementation UIImageView (SWNetworking)
@dynamic complete;
@dynamic imageRequest;


- (void)loadWithURLString:(NSString *)url{
    [self loadWithURLString:url loadFromCacheFirst:NO];
}
- (void)loadWithURLString:(NSString *)url loadFromCacheFirst:(BOOL)status {
    [self loadWithURLString:url loadFromCacheFirst:status complete:nil];
}
- (void)loadWithURLString:(NSString *)url complete:(void(^)(UIImage *image))complete {
    [self loadWithURLString:url loadFromCacheFirst:NO complete:complete];
}
- (void)loadWithURLString:(NSString *)url loadFromCacheFirst:(BOOL)status complete:(void(^)(UIImage *image))complete {
    
    //self.complete = complete;
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.color = [UIColor grayColor];
    activityIndicator.alpha = 1.0;
    activityIndicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    activityIndicator.hidesWhenStopped = NO;
    [activityIndicator startAnimating];
    [self addSubview:activityIndicator];
    
    self.imageRequest = [[SWGETRequest alloc]init];
    self.imageRequest.responseDataType = [SWResponseImageType type];
    [self.imageRequest startDataTaskWithURL:url parameters:nil parentView:nil cachedData:^(NSCachedURLResponse *response, id responseObject) {
        if (status) {
            self.image = (UIImage *)responseObject;
        }
        [activityIndicator removeFromSuperview];
    } success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        [activityIndicator removeFromSuperview];
        self.image = (UIImage *)responseObject;
        if (complete) {
            complete(self.image);
        }
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
    
}

- (void)cancelLoading {
    if (self.imageRequest) {
        [self.imageRequest cancel];
    }
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[UIActivityIndicatorView class]]) {
            [v removeFromSuperview];
            break;
        }
    }
}

- (SWGETRequest *)imageRequest {
    return objc_getAssociatedObject(self, @selector(imageRequest));
}

- (void)setImageRequest:(SWGETRequest *)obj {
    objc_setAssociatedObject(self, @selector(imageRequest), obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
#endif
