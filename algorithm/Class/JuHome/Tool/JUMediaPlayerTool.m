//
//  JUMediaPlayerTool.m
//  algorithm
//
//  Created by 周磊 on 17/3/1.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUMediaPlayerTool.h"
#import "HTTPServer.h"
#import "RegexKitLite.h"
#import "JUMediaModel.h"
#import "JUAsyncSocketManager.h"
#import "NSDictionary+Extension.h"

@interface JUMediaPlayerTool ()<UIAlertViewDelegate>


@property(nonatomic, strong) JULessonModel *lessonModel;
@property(nonatomic, strong) JUMediaModel *mediaModel;
@property(nonatomic, strong) HTTPServer *httpSever;

@property (nonatomic,assign) NSUInteger serverTimeStamp;
@property (nonatomic,assign) NSUInteger serVerPosition;
@property (nonatomic,assign) BOOL VideoPlayed;

@end
@implementation JUMediaPlayerTool

-(JUMediaPlayer *)mediaPlayer{
    __weak typeof(self) weakSelf = self;
    if (!_mediaPlayer) {
        _mediaPlayer = [[JUMediaPlayer alloc]init];
        _mediaPlayer.restartPlay = ^(JULessonModel *lessonModel){
            [weakSelf playDownloadCompletedVideoWithLessonModel:lessonModel];
        };
        
    }
    return _mediaPlayer;
}

+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    static JUMediaPlayerTool *tool = nil;
    dispatch_once(&onceToken, ^{
        tool = [[JUMediaPlayerTool alloc]init];
    });
    return tool;
}
//播放下载的视频
-(void)playDownloadCompletedVideoWithLessonModel:(JULessonModel *)downloadedLessonModel{
    
    JULessonModel *lessonModel = downloadedLessonModel;
    
    [self changeLessonModel:lessonModel];
    
    JUMediaModel *mediaModel = [self mediaModleWithLessonModel:lessonModel];
    mediaModel.resetServerPlay = YES;
    
    _lessonModel = lessonModel;
    _mediaModel = mediaModel;
    
    [self confirmWatchVideo:lessonModel mediaModel:mediaModel];

    
}

