//
//  JUMediaPlayer.m
//  algorithm
//
//  Created by 周磊 on 17/2/22.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUMediaPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "JUMediaView.h"
#import "Masonry.h"
#import "JUMediaModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import "JUAsyncSocketManager.h"

typedef NS_ENUM(NSInteger,AVPlayerPlayState) {
    
    AVPlayerPlayStateNotKnow = 0,      // 未知情况
    AVPlayerPlayStateInitial , // 初始化播放资源

    AVPlayerPlayStatePreparing , // 准备播放
//    AVPlayerPlayStateBeigin,       // 开始播放
    AVPlayerPlayStatePlaying,      // 正在播放
    AVPlayerPlayStatePause,        // 播放暂停
    AVPlayerPlayStateEnd,          // 播放结束
    AVPlayerPlayStateBufferEmpty,  // 没有缓存的数据供播放了
    AVPlayerPlayStateBufferToKeepUp,//有缓存的数据可以供播放
    AVPlayerPlayStateNotPlay     // 不能播放
};

// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, AVPlayerPanDirection){
    PanDirectionHorizontalMoved,
    PanDirectionVerticalMoved
};


@interface JUMediaPlayer ()<JUMediaViewDelagate,UIAlertViewDelegate>
{
    //移动的方向
    AVPlayerPanDirection panDirection;
    
    CGFloat sumTime;
    
}

@property(nonatomic, strong)AVPlayer *player;

@property(nonatomic, strong)AVPlayerLayer *playerLayer;

@property(nonatomic, strong) JUMediaView *mediaView;

@property (nonatomic,assign, getter=isPlayed) BOOL played;

@property(nonatomic, strong) AVPlayerItem *currentItem;

@property (nonatomic, strong) id timeObserve;

//是否被用户暂停的
@property (nonatomic,assign) BOOL pauseByUser;
@property (nonatomic,assign) BOOL pauseONMobileNetwork;

@property (nonatomic,assign) AVPlayerPlayState playState;
//现在播放速率
@property (nonatomic,assign) CGFloat nowRate;
@property(nonatomic, strong) NSArray *multipleArray;


////**********************************************************************************************************************************************************************************************************************************************************************************************************//////
@property(nonatomic, strong) NSTimer *recoderTimer;

@end

@implementation JUMediaPlayer

-(NSArray *)multipleArray{
    if (!_multipleArray) {
        _multipleArray = @[@"1.0", @"1.25", @"1.5", @"1.75", @"2.0"];
    }
    return _multipleArray;
}

-(void)setNowRate:(CGFloat)nowRate{
    _nowRate = nowRate;

    if (self.playState == AVPlayerPlayStatePlaying) {
        self.player.rate = _nowRate;
    }
    
}


-(JUMediaView *)mediaView{
    if (!_mediaView) {
        _mediaView = [[JUMediaView alloc]init];
        _mediaView.FatherView = self;
        _mediaView.delegate = self;
        [_mediaView.layer addSublayer:self.playerLayer];
        [_mediaView.layer insertSublayer:self.playerLayer atIndex:0];
    }
    return _mediaView;
}
-(AVPlayer *)player{
    if (!_player) {
        _player = [[AVPlayer alloc]init];
        [_player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
               __weak typeof(self) weakSelf = self;
      self.timeObserve = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
          if (weakSelf.playState == AVPlayerPlayStatePlaying) {
              [weakSelf.mediaView reFreshTimeLabelWithCurrentTiem:[weakSelf secondMakeWithCMTime:time] totalTime:weakSelf.mediaModel.totalTime];
              weakSelf.mediaModel.currentTime = [weakSelf secondMakeWithCMTime:time];
              if (!weakSelf.lessonModel)return;
              if ([weakSelf.delegate respondsToSelector:@selector(ju_MediaPlayer:currentPlayTime:)] && [weakSelf.VideoID isEqualToString:weakSelf.lessonModel.ID]) {
                  [weakSelf.delegate ju_MediaPlayer:weakSelf currentPlayTime:weakSelf.mediaModel.currentTime];
              }
          }
        }];
    }
    return _player;
}

