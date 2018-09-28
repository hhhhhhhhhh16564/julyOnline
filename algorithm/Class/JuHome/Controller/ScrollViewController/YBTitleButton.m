//
//  YBTitleButton.m
//  algorithm
//
//  Created by 周磊 on 16/9/6.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "YBTitleButton.h"

@implementation YBTitleButton


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [self setTitleColor:Hmblue(1) forState:UIControlStateSelected];

    }
    return self;
}

-(void)setHighlighted:(BOOL)highlighted{};



@end












