//
//  JUColHeaderReuseView.m
//  七月算法_iPad
//
//  Created by 周磊 on 16/5/31.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUColHeaderReuseView.h"


@interface JUColHeaderReuseView ()

@property(nonatomic, strong) UIView *leftView;

@end


@implementation JUColHeaderReuseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        
    }
    return self;
}
-(void)setupView{
    
//    self.backgroundColor = [UIColor yellowColor];
    
    self.backgroundColor = Kcolor16rgb(@"#f3f4f8", 1);
    
    UIView *leftView = [[UIView alloc] init];
    leftView.layer.masksToBounds = YES;
    leftView.layer.cornerRadius = 1.5;
    leftView.backgroundColor = Hmblue(1);
    [self addSubview:leftView];

    self.leftView = leftView;
    
    
    
    self.titleLabel = [[UILabel alloc] init];
    
    self.titleLabel.font = UIptfont(17);
    [self addSubview:self.titleLabel];
    

    
    
    self.moreBtn = [[UIButton alloc] init];
    [self.moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [self.moreBtn.titleLabel setFont:UIptfont(15)];
    
    [self.moreBtn setTitleColor:Hmblue(1) forState:UIControlStateNormal];
    self.moreBtn.hidden = YES;
    [self addSubview:self.moreBtn];
    
    [self.moreBtn addTarget:self action:@selector(moreButtonDidClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    //区与区之间的分割线
//    UIView *lineView = [[UIView alloc]init];
//    lineView.backgroundColor = Kcolor16rgb(@"f4f4f4", 1);
//    [self addSubview:lineView];
//    self.line = lineView;
//    
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(10);
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.bottom.equalTo(weakSelf.mas_top);
//        
//        
//    }];
    
    
   
    
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(3, 18));
        make.centerY.equalTo(self);
        
    }];
    

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftView.mas_right).offset(8);
        
        make.centerY.equalTo(self);
        
        
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-17);
        make.centerY.equalTo(self);
        
        
        
    }];
    
    
}


//点击button时执行
-(void)moreButtonDidClicked:(UIButton *)button{
   
    if ([self.colHeadreuseViewDelegate respondsToSelector:@selector(morebuttonDidClicked:)]) {
        
        [self.colHeadreuseViewDelegate morebuttonDidClicked:self];
        
    }
    
    
}












@end
