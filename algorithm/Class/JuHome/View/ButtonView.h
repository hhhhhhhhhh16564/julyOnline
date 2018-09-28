//
//  ButtonView.h
//  algorithm
//
//  Created by pro on 16/7/13.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^Buttonblock)(NSInteger);

@interface ButtonView : UIView

-(instancetype)initWithTitleArray:(NSArray *)titleArray;

@property(nonatomic, copy) Buttonblock indexBlock;

//button选中的字体字体颜色
@property(nonatomic, strong) UIColor *selectedTitleColor;

//button正常的颜色
@property(nonatomic, strong) UIColor *normalTitleColor;


@property(nonatomic, assign) CGFloat button_Width;


//button的字体大小
@property(nonatomic, assign) CGFloat fontsize;

@property(nonatomic, strong) UIColor *lineColor;

- (void)setButtonClicked:(NSInteger)index;

@end







