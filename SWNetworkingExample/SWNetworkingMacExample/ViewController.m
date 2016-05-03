//
//  ViewController.m
//  SWNetworkingMacExample
//
//  Created by Saman Kumara on 5/2/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
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


#import "ViewController.h"
#import "SWNetworking.h"
#import "UIImageView+SWNetworking.h"
#import "UIProgressView+SWNetworking.h"

@implementation ViewController


- (void)viewDidLoad {
    [self uploadProgress];
    [super viewDidLoad];
}

#pragma mark get request

-(void)simpleGET {
    SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    [getRequest startDataTaskWithURL:@"http://127.0.0.1:3000" parameters:nil success:^(NSURLSessionDataTask *uploadTask, id responseObject) {

    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
}

-(void)withResponseType {
    SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    getRequest.responseDataType = [SWResponseJSONDataType type];
    [getRequest startDataTaskWithURL:@"http://127.0.0.1:3000" parameters:nil parentView:nil success:^(NSURLSessionDataTask *uploadTask, id responseObject) {

    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
}

-(void)withLoadingView {
    SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    getRequest.responseDataType = [SWResponseJSONDataType type];
    [getRequest startDataTaskWithURL:@"http://127.0.0.1:3000" parameters:nil parentView:self.view success:^(NSURLSessionDataTask *uploadTask, id responseObject) {

    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
}

-(void)withParameter {
    SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    getRequest.responseDataType = [SWResponseJSONDataType type];
    [getRequest startDataTaskWithURL:@"http://127.0.0.1:3000" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:nil success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        NSLog(@"response as String %@", responseObject);

    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
}

-(void)withCacheData {
    SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    getRequest.responseDataType = [SWResponseStringDataType type];
    [getRequest startDataTaskWithURL:@"http://127.0.0.1:3000" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:nil cachedData:^(NSCachedURLResponse *response, id responseObject) {
    } success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
}


#pragma mark post request

-(void)simplePOST {
    SWPOSTRequest *postRequest = [[SWPOSTRequest alloc]init];
    postRequest.responseDataType = [SWResponseJSONDataType type];
    
    [postRequest startDataTaskWithURL:@"http://127.0.0.1:3000" parameters:@"name=this is name&address=your address" parentView:nil cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    // or can use following key value  for the parameter
    
    SWPOSTRequest *postRequest2 = [[SWPOSTRequest alloc]init];
    postRequest2.responseDataType = [SWResponseJSONDataType type];
    [postRequest2 startDataTaskWithURL:@"http://127.0.0.1:3000" parameters:@{@"name": @"this is name", @"address": @"your address"} parentView:nil cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        NSLog(@"%@", error);
    }];
}

-(void)WithMultiPart {
    SWPOSTRequest *postRequest = [[SWPOSTRequest alloc]init];
    postRequest.responseDataType = [SWResponseJSONDataType type];
    
    //need to crate files array to upload
    
    NSImage *image = [NSImage imageNamed:@"skywite"];
    NSData *imageData = [self pngRepresentationOfImage:image];
    SWMedia *file1 = [[SWMedia alloc]initWithFileName:@"imagefile.png" key:@"image" data:imageData];
    
    //create with custom mine type one
    
    SWMedia *file2 = [[SWMedia alloc]initWithFileName:@"image.jpg" key:@"image2" mineType:@"image/jpeg" data:imageData];
    
    //create an array with files
    
    NSArray *fileArray = @[file1, file2];
    
    [postRequest startUploadTaskWithURL:@"http://127.0.0.1:3000/drivers" files:fileArray parameters:@{@"name": @"this is name", @"address": @"your address"} parentView:nil
                             cachedData:^(NSCachedURLResponse *response, id responseObject) {
                                 NSLog(@"%@", responseObject);
                             } success:^(NSURLSessionUploadTask *uploadTask, id responseObject) {
                                 NSLog(@"%@", responseObject);
                             } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
                                 NSLog(@"%@", error);
                             }];
    
    // if parent view is nil you can't see any loading view
}


#pragma mark Put request

-(void)simplePUT {
    SWPUTRequest *putRequest = [[SWPUTRequest alloc]init];
    putRequest.responseDataType = [SWResponseXMLDataType type];
    
    [putRequest startDataTaskWithURL:@"http://127.0.0.1:3000/drivers" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:nil success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        NSLog(@"%@", error);
    }];}

#pragma mark Patch request

-(void)simplePatch{
    
    SWPATCHRequest *patchRequest = [[SWPATCHRequest alloc]init];
    patchRequest.responseDataType = [SWResponseXMLDataType type];
    
    [patchRequest startDataTaskWithURL:@"http://127.0.0.1:3000/drivers" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:nil success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark Delete request

-(void)simpleDELETE{
    
    SWDELETERequest *deleteRequest = [[SWDELETERequest alloc]init];
    deleteRequest.responseDataType = [SWResponseXMLDataType type];
    
    [deleteRequest startDataTaskWithURL:@"http://127.0.0.1:3000/drivers" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:nil cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        NSLog(@"%@", error);
    }];}

#pragma mark Head Request

-(void)simpleHEAD{
    
    SWHEADRequest *headRequest = [[SWHEADRequest alloc]init];
    headRequest.responseDataType = [SWResponseXMLDataType type];
    
    [headRequest startDataTaskWithURL:@"http://127.0.0.1:3000/drivers" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:nil cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        NSLog(@"%@", error);
    }];}


#pragma mark Features

-(void)autoLoadingView{
    
    // you only need to pass your parent view . framework will and loading view to parent view. If you want to custormize view you can create nib file inssdie your project and that nib file name shoud be "sw_loadingView"
    
    SWHEADRequest *headRequest = [[SWHEADRequest alloc]init];
    headRequest.responseDataType = [SWResponseXMLDataType type];
    
    [headRequest startDataTaskWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        NSLog(@"%@", error);
    }];
}

-(void)downloadProgress{
    SWGETRequest *getR = [[SWGETRequest alloc]init];
    [getR startDownloadTaskWithURL:@"http://samples.mplayerhq.hu/A-codecs/ACELP.net/2001-04-11.asf" parameters:nil parentView:nil cachedData:^(NSCachedURLResponse *response,  NSURL *location) {
        
    } success:^(NSURLSessionDownloadTask *uploadTask,  NSURL *location) {
        NSLog(@"location %@", location);
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        NSLog(@"error %@", error);
    }];
    
    [getR setDownloadProgressBlock:^(long long bytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"bytesWritten => %lld and totalBytesExpectedToWrite = %lld", bytesWritten, totalBytesExpectedToWrite);
    }];
    
}

-(void)uploadProgress{
    SWPOSTRequest *postRequest = [[SWPOSTRequest alloc]init];
    postRequest.responseDataType = [SWResponseJSONDataType type];
    
    //need to crate files array to upload
    
    NSImage *image = [NSImage imageNamed:@"skywite"];
    NSData *imageData = [self pngRepresentationOfImage:image];
    SWMedia *file1 = [[SWMedia alloc]initWithFileName:@"imagefile.png" key:@"image" data:imageData];
    
    
    //create with custom mine type one
    
    SWMedia *file2 = [[SWMedia alloc]initWithFileName:@"image.jpg" key:@"image2" mineType:@"image/jpeg" data:imageData];
    
    //create an array with files
    
    NSArray *fileArray = @[file1, file2];
    
    [postRequest startUploadTaskWithURL:@"http://127.0.0.1:3000/drivers" files:fileArray parameters:@{@"name": @"this is name", @"address": @"your address"} parentView:nil  success:^(NSURLSessionUploadTask *uploadTask, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        NSLog(@"%@", error);
    }];
    [postRequest setUploadProgressBlock:^(long long bytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"bytesWritten => %lld and totalBytesExpectedToWrite = %lld", bytesWritten, totalBytesExpectedToWrite);
    }];
}

- (NSData *) pngRepresentationOfImage:(NSImage *) image {
    [image lockFocus];
    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0, 0, image.size.width, image.size.height)];
    [image unlockFocus];
    
    return [bitmapRep representationUsingType:NSPNGFileType properties:@{NSImageInterlaced: @NO}];
}

-(void)customHeader{
    SWPOSTRequest *postRequest = [[SWPOSTRequest alloc]init];
    
    [postRequest.request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    postRequest.responseDataType = [SWResponseJSONDataType type];
    
    [postRequest startDataTaskWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
    
}

-(void)customContentType{
    SWPOSTRequest *postRequest = [[SWPOSTRequest alloc]init];
    
    [postRequest.request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    postRequest.responseDataType = [SWResponseJSONDataType type];
    
    [postRequest startDataTaskWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
}

-(void)customTimeOut{
    
    SWPOSTRequest *postRequest = [[SWPOSTRequest alloc]init];
    [postRequest setTimeOut:120];
    postRequest.responseDataType = [SWResponseJSONDataType type];
    
    [postRequest startDataTaskWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
}

-(void)offlineRequest{
    // only you need to call relevent methods. it's available for every reqest time.
    
    SWPOSTRequest *postRequest = [[SWPOSTRequest alloc]init];
    postRequest.responseDataType = [SWResponseJSONDataType type];
    
    [postRequest startDataTaskWithURL:@"http://127.0.0.1:3000/drivers" parameters:@{@"name": @"this is name", @"address": @"your address"} parentView:nil sendLaterIfOffline:YES cachedData:^(NSCachedURLResponse *response, id responseObject) {
        
    } success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
    
    // If you want to see evenet complete time. example on app delegate.
}

-(void)responseEncoding{
    
    //JSON
    SWPOSTRequest *postRequest = [[SWPOSTRequest alloc]init];
    postRequest.responseDataType = [SWResponseJSONDataType type];
    
    [postRequest startDataTaskWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
    
    
    //XML
    SWPOSTRequest *postRequestXML = [[SWPOSTRequest alloc]init];
    postRequestXML.responseDataType = [SWResponseJSONDataType type];
    
    [postRequestXML startDataTaskWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
    
    //String
    SWPOSTRequest *postRequestString = [[SWPOSTRequest alloc]init];
    postRequestString.responseDataType = [SWResponseStringDataType type];
    
    [postRequestString startDataTaskWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
    
    //String
    SWGETRequest *getRequestImage = [[SWGETRequest alloc]init];
    getRequestImage.responseDataType = [SWResponseImageType type];
    
    [getRequestImage startDataTaskWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
}

-(void)accessCacheData{
    
    SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    getRequest.responseDataType = [SWResponseJSONDataType type];
    
    [getRequest startDataTaskWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
}

-(void)netWorkAvailibity{
    if ([SWReachability getCurrentNetworkStatus] == SWNetworkingReachabilityStatusNotReachable) {
        //connection not available.
    }
    
    //if you want to get status change notification
    
    [SWReachability checkCurrentStatus:^(SWNetworkingReachabilityStatus currentStatus) {
        //current status when call method
    } statusChange:^(SWNetworkingReachabilityStatus changedStatus) {
        //every time when change status
    }];
}

@end
