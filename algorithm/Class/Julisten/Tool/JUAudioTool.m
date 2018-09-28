//
//  JUAudioTool.m
//  algorithm
//
//  Created by 周磊 on 16/12/14.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUAudioTool.h"
#import "JUMusicTool.h"


@interface JUAudioTool ()
{

    //后台进程ID
    UIBackgroundTaskIdentifier  _backgroudTaskId;
    
}


@property(nonatomic, strong)JUMusicTool  *musicTool;
@end

@implementation JUAudioTool
static   JUAudioTool *audioTool = nil;

+(instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
        
        audioTool = [[JUAudioTool alloc]init];
        
        audioTool.musicTool = [JUMusicTool shareInstance];
        
         //程序进入后台
         
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:self];
         
         
         
         //程序进入前台
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:self];
         
         
         // 1.设置激活会话类型
         AVAudioSession *session = [AVAudioSession sharedInstance];
         
         [session setCategory:AVAudioSessionCategoryPlayback error:nil];
         
         //2 激活
         [session setActive:YES error:nil];
         
         
         
        
    });
    
    return audioTool;
    
}

-(void)setLessonArray:(NSMutableArray<JUListenLessonModel *> *)lessonArray{
    
    _lessonArray = lessonArray;
    
}


//正在播放的音乐
-(JUListenLessonModel *)playingMusic{
    
    return self.musicTool.playingLessonModel;
    
}

//上一首音乐
-(JUListenLessonModel *)previousMusic{
    
    NSInteger currentIndex = [self.lessonArray indexOfObject:self.playingMusic];
    if (!self.playingMusic) {
        
        currentIndex = 0;
    }
    
    
    NSInteger previousIndex = --currentIndex;
    
    if (previousIndex < 0) {
        previousIndex = self.lessonArray.count-1;
    }
    
    JUListenLessonModel *lessonModel = self.lessonArray[previousIndex];
    
    self.musicTool.playingLessonModel = lessonModel;
    
    return lessonModel;
    

}

//下一首音乐
-(JUListenLessonModel *)nextMusic{
    
    NSInteger currentIndex = [self.lessonArray indexOfObject:self.playingMusic];
    
    if (!self.playingMusic) {
        
        currentIndex = 0;
    }
    
    
    NSInteger nextIndex = ++currentIndex;
    
    if (nextIndex >= self.lessonArray.count) {
        nextIndex = 0;
    }
    
    
    JUListenLessonModel *lessonModel = self.lessonArray[nextIndex];
    self.musicTool.playingLessonModel = lessonModel;
    
    return lessonModel;
    
    
}









#pragma mark

//程序进入后台
-(void)applicationDidEnterBackground{
    __weak typeof(self) weakSelf = self;
    
    _backgroudTaskId = [[UIApplication sharedApplication]beginBackgroundTaskWithExpirationHandler:^{
        
        [weakSelf endBackgroundTask];
        
    }];
    
}


//程序将要进入前台
-(void)applicationDidBecomeActive{
    
    [self endBackgroundTask];
    
}



-(void)endBackgroundTask{
    
    if (_backgroudTaskId != UIBackgroundTaskInvalid) {
        
        [[UIApplication sharedApplication]endBackgroundTask:_backgroudTaskId];
        
        _backgroudTaskId = UIBackgroundTaskInvalid;
        
    }
    
    
    
}





@end
