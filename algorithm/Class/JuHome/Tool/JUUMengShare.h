//
//  JUUMengShare.h
//  algorithm
//
//  Created by 周磊 on 16/10/8.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>
//#import "UMSocialUIManager.h"
#import "JULiveDetailModel.h"


@interface JUUMengShare : NSObject

@property(nonatomic, strong) JULiveDetailModel *liveDetailModel;

- (void)shareDataWithPlatform:(UMSocialPlatformType)platformType;

@end
