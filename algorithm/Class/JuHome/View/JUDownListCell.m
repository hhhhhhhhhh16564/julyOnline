//
//  JUDownListCell.m
//  algorithm
//
//  Created by pro on 16/7/14.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUDownListCell.h"
#import "JULessonModel.h"
@interface JUDownListCell ()

@property(nonatomic, strong) UIView *lineView;

@property(nonatomic, strong) UILabel *durationLab;

@property(nonatomic, strong) UILabel *sizeLabel;

@property(nonatomic, strong) UIButton *hookedButton;

@end

@implementation JUDownListCell

-(void)p_setupViews{
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = HCanvasColor(1);
    [self.contentView addSubview:line];
    self.lineView = line;
    

    
    UILabel *namelab = [[UILabel alloc]init];
    namelab.font = UIptfont(13);
    namelab.textColor = Hmblack(1);
    [self.contentView addSubview:namelab];
    self.nameLab = namelab;
    
    
    UILabel *durationLab = [[UILabel alloc]init];
    durationLab.font = UIptfont(13);
    durationLab.textColor = Kcolor16rgb(@"555555", 1);
    //    durationLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:durationLab];
    self.durationLab = durationLab;
    
    UILabel *sizeLabel = [[UILabel alloc]init];
    sizeLabel.font = UIptfont(13);
    sizeLabel.textColor = Kcolor16rgb(@"555555", 1);
    //    sizeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:sizeLabel];
    self.sizeLabel = sizeLabel;
    
    
    UIButton *hookedButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [hookedButton addTarget:self action:@selector(hookedButtonDidClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:hookedButton];
    self.hookedButton = hookedButton;
  
    
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    __weak typeof(self) weakSelf = self;
    [self.nameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(14);
        make.left.mas_equalTo(12);
        
    }];
    
    [self.durationLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(12);
        make.top.equalTo(weakSelf.nameLab.mas_bottom).with.offset(14);
        
    }];
    
    [self.sizeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.durationLab.mas_right).offset(20);
        make.top.equalTo(weakSelf.nameLab.mas_bottom).with.offset(14);
        
        
    }];
    
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(12);
        make.top.equalTo(weakSelf.durationLab.mas_bottom).offset(14);
        make.height.mas_equalTo(0.8);
        make.right.mas_equalTo(0);
        
    }];
    
    

    [self.hookedButton mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(-25);
        make.centerY.equalTo(weakSelf.mas_top).offset(weakSelf.height_extension/2);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        
        
        
    }];
    
    
    
}
//button点击
-(void)hookedButtonDidClicked:(UIButton *)button{
    
  
    if (self.lessonModel.lessonstate == JUUnSelected) {
        
        self.lessonModel.lessonstate = JUSeleted;
        
    }else if (self.lessonModel.lessonstate == JUSeleted){
        
        self.lessonModel.lessonstate = JUUnSelected;
        
    }
    
    [self setHookedbuttonImage];
    
    //代理方法，点击button时通知controller
    if ([self.delegate respondsToSelector:@selector(hookedButtonDidClicked:)]) {
        
        [self.delegate hookedButtonDidClicked:self];
    }
    
    
}

//设置图片
-(void)setHookedbuttonImage{
    
    if (self.lessonModel.lessonstate == JUCompleted) {
        
        [self.hookedButton setImage:[UIImage imageNamed:@"vidio_right_btn"] forState:(UIControlStateNormal)];
        
    }else if(self.lessonModel.lessonstate == JUUnSelected){
        [self.hookedButton setImage:[UIImage imageNamed:@"vidio_rectangle_btn"] forState:(UIControlStateNormal)];
        
    }else if(self.lessonModel.lessonstate == JUSeleted){
        
         [self.hookedButton setImage:[UIImage imageNamed:@"down_right"] forState:(UIControlStateNormal)];
        
    }
    
    
    
}



-(void)setLessonModel:(JULessonModel *)lessonModel
{
    _lessonModel = lessonModel;
    
    
    self.durationLab.text = [NSString stringWithFormat:@"时长:%@",lessonModel.duration];
    
    self.sizeLabel.text = [NSString stringWithFormat:@"大小:%@",lessonModel.size];
    

    if (self.lessonModel.downloadInfo.downloadstatus == JUDownloadStateCompleted) {
        
        self.lessonModel.lessonstate = JUCompleted;
//        self.hookedButton.enabled = NO;
        self.hookedButton.userInteractionEnabled = NO;
        
    }else{
//        self.hookedButton.enabled = YES;
        self.hookedButton.userInteractionEnabled = YES;

    }
    
    
    [self setHookedbuttonImage];
    
}



@end
