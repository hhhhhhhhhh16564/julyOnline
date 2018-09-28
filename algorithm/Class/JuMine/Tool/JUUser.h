//
//  JUUser.h
//  七月算法_iPad
//
//  Created by pro on 16/5/28.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JUTabBarController.h"

#define JuuserInfo [JUUser sharceInstance]

typedef enum {Third_None = -1,Third_WEIXIN,Third_QQ,Third_WEIBO} ThirdType;




@interface JUUser : NSObject

{
    NSString *_uid;
}


// 是否点击了微信支付按钮

@property (nonatomic,assign) BOOL weixinPayAction;



//没啥作用，只是用全局变量获得tabbvc
@property(nonatomic, strong) JUTabBarController *tabbVC;



//uid （可能是两种类型，NSnumber 或者 NSString)
@property (nonatomic, strong) NSString* uid;
@property (nonatomic, strong) NSString* mobile;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString* password;

//头像

//是否登录登录
@property (nonatomic, assign) BOOL isLogin;

//当时第三方登录或已经注销时，下次就不自动登录



@property (nonatomic,assign) BOOL isThirdPartLogin;


@property (nonatomic, strong) NSString *token;

@property (nonatomic, assign) ThirdType thirdType;


@property(nonatomic, strong)NSMutableDictionary *headDit;


@property(nonatomic, strong) NSMutableDictionary *loginDate;





//
//------------------------------------------------------{
//    data = {
//     errno = 0,
//data = {
//    last_learn_time = 1467085125,
//    w_lear_num = 6,
//    uid = 33521,
//    avatar_file = http://ask.julyedu.com/uploads/avatar/,
//    access_token = 0e2a6ef27e4102d4-0b7125f1b8f52e97,
//    user_name = hhhhhhhhhh1654//    },
//    errno = 0
//}

@property(nonatomic, strong) NSString *nickname;
//头像
@property (nonatomic, strong) NSString* avatar_file;

@property(nonatomic, strong) NSString *group_id;

@property(nonatomic, strong) NSString *w_lear_num;

@property (nonatomic, strong) NSString* user_name;
@property(nonatomic, strong) NSString *access_token;

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *last_learn_time;


@property(nonatomic, assign) BOOL is_vip;


//课程是否显示，用这个全局变量来表示  ipad版本
@property(nonatomic, strong) NSString *showstring;


//课程是否显示，用这个全局变量   手机版本
//@property(nonatomic, strong) NSString *isShow;



//@property (nonatomic,assign) NSTimeInterval lastLogoutApp;


+(instancetype)sharceInstance;

-(void)saveUserInfo;
//-(void)clearUserInfo;
-(void)loadFromUserDefaults;

-(void)logoutClear;

//+ (NSString *)filePathForHeadImg;

@end
