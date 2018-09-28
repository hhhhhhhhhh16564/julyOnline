//
//  JUDownloadedViewCell.m
//  algorithm
//
//  Created by pro on 16/7/16.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUDownloadedViewCell.h"

@interface JUDownloadedViewCell ()

@property(nonatomic, strong) UIImageView *imv;

@property(nonatomic, strong) UILabel *titlelab;

@property(nonatomic, strong) UILabel *studyAmountLabel;

@property(nonatomic, strong) UIView *lineView;

//小圆点
@property(nonatomic, strong) UIView *circleView;

@end

@implementation JUDownloadedViewCell

-(void)p_setupViews{
    
    UIImageView *imv = [[UIImageView alloc]init];
    [self.contentView addSubview:imv];
    self.imv = imv;
    //    self.imv.backgroundColor = [UIColor redColor];
    
    
    UILabel *titlelab = [[UILabel alloc]init];
    [self.contentView addSubview:titlelab];
//    titlelab.backgroundColor = [UIColor redColor];
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
    
    
    UIView *circleView = [[UIView alloc]init];
    circleView.backgroundColor = [UIColor redColor];
    circleView.layer.cornerRadius = 4;
    [self.contentView addSubview:circleView];
    self.circleView = circleView;
    
    
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
        make.width.mas_equalTo(140);
        
        
    }];
    
    [self.studyAmountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titlelab);
        make.top.equalTo(weakSelf.titlelab.mas_bottom).offset(18);
        
        
    }];
    
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        
    }];
    
    [self.circleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(8, 8));
        
    }];
    
    
    //    self.imv.backgroundColor = [UIColor redColor];
    //    self.titlelab.backgroundColor = [UIColor greenColor];
    //    self.studyAmountLabel.backgroundColor = [UIColor yellowColor];
    

    
}

-(void)setLessonArray:(NSMutableArray *)lessonArray{
    
    __weak typeof(self) weakSelf = self;
    
    _lessonArray = lessonArray;
    
    JUDownloadInfo *downloadinfo = [lessonArray firstObject];
    JULessonModel *leesonModel = downloadinfo.lessonModel;
  
    NSURL *url = [NSURL URLWithString:leesonModel.image_name];
    [self.imv sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"smallloading"]];
    self.titlelab.text = leesonModel.course_tile;
    self.studyAmountLabel.text = [NSString stringWithFormat:@"%@人学习过",leesonModel.play_times];
    
    self.circleView.hidden = YES;
    
    if (!JuuserInfo.isLogin)return;
    //小红点
    [lessonArray enumerateObjectsUsingBlock:^(JUDownloadInfo *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        JULessonModel *lessonModel = obj.lessonModel;
        
        JULessonModel *returnLessonModel = [lessonRecordDatabase getLessonModel:lessonModel];
       
        if (returnLessonModel.isPlayed == NO) {
            
//            JULog(@"%d  %@", returnLessonModel.isPlayed, returnLessonModel.ID);
            
            weakSelf.circleView.hidden = NO;
            
            *stop = YES;
        }
        
    }];
    
    
    
}

- (void)dealloc
{
    JUlogFunction
    
}


@end
