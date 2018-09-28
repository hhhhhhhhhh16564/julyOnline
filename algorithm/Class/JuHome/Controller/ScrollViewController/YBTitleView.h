//
//  YBTitleView.h
//  algorithm
//
//  Created by 周磊 on 16/9/6.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^MyButtonBlock)(id);



@interface YBTitleView : UIScrollView

@property(nonatomic, strong) NSArray<NSString *> *titleArray;


//两个按钮之间的间距
@property(nonatomic, assign) CGFloat buttonSpacing;

//设置字体的大小
@property(nonatomic, strong) UIFont *font;

@property(nonatomic, strong) UIView *bottomLineView;

@property (nonatomic,copy) MyButtonBlock Blcok;


//代码点击按钮点击按钮
-(void)titliButtonClicked:(NSUInteger)index;




@end
