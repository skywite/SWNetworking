# <p align="center" style='color:#30a1f3' >SWNetworking</p>

<p align="center" >
  <img src="http://skywite.com/wp-content/uploads/2015/05/skywite.png" alt="AFNetworking" title=“SkyWite”>
</p>


[![Build Status](https://travis-ci.org/skywite/SWNetworking.svg?branch=master)](https://travis-ci.org/skywite/SWNetworking)
[![Version](https://img.shields.io/cocoapods/v/SWNetworking.svg?style=flat)](http://cocoapods.org/pods/SWReachability)
[![License](https://img.shields.io/cocoapods/l/SWNetworking.svg?style=flat)](http://cocoapods.org/pods/SWReachability)
[![Platform](https://img.shields.io/cocoapods/p/SWNetworking.svg?style=flat)](http://cocoapods.org/pods/SWNetworking)
[![Analytics](https://ga-beacon.appspot.com/UA-69386051-1/skywite/SWNetworking/README)](https://github.com/igrigorik/ga-beacon)


SkyWite is an open-source and highly versatile multi-purpose frameworks. Clean code and sleek features make SkyWite an ideal choice. Powerful high-level networking abstractions built into Cocoa. It has a modular architecture with well-designed, feature-rich APIs that are a joy to use.

Achieve your deadlines by using SkyWite. You will save Hundred hours. 

Start development using Skywite. Definitely you will be happy....! yeah..


# Requirements

You need to add "SystemConfiguration" framework into your project before implement this.


#How to apply to Xcode project

### Downloading Source Code
 - [Download SWNetworking](https://github.com/skywite/SWNetworking/archive/master.zip) from gitHub
 - Add required frameworks
 - import "SWNetworking.h" to your source code file
 
### Using CocoaPods

SWNetworking is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SWNetworking"
```
If you new to CocoaPods, please go to [Wiki](https://github.com/skywite/SWNetworking/wiki/CocoaPods-in-to-Xcode-Project) page.

#Architecture
* `Session`
    - `SWSessionManager`
* `SWRequest`
 - `SWOperationManger`
 - `SWRequestOperation`
    - `SWGETRequest`
    - `SWPOSTRequest`
        - `SWMultiPartRequest` 
    - `SWPUTRequest`
    - `SWPATCHRequest`
    - `SWDELETERequest`
    - `SWHEADRequest`
 - `SWOfflineRequestManger`
* `ResponseType`
    - `SWResponseDataType`
        - `SWResponseJSONDataType`
        - `SWResponseXMLDataType`
        - `SWResponseStringDataType`
        - `SWResponseUIImageType`
    - `SWRequestDataType`
        - `SWRequestFormData`
        - `SWRequestMulitFormData`
        - `SWRequestJSONData`
* `Reachability`
    - `SWReachability`
* `File`
    - `SWMedia`
* `UIKit+SWNetworking`
    - `UIImageView+SWNetworking`
    - `UIProgressView+SWNetworking`
# How to Use

## Use HTTP Request Operation
ALL Requests will be operation. So you can use those request as `NSOperationQueue` . Request creation , response serialization, network reachability handing and offline request as well.

### `GET` Request
```objective-c
SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    [getRequest startWithURL:@"your URL String" parameters:nil success:^(SWRequestOperation *operation, id responseObject) {
        NSLog(@"%@", [operation responseString]);
    } failure:^(SWRequestOperation *operation, NSError *error) {
    }];
```
If you want send parameters you have two options

```objective-c
SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    [getRequest startWithURL:@"your URL String" parameters:@"paramkey=paramvalue&testkey=testvalue" success:^(SWRequestOperation *operation, id responseObject) {
        NSLog(@"%@", [operation responseString]);
    } failure:^(SWRequestOperation *operation, NSError *error) {
    }];
```
If you want to encdoe parameters and values you need to pass `NSDictionary` object with keys/values.

```objective-c
SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    [getRequest startWithURL:@"your URL String" parameters:@{@"paramkey"; @"paramvalue", @"testkey": @"testvalue"} success:^(SWRequestOperation *operation, id responseObject) {
        NSLog(@"%@", [operation responseString]);
    } failure:^(SWRequestOperation *operation, NSError *error) {
    }];
```

We are commonoded to use second option because if you have `&` sign with parameter or value it will break sending values.

###  `GET` with Response type 
Available as response types
`SWResponseJSONDataType`, `SWResponseJSONDataType`, `SWResponseXMLDataType`,` SWResponseStringDataType`,`SWResponseUIImageType`  
You need set `responseDataType`.

```objective-c
// this response will be JSON
 SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    getRequest.responseDataType = [SWResponseJSONDataType type];
    [getRequest startWithURL:@"your URL String" parameters:nil success:^(SWRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
```
### `GET` with loading indigator
If you set your parent view to mehtod, loading indigator will be displayed. 
```objective-c
    SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    getRequest.responseDataType = [SWResponseJSONDataType type];
    [getRequest startWithURL:@"your URL String" parameters:nil parentView:self.view success:^(SWRequestOperation *operation, id responseObject) {
        NSLog(@"%@", [operation responseString]);
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
```

If you want custom loading view you need to add new `nib` file to your project and name it as 'sw_loadingView'. It will be displyed on the screen.
### Cache Response
If you want to access cached data on the response. You need to use relevent method that include cache block
```objective-c
 SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    getRequest.responseDataType = [SWResponseJSONDataType type];
    [getRequest startWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"} parentView:self.view cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(SWRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
```
### `POST` request (simple)
Cache, Loading view avaible for the on the relvent methos. Please check avaialbe methods
```objective-c
SWPOSTRequest *postRequest2 = [[SWPOSTRequest alloc]init];
    postRequest2.responseDataType = [SWResponseJSONDataType type];
    [postRequest2 startWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"} parentView:self.view cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(SWRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
```

### `POST` multipart request
It is really easy.
```objective-c
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
```
### `PUT` simple reuqest
```objective-c
SWPUTRequest *putRequest = [[SWPUTRequest alloc]init];
    putRequest.responseDataType = [SWResponseXMLDataType type];
    
    [putRequest startWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view  success:^(SWRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
```
### `PATCH` simple request
```objective-c
    SWPATCHRequest *patchRequest = [[SWPATCHRequest alloc]init];
    patchRequest.responseDataType = [SWResponseXMLDataType type];
    
    [patchRequest startWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view  success:^(SWRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];

```
### `DELETE` simple request
```objective-c
 SWDELETERequest *deleteRequest = [[SWDELETERequest alloc]init];
    deleteRequest.responseDataType = [SWResponseXMLDataType type];
    
    [deleteRequest startWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(SWRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
```

### `HEAD` simple request
```objective-c
SWHEADRequest *headRequest = [[SWHEADRequest alloc]init];
    headRequest.responseDataType = [SWResponseXMLDataType type];
    
    [headRequest startWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view success:^(SWRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
```
## Features
all the following features averrable on all the request types. 
eg : If you want to access you need to call relevant method that include cache block 

### Custom headers
If you want to add custom headers you can set to accessing request object.
```objective-c
SWPOSTRequest *postRequest = [[SWPOSTRequest alloc]init];
    
    [postRequest.request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    postRequest.responseDataType = [SWResponseJSONDataType type];
    
    [postRequest startWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(SWRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
```

### Custom time out
If you want to change request timeout , you have to change property call `timeOut`.
```objective-c
  SWPOSTRequest *postRequest = [[SWPOSTRequest alloc]init];
    [postRequest setTimeOut:120];
    postRequest.responseDataType = [SWResponseJSONDataType type];
    
    [postRequest startWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(SWRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        
    }];
```
 
### Response Encoding
You need to sent object type for the `responseDataType` on all your requests.

```objective-c
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

```

### `UIImageView` with `SWNetworking`
No need to download image and set to `UIImageView` anymore. You can set url to `UIImageView`. 

```objective-c
// Please use only one method . you can see 4 methods :)
    
    // from url
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    [imageView loadWithURLString:@"image url"];
    
    
    //if you want to load image cache and then load download you can use following method
    [imageView loadWithURLString:@"image url" loadFromCacheFirst:YES];
    
    //If you want to get complete event
    [imageView loadWithURLString:@"image url" complete:^(UIImage *image) {
        //you can set your image to your object here.
    }];
    
    //if you want cache and image handle
    [imageView loadWithURLString:@"image url" loadFromCacheFirst:YES complete:^(UIImage *image) {
        
    }];
```

### Check Reachability
New Reachability class to support block when change network status
available Status

`SWNetworkReachabilityStatusNotReachable`
`SWNetworkReachabilityStatusReachableViaWWAN`
`SWNetworkReachabilityStatusReachableViaWiFi`

```objective-c
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

```
### Operation managare
As you know , If you want to send multiple requests (lot of requests) at the same time, it will get performance issue. So need to use `NSOperationQueue`. We are handing 'NSOperationQueue' with `SWOperationManger`

```objective-c
  SWOperationManger *operationManager = [[SWOperationManger alloc]init];
```

You can send max operation count.
```objective-c
  [operationManager setMaxOperationCount:3];
```
You can add multiple requests to queue. Please make sure set `wantToUseQueue` as `YES`.

```objective-c
    
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
```

### Upload progress With Request

```objective-c
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
    
    [postRequest setUploadProgressBlock:^(long bytes, long totalBytes, long totalBytesExpected) {
        NSLog(@"%ld -%ld -%ld", bytes, totalBytes, totalBytesExpected);
    }];
```

### Download Progress With Request

```objective-c
SWGETRequest *getR = [[SWGETRequest alloc]init];
    [getR startWithURL:@"url" parameters:nil parentView:nil cachedData:^(NSCachedURLResponse *response, id responseObject) {
        
    } success:^(SWRequestOperation *operation, id responseObject) {
        NSLog(@"success");
        
    } failure:^(SWRequestOperation *operation, NSError *error) {
        NSLog(@"fail %@", error);
    }];
    
    [getR setDownloadProgressBlock:^(long bytes, long totalBytes, long totalBytesExpected) {
        NSLog(@"%ld -%ld -%ld", bytes, totalBytes, totalBytesExpected);
    }];
```

### Pass object to response block

You can set custom object to your request object as `userObject` . This will allow any type

```objective-c
SWGETRequest *getRequest = [[SWGETRequest alloc]init];
getRequest.userObject = //any type object.

```

### Identify the Request
You can set `tag` for the request

```objective-c
SWGETRequest *getRequest = [[SWGETRequest alloc]init];
getRequest.tag = 12;

```

### Offline request from `SWNetworking`

This is really simple. First of all you need to send offline request expire time. this is seconds

```objective-c
    [SWOfflineRequestManger requestExpireTime:1300 ];
```

You have methods with parameter passing `sendLaterIfOllfine`. Just pass `YES`. That's it.

```objective-c
	SWGETRequest *getR = [[SWGETRequest alloc]init];
     [getR startWithURL:@"http://your url" parameters:nil parentView:nil sendLaterIfOffline:YES cachedData:^(NSCachedURLResponse *response, id responseObject) {
     
     } success:^(SWRequestOperation *operation, id responseObject) {
     NSLog(@"suceess");
     
     } failure:^(SWRequestOperation *operation, NSError *error) {
     NSLog(@"fail");
     }];
```
If you want catch offline request you need to use following methods. Better to add following lines to your `AppDelegate` didFinishLaunchingWithOptions methods.

```objective-c
[[SWOfflineRequestManger sharedInstance] requestSuccessBlock:^(SWRequestOperation *oparation, id responseObject) {
        
        NSLog(@"%@", oparation.responseString);
        
    } requestFailBlock:^(SWRequestOperation *oparation, NSError *error) {
        
    }];
```

Please note you need to set `tag` or `userObject` to identify the request. `userObject` should be `'NSCordering' support object 

### Session managare
All the Sessions will handle using session manger. NSURLSessionUploadTask, NSURLSessionDataTask, NSURLSessionDownloadTask with many options  and blocks for progress/sucess/faileure

### Add Download Task

```objective-c
SWSessionManager *sm = [[SWSessionManager alloc]initWithSessionConfiguration:nil];
    
    NSURLSessionDownloadTask *ts = [sm downloadTaskWithGetURL:@"" parameters:nil dowloadURL:nil success:^(NSURLSessionDownloadTask *uploadTask, NSURL *location) {
        NSLog(@"%@", location);
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
    [ts resume];

```

### Add Data Task

```objective-c
SWSessionManager *sm = [[SWSessionManager alloc]initWithSessionConfiguration:nil];
    
    NSURLSessionDataTask *ts = [sm dataTaskWithGetURL:@"" parameters:nil success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
    
    [ts resume];
```

### Add Upload Task

```objective-c
SWSessionManager *sm = [[SWSessionManager alloc]initWithSessionConfiguration:nil];
    sm.requestDataType = [SWRequestMulitFormData type];

    UIImage *image = [UIImage imageNamed:@"skywite.png"];
    NSData *imageData = UIImagePNGRepresentation(image);
    SWMedia *media = [[SWMedia alloc]initWithFileName:@"skywite.png" key:@"fileToUpload" data:imageData];
    
    NSURLSessionUploadTask *ts = [sm uploadTaskWithPostURL:@"" parameters:nil files:@[media] success:^(NSURLSessionUploadTask *uploadTask, id responseObject) {
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
    [ts resume];

```

### Set download progress block
```objective-c
NSURLSessionDownloadTask *ts = [sm downloadTaskWithGetURL:@"" parameters:nil dowloadURL:nil success:^(NSURLSessionDownloadTask *uploadTask, NSURL *location) {
        NSLog(@"%@", location);
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
    
    [ts setDownloadProgressBlock:^(long long totalBytes, long long totalBytesExpected) {
        NSLog(@"%lld %lld", totalBytes, totalBytesExpected);
    }];
    [ts resume];
```

### Set upload progress block
```objective-c
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
```
these blocks can use for any task.

### Set Task for UIProgressView
Please use following method to set task for UIProgressView

```objective-c
-(void)setDownloadTask:(NSURLSessionDownloadTask *)downloadTask;
-(void)setUploadTask:(NSURLSessionUploadTask *)downloadTask;
```
# Credits

`SWNetworking` is owned and maintained bye the [SkyWite](http://www.skywite.com)
`SWNetworking` was originally created by [saman kumara](http://www.isamankumara.com). If you want to contact [me@isamankuamra.com](mailto:me@isamankumara.com)

# Security disclosure

If you believe you have identified a security vulnerability with `SWNetworking`, you should report it as soon as possible via email to [info@skywite.com](mailto:info@skywite.com). Please do not post it to a public issue tracker.

# License

`SWNetworking` is released under the MIT license. See LICENSE for details.
 
