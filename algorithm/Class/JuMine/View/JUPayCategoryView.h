//
//  JUPayCategoryView.h
//  algorithm
//
//  Created by 周磊 on 16/8/29.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import <UIKit/UIKit.h>



#import "JUButton.h"

@interface JUPayCategoryView : UIView

-(instancetype)initWithImage:(NSString *)image text:(NSString *)str;


@property(nonatomic, copy)globalBlock myblock;
@property(nonatomic, strong) JUButton *checkButton;


@end
