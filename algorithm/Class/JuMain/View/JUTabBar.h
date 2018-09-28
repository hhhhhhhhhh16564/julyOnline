//
//  JUTabBar.h
//  algorithm
//
//  Created by pro on 16/6/27.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class JUTabBar;
//// 因为HWTabBar继承自UITabBar，所以称为HWTabBar的代理，也必须实现UITabBar的代理协议
//@protocol JUTabBarDelegate <UITabBarDelegate>
//
//@optional
//- (void)tabBarDidClickPlusButton:(JUTabBar *)tabBar;
//
//@end

@interface JUTabBar : UITabBar

//@property (nonatomic, weak) id<JUTabBarDelegate> tabbarDelegate;

@property (nonatomic,assign) NSInteger itemCount;
@end
