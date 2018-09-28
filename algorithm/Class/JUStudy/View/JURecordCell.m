//
//  JURecordCell.m
//  algorithm
//
//  Created by 周磊 on 16/7/21.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JURecordCell.h"
@interface JURecordCell ()

@property(nonatomic, strong) UIImageView *imv;
@property(nonatomic, strong) UILabel *QQLabel;

@property(nonatomic, strong) UILabel *lessonLabel;

@property(nonatomic, strong) UILabel *lastStudyTimeLabel;

@property(nonatomic, strong) UILabel *studyRecorderLabel;

@property(nonatomic, strong) UIImageView *arrowView;

@property(nonatomic, strong) UIView *lineView;

@end

@implementation JURecordCell

-(void)p_setupViews{
    
    UIImageView *imv = [[UIImageView alloc]init];
    [self.contentView addSubview:imv];
    self.imv = imv;
    //    self.imv.backgroundColor = [UIColor redColor];
    
    UILabel *QQLabel = [[UILabel alloc]init];
    [self.contentView addSubview:QQLabel];
    QQLabel.font = UIptfont(10);
    QQLabel.textColor = Kcolor16rgb(@"#0099ff", 1);
    
    self.QQLabel = QQLabel;
    
    
    UILabel *lessonLabel = [[UILabel alloc]init];
    [self.contentView addSubview:lessonLabel];
    lessonLabel.font = UIptfont(13);
    lessonLabel.textColor = Hcgray(1);
    lessonLabel.numberOfLines = 1;
    lessonLabel.textColor = Kcolor16rgb(@"#666666", 1);
    self.lessonLabel = lessonLabel;
    
    UILabel *lastStudyTimeLabel = [[UILabel alloc]init];
    lastStudyTimeLabel.textColor = Kcolor16rgb(@"#999999", 1);
    lastStudyTimeLabel.font = UIptfont(11);
    [self.contentView addSubview:lastStudyTimeLabel];
    self.lastStudyTimeLabel = lastStudyTimeLabel;
    
    
    UILabel *studyRecorderLabel = [[UILabel alloc]init];
    studyRecorderLabel.font = UIptfont(11);
    studyRecorderLabel.textColor = Kcolor16rgb(@"#999999", 1);
    [self.contentView addSubview:studyRecorderLabel];
    self.studyRecorderLabel = studyRecorderLabel;
    
//    
//    UIImageView *arrowView = [[UIImageView alloc]init];
//    arrowView.image = [UIImage imageNamed:@"yindao@studyjilu"];
//    [self addSubview:arrowView];
//    self.arrowView = arrowView;
//    
    
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = HCommomSeperatorline(1);
    
    [self.contentView addSubview:lineView];
    
    self.lineView = lineView;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    __weak typeof(self) weakSelf = self;
    [self.imv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(Kwidth*0.4, Kwidth*0.4*0.72));
    }];
    
    [self.QQLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.imv.mas_right).offset(10);
        make.top.equalTo(weakSelf.imv.mas_top).offset(5);
        make.height.mas_equalTo(10);
    }];
    
    [self.lessonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.QQLabel);
//        make.centerY.equalTo(weakSelf.imv);
        
        make.top.equalTo(weakSelf.QQLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(13);
    }];
    
    [self.lastStudyTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.QQLabel);
        make.bottom.equalTo(weakSelf.imv).offset(-11);
    }];
    
    
    [self.studyRecorderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.lastStudyTimeLabel.mas_right).offset(12);
        make.centerY.equalTo(weakSelf.lastStudyTimeLabel);
    }];
    
 
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        
    }];

    
    
    //    self.imv.backgroundColor = [UIColor redColor];
    //    self.titlelab.backgroundColor = [UIColor greenColor];
    //    self.lessonLabel.backgroundColor = [UIColor yellowColor];

 
    
}


