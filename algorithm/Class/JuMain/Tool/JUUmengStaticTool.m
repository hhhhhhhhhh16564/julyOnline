//
//  JUUmengStaticTool.m
//  algorithm
//
//  Created by 周磊 on 17/4/17.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUUmengStaticTool.h"

//首页
NSString * const JUUmengStaticHomePage = @"HomePage";

//下载
NSString * const JUUmengStaticDownload = @"Download";

//我
NSString * const JUUmengStaticMine = @"Mine";

//所有直播课程
NSString * const JUUmengStaticAllLiveCourse = @"AllLiveCourse";

//所有视频课程
NSString * const JUUmengStaticAllVideo = @"AllVideo";

//课程详情页
NSString * const JUUmengStaticCourseDetail = @"CourseDetail";

//课程播放页
NSString * const JUUmengStaticPlayerDetail = @"PlayerDetail";

//播放器
NSString * const JUUmengStaticPlayer = @"Player";

//课程报名页
NSString * const JUUmengStaticCourseApplication = @"CourseApplication";

//在线支付页
NSString * const JUUmengStaticOnlinePay = @"OnlinePay";

//购物车页面
NSString * const JUUmengStaticShoppingCart = @"ShoppingCart";

//支付成功
NSString * const JUUmengStaticPaySuccess = @"PaySuccess";

//PV
NSString * const JUUmengStaticPV = @"PV";



//参数
NSString * const JUUmengParamBannerView = @"BannerView";
NSString * const JUUmengParamBannerClick = @"BannerClick";
NSString * const JUUmengParamBannerSlide = @"BannerSlide";
NSString * const JUUmengParamLiveClick = @"LiveClick";
NSString * const JUUmengParamVideoClick = @"VideoClick";
NSString * const JUUmengParamDownloaded = @"Downloaded";
NSString * const JUUmengParamDownloading = @"Downloading";
NSString * const JUUmengParamMineNotLogin = @"MineNotLogin";
NSString * const JUUmengParamMineLogin = @"MineLogin";
NSString * const JUUmengParamCourseView = @"CourseView";
NSString * const JUUmengParamCourseClick = @"CourseClick";
NSString * const JUUmengParamSlide = @"Slide";
NSString * const JUUmengParamFilter = @"Filter";
NSString * const JUUmengParamCourseNotBuy = @"CourseNotBuy";
NSString * const JUUmengParamCourseBought = @"CourseBought";
NSString * const JUUmengParamCatalogue = @"Catalogue";
NSString * const JUUmengParamAbstract = @"Abstract";
NSString * const JUUmengParamComment = @"Comment";

@implementation JUUmengStaticTool
+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes{
    

//    [super event:eventId attributes:attributes];
    
}
+(void)event:(NSString *)eventId key:(NSString *)key intValue:(NSInteger)value{
    
    NSString *strValue = [NSString stringWithFormat:@"%zd",value];
    [self event:eventId key:key value:strValue];
    
    
}

+(void)event:(NSString *)eventId key:(NSString *)key value:(id)value{
    
    NSString *str = nil;
    if ([value isKindOfClass:[NSString class]]) {
        str = value;
    }else{
        str = [NSString stringWithFormat:@"%@",value];
    }
    if (!str)return;
    NSDictionary *dict = @{
                           key:str
                           };
    if (![dict isKindOfClass:[NSDictionary class]]) return;
    [self event:eventId attributes:dict];
}

/*
-(void)changeFormate{
    
    NSArray *changeArray = @[@"BannerView",
                             @"BannerClick",
                             @"BannerSlide",
                             @"LiveClick",
                             @"VideoClick",
                             @"Downloaded",
                             @"Downloading",
                             @"MineNotLogin",
                             @"MineLogin",
                             @"CourseView",
                             @"CourseClick",
                             @"Slide",
                             @"Filter",
                             @"CourseView",
                             @"CourseClick",
                             @"Slide",
                             @"Filter",
                             @"CourseNotBuy",
                             @"CourseBought",
                             @" Catalogue",
                             @"Abstract",
                             @"Comment",
                             ];
    
    NSMutableArray *array = [NSMutableArray array];
    
    
    [changeArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (![array containsObject:obj]) {
            
            [array addObject:obj];
        }
        
    }];
    
    
    NSMutableString *result = [@"" mutableCopy];
    NSMutableString *result2 = [@"" mutableCopy];
    
    for (NSString *str  in array) {
        
        
        NSString *rule1  = [NSString stringWithFormat:@"UIKIT_EXTERN NSString * const JUUmengParam%@\n", str];
        [result appendString:rule1];
        
        NSString *rule2 = [NSString stringWithFormat:@"NSString * const JUUmengParam%@ = @\"%@\"\n", str,str];
        
        [result2 appendString:rule2];
        
    }
    
    JULog(@"%@", result);
    JULog(@"%@", result2);
    
}
*/
@end
