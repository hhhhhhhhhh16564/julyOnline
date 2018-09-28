//
//  JUDownloadingViewCell.m
//  七月算法_iPad
//
//  Created by pro on 16/6/19.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUDownloadingViewCell.h"
#import "JULessonModel.h"
#import "JUDateBase.h"
#import "JUDownloadInfo.h"
#import "JUDownloadManager.h"
@interface JUDownloadingViewCell ()

@property(nonatomic, strong) UILabel *sizeLabel;

//为了解决block对label的引用不释放的问题
@property(nonatomic, strong) UILabel *minorsizeLabel;

@property(nonatomic, strong) UIView *lineView;

@property(nonatomic, strong) UILabel *remainingTimeLabel;


//@property(nonatomic, strong) UILabel *testlabel;
@end
@implementation JUDownloadingViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self p_makeupSubViews];
        
        
    }
    
    return self;
    
}

-(void)p_makeupSubViews{
    
    
    
    
    UILabel *lessonNamelabel = [[UILabel alloc]init];
    lessonNamelabel.font = UIptfont(15);
    lessonNamelabel.textColor = Hmblack(1);
    [self.contentView addSubview:lessonNamelabel];
    
    self.lessonNameLabel = lessonNamelabel;
    
    
#pragma mark 测试找bug

    
    

    
    //状态
    UILabel *statusLabel = [[UILabel alloc]init];
    statusLabel.textColor = Hcgray(1);
    statusLabel.font = UIptfont(13);
    [self.contentView addSubview:statusLabel];
    self.statusLabel = statusLabel;
    
    //大小
    UILabel *sizeLable = [[UILabel alloc]init];
    sizeLable.textColor = Hcgray(1);
    sizeLable.font = UIptfont(13);
    [self.contentView addSubview:sizeLable];
    self.sizeLabel = sizeLable;
    
    
    //剩余时间
    UILabel *remainingTimeLabel = [[UILabel alloc]init];
    remainingTimeLabel.textColor = Hcgray(1);
    remainingTimeLabel.font = UIptfont(13);
//    remainingTimeLabel.backgroundColor = [UIColor redColor];
    
    [self.contentView addSubview:remainingTimeLabel];
    self.remainingTimeLabel = remainingTimeLabel;
    


    
    
    //分割线
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = HCommomSeperatorline(1);
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
    
    
    
    
    SDDemoItemView *demoItemviwe = [SDDemoItemView demoItemViewWithClass:[SDPieLoopProgressView class]];
    demoItemviwe.userInteractionEnabled = YES;
    [self.contentView addSubview:demoItemviwe];
    self.domoItemView = demoItemviwe;
    

    
    
    
    
    UIButton *downloadButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [downloadButton addTarget:self action:@selector(downStatuesButtondidClicked:) forControlEvents:(UIControlEventTouchUpInside)];
//    downloadButton.layer.cornerRadius = 22;
//    downloadButton.backgroundColor = [UIColor redColor];
//    [downloadButton setImage:[UIImage imageNamed:@"download_stop_btn"] forState:(UIControlStateNormal)];
    
    [demoItemviwe addSubview:downloadButton];
    self.downStatuesButton = downloadButton;
    
    

    
    
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
     __weak typeof(self) weakSelf = self;
 
 
    [self.lessonNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(18);
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(-80);
        
    }];
    
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
         make.height.mas_equalTo(13);
        make.top.equalTo(weakSelf.lessonNameLabel.mas_bottom).offset(18);
    }];
    
    [self.sizeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.statusLabel.mas_right).offset(15);
        make.top.equalTo(weakSelf.lessonNameLabel.mas_bottom).offset(18);
         make.height.mas_equalTo(13);
    }];
    
    [self.remainingTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.sizeLabel.mas_right).offset(15);
       make.top.equalTo(weakSelf.lessonNameLabel.mas_bottom).offset(18);
        make.width.mas_equalTo(100);
         make.height.mas_equalTo(13);
    }];
    
    
    [self.domoItemView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-12);
        make.centerY.equalTo(weakSelf.mas_top).offset(weakSelf.height_extension/2);
        make.size.mas_equalTo(CGSizeMake(45, 45));

        
    }];
    
    
    
    [self.downStatuesButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(44, 44));
        
        make.centerX.equalTo(weakSelf.domoItemView.mas_left).offset(22.5);
        make.centerY.equalTo(weakSelf.domoItemView.mas_top).offset(22.5);
        
        
    }];
    
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    
    #pragma mark 测试找bug
//    self.testlabel.frame = self.lessonNameLabel.bounds;
//    self.testlabel.x = self.lessonNameLabel.width/4;
//    self.testlabel.width = self.lessonNameLabel.width*0.8;
//    
//    
    
}



