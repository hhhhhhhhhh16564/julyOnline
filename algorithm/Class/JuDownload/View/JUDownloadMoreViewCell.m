//
//  JUDownloadMoreViewCell.m
//  algorithm
//
//  Created by pro on 16/7/17.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUDownloadMoreViewCell.h"
@interface JUDownloadMoreViewCell ()

@property(nonatomic, strong) UILabel *durationLabel;
@property(nonatomic, strong) UILabel *sizeLabel;

@property(nonatomic, strong) UIView *lineView;

//小圆点
@property(nonatomic, strong) UIView *circleView;

@end

@implementation JUDownloadMoreViewCell

-(void)p_setupViews{
   
    UILabel *lessonNamelabel = [[UILabel alloc]init];
    lessonNamelabel.font = UIptfont(15);
    lessonNamelabel.textColor = Hmblack(1);
    [self.contentView addSubview:lessonNamelabel];
    
    self.lessonNameLabel = lessonNamelabel;
    
    
    //时间
    UILabel *durationlable = [[UILabel alloc]init];
    durationlable.textColor = Hcgray(1);
    durationlable.font = UIptfont(15);
    [self.contentView addSubview:durationlable];
    self.durationLabel = durationlable;
    
    //大小
    UILabel *sizeLable = [[UILabel alloc]init];
    sizeLable.textColor = Hcgray(1);
    sizeLable.font = UIptfont(15);
    [self.contentView addSubview:sizeLable];
    self.sizeLabel = sizeLable;
    
    //分割线
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = HCommomSeperatorline(1);
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
   
    
    UIView *circleView = [[UIView alloc]init];
    circleView.backgroundColor = [UIColor redColor];
    circleView.layer.cornerRadius = 3;
    [self.contentView addSubview:circleView];
    self.circleView = circleView;
    
    
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
     __weak typeof(self) weakSelf = self;
    [self.lessonNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(18);
        make.height.mas_equalTo(15);
        
    }];
    
    [self.durationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.equalTo(weakSelf.lessonNameLabel.mas_bottom).offset(18);
         make.height.mas_equalTo(13);
    }];
    
    [self.sizeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.durationLabel.mas_right).offset(15);
        make.top.equalTo(weakSelf.lessonNameLabel.mas_bottom).offset(18);
         make.height.mas_equalTo(13);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.right.and.bottom.mas_equalTo(0);
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(0.5);
        
    }];
    
    
    [self.circleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(6, 6));
        
    }];
    
    
    

}

-(void)setLessonModel:(JULessonModel *)lessonModel{
    _lessonModel = lessonModel;
    
    self.durationLabel.text = [NSString stringWithFormat:@"时长:%@",lessonModel.duration];
    self.sizeLabel.text = [NSString stringWithFormat:@"大小:%@",lessonModel.size];
    
    if (!JuuserInfo.isLogin) return;
    JULessonModel *returnLessonModel = [lessonRecordDatabase getLessonModel:lessonModel];
    
    if (returnLessonModel.isPlayed) {
        self.circleView.hidden = YES;
    }else{
        self.circleView.hidden = NO;
    }
    
    
    
    
    
}



















@end
