//
//  JUMoreViewCell.m
//  algorithm
//
//  Created by pro on 16/7/11.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUMoreViewCell.h"
#import "JUCoursesModel.h"
@interface JUMoreViewCell ()

@property(nonatomic, strong) UIImageView *imv;
@property(nonatomic, strong) UILabel *titlelab;

@property(nonatomic, strong) UILabel *studyAmountLabel;

@property(nonatomic, strong) UIView *lineView;

@end


@implementation JUMoreViewCell

-(void)p_setupViews{
    
    UIImageView *imv = [[UIImageView alloc]init];
    [self.contentView addSubview:imv];
    self.imv = imv;
    //    self.imv.backgroundColor = [UIColor redColor];
    
    
    UILabel *titlelab = [[UILabel alloc]init];
    [self.contentView addSubview:titlelab];
    titlelab.font = UIptfont(16);
    self.titlelab = titlelab;
 
    
    UILabel *studyAmountLabel = [[UILabel alloc]init];
    [self.contentView addSubview:studyAmountLabel];
    studyAmountLabel.font = UIptfont(14);
    studyAmountLabel.textColor = Hcgray(1);
    self.studyAmountLabel = studyAmountLabel;
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = HCommomSeperatorline(1);

    [self.contentView addSubview:lineView];
    
    self.lineView = lineView;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
     __weak typeof(self) weakSelf = self;
    [self.imv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(125, 90));
    }];
    
    [self.titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.imv.mas_right).offset(15);
        make.top.equalTo(weakSelf.imv.mas_top);
        
        
        
    }];
    
    [self.studyAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titlelab);
        make.top.equalTo(weakSelf.titlelab.mas_bottom).offset(18);
        
        
    }];
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        
    }];
    
    
    
//    self.imv.backgroundColor = [UIColor redColor];
//    self.titlelab.backgroundColor = [UIColor greenColor];
//    self.studyAmountLabel.backgroundColor = [UIColor yellowColor];
    
  
    
    
}


-(void)setCourseModel:(JUCoursesModel *)courseModel{
    
    _courseModel = courseModel;
    
    /**
     *  simpledescription = 在各大高校举办的面试算法讲座。,
     course_id = 21,
     image_name = 55e85ea0df9d7.jpg,
     course_title = 线下算法讲座,
     img = https://www.julyedu.com/Public/Image/55e85ea0df9d7.jpg,
     stu_num = 10963

     */
    
    
    NSURL *url = [NSURL URLWithString:courseModel.img];
    [self.imv sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"smallloading"]];
    self.titlelab.text = courseModel.course_title;

    self.studyAmountLabel.text = [NSString stringWithFormat:@"%@人学习过",courseModel.stu_num];
    
    
    
}
















@end
