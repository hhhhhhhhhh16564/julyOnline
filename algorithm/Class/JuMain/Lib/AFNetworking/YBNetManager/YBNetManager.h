//
//  YBNetManager.h
//  ceshicesih
//
//  Created by lanou3g on 16/4/16.
//  Copyright © 2016年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


#define requestManager [[YBNetManager alloc]init]
@interface YBNetManager : NSObject

@property(nonatomic, strong) AFHTTPSessionManager *requestSessionManager;

-(void)canceAllrequest;

//get 请求

-(NSURLSessionDataTask *)GET:(NSString *)URLString
parameters:(id)parameters
  headdict:(NSMutableDictionary *)headDict
  progress:(void (^)(NSProgress * progress))Progress
   success:(void (^)(NSURLSessionDataTask * task , id responobject))success
   failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;


//post请求

- (NSURLSessionDataTask *)POST:(NSString *)URLString
  parameters:(id)parameters
    headdict:(NSMutableDictionary *)headDict
    progress:(void (^)(NSProgress * progress))Progress
     success:(void (^)(NSURLSessionDataTask * task , id responobject))success
     failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;
//放弃使用单例，因为不方便取消任务
//+(instancetype)sharceInstance;




//文件上传 multipart/form-data请求

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                      headdict:(NSMutableDictionary *)headDict
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      progress:(nullable void (^)(NSProgress * _Nonnull Progress))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;






@end