-(AVPlayerLayer *)playerLayer{
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        
    }
    return _playerLayer;
}

-(void)setPlayed:(BOOL)played{
    _played = played;
    [self.mediaView playButtonState:_played];
}



-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mediaView];
        [self addNotifiCation];
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    if (self.mediaView.superview == self) {
        self.mediaView.frame = self.bounds;
        self.playerLayer.frame = self.mediaView.bounds;
    }
}
//重置播放器
-(void)resetMediaPlayer{
    
    //设置不隐藏
    
    //self.mediaView.showBufferProgress = !(_mediaModel.downloaded || _mediaModel.isM3u8File);
    //本项目部展示进度条
//    self.mediaView.
    self.mediaView.showBufferProgress = NO;
    self.mediaView.autoScreenRotation = YES;
    self.playState = AVPlayerPlayStatePreparing;
    self.mediaModel.totalTime = [self secondMakeWithCMTime:self.currentItem.duration];
    self.mediaView.slider.maximumValue = self.mediaModel.totalTime;
    self.mediaView.slider.minimumValue = 0;
    if (self.mediaModel.beginTime >= self.mediaModel.totalTime) {
        self.mediaModel.beginTime = self.mediaModel.totalTime-5;
    }
    [self.mediaView reFreshTimeLabelWithCurrentTiem:self.mediaModel.beginTime totalTime:self.mediaModel.totalTime];
    __weak typeof(self) weakSelf = self;
    [self.player seekToTime:[self CMTimeWithSeconds:self.mediaModel.beginTime] completionHandler:^(BOOL finished) {
        if (finished) {
            [self.mediaView loadAnimated:NO color:[UIColor whiteColor]];

            [weakSelf play];
            weakSelf.nowRate = [[[NSUserDefaults standardUserDefaults] objectForKey:mediaPlayerMultipleNumberKey] floatValue];
           
        }
        
    }];
    
    self.mediaView.allowToolBarResponsed = YES;

  
}

-(void)setMediaModel:(JUMediaModel *)mediaModel{
    _mediaModel = mediaModel;
    
    if (!_mediaModel) return;
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:_mediaModel.VideoURL];
    [self itemAddObseVer:item];
    self.currentItem = item;
    [self.player replaceCurrentItemWithPlayerItem:item];
    self.playState = AVPlayerPlayStateInitial;
    
    
    if (!_mediaModel.resetServerPlay) {
        [self.mediaView resetControlView];
    }
    
    
    self.mediaView.titleLabel.text = mediaModel.title;
    
    self.mediaView.allowToolBarResponsed = NO;
    
}

-(void)play{
    
    if (self.playState == AVPlayerPlayStateInitial)return;
    [self.player play];
    self.played = YES;

    self.playState = AVPlayerPlayStatePlaying;
    [self startRecord];
    self.pauseByUser = NO;
    self.pauseONMobileNetwork = NO;
    
    if (_nowRate) {
        self.nowRate = self.nowRate;
    }
    
}

-(void)pause{
    if (self.playState == AVPlayerPlayStateInitial)return;
    [self.player pause];
    self.played = NO;
    self.playState = AVPlayerPlayStatePause;
    [self stopRecord];

}
-(void)stop{
    
    [self pause];
    [self.currentItem removeObserver:self forKeyPath:@"status" context:nil];
    //进度条
    [self.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.currentItem = nil;
    self.mediaModel = nil;
    self.lessonModel = nil;
    self.VideoID = @"";
    [self.mediaView resetControlView];
    [self.mediaView loadAnimated:NO color:nil];
    self.mediaView.autoScreenRotation = NO;
    
    
}


//切换播放暂停
-(void)switchPlayPause{
    if (self.isPlayed) {
        [self pause];
        self.pauseByUser = YES;
        
    }else{
        
        [self confirmPlay];
    }
}

-(void)confirmPlay{
    
    if (self.pauseONMobileNetwork && networkingType == ReachableViaWWAN) {
        UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"你确定观看该视频吗" message:@"当前网络环境观看视频可能会耗费手机流量" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alterView show];

    }else{
        
        [self play];
    }

}