-(void)playVideoWithLessonModel:(JULessonModel *)lessonModel{

    [self InitializeVideoSource:lessonModel];
    
    //如果没有网络就不必请求，直接初始化播放资源
    if (networkingType == NotReachable) {
        [self configVideoSource:lessonModel];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",getLastVideoPlayPosition, lessonModel.ID];
    YBNetManager *manager = [[YBNetManager alloc]init];
    [manager GET:urlString parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, NSDictionary * responobject) {
        if ([[responobject[@"errno"] description] isEqualToString:@"0"] ) {
            NSString *time = responobject[@"data"][@"time"];
            NSString *time_stamp = responobject[@"data"][@"time_stamp"];
            weakSelf.serverTimeStamp =[time_stamp integerValue];
            weakSelf.serVerPosition = [time integerValue];
            
            
            if (!self.VideoPlayed) {
                JULog(@"请求播放");
                self.VideoPlayed = YES;
                [self configVideoSource:lessonModel];
            }
            

            
        }
        

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
   dispatch_get_main_queue(), ^{
       
       
       if (!self.VideoPlayed) {
           JULog(@"延迟播放");
           self.VideoPlayed = YES;
           [self configVideoSource:lessonModel];
       }
       
       
   });
  
    
}
//播放前初始化
-(void)InitializeVideoSource:(JULessonModel *)lessonModel{
    //时间戳为0
    self.serVerPosition = 0;
    self.serverTimeStamp = 0;
    self.mediaPlayer.hidden = NO;
    self.VideoPlayed = NO;
    //因为延时一秒播放，刷新播放列表时播放工具的Model没有值，播放的视频不变蓝色，在这儿赋值
    self.mediaPlayer.VideoID=lessonModel.ID;
    
    //添加播放的通知
    
     [[NSNotificationCenter defaultCenter] postNotificationName:startplayVedioNotification object:nil];


}

-(void)configVideoSource:(JULessonModel *)lessonModel{
    
    [self changeLessonModel:lessonModel];
    
    JUMediaModel *mediaModel = [self mediaModleWithLessonModel:lessonModel];
    
    _lessonModel = lessonModel;
    _mediaModel = mediaModel;
    
    if (mediaModel.downloaded) {
        
        [self showWithView:self.mediaPlayer text:@"你正在观看本地视频" duration:1.5];
        [self confirmWatchVideo:lessonModel mediaModel:mediaModel];
        
    }else{
        
        if (networkingType==NotReachable) {
            [self showWithView:self.mediaPlayer text:@"请检查你的网咯" duration:1.5];
            self.mediaPlayer.hidden = YES;
            return;
            
            
        }else if (networkingType == ReachableViaWWAN){
            
            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"你确定观看该视频吗" message:@"当前网络环境观看视频可能会耗费手机流量" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            [alterView show];
            
            
        }else{
            
            [self confirmWatchVideo:lessonModel mediaModel:mediaModel];
            
            
        }
        
    }
    
}



-(void)confirmWatchVideo:(JULessonModel *)lessonModel mediaModel:(JUMediaModel *)mediaModel{
    
    self.mediaPlayer.lessonModel = lessonModel;
    self.mediaPlayer.mediaModel = mediaModel;
    
    //添加学习的记录
    [self addStudyRecoder:lessonModel];
    
//    self.mediaPlayer.hidden = NO;
}

-(JUMediaModel *)mediaModleWithLessonModel:(JULessonModel *)lessonModel{
    
    JUMediaModel *mediaModel = [[JUMediaModel alloc]init];
    
    
    mediaModel.title = lessonModel.name;
    mediaModel.placeholderImage = lessonModel.img;
//    mediaModel.beginTime = playRecordLessonModel.timeRecord;
    mediaModel.downloaded = (lessonModel.downloadInfo.downloadstatus == JUDownloadStateCompleted);
    
    if (mediaModel.downloaded) {
    
        if (lessonModel.isM3u8Video) {
            [self configureHttpSever:lessonModel];
            mediaModel.VideoURL = [NSURL URLWithString:lessonModel.contentUrlString];
        }else{
        mediaModel.VideoURL = [NSURL fileURLWithPath:lessonModel.destinationPath];
        }
  
    }else{
        
        mediaModel.VideoURL = [NSURL URLWithString:lessonModel.play_url];
    }
    
    if (JuuserInfo.isLogin) {
        
        JULessonModel *playRecordLessonModel = [lessonRecordDatabase getLessonModel:lessonModel];
        
//        JULog(@"%@****   %d", playRecordLessonModel, playRecordLessonModel.isPlayed);
        
        if (playRecordLessonModel) {
            mediaModel.beginTime = playRecordLessonModel.timeRecord;
            playRecordLessonModel.isPlayed = mediaModel.downloaded;
            
//
//            JULog(@"服务器记录：%zd  服务器时间戳 %zd", self.serVerPosition, self.serverTimeStamp);
//            JULog(@"本地记录：%zd  本地时间戳:%zd", playRecordLessonModel.timeRecord, playRecordLessonModel.timestamp);
            
            
            if (self.serverTimeStamp > playRecordLessonModel.timestamp) {
                mediaModel.beginTime = self.serVerPosition;
            }

//            JULog(@"开始播放时间: %d", (int)mediaModel.beginTime);
            
            [lessonRecordDatabase updateLessonModel:playRecordLessonModel];
        }else{
            [lessonRecordDatabase addLessonModel:lessonModel];
            
        }
    }
    
    return mediaModel;
}

//增加或者更改播放记录:某个课程下播放的最后一个课程
-(void)changeLessonModel:(JULessonModel *)lessonModel{
    
    if (!JuuserInfo.isLogin)return;
    
    JULessonModel *lastLessonMode = [courseLaseRecorder111 lastLessonRecoderGetLessonModel:lessonModel];
    
    if (lastLessonMode) {
        [courseLaseRecorder111 lastLessonRecoderUPdateLessonModel:lessonModel];
    }else{
        [courseLaseRecorder111 lastLessonRecoderAddLessonModel:lessonModel];
 
    }

}

-(void)configureHttpSever:(JULessonModel *)lessonModel{
    [self.httpSever stop];
    self.httpSever = nil;
    
    if (!self.httpSever || !self.httpSever.isRunning) {
        self.httpSever = [[HTTPServer alloc]init];
        [self.httpSever setType:@"_http._tcp."];
        [self.httpSever setDocumentRoot:lessonModel.documnetrootString];
        self.httpSever.port = 9327;
        NSError *error = nil;
        
        if (![self.httpSever start:&error]) {
            
            JULog(@"Error stating Http Server : %@", error);
        }
        
    }
    
}

-(void)addStudyRecoder:(JULessonModel *)lessonModel{
    //当播放视频时，AFN发送post请求，增加用户学习记录
    if (!JuuserInfo.isLogin)return;
    YBNetManager *mannager = [[YBNetManager alloc]init];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"course_id"] = lessonModel.course_id;
    dic[@"lesson_id"] = lessonModel.ID;
    
    [mannager POST:addCourseRecoder parameters:dic headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
    } success:^(NSURLSessionDataTask *task, id responobject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

-(void)play{

    [self.mediaPlayer play];
    
    }


-(void)pause{
        [self.mediaPlayer pause];
    }

-(void)stop{
    
    [self.mediaPlayer stop];

}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex) {
        
        [self confirmWatchVideo:_lessonModel mediaModel:_mediaModel];
        
    }else{
        
        self.mediaPlayer.hidden = YES;
        
        
        
    }
    
}


@end
