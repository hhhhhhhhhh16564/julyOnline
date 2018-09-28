//
//  AppDelegate.m
//  algorithm
//
//  Created by pro on 16/6/27.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "AppDelegate.h"
#import "JUTabBarController.h"
#import "JURegisterLoginIBackInfo.h"
#import "JUDateBase.h"
#import "JUThirdLoginTool.h"


#import <AlipaySDK/AlipaySDK.h>

//友盟第三方分享
#import <UMSocialCore/UMSocialCore.h>

//bugHd
//#import <KSCrash/KSCrashInstallationStandard.h>

static NSString * const JUUmengAppkey = @"57987c38e0f55a79d4001a52";


static NSString * const BugHUDkey = @"021003451863749efdda576f656e35e0";

@interface AppDelegate ()<WXApiDelegate>

//@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
 
    JUTabBarController *tabbarVC = [[JUTabBarController alloc]init];
    self.window.rootViewController = tabbarVC;
    
    
    //程序启动时，设置下载状态为 暂停下载
    [mydatabase changedDownloadStatusOnAppLaunch];

    
    //设置缓存的空间大小
    NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:3 * 1024 * 1024 diskCapacity:3  * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:cache];
    

    
    JUDetectNetworkingTool *mannager = [JUDetectNetworkingTool shareMannger];
    //检测网络
    [mannager detectNetwok];
    //留2秒的时间检测网络
//    [NSThread sleepForTimeInterval:2];
    

    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(algorithmDowonloadMediaCachPath, NSUserDomainMask, YES) lastObject];
    JULog(@"%@", cachesPath);
    
    //    [WXApi registerApp:APPID withDescription:@"demo 2.0"];
    [JUThirdLoginTool initializeConfigure];
    return YES;
}

//9.0之前， 其它应用打开本应用时调用,  url是打开应用传入的参数，需要配置url,配置的才允许打开本应用
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
//    NSLog(@"从第三方应用回到本应用  哈哈哈哈哈哈哈哈哈哈哈\n\n\n\n\n\n\n\n\n\n\n\n");
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    
    if (result) {
        if (JuuserInfo.weixinPayAction) {
            result = NO;
        }
    }
        if (result == NO) {
        //调用其他SDK，例如支付宝SDK等
        //回复默认值
        JuuserInfo.weixinPayAction = NO;
        if ([url.scheme isEqualToString:APPID])
        {
            return  [WXApi handleOpenURL:url delegate:self];
        }
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
                if ([[resultDic[@"resultStatus"] description]isEqualToString:@"9000"]){
//                      JULog(@"支付宝支付成功哈哈哈哈");
                    [[NSNotificationCenter defaultCenter] postNotificationName:JUPayOrderSucceedNotification object:nil];
                }
   
            }];
        }
    }
    return YES;
}



// 9.0之后的方法
-(BOOL)application:(UIApplication*)app openURL:(NSURL*)url options:(NSDictionary<NSString *,id> *)options
{
//    JULog(@"从第三方应用回到本应用  哈哈哈哈哈哈哈哈哈哈哈\n\n\n\n\n\n\n\n\n\n\n\n");
    
        BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];

    
    //友盟出了bug,当调用微信支付时，友盟result(可能是微信分享的原因) 的值 为1，导致不能处理， 自己检测改变值
    if (result) {
        
        if (JuuserInfo.weixinPayAction) {
            result = NO;
        }
        
    }
    
    
    
    if (result == NO) {

        JuuserInfo.weixinPayAction = NO;
        
        if ([url.scheme isEqualToString:APPID])
        {
            

            return  [WXApi handleOpenURL:url delegate:self];
            
           }

        
        if ([url.host isEqualToString:@"safepay"]) {
            
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
             
                if ([[resultDic[@"resultStatus"] description]isEqualToString:@"9000"]){
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:JUPayOrderSucceedNotification object:nil];
                    
                    
                }
                
            }];
        }
            
    }
    
    return YES;

}

-(void)onResp:(BaseResp*)resp{
    
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                [[NSNotificationCenter defaultCenter] postNotificationName:JUPayOrderSucceedNotification object:nil];
                break;
            default:
                JULog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
    }
}
//内存警告时清楚缓存
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    //终止所有下载
    [[SDWebImageManager sharedManager]cancelAll];
        //清除缓存
    [[SDImageCache sharedImageCache]clearMemory];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
}




@end