#pragma mark观察者模式
//视频资源添加观察者
-(void)itemAddObseVer:(AVPlayerItem *)item{
    //添加之前要先移除之前的观察者
    //资源状态
    [self.currentItem removeObserver:self forKeyPath:@"status" context:nil];
        //进度条
    [self.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    
    [self.player replaceCurrentItemWithPlayerItem:nil];
    
    [item addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil];
    [item addObserver:self forKeyPath:@"loadedTimeRanges" options:(NSKeyValueObservingOptionNew) context:nil];
    
}

-(void)addNotifiCation{
    // 程序将要失去焦点
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PlayerWillResignNotification) name:UIApplicationWillResignActiveNotification object:nil];
    
    // 程序已经进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PlayedidActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //网络变为手机流量
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NetWorkingDidChangedAction) name:JUNetWorkingDidChangedNotification object:nil];

    
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"status"]) {
        
        [self observerForStatus:change];
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        
        [self observerForLoadedTimeRanges:change];
        
    }else if ([keyPath isEqualToString:@"rate"]){
        [self observerForRate:change];
        
    }else{
        
    }

}

//AVPlayerItemStatusUnknown,
//AVPlayerItemStatusReadyToPlay,
//AVPlayerItemStatusFailed
-(void)observerForStatus:(NSDictionary<NSKeyValueChangeKey,id> *)change{
    AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] intValue];
    switch (status) {
        case AVPlayerItemStatusUnknown:{
            JULog(@"未知");
            
            break;
        }
        case AVPlayerItemStatusReadyToPlay:{
            
            if (self.playState != AVPlayerPlayStateInitial) return;
            
            [self resetMediaPlayer];
            
//            JULog(@"%f", self.mediaModel.totalTime);

            
            break;
        }
            
        case AVPlayerItemStatusFailed:{
            JULog(@"播放失败");
            [self.mediaView loadAnimated:NO color:[UIColor whiteColor]];
            self.mediaView.warningLabel.hidden = NO;
            break;
        }
        default:
            JULog(@"发生错误");
            break;
    }
    
    
}
-(void)observerForLoadedTimeRanges:(NSDictionary<NSKeyValueChangeKey,id> *)change{
    
    //本项目不需要进度
   
  
    
//    if (self.currentItem.status != AVPlayerItemStatusReadyToPlay)return;
//
//    NSArray<NSValue *> * loadeTimeRanges = self.currentItem.loadedTimeRanges;
//    CMTimeRange timeRange = [loadeTimeRanges.firstObject CMTimeRangeValue];
//    //缓冲区域的开始
//    float bufferStart = CMTimeGetSeconds(timeRange.start);
//    float bufferLength = CMTimeGetSeconds(timeRange.duration);
//    NSTimeInterval result = bufferStart + bufferLength;
//    [self.mediaView.bufferProgressView setProgress:result/self.mediaModel.totalTime];
    
}

-(void)observerForRate:(NSDictionary<NSKeyValueChangeKey,id> *)change{
    
    
//    if (self.currentItem.status != AVPlayerItemStatusReadyToPlay)return;
//   float rate = [change[NSKeyValueChangeNewKey] floatValue];


    
}

