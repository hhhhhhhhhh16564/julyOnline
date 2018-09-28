//
//  JUDetectNetworkingTool.m
//  七月算法_iPad
//
//  Created by pro on 16/5/29.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUDetectNetworkingTool.h"
#import "AFNetworking.h"

#define netmanager [AFNetworkReachabilityManager sharedManager]
@interface JUDetectNetworkingTool ()

@end

@implementation JUDetectNetworkingTool


-(instancetype)init{
    
    self = [super init];
    
    if (self) {
     
       
        
    }
    
    
    return self;
    
}

-(void)detectNetwok{
    
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态发生改变的时候调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                JULog(@"WIFI");
                _networkType = ReachableViaWiFi;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                _networkType = ReachableViaWWAN;
                JULog(@"自带网络");
                
                // 当网络转变为为自带网络时, 发送通知，下载页面要停止下载
                [[NSNotificationCenter defaultCenter]postNotificationName:JUNetWorkingDidChangedNotification object:nil];
                
                
                // 当有正在下载任务时
                if ([[JUDownloadManager shredManager] downloadingCount]) {
                    // 加提示
                                      
                }
 
                
                break;
            case AFNetworkReachabilityStatusNotReachable:
                _networkType = NotReachable;
                JULog(@"没有网络");
                dispatch_async(dispatch_get_main_queue(), ^{
                  
                    
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    GMToast *toasts = [[GMToast alloc]initWithView:window text:@"请检查你的网络" duration:1.5];
                    
                    [toasts show];
                    
                });
                
                
                
                break;
            case AFNetworkReachabilityStatusUnknown:
                _networkType = Unknown;
                JULog(@"未知网络");
                break;
            default:
                break;
        }
    }];
    // 开始监控
    [mgr startMonitoring];
    
}


+(instancetype)shareMannger{
    
    static dispatch_once_t onceToken;
    static JUDetectNetworkingTool *tool = nil;
    dispatch_once(&onceToken, ^{
        
        tool = [[JUDetectNetworkingTool alloc]init];
        
    });
    
    return tool;
    
}














@end
