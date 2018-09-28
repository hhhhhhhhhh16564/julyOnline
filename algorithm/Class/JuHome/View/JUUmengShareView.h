//
//  JUUmengShareView.h
//  algorithm
//
//  Created by 周磊 on 16/10/13.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUShareButton.h"


@interface JUUmengShareView : UIView


@property (nonatomic,copy) globalBlock cancelBlcok;
@property(nonatomic, copy) globalBlock shareBlock;


@property (nonatomic,copy) globalBlock loginBlock;

// 是否展示区登录的页面

@property (nonatomic,assign) BOOL showLogin;

@end
