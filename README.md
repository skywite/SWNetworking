# <p align="center" style='color:#30a1f3' >SWNetworking</p>

<p align="center" >
  <img src="http://skywite.com/wp-content/uploads/2015/05/skywite.png" alt="SWNetworking" title=“SkyWite”>
</p>


[![Build Status](https://travis-ci.org/skywite/SWNetworking.svg?branch=master)](https://travis-ci.org/skywite/SWNetworking)
[![Version](https://img.shields.io/cocoapods/v/SWNetworking.svg?style=flat)](http://cocoapods.org/pods/SWNetworking)
[![License](https://img.shields.io/cocoapods/l/SWNetworking.svg?style=flat)](http://cocoapods.org/pods/SWNetworking)
[![Platform](https://img.shields.io/cocoapods/p/SWNetworking.svg?style=flat)](http://cocoapods.org/pods/SWNetworking)
[![Analytics](https://ga-beacon.appspot.com/UA-69386051-1/SWNetworking/README?pixel)](https://github.com/igrigorik/ga-beacon)
[![Twitter](https://img.shields.io/badge/twitter-@SWframeworks-blue.svg?style=flat)](http://twitter.com/SWframeworks)



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

If you are new to CocoaPods, please go to [Wiki](https://github.com/skywite/SWNetworking/wiki/CocoaPods-in-to-Xcode-Project) page.

- Read the [SWNetworking 1.0 Migration Guide](https://github.com//skywite/SWNetworking/wiki/SWNetworking-1.0-Migration-Guide) for an overview of the architectural changes from 0.9.3

### Communication

- If you **need any help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/swnetworking). (Tag 'swnetworking') or you can send a mail with details ( we will provide fast feedback )
- If you'd like to **ask a general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/SWNetworking).
- If you **found a bug**, _and can provide steps to reliably reproduce it_, open an issue or you can contribute.
- If you **have a feature request**, send a request mail we will add as soon as possible.
- If you **want to contribute**, submit a pull request.

#Architecture


* `SWRequest`
 - `SWRequest`
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

## Use HTTP Request will be `NSURLSession`
ALL Requests will be NSURLSession. Session will add in to `NSOperationQueue` . Request creation , response serialization, network reachability handing and offline request as well.

### `GET` Request
```objective-c
	SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    [getRequest startDataTaskWithURL:@"http://127.0.0.1:3000" parameters:nil success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
   
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
    
    }];
```
If you want send parameters you have two options

```objective-c
    SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    getRequest.responseDataType = [SWResponseJSONDataType type];
    [getRequest startDataTaskWithURL:@"http://127.0.0.1:3000" parameters:@"name=this is name&address=your address"  parentView:nil success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {

    }];
```
If you want to encdoe parameters and values you need to pass `NSDictionary` object with keys/values.

```objective-c
	SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    getRequest.responseDataType = [SWResponseJSONDataType type];
    [getRequest startDataTaskWithURL:@"http://127.0.0.1:3000" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:nil success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {

    }];
```

We are recommend to use second option because if you have `&` sign with parameter or value it will break sending values.

###  `GET` with Response type 
Available as response types
`SWResponseJSONDataType`, `SWResponseJSONDataType`, `SWResponseXMLDataType`,` SWResponseStringDataType`,`SWResponseUIImageType`  
You need set `responseDataType`.

```objective-c
// this response will be JSON
  	SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    getRequest.responseDataType = [SWResponseJSONDataType type];
    [getRequest startDataTaskWithURL:@"http://127.0.0.1:3000" parameters:nil parentView:nil success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
    
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {

    }];
```
### `GET` with loading indicator
If you set your parent view to method, loading indicator will be displayed. 
```objective-c
    SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    getRequest.responseDataType = [SWResponseJSONDataType type];
    [getRequest startDataTaskWithURL:@"http://127.0.0.1:3000" parameters:nil parentView:self.view success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
    
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {

    }];
```

If you want custom loading view you need to add new `nib` file to your project and name it as 'sw_loadingView'. It will be displayed on the screen.
### Cache Response
If you want to access cached data on the response. You need to use relevant method that include cache block
```objective-c
 	SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    getRequest.responseDataType = [SWResponseJSONDataType type];
    [getRequest startDataTaskWithURL:@"http://127.0.0.1:3000" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:nil success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
    
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {

    }];
```
### `POST` request (simple)
Cache, Loading view available for the on the relevant method. Please check available methods
```objective-c
	SWPOSTRequest *postRequest = [[SWPOSTRequest alloc]init];
    postRequest.responseDataType = [SWResponseJSONDataType type];
    
    [postRequest startDataTaskWithURL:@"http://127.0.0.1:3000/drivers" parameters:@{@"name": @"this is name", @"address": @"your address"} parentView:nil cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        NSLog(@"%@", error);
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
    
    [postRequest startUploadTaskWithURL:@"http://127.0.0.1:3000/drivers" files:fileArray parameters:@{@"name": @"this is name", @"address": @"your address"} parentView:nil
    cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(NSURLSessionUploadTask *uploadTask, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        NSLog(@"%@", error);
    }];
```
### `PUT` simple request
```objective-c
	SWPUTRequest *putRequest = [[SWPUTRequest alloc]init];
    putRequest.responseDataType = [SWResponseXMLDataType type];
    
    [putRequest startDataTaskWithURL:@"http://127.0.0.1:3000/drivers" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:nil success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        NSLog(@"%@", error);
    }];}
```
### `PATCH` simple request
```objective-c
    SWPATCHRequest *patchRequest = [[SWPATCHRequest alloc]init];
    patchRequest.responseDataType = [SWResponseXMLDataType type];
    
    [patchRequest startDataTaskWithURL:@"http://127.0.0.1:3000/drivers" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:nil success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        NSLog(@"%@", error);
    }];

```
### `DELETE` simple request
```objective-c
 	SWDELETERequest *deleteRequest = [[SWDELETERequest alloc]init];
    deleteRequest.responseDataType = [SWResponseXMLDataType type];
    
    [deleteRequest startDataTaskWithURL:@"http://127.0.0.1:3000/drivers" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:nil cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        NSLog(@"%@", error);
    }];
```

### `HEAD` simple request
```objective-c
	SWHEADRequest *headRequest = [[SWHEADRequest alloc]init];
    headRequest.responseDataType = [SWResponseXMLDataType type];
    
    [headRequest startDataTaskWithURL:@"http://127.0.0.1:3000/drivers" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:nil cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        NSLog(@"%@", error);
    }];}
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
    
    [postRequest startDataTaskWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
```

### Custom time out
If you want to change request timeout , you have to change property call `timeOut`.
```objective-c
  	SWPOSTRequest *postRequest = [[SWPOSTRequest alloc]init];
    [postRequest setTimeOut:120];
    postRequest.responseDataType = [SWResponseJSONDataType type];
    
    [postRequest startDataTaskWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
```
 
### Response Encoding
You need to sent object type for the `responseDataType` on all your requests.

```objective-c
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
    getRequestImage.responseDataType = [SWResponseUIImageType type];
    
    [getRequestImage startDataTaskWithURL:@"your URL String" parameters:@{@"name": @"this is name", @"address": @"your address"}  parentView:self.view cachedData:^(NSCachedURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
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
        //you can assing your image to your object here.
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
	if ([SWReachability getCurrentNetworkStatus] == SWNetworkingReachabilityStatusNotReachable) {
        //connection not available.
    }
    
    //if you want to get status change notification
    
    [SWReachability checkCurrentStatus:^(SWNetworkingReachabilityStatus currentStatus) {
        //current status when call method
    } statusChange:^(SWNetworkingReachabilityStatus changedStatus) {
        //every time when change status
    }];

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
    
    [postRequest startUploadTaskWithURL:@"http://127.0.0.1:3000/drivers" files:fileArray parameters:@{@"name": @"this is name", @"address": @"your address"} parentView:nil  success:^(NSURLSessionUploadTask *uploadTask, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        NSLog(@"%@", error);
    }];
    [postRequest setUploadProgressBlock:^(long long bytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"bytesWritten => %lld and totalBytesExpectedToWrite = %lld", bytesWritten, totalBytesExpectedToWrite);
    }];

```

### Download Progress With Request

```objective-c
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
     getR.tag = 400;
     [getR startDataTaskWithURL:@"http://www.google.com" parameters:nil parentView:nil sendLaterIfOffline:YES cachedData:^(NSCachedURLResponse *response, id responseObject) {
     
     } success:^(NSURLSessionDataTask *operation, id responseObject) {
     
     } failure:^(NSURLSessionTask *operation, NSError *error) {

     }];
```
If you want catch offline request you need to use following methods. Better to add following lines to your `AppDelegate` didFinishLaunchingWithOptions methods.

```objective-c
	[[SWOfflineRequestManger sharedInstance] requestSuccessBlock:^(SWRequest *operation, id responseObject) {
        
        NSLog(@"%d", operation.tag);
        
    } requestFailBlock:^(SWRequest *operation, NSError *error) {
        
    }];
```

Please note you need to set `tag` or `userObject` to identify the request. `userObject` should be `'NSCording' support object 


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
 
