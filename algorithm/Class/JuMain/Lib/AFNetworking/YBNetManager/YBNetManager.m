//
//  YBNetManager.m
//  ceshicesih
//
//  Created by lanou3g on 16/4/16.
//  Copyright © 2016年 lanou3g. All rights reserved.
//

#import "YBNetManager.h"

#import "JUDetectNetworkingTool.h"



@interface YBNetManager ()

@property(nonatomic, strong)NSMutableArray *taskArray;
@end


@implementation YBNetManager

//+(instancetype)sharceInstance
//{
//    
//    static dispatch_once_t onceToken;
//    static YBNetManager *Ybmanager = nil;
//    dispatch_once(&onceToken, ^{
//      
//        Ybmanager = [[YBNetManager alloc]init];
//        
//    });
//    
//    return Ybmanager;
//    
//}

-(instancetype)init{
    self = [super init];
    
    self.requestSessionManager = [AFHTTPSessionManager manager];
    
    return self;
    
}


-(NSMutableArray *)taskArray
{
    if (_taskArray) {
        _taskArray = [NSMutableArray array];
    }
    
    
    return _taskArray;
    
}


//get请求
-(NSURLSessionDataTask *)GET:(NSString *)URLString
parameters:(id)parameters
  headdict:(NSMutableDictionary *)headDict
  progress:(void (^)(NSProgress * progress))Progress
   success:(void (^)(NSURLSessionDataTask * task , id responobject))success
   failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure

{
    
    
    
    AFHTTPSessionManager *mannager = self.requestSessionManager;
    mannager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //设置缓存策略
    [self setCachepolicy:mannager];
    
    //设置请求头
    if (headDict) {
        [headDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
                [mannager.requestSerializer setValue:obj forHTTPHeaderField:key];
            
        }];
        
        
    }

    
  NSURLSessionDataTask *task = [mannager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if (downloadProgress) {
            
            Progress(downloadProgress);

        }
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      
        if (task != nil && responseObject != nil) {
            success(task, responseObject);

        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (task!= nil && error != nil) {
            failure(task, error);

        }
        
        
    }];
    if (task) {
        [self.taskArray addObject:task];
    }
    
    
    
    
    return task;
    
    
}

//post请求
- (NSURLSessionDataTask *)POST:(NSString *)URLString
  parameters:(id)parameters
    headdict:(NSMutableDictionary *)headDict
    progress:(void (^)(NSProgress * progress))Progress
     success:(void (^)(NSURLSessionDataTask * task , id responobject))success
     failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
{
    AFHTTPSessionManager *mannager = [AFHTTPSessionManager manager];
     
    mannager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //设置缓存策略
    [self setCachepolicy:mannager];

    
    //设置请求头
    
    if (headDict) {
        [headDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
                [mannager.requestSerializer setValue:obj forHTTPHeaderField:key];
            
        }];
        
    }
    
    
  NSURLSessionDataTask *task = [mannager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        if (uploadProgress) {
            Progress(uploadProgress);

        }
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (task != nil && responseObject != nil) {
            success(task, responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (task!= nil && error != nil) {
            failure(task, error);
            
        }

    }];
    
    if (task) {
        [self.taskArray addObject:task];
        
        
    }
    
    return task;
    
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                      headdict:(NSMutableDictionary *)headDict
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      progress:(nullable void (^)(NSProgress * _Nonnull Progress))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    
    
    
    AFHTTPSessionManager *mannager = [AFHTTPSessionManager manager];
    
    mannager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //设置缓存策略
    [self setCachepolicy:mannager];
    
    
    //设置请求头
    
    if (headDict) {
        [headDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            [mannager.requestSerializer setValue:obj forHTTPHeaderField:key];
            
        }];
        
    }
    
    
    NSURLSessionDataTask *task = [mannager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (formData) {
            
            block(formData);
            
        }
        
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress1) {
        
        if (uploadProgress1 != nil) {
            
            uploadProgress(uploadProgress1);
            
        }
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        if (task != nil && responseObject != nil) {
            
            success(task, responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (task!= nil && error != nil) {
            
            failure(task, error);
            
        }
        
    }];
    

    if (task) {
        [self.taskArray addObject:task];
        
        
    }
    
    return task;
    

    
    return nil;
    
}








-(void)jj{

    
    
    
}












-(void)canceAllrequest{
    
    for (NSURLSessionDataTask *task in self.taskArray) {
        
        [task cancel];
        
    }
    
    
    
}


//请求的类设置缓存策略
-(void)setCachepolicy:(AFHTTPSessionManager *)manager{
    /**
     ReachableViaWiFi,//wife
     ReachableViaWWAN,//自带网络
     NotReachable,//没有网络
     Unknown,//未知网络

     */
    
    
    JUDetectNetworkingTool *detectTool = [JUDetectNetworkingTool shareMannger];
    
    switch (detectTool.networkType) {
        case ReachableViaWiFi:{//wift状态下 : 忽略缓存，重新请求
            [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringCacheData];
            
            break;
        }
        case ReachableViaWWAN:{//手机自带网络下  忽略缓存，重新请求
            [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringCacheData];
           break;
        }
        case NotReachable:{//没有网络  有缓存就用缓存，没有缓存就不发请求，当做请求出错处理（用于离线模式）
            [manager.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataDontLoad];

            
            break;
        }
        case Unknown:{//未知的网络
            [manager.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataDontLoad];

            
            break;
        }

            
        default:
            [manager.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataDontLoad];
            break;
    }
    
    
    
    
    
    
}


- (void)dealloc
{
    self.taskArray = nil;
}















@end
