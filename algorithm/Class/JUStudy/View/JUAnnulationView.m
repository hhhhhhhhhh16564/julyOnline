//
//  JUAnnulationView.m
//  algorithm
//
//  Created by yanbo on 17/9/15.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUAnnulationView.h"

@interface JUAnnulationView()

@property(nonatomic, strong) UILabel *loginLabel;
@end

@implementation JUAnnulationView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    UILabel *loginLabel = [[UILabel alloc]init];
    loginLabel.textColor = Kcolor16rgb(@"0099ff", 1);
    loginLabel.font = UIptfont(18);
    loginLabel.text = @"登录";
    loginLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:loginLabel];
    
    self.loginLabel = loginLabel;
    return self;
    
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.loginLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.left.and.right.and.top.and.bottom.mas_equalTo(0);
        
    }];
    
    
}


-(void)drawRect:(CGRect)rect{
    
    UIBezierPath* path1 =  [UIBezierPath bezierPathWithArcCenter:CGPointMake(40, 40) radius:36.5 startAngle:0 endAngle:(2*M_PI) clockwise:YES];
    UIColor *color = Kcolor16rgb(@"18b4ed", 1);
    [color setStroke];
    
    [path1 setLineWidth:3.5];
    [path1 stroke];

    
}

-(void)stytleText1{
    //圆环
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(150, 150) radius:100 startAngle:0 endAngle:(2*M_PI) clockwise:YES];
    
    //线宽
    [path setLineWidth:20];
    
    
    [path stroke];
    
}



























@end
