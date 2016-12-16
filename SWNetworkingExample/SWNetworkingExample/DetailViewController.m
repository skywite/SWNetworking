//
//  DetailViewController.m
//  Example
//
//  Created by Saman Kumara on 7/6/15.
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

#import "DetailViewController.h"
#import "SWNetworking.h"
#import "UIImageView+SWNetworking.h"
#import "UIProgressView+SWNetworking.h"
@interface DetailViewController (){
    IBOutlet UIProgressView *progressView;
}

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }
}


- (void)viewDidLoad {
    NSIndexPath *indexPath = self.detailItem;
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [self simpleGET];
                    break;
                }
                case 1:
                {
                    [self withResponseType];
                    break;
                }
                case 2:
                {
                    [self withLoadingView];
                    break;
                }
                case 3:
                {
                    [self withParameter];
                    break;
                }
                case 4:
                {
                    [self withCacheData];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:
            switch (indexPath.row) {
                case 0:
                {
                    [self simplePOST];
                    break;
                }
                case 1:
                {
                    [self WithMultiPart];
                    break;
                }
                default:
                    break;
            }
            break;
            
        case 2:
        {
            [self simplePUT];
            break;
        }
        case 3:
        {
            [self simplePatch];
            break;
        }
        case 4:
        {
            [self simpleDELETE];
            break;
            
        }
        case 5:{
            
            [self simpleHEAD];
            break;
        }
        case 6:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [self autoLoadingView];
                    break;
                }
                case 1:{
                    [self downloadProgress];
                    break;
                }
                  
                case 2:{
                    [self uploadProgress];
                    break;
                }
                case 3:
                {
                    [self customHeader];
                    break;
                }
                case 4:
                {
                    [self customContentType];
                    break;
                }
                case 5:
                {
                    [self customTimeOut];
                    break;
                }
                case 6:
                {
                    [self offlineRequest];
                    break;
                }
                case 7:
                {
                    [self responseEncoding];
                    break;
                }
                case 8:
                {
                    [self accessCacheData];
                    break;
                }
                case 9:
                {
                    [self uiImageViewWithURL];
                    break;
                }
                case 10:
                {
                    [self netWorkAvailibity];
                    break;
                }
                case 11:{
                    [self multipleOperations];
                    break;
                }
                case 12:{
                    [self downloadProgressWithProgressView];
                    break;
                }
                case 13:{
                    [self uploadProgressWithProgressView];
                    break;
                }
                case 14:{
                    //[self startdownloadSession];
                    break;
                }
                case 15:{
                   // [self startUploadSession];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
        break;
    }
    [super viewDidLoad];
}

#pragma mark get request

- (void)simpleGET {
    SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    [getRequest startDataTaskWithURL:@"https://www.google.lk/" parameters:nil success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        NSLog(@"response as String %@", getRequest.responseString);

    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
    
    }];
}

