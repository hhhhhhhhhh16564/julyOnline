//
//  JUCoverView.h
//  algorithm
//
//  Created by 周磊 on 16/7/20.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JUCoverView : UIView

@property(nonatomic, strong) NSString *labelOneString;
@property(nonatomic, strong) NSString *labelTwoString;
@property(nonatomic, strong) NSString *imageName;

//@property (nonatomic,assign) CGRect imageRect;

@property (nonatomic,assign) CGFloat labelTop;

@property (nonatomic,assign) CGFloat imageViewTop;

@property(nonatomic, strong) UIColor *textColor;

//需要设置button的size, button才会显示
@property(nonatomic, strong, readonly) UIButton *button;

@property (nonatomic,copy) dispatch_block_t buttonBlock;

@end
