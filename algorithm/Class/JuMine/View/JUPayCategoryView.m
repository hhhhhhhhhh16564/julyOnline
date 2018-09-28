//
//  JUPayCategoryView.m
//  algorithm
//
//  Created by 周磊 on 16/8/29.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUPayCategoryView.h"


@interface JUPayCategoryView ()
@property(nonatomic, strong) UIImageView *imageView;

@property(nonatomic, strong) UILabel *label;





@property(nonatomic, strong) UIView *topLineView;
@property(nonatomic, strong) UIView *bottomLineView;


@end


@implementation JUPayCategoryView
-(instancetype)initWithImage:(NSString *)image text:(NSString *)str{
    
    self = [super init];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
     
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:image];
        [self addSubview:imageView];
        
        self.imageView = imageView;
        
        
        
        
        UILabel *label = [[UILabel alloc]init];
        label.text = str;
        label.textColor = [UIColor blackColor];
        label.font = UIptfont(15);
        [self addSubview:label];
        
        self.label = label;
        
        
        
        
   
        
        JUButton *button = [JUButton buttonWithType:(UIButtonTypeCustom)];
        [button setImage:[UIImage imageNamed:@"pay_btn_check"] forState:(UIControlStateNormal)];
        
        [button setImage:[UIImage imageNamed:@"pay_btn_check_pre"] forState:(UIControlStateSelected)];
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self addSubview:button];
        
        self.checkButton = button;
        
        
        
        
        
        
        
        
        
        
        
        UIView *topLineView = [[UIView alloc]init];
        topLineView.backgroundColor = HCommomSeperatorline(1);
        [self addSubview:topLineView];
        self.topLineView = topLineView;
        
        
        UIView *bottomLineView = [[UIView alloc]init];
        bottomLineView.backgroundColor = HCommomSeperatorline(1);
        [self addSubview:bottomLineView];
        self.bottomLineView = bottomLineView;
        

        
    }
  

    return self;

    
}


-(void)buttonClicked:(JUButton *)button{
    
    if (button.selected == YES)return;
    
    
    button.selected = YES;
 
    if (self.myblock) {
        
        self.myblock(button);

    }
    
}




-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(15, 0, 30, 30);
    [self.imageView Y_centerInSuperView];
    
    
    self.label.frame = CGRectMake(self.imageView.right_extension+10, 0, self.width_extension*0.4, self.height_extension);
    [self.label Y_centerInSuperView];
    
    
    
    self.checkButton.frame = CGRectMake(self.width_extension-50, 0, self.height_extension, self.height_extension);
    [self.checkButton Y_centerInSuperView];
    
    
    
    
    
    self.topLineView.frame = CGRectMake(0, 0, self.width_extension, 0.5);
    self.bottomLineView.frame = CGRectMake(0, self.height_extension-0.5, self.width_extension, 0.5);
    
    
}


@end
