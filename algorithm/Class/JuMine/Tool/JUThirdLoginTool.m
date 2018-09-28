//
//  JUThirdLoginTool.m
//  algorithm
//
//  Created by 周磊 on 16/11/15.
//  Copyright © 2016年 Julyonline. All rights reserved.
//
//友盟
#import "JUThirdLoginTool.h"
#import <UMSocialCore/UMSocialCore.h>
#import "WXApi.h"
// 友盟统计


//bugHd

@implementation JUThirdLoginTool

//singleton_implementation(JUThirdLoginTool)

//微信
#define APPID @"wx5dd973a1ed4c1b27"
#define appsecret @"e0b266aef8d1688305dcc5d7ca8b1fbd"

//上线账号
static NSString * const JUUmengAppkey = @"57987c38e0f55a79d4001a52";

// 友盟测试账号 58f43e7abbea83565c000108


//#ifdef DEBUG
//
//static NSString * const JUUmengAppkey = @"58f43e7abbea83565c000108";
//
//#else
//
//static NSString * const JUUmengAppkey = @"57987c38e0f55a79d4001a52";
//#endif



#pragma mark 登录
//微信登录
-(void)weixinLogin:(void(^)())success failure:(void(^)())failure{
    
    
//    
//    [[UMSocialManager defaultManager]  authWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
//        
//        if(error)return ;
//        
//        UMSocialAuthResponse *authresponse = result;
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        
//        dic[@"ty"] = @"3";
//        dic[@"at"] = authresponse.accessToken;
//        dic[@"rt"] = authresponse.refreshToken;
//        dic[@"unionid"] = authresponse.originalResponse[@"unionid"];
//        dic[@"oid"] = authresponse.openid;
//        
//        [authresponse logObjectAllExtension_YanBo];
//        
////        [self thirdLoginWithdict:dic];
//        
//        [self thirdLoginWithdict:dic success:success failure:failure];
//        
//    }];
//    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *authresponse = result;
            
            // 授权信息
            //            NSLog(@"Wechat uid: %@", resp.uid);
            //            NSLog(@"Wechat openid: %@", resp.openid);
            //            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            //            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            //            NSLog(@"Wechat expiration: %@", resp.expiration);
            //
            //            // 用户信息
            //            NSLog(@"Wechat name: %@", resp.name);
            //            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            //            NSLog(@"Wechat gender: %@", resp.gender);
            //
            //            // 第三方平台SDK源数据
            //            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            dic[@"ty"] = @"3";
            dic[@"at"] = authresponse.accessToken;
            dic[@"rt"] = authresponse.refreshToken;
            dic[@"unionid"] = authresponse.uid;
            dic[@"oid"] = authresponse.openid;
            dic[@"name"] = authresponse.name;
            dic[@"iconurl"] = authresponse.iconurl;
            JULog(@"微信第三方登录:   %@", authresponse);

            
            [self thirdLoginWithdict:dic success:success failure:failure];
            
        }
    }];
    
    

    
}

