//
//  AFNetworkingViewController.m
//  UsefulFrame
//
//  Created by Mac-Pro on 15/5/21.
//  Copyright (c) 2015年 shy. All rights reserved.
//

#import "AFNetworkingViewController.h"
#import "AFNetworking.h"

typedef void(^AFNSuccessBlock)(id object);
typedef void(^AFNFailureBlock)(NSError *error);
typedef void(^AFNErrorBlock)(id error);

typedef void(^AFNDownloadingBlock)(float percent);

typedef void(^AFUploadingBlock)(float percent);

#define kBaseURL        @"http://www.weather.com.cn/data/sk/101010100.html"
#define kPostURL        @"http://192.168.199.104/json.php"
//#define kDownLoadURL    @"http://www.cocoachina.com/bbs/job.php?action=download&aid=55299"
#define kDownLoadURL    @"http://samples.leanpub.com/iosfrp-sample.pdf"

@interface AFNetworkingViewController ()
@property (strong, nonatomic) IBOutlet UILabel *weatherInfoLabel;

@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@end

@implementation AFNetworkingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    {
        [self queryWeatherData:kBaseURL successBlock:^(id object) {
            NSLog(@"success ==%@==",object);
            NSDictionary *weatherInfo = object[@"weatherinfo"];
            dispatch_async(dispatch_get_main_queue(), ^{
                _weatherInfoLabel.text = [NSString
                                          stringWithFormat:@"%@%@%@",weatherInfo[@"city"],weatherInfo[@"WD"],weatherInfo[@"WS"]];
            });
        } failureBlock:^(NSError *error) {
            NSLog(@"fail ==%@==",error);
        } errorBlock:^(id error) {
            
        }];
    }
    
    {
        [self queryDataWithParam:@{@"id":@(123)} url:kPostURL successBlock:^(id object) {
            NSLog(@"success-post ==%@==",object);
        } failureBlock:^(NSError *error) {
            NSLog(@"error-post ==%@==",error);
        } errorBlock:^(id error) {
            
        }];
    }
    
    {
        [self downloadTask:nil successBlock:^(id object) {
            
        } failureBlock:^(NSError *error) {
            
        } downloadingBlock:^(float percent) {
            
        }];
         
     }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
//get 方法
- (void)queryWeatherData:(NSString *)urlStr successBlock:(AFNSuccessBlock)successBlock failureBlock:(AFNFailureBlock)failBlock errorBlock:(AFNErrorBlock)errorBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //解析格式不全
    NSMutableSet *typeSet = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [typeSet addObject:@"text/html"];
    
    manager.responseSerializer.acceptableContentTypes = typeSet;
    
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failBlock(error);
    }];
}


//post
- (void)queryDataWithParam:(NSDictionary *)dic  url:(NSString *)urlStr successBlock:(AFNSuccessBlock)successBlock failureBlock:(AFNFailureBlock)failBlock errorBlock:(AFNErrorBlock)errorBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failBlock(error);
    }];
}

//下载
- (void)downloadTask:(NSString *)url successBlock:(AFNSuccessBlock)successBlock failureBlock:(AFNFailureBlock)failBlock downloadingBlock:(AFNDownloadingBlock)downloadingBlock
{
    __weak typeof(self) weakSelf = self;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *downURL = [NSURL URLWithString:kDownLoadURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:downURL];
    
    NSProgress *progress = nil;
    NSURLSessionDownloadTask *downLoadTask = [manager downloadTaskWithRequest:request progress:&progress  destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //指定下载路径
        NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        //此处已经在主线程了
        NSLog(@"filePath===下载完成===");
        if (!error)
        {
             successBlock(filePath.absoluteString);
        }
        else
        {
            failBlock(error);
        }
        
    }];
    [downLoadTask resume];
    [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        float downloadPercentage = (float)totalBytesWritten/(float)totalBytesExpectedToWrite;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.progressView setProgress:downloadPercentage animated:YES];
        });
        downloadingBlock(downloadPercentage);
    }];
}



//上传
- (void)uploadDataTaskWithURL:(NSString *)url successBlock:(AFNSuccessBlock)successBlock failBlock:(AFNFailureBlock)failBlock uploadBlock:(AFUploadingBlock)uploadBlock
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *uploadURL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:uploadURL];
    
    //nsdata
    NSData *fileData = nil;
    NSURLSessionUploadTask *uploadTaskData = [manager uploadTaskWithRequest:request fromData:fileData progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
    }];
    
    
    //文件路径
    NSURL *filePath = [NSURL fileURLWithPath:@""]; //文件路径
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error)
        {
            failBlock(error);
        }
        else
        {
            successBlock(responseObject);
        }
        
    }];
    
    [uploadTask resume];
    
    [manager setTaskDidSendBodyDataBlock:^(NSURLSession *session, NSURLSessionTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        
        float downloadPercentage = (float)bytesSent/(float)totalBytesSent;
        uploadBlock(downloadPercentage);
    }];
}


//设置请求头
- (void)setRequestHeaders
{
    //请求行 post、get...
    //请求头
    //请求体
    
}

//上传下载 还可以根据
- (void)method1
{
    //上传
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //get、post方法
    AFHTTPRequestOperation *operaton = [manager POST:kBaseURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [operaton setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    }];
    
    
    //下载
    operaton = [manager GET:kBaseURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [operaton setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    }];
}




@end
