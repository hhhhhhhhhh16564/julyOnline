//
//  JUUMengShare.m
//  algorithm
//
//  Created by 周磊 on 16/10/8.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUUMengShare.h"

@implementation JUUMengShare


- (void)shareDataWithPlatform:(UMSocialPlatformType)platformType
{
    
    if (!self.liveDetailModel)return;
    // 创建UMSocialMessageObject实例进行分享
    // 分享数据对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    NSString *title = self.liveDetailModel.course_title;
    NSString *url = self.liveDetailModel.share_url;
    NSString *text = self.liveDetailModel.simpledescription;
    NSString *imageurl = self.liveDetailModel.share_img;
//    UIImage *imageurl = [UIImage imageNamed:@"empty_download_sign"];

    
    JULog(@"%@ \n %@  \n %@  \n %@",title, url, text, imageurl);
    
    
    UMShareWebpageObject *shareWebObject = [UMShareWebpageObject shareObjectWithTitle:title descr:text thumImage:imageurl];
    [shareWebObject setWebpageUrl:url];
    messageObject.shareObject = shareWebObject;

    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id result, NSError *error) {
      
        if (!error) {
           
            JULog(@"分享成功");
            [[NSNotificationCenter defaultCenter] postNotificationName:JUShareCouponSucceedNotification object:nil];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            NSString *category = @"";
            
            switch (platformType) {
                case UMSocialPlatformType_Sina:
                {
                    category = @"1";
                    break;
                }
                case UMSocialPlatformType_WechatSession:
                case UMSocialPlatformType_WechatTimeLine:

                {
                    category = @"2";
                    break;
                }
                case UMSocialPlatformType_QQ:
                case UMSocialPlatformType_Qzone:

                {
                    category = @"3";
                    break;
                }
 
                default:
                    break;
            }
            
            dic[@"type"] = category;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:JUShareCouponSucceedNotification object:nil userInfo:dic];
            
        
        } else {
            JULog(@"分享失败");
            
        }
        
      
        
    }];

}




@end
