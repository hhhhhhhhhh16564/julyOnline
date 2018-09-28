//
//  JUTabBar.m
//  algorithm
//
//  Created by pro on 16/6/27.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUTabBar.h"

@interface JUTabBar ()

@end

@implementation JUTabBar


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}

///**
// *  加号按钮点击
// */
//- (void)plusClick
//{
//    // 通知代理
//    if ([self.tabbarDelegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
//        [self.tabbarDelegate tabBarDidClickPlusButton:self];
//    }
//}

- (void)layoutSubviews
{

    [super layoutSubviews];
    
    
//    NSInteger count = 3;
//    
//    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
//        
//        count = 4;
//    }
    
    
    // 2.设置其他tabbarButton的位置和尺寸
    CGFloat tabbarButtonW = self.width_extension / _itemCount;
    CGFloat tabbarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            // 设置宽度
            child.width_extension = tabbarButtonW;
            // 设置x
            child.x_extension = tabbarButtonIndex * tabbarButtonW;
            
            // 增加索引
            tabbarButtonIndex++;
            
        }
    }
}


@end
