//
//  JUUmengStaticTool.h
//  algorithm
//
//  Created by 周磊 on 17/4/17.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "UMMobClick/MobClick.h"

//首页
UIKIT_EXTERN NSString * const JUUmengStaticHomePage;
//下载
UIKIT_EXTERN NSString * const JUUmengStaticDownload;
//我
UIKIT_EXTERN NSString * const JUUmengStaticMine;
//所有直播课程
UIKIT_EXTERN NSString * const JUUmengStaticAllLiveCourse;
//所有视频课程
UIKIT_EXTERN NSString * const JUUmengStaticAllVideo;
//课程详情页
UIKIT_EXTERN NSString * const JUUmengStaticCourseDetail;
//课程播放页
UIKIT_EXTERN NSString * const JUUmengStaticPlayerDetail;
//播放器
UIKIT_EXTERN NSString * const JUUmengStaticPlayer;
//课程报名页
UIKIT_EXTERN NSString * const JUUmengStaticCourseApplication;
//在线支付页
UIKIT_EXTERN NSString * const JUUmengStaticOnlinePay;
//购物车页面
UIKIT_EXTERN NSString * const JUUmengStaticShoppingCart;
//支付成功
UIKIT_EXTERN NSString * const JUUmengStaticPaySuccess;

//PV
UIKIT_EXTERN NSString * const JUUmengStaticPV;



//参数

UIKIT_EXTERN NSString * const JUUmengParamBannerView;
UIKIT_EXTERN NSString * const JUUmengParamBannerClick;
UIKIT_EXTERN NSString * const JUUmengParamBannerSlide;
UIKIT_EXTERN NSString * const JUUmengParamLiveClick;
UIKIT_EXTERN NSString * const JUUmengParamVideoClick;
UIKIT_EXTERN NSString * const JUUmengParamDownloaded;
UIKIT_EXTERN NSString * const JUUmengParamDownloading;
UIKIT_EXTERN NSString * const JUUmengParamMineNotLogin;
UIKIT_EXTERN NSString * const JUUmengParamMineLogin;
UIKIT_EXTERN NSString * const JUUmengParamCourseView;
UIKIT_EXTERN NSString * const JUUmengParamCourseClick;
UIKIT_EXTERN NSString * const JUUmengParamSlide;
UIKIT_EXTERN NSString * const JUUmengParamFilter;
UIKIT_EXTERN NSString * const JUUmengParamCourseNotBuy;
UIKIT_EXTERN NSString * const JUUmengParamCourseBought;
UIKIT_EXTERN NSString * const JUUmengParamCatalogue;
UIKIT_EXTERN NSString * const JUUmengParamAbstract;
UIKIT_EXTERN NSString * const JUUmengParamComment;





@interface JUUmengStaticTool : NSObject

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes;

+(void)event:(NSString *)eventId key:(NSString *)key value:(id)value;

+(void)event:(NSString *)eventId key:(NSString *)key intValue:(NSInteger)value;

@end