-(void)setDownloadinfo:(JUDownloadInfo *)downloadinfo{
    
    _downloadinfo = downloadinfo;
    
    
//    self.backgroundColor = [UIColor greenColor];
    
    
//    JULessonModel *lessonMoel = downloadinfo.lessonModel;
    NSInteger sizecount = [self getSize:downloadinfo];
    self.remainingTimeLabel.hidden = YES;
    
    if (_downloadinfo.downloadstatus == JUDownloadStateWillResume) {//将要下载
      self.statusLabel.text = @"等待下载";
        self.sizeLabel.text = [NSString stringWithFormat:@"0M/%ldM",(long)sizecount];
        self.domoItemView.progressView.progress = 0;
        [self.downStatuesButton setBackgroundImage:[UIImage imageNamed:@"download_start_btn"] forState:(UIControlStateNormal)];
        
    }else if (_downloadinfo.downloadstatus == JUDownloadStateResumed){//正在下载
       self.statusLabel.text = @"正在下载";
    [self.downStatuesButton setBackgroundImage:[UIImage imageNamed:@"download_stop_btn"] forState:(UIControlStateNormal)];
        //如果正在下载，在这里更改下载进度
        JUDownloadManager *mannager = [JUDownloadManager shredManager];
    __weak JUDownloader *downloader = mannager.downloader;
        __weak typeof(self) weakSelf = self;
      
        downloader.process = ^(float progress,NSString *sizeString,NSString *speedString){
            
//            JULog(@" %@  %@", sizeString, speedString);
    
            dispatch_async(dispatch_get_main_queue(), ^{
                //这一句判断一定不能少，cell的重用机制
                if (downloadinfo.downloadstatus == JUDownloadStateResumed) {
                    if (![weakSelf.downloadinfo.lessonModel.ID isEqualToString: downloader.lessonModel.ID]) {
                        return;
                    }
//                    weakSelf.backgroundColor = RandomColor;
//                    JULog(@"%@  %@", weakSelf.downloadinfo.lessonModel.ID , downloader.lessonModel.ID);
                    
                
                    weakSelf.remainingTimeLabel.hidden = NO;
                    
                    weakSelf.sizeLabel.text = [NSString stringWithFormat:@"%.2fM/%ldM",sizecount*progress, (long)sizecount];
                    weakSelf.domoItemView.progressView.progress = progress;

                    
                    float downloadspeed = [speedString floatValue];
                    if (downloadspeed == 0) {
                        
                        downloadspeed = 0.005;
                        
                    }
                    
                    NSInteger remainingtime = sizecount*(1-progress)/downloadspeed;
                    
                    NSString *timeString = [weakSelf convertedTimer:remainingtime];
                    if ([timeString isEqualToString:@"0分钟0秒"]) {
                        timeString = @"0分钟1秒";
                    }
                    
                    weakSelf.remainingTimeLabel.text = [NSString stringWithFormat:@"%@", timeString];
  
                }
            });
             
      };
        
    }else if (_downloadinfo.downloadstatus == JUDownloadStateSuspened){//暂停下载
        self.statusLabel.text = @"暂停下载";
        self.sizeLabel.text = [self getSizeWithDownloadInfo:downloadinfo];
        [self.downStatuesButton setBackgroundImage:[UIImage imageNamed:@"download_start_btn"] forState:(UIControlStateNormal)];
        self.domoItemView.progressView.progress = [self getProgressWithDownloadInfo:downloadinfo];
        
    }
    
}

//sizeLabel的字体
-(NSString *)getSizeWithDownloadInfo:(JUDownloadInfo *)downloadinfo{
    
    JULessonModel *lessonModel = downloadinfo.lessonModel;
    NSInteger sizecount = [self getSize:downloadinfo];
    
    if ([lessonModel.play_url containsString:@".m3u8"] ) {
        
        float nowsize = sizecount*(downloadinfo.progress+downloadinfo.partID)/downloadinfo.allPartID;
        NSString *nowSizeString = [NSString stringWithFormat:@"%.2fM", nowsize];
        if ([nowSizeString isEqualToString:@"-infM"]) {
            nowSizeString = @"0M";
        }
        
        if ([nowSizeString isEqualToString:@"-0M"]) {
            nowSizeString = @"0M";
        }
        
        if ([nowSizeString isEqualToString:@"nanM"]) {
            nowSizeString = @"0M";
        }
        
        
        
      return [NSString stringWithFormat:@"%@/%ldM",nowSizeString, (long)sizecount];
        
    }else{
        
        
        return [NSString stringWithFormat:@"%.2fM/%ldM",sizecount*downloadinfo.progress, (long)sizecount];

        
    }
    
    
    
}

//下载进度
-(CGFloat)getProgressWithDownloadInfo:(JUDownloadInfo *)downloadinfo{
    JULessonModel *lessonModel = downloadinfo.lessonModel;
   
    if ([lessonModel.play_url containsString:@".m3u8"] ) {
        
        if (downloadinfo.partID == -1) {
            downloadinfo.partID = 0;
        }
    
        return (downloadinfo.progress+downloadinfo.partID)/downloadinfo.allPartID;
        
    }else{
      
        return downloadinfo.progress;
        
    }
    
}


//返回下载文件的总大小  interger值
-(NSInteger)getSize:(JUDownloadInfo *)downloadinfo{
    
    NSMutableString *sizestr = [downloadinfo.lessonModel.size mutableCopy];
    [sizestr deleteCharactersInRange:NSMakeRange(sizestr.length-1, 1)];
    NSInteger sizecount = [sizestr integerValue];
    
    return sizecount;
}




-(void)downStatuesButtondidClicked:(UIButton *)downloadstatusButton{
    
    if (self.downloadBlock) {
        self.downloadBlock(downloadstatusButton);
    }
    
}

// 将剩余时间s转化
-(NSString *)convertedTimer:(NSInteger)second{
    if (second < 60) {
        
        return [NSString stringWithFormat:@"0分钟%ld秒",(long)second];
        
    }else if (second < 60*60){
        
        NSInteger minute = second/60;
        NSInteger secs = second % 60;
        return [NSString stringWithFormat:@"%ld分钟%ld秒",(long)minute, (long)secs];
        
    }else if (second < 60 * 60 * 24){
        
        NSInteger hour = second/3600;
        NSInteger minute = second%3600/60;
        NSInteger secs = second%60;
        
        return [NSString stringWithFormat:@"%ld时%ld分%ld秒",(long)hour, (long)minute, (long)secs];
        
    }else{
        
        return [NSString stringWithFormat:@"超过1天"];
    }
    
  
}

- (void)dealloc
{
    JUlogFunction
}
@end
