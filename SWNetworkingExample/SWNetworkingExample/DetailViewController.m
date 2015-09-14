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

@interface DetailViewController (){
    IBOutlet UIProgressView *progressView;
}

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        // Update the view.
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
        case 7:
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
                    [self startdownloadSession];
                    break;
                }
                case 15:{
                    [self startUploadSession];
                    break;
                }
               
                default:
                    break;
            }
            break;
        }
        case 6: {
            switch (indexPath.row) {
                case 0:
                {
                    [self startdownloadSession];
                    break;
                }
                case 1:{
                    [self startUploadSession];

                    break;
                }
                    
                case 2:{
                    [self startdataSession];
                    break;
                }
               
            }
        }
        default:
            break;
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark get request

-(void)simpleGET{
    
    SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    [getRequest startWithURL:@"your URL String" parameters:nil success:^(SWRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", [operation responseString]);
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)withResponseType{
    
    SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    getRequest.responseDataType = [SWResponseJSONDataType type];
    [getRequest startWithURL:@"your URL String" parameters:nil success:^(SWRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)withLoadingView{
   
    SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    getRequest.responseDataType = [SWResponseJSONDataType type];
    [getRequest startWithURL:@"your URL String" parameters:nil parentView:self.view success:^(SWRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", [operation responseString]);
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)withParameter{
   
    SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    getRequest.responseDataType = [SWResponseJSONDataType type];
    [getRequest startWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view success:^(SWRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)withCacheData{
    
    SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    getRequest.responseDataType = [SWResponseJSONDataType type];
    [getRequest startWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(SWRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
}


#pragma mark post request

-(void)simplePOST{
    
    SWPOSTRequest *postRequest = [[SWPOSTRequest alloc]init];
    postRequest.responseDataType = [SWResponseJSONDataType type];
    [postRequest startWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"} parentView:self.view cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(SWRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
    
    // or can use following key value  for the parameter
    
    
    SWPOSTRequest *postRequest2 = [[SWPOSTRequest alloc]init];
    postRequest2.responseDataType = [SWResponseJSONDataType type];
    [postRequest2 startWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"} parentView:self.view cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(SWRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)WithMultiPart{
    
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
    
    [postRequest startMultipartWithURL:@"your url" files:fileArray parameters:@{@"name": @"this is name", @"address": @"your address"} parentView:nil success:^(SWRequestOperation *operation, id responseObject) {
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
    
    // if parent view is nil you can't see any loading view
}

#pragma mark Put request

-(void)simplePUT{
    
    SWPUTRequest *putRequest = [[SWPUTRequest alloc]init];
    putRequest.responseDataType = [SWResponseXMLDataType type];
    
    [putRequest startWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view success:^(SWRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark Patch request

-(void)simplePatch{
    
    SWPATCHRequest *patchRequest = [[SWPATCHRequest alloc]init];
    patchRequest.responseDataType = [SWResponseXMLDataType type];
    
    [patchRequest startWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view success:^(SWRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark Delete request

-(void)simpleDELETE{
    
    SWDELETERequest *deleteRequest = [[SWDELETERequest alloc]init];
    deleteRequest.responseDataType = [SWResponseXMLDataType type];
    
    [deleteRequest startWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(SWRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark Head Request

-(void)simpleHEAD{
    
    SWHEADRequest *headRequest = [[SWHEADRequest alloc]init];
    headRequest.responseDataType = [SWResponseXMLDataType type];
    
    [headRequest startWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view success:^(SWRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark Features

-(void)autoLoadingView{
    
    // you only need to pass your parent view . framework will and loading view to parent view. If you want to custormize view you can create nib file inssdie your project and that nib file name shoud be "sw_loadingView"
    
    SWHEADRequest *headRequest = [[SWHEADRequest alloc]init];
    headRequest.responseDataType = [SWResponseXMLDataType type];
    
    [headRequest startWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(SWRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)downloadProgress{
    SWGETRequest *getR = [[SWGETRequest alloc]init];
    [getR startWithURL:@"http://samples.mplayerhq.hu/A-codecs/ACELP.net/2001-04-11.asf" parameters:nil parentView:nil cachedData:^(NSCachedURLResponse *response, id responseObject) {
        
    } success:^(SWRequestOperation *operation, id responseObject) {
        NSLog(@"success");
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        NSLog(@"fail %@", error);
    }];
    
    [getR setDownloadProgressBlock:^(long long bytes,long long totalBytes,long long totalBytesExpected) {
        NSLog(@"%lld -%lld -%lld", bytes, totalBytes, totalBytesExpected);
    }];
    
}

-(void)uploadProgress{
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
    
    [postRequest startMultipartWithURL:@"your url" files:fileArray parameters:@{@"name": @"this is name", @"address": @"your address"} parentView:nil success:^(SWRequestOperation *operation, id responseObject) {
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
    
    [postRequest setUploadProgressBlock:^(long long bytes,long long totalBytes,long long totalBytesExpected) {
        NSLog(@"%lld -%lld -%lld", bytes, totalBytes, totalBytesExpected);
    }];

}

-(void)customHeader{
    SWPOSTRequest *postRequest = [[SWPOSTRequest alloc]init];
    
    [postRequest.request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    postRequest.responseDataType = [SWResponseJSONDataType type];
    
    [postRequest startWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(SWRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
    
}

-(void)customContentType{
    SWPOSTRequest *postRequest = [[SWPOSTRequest alloc]init];
    
    [postRequest.request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    postRequest.responseDataType = [SWResponseJSONDataType type];
    
    [postRequest startWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(SWRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)customTimeOut{
    
    SWPOSTRequest *postRequest = [[SWPOSTRequest alloc]init];
    [postRequest setTimeOut:120];
    postRequest.responseDataType = [SWResponseJSONDataType type];
    
    [postRequest startWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(SWRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)offlineRequest{
    // only you need to call relevent methods. it's available for every reqest time.
    
    SWPOSTRequest *postRequest = [[SWPOSTRequest alloc]init];
    postRequest.responseDataType = [SWResponseJSONDataType type];
    
    [postRequest startWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view sendLaterIfOffline:YES  cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(SWRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
    
    // If you want to see evenet complete time. example on app delegate.

}

-(void)responseEncoding{
    
    //JSON
    SWPOSTRequest *postRequest = [[SWPOSTRequest alloc]init];
    postRequest.responseDataType = [SWResponseJSONDataType type];
    
    [postRequest startWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(SWRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
    
    
    //XML
    SWPOSTRequest *postRequestXML = [[SWPOSTRequest alloc]init];
    postRequestXML.responseDataType = [SWResponseJSONDataType type];
    
    [postRequestXML startWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(SWRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
    
    //String
    SWPOSTRequest *postRequestString = [[SWPOSTRequest alloc]init];
    postRequestString.responseDataType = [SWResponseStringDataType type];
    
    [postRequestString startWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(SWRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
    
    //String
    SWGETRequest *getRequestImage = [[SWGETRequest alloc]init];
    getRequestImage.responseDataType = [SWResponseUIImageType type];
    
    [getRequestImage startWithURL:@"your URL String" parameters:nil parentView:nil cachedData:^(NSCachedURLResponse *response, id responseObject) {
       // responseObject will be an image
    } success:^(SWRequestOperation *operation, id responseObject) {
        
       // responseObject will be an image
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)accessCacheData{
    
    SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    getRequest.responseDataType = [SWResponseJSONDataType type];
    
    [getRequest startWithURL:@"your URL String" parameters:nil parentView:nil cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
        // cahched json response will come to this block
    } success:^(SWRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)uiImageViewWithURL{
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

-(void)netWorkAvailibity{
    
    if ([SWReachability getCurrentNetworkStatus] == SWNetworkReachabilityStatusNotReachable) {
        //connection not available.
    }
    
    //if you want to get status change notification
    
    [SWReachability checkCurrentStatus:^(SWNetworingReachabilityStatus currentStatus) {
        //current status when call method
    } statusChange:^(SWNetworingReachabilityStatus changedStatus) {
        //every time when change status
    }];
}

-(void)multipleOperations{
    
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
    
}

-(void)downloadProgressWithProgressView{
    SWGETRequest *getR = [[SWGETRequest alloc]init];
    [getR startWithURL:@"http://samples.mplayerhq.hu/A-codecs/ACELP.net/2001-04-11.asf" parameters:nil parentView:nil cachedData:^(NSCachedURLResponse *response, id responseObject) {
        
    } success:^(SWRequestOperation *operation, id responseObject) {
        NSLog(@"success");
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        NSLog(@"fail %@", error);
    }];
    
    progressView.hidden = NO;
    [progressView setRequestForDownload:getR];
}

-(void)uploadProgressWithProgressView{
    
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
    
    [postRequest startMultipartWithURL:@"your url" files:fileArray parameters:@{@"name": @"this is name", @"address": @"your address"} parentView:nil success:^(SWRequestOperation *operation, id responseObject) {
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
    
    [progressView setRequestForDownload:postRequest];

}

#pragma mark session method

-(void)startUploadSession{
    SWSessionManager *sm = [[SWSessionManager alloc]initWithSessionConfiguration:nil];
    sm.requestDataType = [SWRequestMulitFormData type];
    
    UIImage *image = [UIImage imageNamed:@"skywite.png"];
    
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    
    SWMedia *media = [[SWMedia alloc]initWithFileName:@"skywite.png" key:@"fileToUpload" data:imageData];
    
    NSURLSessionUploadTask *ts = [sm uploadTaskWithPostURL:@"" parameters:nil files:@[media] success:^(NSURLSessionUploadTask *uploadTask, id responseObject) {
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
    [ts resume];
    [ts setUploadProgressBlock:^(long long bytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"%lld - %lld", bytesWritten, totalBytesExpectedToWrite);
    }];
}


-(void)startdownloadSession{
    SWSessionManager *sm = [[SWSessionManager alloc]initWithSessionConfiguration:nil];
    
    NSURLSessionDownloadTask *ts = [sm downloadTaskWithGetURL:@"" parameters:nil dowloadURL:nil success:^(NSURLSessionDownloadTask *uploadTask, NSURL *location) {
        NSLog(@"%@", location);
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
    
    [ts setDownloadProgressBlock:^(long long totalBytes, long long totalBytesExpected) {
        NSLog(@"%lld %lld", totalBytes, totalBytesExpected);
    }];
    [ts resume];
}


-(void)startdataSession{
    SWSessionManager *sm = [[SWSessionManager alloc]initWithSessionConfiguration:nil];
    
    NSURLSessionDataTask *ts = [sm dataTaskWithGetURL:@"" parameters:nil success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
    
    [ts resume];
}
@end