//学习记录
//-(void)setrecorderModel:(JUrecorderModel *)recorderModel
//{
//    _recorderModel = recorderModel;
//    /**
//     *  //
//     //course_id = 18,
//     //image_name = 55e85e81d50c8.jpg,
//     //course_title = 机器学习公开课,
//     //logo = https://www.julyedu.com/Public/Image/55e85e81d50c8.jpg
//     //last_time = 1466522693
//     */
//    
////    NSURL *url = [NSURL URLWithString:recorderModel.image_name];
////    [self.imv sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"smallloading"]];
////  
////    
////    
////    
////    self.QQLabel.text = recorderModel.course_title;
////    self.lessonLabel.text = recorderModel.last_video.video_name;
////    NSString *str=recorderModel.last_time;//时间戳
////    NSTimeInterval time=[str doubleValue];
////    NSDate *createDate=[NSDate dateWithTimeIntervalSince1970:time];
////    self.lastStudyTimeLabel.text = [self createdate:createDate];
////  
////    
////    NSString *videoTime = [self studyTime:[recorderModel.last_video.video_time integerValue]];
////    self.studyRecorderLabel.text = [NSString stringWithFormat:@"学习到: %@",videoTime];
//}
//


-(void)setRecorderModel:(JUStudyingRecorderModel *)recorderModel{
    _recorderModel = recorderModel;
    
    
//    "course_id": 59,
//    "course_title": "图搜索实战班",
//    "simpledescription": "图论之图搜索BFS、DFS实战",
//    "course_qq": "331694040",
//    "image_name": "http://www.julyedu.com/Public/Image/46ee58e50b.jpg",
//    "ago": 0,
//    "seconds": 0,
//    "last_lesson": 266,
//    "lesson_name": "第2课 图搜索实战班第2讲",
//    "v_course_id": 51

        NSURL *url = [NSURL URLWithString:recorderModel.image_name];
        [self.imv sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"smallloading"]];

    self.QQLabel.text = [NSString stringWithFormat:@"QQ群:  %@", _recorderModel.course_qq];
    self.lessonLabel.text = _recorderModel.lesson_name;
         NSString *str=recorderModel.ago;//时间戳
        NSTimeInterval time=[str doubleValue];
        NSDate *createDate=[NSDate dateWithTimeIntervalSince1970:time];
     self.lastStudyTimeLabel.text = [self createdate:createDate];
    
    NSString *videoTime = [self studyTime:[recorderModel.seconds integerValue]];
    self.studyRecorderLabel.text = [NSString stringWithFormat:@"学习到: %@",videoTime];
    
    if ([recorderModel.ago isEqualToString:@"0"]) {
        self.lessonLabel.text = @"尚未开始观看";
        self.lastStudyTimeLabel.hidden = YES;
        self.studyRecorderLabel.hidden = YES;
   
    }else{
        
        self.lastStudyTimeLabel.hidden = NO;
        self.studyRecorderLabel.hidden = NO;
    }
    
    if (recorderModel.is_free) {
        self.QQLabel.hidden = YES;
    }else{
        self.QQLabel.hidden = NO;
    }

    
    
    
}


-(NSString *)createdate:(NSDate *)createDate{
    
    NSDate *nowDate = [NSDate date];
    NSTimeInterval timeinterval = [nowDate timeIntervalSinceDate:createDate];
    if (timeinterval < 60) {
        return @"1分钟前";
    }else if (timeinterval < 60*60){
        
        return [NSString stringWithFormat:@"%.0lf分钟前",timeinterval/60];
        
    }else if (timeinterval < 60*60*24){
        
        return [NSString stringWithFormat:@"%.0lf小时前",timeinterval/(60*60)];
        
        
    }else if (timeinterval < 60*60*24*30){
        
        return [NSString stringWithFormat:@"%.0lf天前",timeinterval/(60*60*24)];
        
    }else if (timeinterval < 60*60*24*30*12){
        
        return [NSString stringWithFormat:@"%.0lf个月前",timeinterval/(60*60*24*30)];
        
    }else {
        
        return [NSString stringWithFormat:@"%.0lf年前",timeinterval/(60*60*24*30*12)];
        
    }
    
    return @"";
    
}


-(NSString *)studyTime:(NSInteger)studyTime{
    
    int second = (int)studyTime;
    if (second >= 60) {
        return [NSString stringWithFormat:@"%d:%02d",(second/60),(second%60)];
    }else{
        return [NSString stringWithFormat:@"00:%02d",second];
    }

    
}






@end