//微博登录
-(void)weiboLogin:(void(^)())success failure:(void(^)())failure{
    
//    [[UMSocialManager defaultManager]  authWithPlatform:UMSocialPlatformType_Sina currentViewController:self completion:^(id result, NSError *error) {
//        
//        if(error)return ;
//        
//        UMSocialAuthResponse *authresponse = result;
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        dic[@"ty"] = @"2";
//        dic[@"at"] = authresponse.accessToken;
//        dic[@"rt"] = authresponse.refreshToken;
//        dic[@"uid"] = authresponse.uid;
//        
//        [self thirdLoginWithdict:dic success:success failure:failure];
//        
//    }];
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            //            UMSocialUserInfoResponse *resp = result;
            
            //            // 授权信息
            //            NSLog(@"Sina uid: %@", resp.uid);
            //            NSLog(@"Sina accessToken: %@", resp.accessToken);
            //            NSLog(@"Sina refreshToken: %@", resp.refreshToken);
            //            NSLog(@"Sina expiration: %@", resp.expiration);
            //
            //            // 用户信息
            //            NSLog(@"Sina name: %@", resp.name);
            //            NSLog(@"Sina iconurl: %@", resp.iconurl);
            //            NSLog(@"Sina gender: %@", resp.gender);
            //
            //            // 第三方平台SDK源数据
            //            NSLog(@"Sina originalResponse: %@", resp.originalResponse);
            
            UMSocialUserInfoResponse *authresponse = result;
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"ty"] = @"2";
            dic[@"at"] = authresponse.accessToken;
            dic[@"rt"] = authresponse.refreshToken;
            dic[@"uid"] = authresponse.uid;
            dic[@"name"] = authresponse.name;
            dic[@"iconurl"] = authresponse.iconurl;
            
            //            JULog(@"微博第三方登录:   %@", authresponse);
            
            [self thirdLoginWithdict:dic success:success failure:failure];
            
            
            
            JULog(@"微博第三方登录:   %@", authresponse);

            
            
            
        }
    }];
    

}
//QQ登录
-(void)qqLogin:(void(^)())success failure:(void(^)())failure{
    
    
    
//    [[UMSocialManager defaultManager]  authWithPlatform:UMSocialPlatformType_QQ currentViewController:self completion:^(id result, NSError *error) {
//        
//        if(error)return ;
//        
//        UMSocialAuthResponse *authresponse = result;
//        [authresponse logObjectAllExtension_YanBo];
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        dic[@"ty"] = @"1";
//        dic[@"at"] = authresponse.accessToken;
//        dic[@"rt"] = authresponse.refreshToken;
//        dic[@"oid"] = authresponse.openid;
//        
////        [self thirdLoginWithdict:dic];
//        
//        [self thirdLoginWithdict:dic success:success failure:failure];
//
//        
//    }];
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            //            UMSocialUserInfoResponse *resp = result;
            //
            //            // 授权信息
            //            NSLog(@"QQ uid: %@", resp.uid);
            //            NSLog(@"QQ openid: %@", resp.openid);
            //            NSLog(@"QQ accessToken: %@", resp.accessToken);
            //            NSLog(@"QQ expiration: %@", resp.expiration);
            //
            //            // 用户信息
            //            NSLog(@"QQ name: %@", resp.name);
            //            NSLog(@"QQ iconurl: %@", resp.iconurl);
            //            NSLog(@"QQ gender: %@", resp.gender);
            //
            //            // 第三方平台SDK源数据
            //            NSLog(@"QQ originalResponse: %@", resp.originalResponse);
            
            
            UMSocialUserInfoResponse *authresponse = result;
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"ty"] = @"1";
            dic[@"at"] = authresponse.accessToken;
            dic[@"rt"] = authresponse.refreshToken;
            dic[@"oid"] = authresponse.openid;
            dic[@"name"] = authresponse.name;
            dic[@"iconurl"] = authresponse.iconurl;
            
            //        [self thirdLoginWithdict:dic];
            
            
            JULog(@"qq第三方登录:   %@", authresponse);
            
            [self thirdLoginWithdict:dic success:success failure:failure];
            
            
            
        }
    }];
    
}






//第三方登录后获取 第三方信息后的登录方法


-(void)thirdLoginWithdict:(NSMutableDictionary *)loginDict success:(void(^)())success failure:(void(^)())failure{
    
    YBNetManager *mannager = [[YBNetManager alloc]init];
    [JuuserInfo loadFromUserDefaults];
    
    
    [mannager POST:thirdLoginURL parameters:loginDict headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
        
    } success:^(NSURLSessionDataTask *task, id responobject) {
        
      //  NSLog(@"\n\n\n\n\n\n\n%@", responobject);
        
        if (responobject[@"data"]) {
            //msg字段是ok时，注册成功
            if ([[responobject[@"errno"] description] isEqualToString:@"0"]) {
                
                JULog(@"登录成功");
                
          
                //登录成功时，保存用户信息
                
                
                //此时第三方登录成功，email 和 password都是空字符串，这样下一次就不能自动登录，要手动输入账号密码登录
                JuuserInfo.email = @"";
                JuuserInfo.password = @"";
                NSDictionary *dict = responobject[@"data"];
                //加入两个字段
                if (dict) {
                    JuuserInfo.uid = dict[@"uid"];
                    
                    //第三方返回的是 at
                    JuuserInfo.accessToken = dict[@"at"];
                    
              //  JULog(@"第三方 ============== %@ ==============", dict);
                }
                
                //islogin要写在最后，否则会出错，因为设置状态会走代理方法，但此时uid为空
                
                //第三方登录的信息保存, 有值的话下次用这个登录，如果失败，则清空
                JuuserInfo.loginDate = loginDict;
                
                JuuserInfo.isLogin = YES;
                [JuuserInfo saveUserInfo];
                
                //登录成功后返回
//                [weakSelf.navigationController popViewControllerAnimated:NO];
//                return ;
                
                success();
                
                
            }
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
//        JuuserInfo.loginDate = nil;
//        
//        JuuserInfo.isLogin = NO;
//
//        [JuuserInfo saveUserInfo];
        
        failure();
        
    }];
    
    
    
    
}



