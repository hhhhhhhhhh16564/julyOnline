//
//  JUShareButton.h
//  algorithm
//
//  Created by 周磊 on 16/10/14.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMSocialCore/UMSocialPlatformConfig.h>



//typedef NS_ENUM(NSInteger,UMSocialPlatformType)
//{
//    UMSocialPlatformType_UnKnown        = -2,
//    //预定义的平台
//    UMSocialPlatformType_Predefine_Begin = -1,
//    UMSocialPlatformType_Sina,          //新浪
//    UMSocialPlatformType_WechatSession, //微信聊天
//    UMSocialPlatformType_WechatTimeLine,//微信朋友圈
//    UMSocialPlatformType_WechatFavorite,//微信收藏
//    UMSocialPlatformType_QQ,            //QQ聊天页面
//    UMSocialPlatformType_Qzone,         //qq空间
//    UMSocialPlatformType_TencentWb,     //腾讯微博
//    UMSocialPlatformType_AlipaySession, //支付宝聊天页面
//    UMSocialPlatformType_YixinSession,  //易信聊天页面
//    UMSocialPlatformType_YixinTimeLine, //易信朋友圈
//    UMSocialPlatformType_LaiWangSession,//点点虫（原来往）聊天页面
//    UMSocialPlatformType_LaiWangTimeLine,//点点虫动态
//    UMSocialPlatformType_Sms,           //短信
//    UMSocialPlatformType_Email,         //邮件
//    UMSocialPlatformType_Renren,        //人人
//    UMSocialPlatformType_Facebook,      //Facebook
//    UMSocialPlatformType_Twitter,       //Twitter
//    UMSocialPlatformType_Douban,        //豆瓣
//    UMSocialPlatformType_KakaoTalk,     //KakaoTalk（暂未支持）
//    UMSocialPlatformType_Pinterest,     //Pinterest（暂未支持）
//    UMSocialPlatformType_Line,          //Line
//    
//    UMSocialPlatformType_Linkedin,      //领英
//    
//    UMSocialPlatformType_Flickr,        //Flickr
//    
//    UMSocialPlatformType_Tumblr,        //Tumblr（暂未支持）
//    UMSocialPlatformType_Instagram,     //Instagram
//    UMSocialPlatformType_Whatsapp,      //Whatsapp
//    UMSocialPlatformType_Predefine_end,
//    
//    //用户自定义的平台
//    UMSocialPlatformType_UserDefine_Begin = 1000,
//    UMSocialPlatformType_UserDefine_End = 2000,
//};

@interface JUShareButton : UIButton

@property (nonatomic,assign) UMSocialPlatformType platformType;

@end
