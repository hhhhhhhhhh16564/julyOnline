//
//  JUMenuView.h
//  algorithm
//
//  Created by 周磊 on 16/10/17.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBTitleButton.h"


@interface JUMenuView : UIView

@property(nonatomic, strong) NSArray<NSString *> *buttonArray;


//两个按钮之间的间距
@property(nonatomic, assign) CGFloat buttonSpacing;

//设置字体的大小
@property(nonatomic, strong) UIFont *font;

@property(nonatomic, strong) UIView *bottomLineView;

@property (nonatomic,copy) globalBlock buttonBlcok;

@property (nonatomic,assign) BOOL isClicked;

//点击类型:  1表示手动点击   2 表示代码点击， 0表示默认
@property (nonatomic,assign) NSInteger clickType;

//代码点击按钮点击按钮
-(void)MenubuttonClicked:(NSUInteger)index;
@end
