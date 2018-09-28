//
//  JUDeletelineLabel.m
//  algorithm
//
//  Created by 周磊 on 16/8/22.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUDeletelineLabel.h"


@interface JUDeletelineLabel ()
@property(nonatomic, strong) UIView *lineview;
@end

@implementation JUDeletelineLabel

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        
    
    
        self.textAlignment = NSTextAlignmentCenter;
        
        UIView *lineview = [[UIView alloc]init];
        
        [self addSubview:lineview];
        
        self.lineview = lineview;
        
        

    }
    return self;
    
    
    
}



-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    
    self.lineview.backgroundColor = self.textColor;
    
    
    self.lineview.width_extension = self.width_extension+7;
    
    self.lineview.height_extension = 1;
    
    
    [self.lineview XY_centerInSuperView];
    

    
}













@end
