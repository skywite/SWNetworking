//
//  SWMedia.m
//  SWNetworking Example
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

#import "SWMedia.h"

@interface SWMedia(){

}

@property (readwrite, nonatomic, retain) NSString               *fileName;
@property (readwrite, nonatomic, retain) NSString               *MIMEType;
@property (readwrite, nonatomic, retain) NSString               *key;
@property (readwrite, nonatomic, retain) NSData                 *data;

@property (nonatomic, retain) NSMutableArray                    *mineTypes;

@end

@implementation SWMedia

- (void)createMinetypes{
    self.mineTypes = [[NSMutableArray alloc]init];
    [self.mineTypes addObject:@{@"extention": @"3gp", @"type": @"video/3gpp"}];
    [self.mineTypes addObject:@{@"extention": @"3g2", @"type": @"video/3gpp2"}];
    [self.mineTypes addObject:@{@"extention": @"7z", @"type": @"application/x-7z-compressed"}];
    [self.mineTypes addObject:@{@"extention": @"pdf", @"type": @"application/pdf"}];
    [self.mineTypes addObject:@{@"extention": @"gif", @"type": @"image/gif"}];
    [self.mineTypes addObject:@{@"extention": @"jpeg", @"type": @"image/jpeg"}];
    [self.mineTypes addObject:@{@"extention": @"jpg", @"type": @"image/jpeg"}];
    [self.mineTypes addObject:@{@"extention": @"jpgv", @"type": @"video/jpeg"}];
    [self.mineTypes addObject:@{@"extention": @"xls", @"type": @"application/vnd.ms-excel"}];
    [self.mineTypes addObject:@{@"extention": @"pptx", @"type": @"application/vnd.openxmlformats-officedocument.presentationml.presentation"}];
    [self.mineTypes addObject:@{@"extention": @"docx", @"type": @"application/vnd.openxmlformats-officedocument.wordprocessingml.document"}];
    [self.mineTypes addObject:@{@"extention": @"ppt", @"type": @"application/vnd.ms-powerpoint"}];
    [self.mineTypes addObject:@{@"extention": @"wmv", @"type": @"video/x-ms-wmv"}];
    [self.mineTypes addObject:@{@"extention": @"doc", @"type": @"application/msword"}];
    [self.mineTypes addObject:@{@"extention": @"mpeg", @"type": @"video/mpeg"}];
    [self.mineTypes addObject:@{@"extention": @"mp4a", @"type": @"audio/mp4"}];
    [self.mineTypes addObject:@{@"extention": @"mp4", @"type": @"video/mp4"}];
    [self.mineTypes addObject:@{@"extention": @"png", @"type": @"image/png"}];
    [self.mineTypes addObject:@{@"extention": @"xml", @"type": @"application/rss+xml"}];
    [self.mineTypes addObject:@{@"extention": @"rss", @"type": @"application/rss+xml"}];
    [self.mineTypes addObject:@{@"extention": @"movie", @"type": @"video/x-sgi-movie"}];
    [self.mineTypes addObject:@{@"extention": @"tar", @"type": @"application/x-tar"}];
    [self.mineTypes addObject:@{@"extention": @"txt", @"type": @"text/plain"}];
}
- (id)initWithFileName:(NSString*)name key:(NSString*)key data:(NSData *)data {
    
    self            = [super init];
    
    [self createMinetypes];
    
    self.fileName   = name;
    self.key        = key;
    self.data       = data;
    
    NSString *extention = [self.fileName pathExtension];
    if (extention) {
        for (NSDictionary *temp in self.mineTypes) {
            if ([[temp objectForKey:@"extention"] isEqualToString:[extention lowercaseString]]) {
                self.MIMEType = [temp objectForKey:@"type"];
                break;
            }
        }
    }
    
    return self;
}

- (id)initWithFileName:(NSString *)name key:(NSString *)key mineType:(NSString *)type data:(NSData *)data {
    self            = [self initWithFileName:name key:key data:data];
    self.MIMEType   = type;
    return self;
}

@end
