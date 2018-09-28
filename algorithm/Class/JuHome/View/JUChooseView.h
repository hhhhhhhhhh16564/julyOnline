//
//  JUChooseView.h
//  algorithm
//
//  Created by 周磊 on 16/8/24.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JUButton;

typedef void (^MyBlock)(JUButton *);


@interface JUChooseView : UIView

-(instancetype)initWithFrame:(CGRect)frame categoryString:(NSString *)categoryString;

@property(nonatomic, strong) NSArray<NSString *> *array;

@property (nonatomic,copy) MyBlock block;

@property (nonatomic,assign) NSUInteger seletedIndex;

@end
