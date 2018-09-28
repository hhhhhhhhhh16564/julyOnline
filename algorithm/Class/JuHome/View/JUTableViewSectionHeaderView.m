//
//  JUTableViewSectionHeaderView.m
//  algorithm
//
//  Created by pro on 17/9/23.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUTableViewSectionHeaderView.h"

@interface JUTableViewSectionHeaderView ()
@property(nonatomic, strong) UIView *leftView;

@end

@implementation JUTableViewSectionHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
        
    }
    return self;
    
}

-(void)setupView{
    
    
    self.backgroundColor = Kcolor16rgb(@"#f3f4f8", 1);
    
    UIView *leftView = [[UIView alloc] init];
    leftView.layer.masksToBounds = YES;
    leftView.layer.cornerRadius = 1.5;
    leftView.backgroundColor = Hmblue(1);
    [self.contentView addSubview:leftView];
    
    self.leftView = leftView;
    
    
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = Kcolor16rgb(@"202426", 1);
    self.titleLabel.font = UIptfont(16);
    [self.contentView addSubview:self.titleLabel];
    
    
//        self.contentView.backgroundColor = [UIColor yellowColor];

 
//    [self.contentView colorForSubviews];
    
    
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
    
 
    
    
}



@end
