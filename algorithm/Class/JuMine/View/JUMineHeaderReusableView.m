//
//  JUMineHeaderReusableView.m
//  algorithm
//
//  Created by pro on 16/7/12.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUMineHeaderReusableView.h"


@interface JUMineHeaderReusableView ()
@property(nonatomic, strong) UIView *bottomlineView;
@property(nonatomic, strong) UIButton *coverButton;


@property(nonatomic, strong) UIView *buttonview;
@end


@implementation JUMineHeaderReusableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        
    }
    return self;
}
-(void)setupView{

    

    
    JUCourseCellView *cellView = [[[NSBundle mainBundle]loadNibNamed:@"JUCourseCellView" owner:self options:nil]lastObject];
    
    [self addSubview:cellView];
    self.cellView = cellView;

    
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self addSubview:button];
        [button addTarget:self action:@selector(coverButtonDidClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    
        self.coverButton = button;
        self.coverButton.backgroundColor = [UIColor clearColor];
    
    
    //区与区之间的分割线
//    UIView *lineView = [[UIView alloc]init];
//    lineView.backgroundColor = Kcolor16rgb(@"f4f4f4", 1);
//    [self addSubview:lineView];
//    self.line = lineView;
    
    //底部的细的分割线
    
    UIView *bottomlineView = [[UIView alloc]init];
    bottomlineView.backgroundColor = HCanvasColor(1);
    [self addSubview:bottomlineView];
    self.bottomlineView = bottomlineView;

    
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
 
//    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(10);
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.bottom.equalTo(weakSelf.mas_top);
//        
//    }];

    
    [self.cellView mas_makeConstraints:^(MASConstraintMaker *make) {
   
        make.left.and.right.and.top.mas_equalTo(0);
        make.height.mas_equalTo(44);
        
    }];
    
    [self.bottomlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
        
    }];
    
    
    [self.coverButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.and.right.and.top.and.bottom.mas_equalTo(0);
        
    }];
    
}

-(void)coverButtonDidClicked:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(didClickedHeaderReusableView:)]) {
        
        [self.delegate didClickedHeaderReusableView:self];
    }
    
    
    
}

@end