- (void)withResponseType {
    SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    getRequest.responseDataType = [SWResponseJSONDataType type];
    [getRequest startDataTaskWithURL:@"http://127.0.0.1:3000" parameters:nil parentView:nil success:^(NSURLSessionDataTask *uploadTask, id responseObject) {

    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {

    }];
}

- (void)withLoadingView {
    SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    getRequest.responseDataType = [SWResponseJSONDataType type];
    [getRequest startDataTaskWithURL:@"http://127.0.0.1:3000" parameters:nil parentView:self.view success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
    
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {

    }];
}

- (void)withParameter {
    SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    getRequest.responseDataType = [SWResponseJSONDataType type];
    [getRequest startDataTaskWithURL:@"http://127.0.0.1:3000" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:nil success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
    
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {

    }];
}

- (void)withCacheData {
    SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    getRequest.responseDataType = [SWResponseStringDataType type];
    [getRequest startDataTaskWithURL:@"http://127.0.0.1:3000" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:nil cachedData:^(NSCachedURLResponse *response, id responseObject) {
    } success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
}


#pragma mark post request

- (void)simplePOST {
    SWPOSTRequest *postRequest = [[SWPOSTRequest alloc]init];
    postRequest.responseDataType = [SWResponseJSONDataType type];
    
    [postRequest startDataTaskWithURL:@"http://127.0.0.1:3000/drivers" parameters:@"name=this is name&address=your address" parentView:nil cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    // or can use following key value  for the parameter
    
    SWPOSTRequest *postRequest2 = [[SWPOSTRequest alloc]init];
    postRequest2.responseDataType = [SWResponseJSONDataType type];
    [postRequest2 startDataTaskWithURL:@"http://127.0.0.1:3000/drivers" parameters:@{@"name": @"this is name", @"address": @"your address"} parentView:nil cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)WithMultiPart {
    SWPOSTRequest *postRequest = [[SWPOSTRequest alloc]init];
    postRequest.responseDataType = [SWResponseJSONDataType type];
    
    //need to crate files array to upload
    
    UIImage *image = [UIImage imageNamed:@"skywite"];
    NSData *imageData = UIImagePNGRepresentation(image);
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

- (void)simplePUT {
    SWPUTRequest *putRequest = [[SWPUTRequest alloc]init];
    putRequest.responseDataType = [SWResponseXMLDataType type];
    
    [putRequest startDataTaskWithURL:@"http://127.0.0.1:3000/drivers" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:nil success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        NSLog(@"%@", error);
    }];}

#pragma mark Patch request

- (void)simplePatch{
    
    SWPATCHRequest *patchRequest = [[SWPATCHRequest alloc]init];
    patchRequest.responseDataType = [SWResponseXMLDataType type];
    
    [patchRequest startDataTaskWithURL:@"http://127.0.0.1:3000/drivers" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:nil success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark Delete request

- (void)simpleDELETE{
    
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

- (void)simpleHEAD{
    
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

- (void)autoLoadingView{
    
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

- (void)downloadProgress{
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

- (void)uploadProgress{
    SWPOSTRequest *postRequest = [[SWPOSTRequest alloc]init];
    postRequest.responseDataType = [SWResponseJSONDataType type];
    
    //need to crate files array to upload
    
    UIImage *image = [UIImage imageNamed:@"skywite"];
    NSData *imageData = UIImagePNGRepresentation(image);
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

- (void)customHeader{
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

- (void)customContentType{
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

- (void)customTimeOut{
    
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

- (void)offlineRequest{
    // only you need to call relevent methods. it's available for every reqest time.
    
    SWPOSTRequest *postRequest = [[SWPOSTRequest alloc]init];
    postRequest.responseDataType = [SWResponseJSONDataType type];
    
    [postRequest startDataTaskWithURL:@"http://127.0.0.1:3000/drivers" parameters:@{@"name": @"this is name", @"address": @"your address"} parentView:nil sendLaterIfOffline:YES cachedData:^(NSCachedURLResponse *response, id responseObject) {
        
    } success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
    
    // If you want to see evenet complete time. example on app delegate.
}

- (void)responseEncoding{
    
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

- (void)accessCacheData{
    
    SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    getRequest.responseDataType = [SWResponseJSONDataType type];
    
    [getRequest startDataTaskWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
}

- (void)uiImageViewWithURL{
    // few samples
    
    // Please use only one method . you can see 4 methods :)
    
    // from url
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    [imageView loadWithURLString:@"image url"];
    
    
    //if you want to load image cache and then load download you can use following method
    [imageView loadWithURLString:@"image url" loadFromCacheFirst:YES];
    
    //If you want to get complete event
    [imageView loadWithURLString:@"image url" complete:^(UIImage *image) {
        //you can assing your image to your object here.
    }];
    
    //if you want cache and image handle
    [imageView loadWithURLString:@"image url" loadFromCacheFirst:YES complete:^(UIImage *image) {
        
    }];
}

- (void)netWorkAvailibity{
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

- (void)multipleOperations{
    /*
    SWGETRequest *getR = [[SWGETRequest alloc]init];
    getR.wantToUseQueue = YES;
    [getR startWithURL:@"http://www.google.com" parameters:nil parentView:nil sendLaterIfOffline:YES cachedData:^(NSCachedURLResponse *response, id responseObject) {
        
    } success:^(SWRequestOperation *operation, id responseObject) {
        NSLog(@"success");
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        NSLog(@"fail %@", error);
    }];
    
    SWPOSTRequest *postR = [[SWPOSTRequest alloc]init];
    postR.wantToUseQueue = YES;
    [postR startWithURL:@"your send request URL" parameters:nil parentView:nil sendLaterIfOffline:YES cachedData:^(NSCachedURLResponse *response, id responseObject) {
        
    } success:^(SWRequestOperation *operation, id responseObject) {
        NSLog(@"success");
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        NSLog(@"fail %@", error);
    }];
    
    SWOperationManger *oparetaionManager = [[SWOperationManger alloc]init];
    [oparetaionManager addOperation:getR];
    [oparetaionManager addOperation:postR];
    */
}

- (void)downloadProgressWithProgressView{
    SWGETRequest *getR = [[SWGETRequest alloc]init];
    [getR startDownloadTaskWithURL:@"http://samples.mplayerhq.hu/A-codecs/ACELP.net/2001-04-11.asf" parameters:nil parentView:nil success:^(NSURLSessionDownloadTask *uploadTask,  NSURL *location) {
        NSLog(@"%@", location);
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    progressView.hidden = NO;
    [progressView setRequestForDownload:getR];
}

- (void)uploadProgressWithProgressView{
    
    SWPOSTRequest *postRequest = [[SWPOSTRequest alloc]init];
    postRequest.responseDataType = [SWResponseJSONDataType type];
    
    //need to crate files array to upload
    
    UIImage *image = [UIImage imageNamed:@"skywite"];
    NSData *imageData = UIImagePNGRepresentation(image);
    SWMedia *file1 = [[SWMedia alloc]initWithFileName:@"imagefile.png" key:@"image" data:imageData];
    
    //create with custom mine type one
    
    SWMedia *file2 = [[SWMedia alloc]initWithFileName:@"image.jpg" key:@"image2" mineType:@"image/jpeg" data:imageData];
    
    //create an array with files
    
    NSArray *fileArray = @[file1, file2];
    
    [postRequest startUploadTaskWithURL:@"" files:fileArray parameters:@{@"name": @"this is name", @"address": @"your address"} success:^(NSURLSessionUploadTask *uploadTask, id responseObject) {
        
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
    
    [progressView setRequestForUpload:postRequest];

}
@end