#pragma mark 跳转播放
- (void)seekToTime:(NSTimeInterval)nowTime completionHandler:(void (^)(BOOL finished))completionHandler{
    
    if (self.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        [self pause];
        self.played = YES;
        [self.mediaView reFreshTimeLabelWithCurrentTiem:nowTime totalTime:self.mediaModel.totalTime];
        CMTime nowCMTime = [self CMTimeWithSeconds:nowTime];

        //下一步是跳转准备播放
        self.playState = AVPlayerPlayStatePreparing;
        [self.mediaView loadAnimated:YES color:nil];
        __weak typeof(self) weakSelf = self;

       // JULog(@"跳转时间:  %f  %f", nowTime, kkkkk);
        [self.player seekToTime:nowCMTime completionHandler:^(BOOL finished) {
            [weakSelf play];

            [weakSelf.mediaView loadAnimated:NO color:nil];
            [weakSelf delayUpdateRecoder];
            if (completionHandler) completionHandler(finished);
         }];
      }
}
#pragma mark 时间转化
//CMtime转换为当前秒数
-(NSTimeInterval)secondMakeWithCMTime:(CMTime)CMtime{
    return CMtime.value/CMtime.timescale;
}

-(CMTime)CMTimeWithSeconds:(float)seconds{
    return CMTimeMakeWithSeconds(seconds, 1);
    
  //  int timeScale = self.currentItem.duration.timescale;
  //  int value = (int)seconds;
  //  return CMTimeMake(timeScale * value, timeScale);
}

