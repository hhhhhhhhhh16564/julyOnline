//
//  JUDownloadMoreTableViewHeadView.m
//  algorithm
//
//  Created by pro on 16/7/17.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUDownloadMoreTableViewHeadView.h"

@interface JUDownloadMoreTableViewHeadView ()

@property(nonatomic, strong) UIImageView *imv;

@property(nonatomic, strong) UILabel *titlelab;

@property(nonatomic, strong) UILabel *studyAmountLabel;

@property(nonatomic, strong) UIView *lineView;


@end
@implementation JUDownloadMoreTableViewHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self p_setupSubViews];
    }
    
    return self;
    
}

-(void)p_setupSubViews{
    
    UIImageView *imv = [[UIImageView alloc]init];
    [self addSubview:imv];
    self.imv = imv;
    //    self.imv.backgroundColor = [UIColor redColor];
    
    
    UILabel *titlelab = [[UILabel alloc]init];
    [self addSubview:titlelab];
    titlelab.font = UIptfont(16);
    self.titlelab = titlelab;
    
    
    UILabel *studyAmountLabel = [[UILabel alloc]init];
    [self addSubview:studyAmountLabel];
    studyAmountLabel.font = UIptfont(14);
    studyAmountLabel.textColor = Hcgray(1);
    self.studyAmountLabel = studyAmountLabel;
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = HCommomSeperatorline(1);
    
    [self addSubview:lineView];
    
    self.lineView = lineView;
    
    
    //    UIView *circleView = [[UIView alloc]init];
    //    circleView.backgroundColor = [UIColor redColor];
    //    circleView.layer.cornerRadius = 5;
    //    [self.contentView addSubview:circleView];
    //    self.circleView = circleView;

    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    __weak typeof(self) weakSelf = self;
    [self.imv mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(125, 90));
    }];
    
    [self.titlelab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.imv.mas_right).offset(15);
        make.top.equalTo(weakSelf.imv.mas_top);
        
        
        
    }];
    
    [self.studyAmountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titlelab);
        make.top.equalTo(weakSelf.titlelab.mas_bottom).offset(18);
        
        
    }];
    
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        
    }];
    
    //    [self.circleView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.top.mas_equalTo(15);
    //        make.right.mas_equalTo(-15);
    //        make.size.mas_equalTo(CGSizeMake(10, 10));
    //
    //    }];
    
    
    //    self.imv.backgroundColor = [UIColor redColor];
    //    self.titlelab.backgroundColor = [UIColor greenColor];
    //    self.studyAmountLabel.backgroundColor = [UIColor yellowColor];
}


-(void)setLessonModel:(JULessonModel *)lessonModel{
    
    _lessonModel = lessonModel;
    NSURL *url = [NSURL URLWithString:lessonModel.image_name];
    [self.imv sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"smallloading"]];
    self.titlelab.text = lessonModel.course_tile;
    self.studyAmountLabel.text = [NSString stringWithFormat:@"%@人学习过",lessonModel.play_times];

    
}



@end
