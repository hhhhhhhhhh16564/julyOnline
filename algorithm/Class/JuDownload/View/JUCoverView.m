//
//  JUCoverView.m
//  algorithm
//
//  Created by 周磊 on 16/7/20.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUCoverView.h"

@interface JUCoverView ()
{
    CGSize _imageSize;
}

@property(nonatomic, strong) UILabel *labelOne;
@property(nonatomic, strong) UILabel *labelTwo;
@property(nonatomic, strong) UIImageView *imv;
@property(nonatomic, strong) UIButton *button;

@end


@implementation JUCoverView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self ) {
       
        [self p_setupSubViews];
        self.backgroundColor = [UIColor whiteColor];
        
    }
    
    
    return self;
    
}
-(void)p_setupSubViews{
    
    UIImageView *imv = [[UIImageView alloc]init];
    [self addSubview:imv];
    

    
    
    self.imv = imv;
    
    UILabel *labelOne = [[UILabel alloc]init];
    self.labelOne = labelOne;
    [self setLabeAttribute:labelOne];
    
    UILabel *labelTwo = [[UILabel alloc]init];
    self.labelTwo = labelTwo;
    [self setLabeAttribute:labelTwo];
    
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    UIColor *blueColor = Kcolor16rgb(@"#0099FF", 1);
 
    [button setTitleColor:blueColor forState:(UIControlStateNormal)];
    button.titleLabel.font = UIptfont(13);
    button.layer.borderColor = [blueColor CGColor];
    button.layer.borderWidth = 0.5;
    button.layer.cornerRadius = 2;
    
    self.button = button;
    
    [self addSubview:button];
    
    
}

-(void)setLabeAttribute:(UILabel *)label{
    
    label.font = UIptfont(14);
    label.textColor = Kcolor16rgb(@"#666666", 1);
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
 
//    label.backgroundColor = RandomColor;
}

-(void)setTextColor:(UIColor *)textColor{
    
    _textColor = textColor;
    
    self.labelOne.textColor = textColor;
    self.labelTwo.textColor = textColor;

}



-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    __weak typeof(self) weakSelf = self;

    CGFloat top = 100;
    CGFloat labelTop = 15;
    
    if (self.labelTop) {
        labelTop = self.labelTop;
    }

    if (self.imageViewTop) {
        top = self.imageViewTop;
    }
    
    
    [self.imv mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.size.mas_equalTo(_imageSize);
    }];
    
    

    
    [self.labelOne mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.equalTo(weakSelf.imv.mas_bottom).offset(labelTop);
        make.height.mas_equalTo(14);
        
    }];
    
    CGSize size = self.button.frame.size;
    
    [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.labelOne.mas_bottom).offset(14);
        make.size.mas_equalTo(size);
        make.centerX.mas_equalTo(0);
        
        
    }];
    
    
    [self.labelTwo mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.equalTo(weakSelf.labelOne.mas_bottom).offset(5);
        make.height.mas_equalTo(14);
    
    }];
    
}


-(void)setLabelOneString:(NSString *)labelOneString{
    
    _labelOneString = labelOneString;
    self.labelOne.text = labelOneString;
}

-(void)setLabelTwoString:(NSString *)labelTwoString{
    
    _labelTwoString = labelTwoString;
    self.labelTwo.text = labelTwoString;
}

-(void)setImageName:(NSString *)imageName{
 
    _imageName = imageName;
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    _imageSize = image.size;
    self.imv.image = image;
    
    [self setNeedsLayout];

    
}

-(void)buttonClicked:(UIButton *)sender{
    
    if (self.buttonBlock) {
        self.buttonBlock();
    }
    
    
    
    
    
}


@end