//登录之前，先初始化
-(void)autoLogin{//自动登录
    
    [self initThirdPartLogin];
    
    [JuuserInfo loadFromUserDefaults];
    
    
    //如果没有网络，就返回
    if (networkingType == NotReachable)return;
    
    
    if (!JuuserInfo.isLogin)return;
    
    if ([JuuserInfo.loginDate count]) { //第三方自动登录
        
        [self thirdLoginWithdict:JuuserInfo.loginDate success:^{
            
            
        } failure:^{
                
        }];
        
    }else{  //个人账号密码自动登录
        
        [self loginWithuserNameAndPassWord];
        
    }

    
}

-(void)initThirdPartLogin{
    

    
    
    
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:JUUmengAppkey];
    
    // 获取友盟social版本号
    //NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:APPID appSecret:appsecret redirectURL:@"http://mobile.umeng.com/social"];
    
    
    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105484262"  appSecret:@"sl3RmCcPuocztD8Y" redirectURL:@"http://mobile.umeng.com/social"];
    
    //设置新浪的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"493927300"  appSecret:@"bda7a52001ece49a710e6547596188bf" redirectURL:@"https://api.weibo.com/oauth2/default.html"];
    
     [WXApi registerApp:APPID];
}


-(void)loginWithuserNameAndPassWord{

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"em"] = JuuserInfo.email;
    dic[@"pd"] = JuuserInfo.password;
    
    
    NSMutableDictionary *headdic = JuuserInfo.headDit;
    
    //    __weak typeof(self) weakself = self;
    [requestManager POST:V30LoginURL parameters:dic headdict:headdic progress:^(NSProgress *progress) {
        
        
    } success:^(NSURLSessionDataTask *task, id responobject) {
        if (responobject) {
            
            
            if (responobject[@"errno"]) {
                if ([[responobject[@"errno"] description] isEqualToString:@"0"]) {
                    
                    //                    JULog(@"登录成功");
                    
                    NSDictionary *dict = responobject[@"data"];
                    //加入两个字段
                    if (dict) {
                        JuuserInfo.uid = dict[@"uid"];
                        JuuserInfo.accessToken = dict[@"access-token"];
                        
                        
                      //  NSLog(@"============== %@ ==============", dict);
                    }
                    
                    //登录成功时，保存用户信息
                    
                    JULog(@"登录成功-------------------");
                    JuuserInfo.isLogin = YES;
                    JuuserInfo.loginDate = nil;
                    
                    [JuuserInfo saveUserInfo];
                    
                }else{
                    
                    JuuserInfo.isLogin = NO;
                    [JuuserInfo saveUserInfo];
                    
                    
                }
                
            }
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
        //登录失败状态是没有登录   JULog(@"请求失败失败: %@",error);
//        JuuserInfo.isLogin = NO;
//        [JuuserInfo saveUserInfo];
        
        
    }];
    
    
}


#pragma mark 友盟统计
-(void)UMengStatistics{
    
    
}


#pragma mark bughd
-(void)setBugHUD{
    
  
    
}




#pragma mark 初始化所有第三方的配置
+(void)initializeConfigure{
    
    JUThirdLoginTool *thirdTool = [[JUThirdLoginTool alloc]init];
    // 设置友盟统计
    [thirdTool UMengStatistics];
    
    // 自动登录
    [thirdTool autoLogin];
    
    //检测bug的bugHD
    [thirdTool setBugHUD];
    
}



@end
