//
//  JUFreeCollectionCell.m
//  algorithm
//
//  Created by yanbo on 17/9/21.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUFreeCollectionCell.h"

@interface JUFreeCollectionCell ()

@property(nonatomic, strong) UIImageView *imv;
@property(nonatomic, strong) UILabel *titlelab;

@property(nonatomic, strong) UILabel *courseCountLabel;
@property(nonatomic, strong) UILabel *watchCountLabel;
@property(nonatomic, strong) UILabel *categoryLabel;



@end

@implementation JUFreeCollectionCell


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setupViews];
    }
    return self;
}




-(void)p_setupViews{
    
    UIImageView *imv = [[UIImageView alloc]init];
    [self.contentView addSubview:imv];
    self.imv = imv;

    UILabel *titlelab = [[UILabel alloc]init];
    titlelab.textAlignment = NSTextAlignmentLeft;
    titlelab.textColor = Kcolor16rgb(@"333333", 1);
    [self.contentView addSubview:titlelab];
    titlelab.font = UIptfont(14);
    self.titlelab = titlelab;
    
    
    UILabel *courseCountLabel = [[UILabel alloc]init];
    courseCountLabel.textAlignment = NSTextAlignmentLeft;
    courseCountLabel.textColor = Kcolor16rgb(@"666666", 1);
    [self.contentView addSubview:courseCountLabel];
    courseCountLabel.font = UIptfont(12);
    self.courseCountLabel = courseCountLabel;
    
    
    UILabel *watchCountLabel = [[UILabel alloc]init];
    courseCountLabel.textAlignment = NSTextAlignmentRight;
    watchCountLabel.textColor = Kcolor16rgb(@"666666", 1);
    [self.contentView addSubview:watchCountLabel];
    watchCountLabel.font = UIptfont(12);
    self.watchCountLabel = watchCountLabel;
    
    
    UILabel *categoryLabel = [[UILabel alloc]init];
    categoryLabel.textColor = Kcolor16rgb(@"00a4d3", 1);
    categoryLabel.textAlignment = NSTextAlignmentCenter;
    categoryLabel.layer.borderColor = [categoryLabel.textColor CGColor];
    categoryLabel.layer.borderWidth = 0.5;
    categoryLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:categoryLabel];
    categoryLabel.font = UIptfont(7);
    self.categoryLabel = categoryLabel;

//    [self.contentView colorForSubviews];
    
}


-(void)layoutSubviews{
    [super layoutSubviews];
 
    CGFloat kItemWith = (Kwidth-15*3)/2;
    [self.imv mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.and.and.right.mas_equalTo(0);
        make.height.mas_equalTo(kItemWith*0.72);
    }];
 
    [self.titlelab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imv.mas_bottom).offset(10);
        make.height.mas_equalTo(14);
        make.left.and.right.mas_equalTo(0);
    }];
  
//    self.titlelab.backgroundColor = [UIColor redColor];
    
    [self.courseCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titlelab.mas_bottom).offset(7);
        make.height.mas_equalTo(12);
        make.left.mas_equalTo(0);
    }];
    
    
    [self.watchCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titlelab.mas_bottom).offset(7);
        make.height.mas_equalTo(12);
        make.right.mas_equalTo(0);
    }];
    
    
    [self.categoryLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.courseCountLabel.mas_bottom).offset(7);
        make.height.mas_equalTo(12);
        make.left.mas_equalTo(0);
//        make.width.mas_equalTo(40);
    }];
    
}


-(void)setFreeCourseModel:(JUFreeCourseModel *)freeCourseModel{
    
    _freeCourseModel = freeCourseModel;
    
    NSURL *url = [NSURL URLWithString:freeCourseModel.logo];
    [self.imv sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"smallloading"]];

    self.titlelab.text = freeCourseModel.video_course_name;
    self.courseCountLabel.text = [NSString stringWithFormat:@"共%@次课",freeCourseModel.lessons];
    self.watchCountLabel.text = [NSString stringWithFormat:@"%@人观看",freeCourseModel.play_times];

    self.categoryLabel.text = [NSString stringWithFormat:@"%@   ",freeCourseModel.category];

 
    
    
}

@end