#pragma mark 代理方法
//双击
-(void)ju_MediaView:(UIView *)mediaView doubleTapAction:(UITapGestureRecognizer *)sender{
    if (self.currentItem.status != AVPlayerItemStatusReadyToPlay)return;

    [self switchPlayPause];
    
}
//拖动
-(void)ju_MediaView:(UIView *)mediaView panAction:(UIPanGestureRecognizer *)sender{
    if (self.currentItem.status != AVPlayerItemStatusReadyToPlay)return;

    
    CGPoint velocityPoint = [sender velocityInView:sender.view];
         switch (sender.state) {
        case UIGestureRecognizerStateBegan:{
            CGFloat x = fabs(velocityPoint.x);
            CGFloat y = fabs(velocityPoint.y);
            sumTime = self.mediaModel.currentTime;
            if (x > y) {
                //水平移动
                panDirection = PanDirectionHorizontalMoved;
                self.mediaView.showHorizontalPanTimeLabel = YES;
                [self ju_MediaView:self.mediaView progressSliderTouchBegan:nil];
            }else{
                //竖直移动
                panDirection = PanDirectionVerticalMoved;
            }
            
        break;
        }
        case UIGestureRecognizerStateChanged:{
            switch (panDirection) {
                case PanDirectionHorizontalMoved:{
                    [self horizontalMoved:velocityPoint.x]; // 水平移动的方法只要x方向的值
                    break;
                }
                case PanDirectionVerticalMoved:{
                    [self verticalMoved:velocityPoint.y];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            
        {
            switch (panDirection) {
                case PanDirectionHorizontalMoved:{
                    self.mediaView.showHorizontalPanTimeLabel = NO;
                    [self seekToTime:sumTime completionHandler:^(BOOL finished) {
                    }];
                    break;
                }
                case PanDirectionVerticalMoved:{
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

//点击了播放按钮
-(void)ju_MediaView:(UIView *)mediaView playButtonAction:(UIButton *)sender{
    
    if (self.currentItem.status != AVPlayerItemStatusReadyToPlay)return;
    [self switchPlayPause];
}

//开始滑动
-(void)ju_MediaView:(UIView *)mediaView progressSliderTouchBegan:(UISlider *)sender{
    [self.player pause];
    self.playState = AVPlayerPlayStatePause;
    self.mediaView.gestureManipulate = YES;
    
    
}

//滑动中
-(void)ju_MediaView:(UIView *)mediaView progressSliderValueChanged:(UISlider *)sender{
    
    self.playState = AVPlayerPlayStatePreparing;
    [self.mediaView reFreshTimeLabelWithCurrentTiem:sender.value totalTime:self.mediaModel.totalTime];
}

//滑动结束
-(void)ju_MediaView:(UIView *)mediaView progressSliderTouchEnded:(UISlider *)sender{
    self.mediaView.gestureManipulate = NO;
//    __weak typeof(self) weakSelf = self;
  [self seekToTime:sender.value completionHandler:^(BOOL finished) {
      if (finished) {
      
      }
  }];
}

// slider的点击
-(void)ju_MediaView:(UIView *)mediaView tapSliderAction:(UITapGestureRecognizer *)sender percentage:(CGFloat)percentage{
    
    if (self.currentItem.status != AVPlayerItemStatusReadyToPlay)return;
    NSTimeInterval nowTime = self.mediaModel.totalTime * percentage;
    
//    __weak typeof(self) weakSelf = self;
    [self seekToTime:nowTime completionHandler:^(BOOL finished) {

    }];
}

-(void)ju_MediaView:(UIView *)mediaView multipleButtonAction:(UIButton *)sender{
    if (self.currentItem.status != AVPlayerItemStatusReadyToPlay)return;

    NSString *buttonString = self.mediaView.multipleLabel.text;
  __block  NSUInteger index = 0;
    [self.multipleArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([buttonString containsString:obj]) {
            index = idx;
            *stop = YES;
        }
    }];
    index = index+1;
    
    if (index >= self.multipleArray.count)index = 0;
    self.nowRate = [self.multipleArray[index] floatValue];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.multipleArray[index] forKey:mediaPlayerMultipleNumberKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    buttonString = [NSString stringWithFormat:@"X%@倍",self.multipleArray[index]];
    self.mediaView.multipleLabel.text = buttonString;
    
    NSString *showString = [NSString stringWithFormat:@"已经转变为%@倍速度播放",self.multipleArray[index]];
    [self showWithView:self.mediaView text:showString duration:1.5];
    
    //友盟统计延迟2秒钟
    [self umengStatistiTimesDelay];
    
}

-(void)umengStatistiTimesDelay{
    
    [JUMediaView cancelPreviousPerformRequestsWithTarget:self selector:@selector(umengStatistiTimes) object:nil];
    
    [self performSelector:@selector(umengStatistiTimes) withObject:nil afterDelay:2];

}

-(void)umengStatistiTimes{
    NSString *str = [NSString stringWithFormat:@"%.2f",_nowRate];
    [JUUmengStaticTool event:JUUmengStaticPlayer key:JUUmengStaticPlayer value:str];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex) {
        [self play];
    }
}





//水平移动
-(void)horizontalMoved:(CGFloat)value{
    
    sumTime += value/100;
    if (sumTime <= 0 || sumTime >= self.mediaModel.totalTime)return;
    self.playState = AVPlayerPlayStatePreparing;
    [self.mediaView reFreshTimeLabelWithCurrentTiem:sumTime totalTime:self.mediaModel.totalTime];
 
}

//竖直移动
-(void)verticalMoved:(CGFloat)value{
    
    MPMusicPlayerController *mp = [MPMusicPlayerController applicationMusicPlayer];
    mp.volume = mp.volume - value / 10000;
}

#pragma mark 通知方法
-(void)PlayerWillResignNotification{
    if (self.window) {
        if (self.pauseByUser)return;
        if (self.playState == AVPlayerPlayStatePreparing || self.playState == AVPlayerPlayStatePlaying) {
            [self pause];
        }
    }
    
    
    
}

-(void)PlayedidActiveNotification{
    if (self.window) {
        
        if (self.mediaModel && self.mediaModel.downloaded&&self.playState == AVPlayerPlayStatePause) {
            if (self.restartPlay) {
                
                self.restartPlay(_lessonModel);
                
                return;
            }
        }

        if (self.pauseByUser)return;
        if (self.playState == AVPlayerPlayStatePause) {
            [self play];
        }
 
    }
    
    
}

-(void)NetWorkingDidChangedAction{
    if (!self.window)return;
    if (self.currentItem.status != AVPlayerItemStatusReadyToPlay)return;
    if ((!self.mediaModel.isDownloaded) && (networkingType == ReachableViaWWAN)) {
        if (self.playState != AVPlayerPlayStateInitial) {
            [self pause];
            self.pauseONMobileNetwork = YES;
        }
    }
}

#pragma mark 系统方法
- (void)dealloc
{
    [self pause];
    [self.player removeObserver:self forKeyPath:@"rate" context:nil];
    [self.currentItem removeObserver:self forKeyPath:@"status" context:nil];
    [self.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    if (self.timeObserve) {
        [self.player removeTimeObserver:self.timeObserve];
        self.timeObserve = nil;
    }
 
}


//************************************************************************************//
//************************************************************************************//
//************************************************************************************//
//************************************************************************************//
//************************************************************************************//
//************************************************************************************//
//************************************************************************************//
//************************************************************************************//
//************************************************************************************//
//************************************************************************************//
//************************************************************************************//
//************************************************************************************//
//************************************************************************************//
//************************************************************************************//
//************************************************************************************//
//************************************************************************************//
#pragma mark 本项目需要,记录播放的百分比

-(NSTimer *)recoderTimer{
    if (!_recoderTimer) {
        _recoderTimer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(updateRecoder) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_recoderTimer forMode:NSRunLoopCommonModes];
    }
    return _recoderTimer;
}

-(void)startRecord{
    [self recoderTimer];
}

-(void)stopRecord{
    if (self.recoderTimer) {
        [self.recoderTimer invalidate];
        self.recoderTimer = nil;
    }
}

-(void)updateRecoder{
//    return;
    if (!JuuserInfo.isLogin)return;
    if (self.currentItem.status != AVPlayerItemStatusReadyToPlay)return;
    if (self.playState != AVPlayerPlayStatePlaying)return;
    if (![self.VideoID isEqualToString:self.lessonModel.ID]) return;
    JULessonModel *lessonModel = [lessonRecordDatabase getLessonModel:self.lessonModel];
    lessonModel.timeRecord = (int)self.mediaModel.currentTime;
    NSDate *date = [NSDate date];
    lessonModel.timestamp = (NSUInteger)(date.timeIntervalSince1970);
    
    if (lessonModel.timeRecord == 0)return;
    
    [lessonRecordDatabase updateLessonModel:lessonModel];
    
    [self updateToServer:lessonModel];
    //更新到服务器
 }
-(void)delayUpdateRecoder{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       [self updateRecoder];
                   });
}

-(void)updateToServer:(JULessonModel *)lessonModel{
    
    if (networkingType == NotReachable) return;
    
    JUAsyncSocketManager *manager = [JUAsyncSocketManager shareManager];
    
    if (manager.isConnected) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"uid"] = JuuserInfo.uid;
        dict[@"token"] = JuuserInfo.token;
        dict[@"course_id"] = lessonModel.course_id;
        dict[@"video_id"] = lessonModel.ID;
        dict[@"video_time"] = [NSString stringWithFormat:@"%zd",lessonModel.timeRecord];
        dict[@"plat"] = @"1";
        
//        JULog(@"%zd",发送数据成功 lessonModel.timestamp);

        NSMutableDictionary *recordDict = [NSMutableDictionary dictionary];
        recordDict[@"event"] = @"addRecord";
        recordDict[@"data"] = dict;
        
        
        [manager ju_sendData:recordDict withTimeout:-1 tag:100 sendSuccess:^(long tag) {
            
//        JULog(@"发送数据成功: %@:  %zd",lessonModel.ID, lessonModel.timestamp);
            
        } receiveData:^(id data, long tag) {

//            JULog(@"收到服务器返回的数据： %@",data);
        }];
        
        
    }else{
        
        JULog(@"****************************************************************************************************************************************************************************服务器是断开连接***********************************************************************************************************************************************************************************************************************");
        [manager ju_reconnnect];
    }
  
    
}


@end
