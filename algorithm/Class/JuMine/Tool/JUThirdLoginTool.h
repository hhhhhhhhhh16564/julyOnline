//
//  JUThirdLoginTool.h
//  algorithm
//
//  Created by 周磊 on 16/11/15.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "Singleton.h"

typedef void (^login)();


@interface JUThirdLoginTool : NSObject

//singleton_interface(JUThirdLoginTool)

#pragma mark 登录


//微信登录
-(void)weixinLogin:(void(^)())success failure:(void(^)())failure;

//微博登录
-(void)weiboLogin:(void(^)())success failure:(void(^)())failure;

//QQ登录
-(void)qqLogin:(void(^)())success failure:(void(^)())failure;


//自动登录
-(void)autoLogin;



#pragma mark 友盟统计


#pragma mark bughd


#pragma mark 初始化所有第三方的配置
+(void)initializeConfigure;




@end
