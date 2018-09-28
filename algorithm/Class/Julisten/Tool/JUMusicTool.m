//
//  JUMusicTool.m
//  algorithm
//
//  Created by 周磊 on 16/12/14.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUMusicTool.h"



//@interface JUMusicTool ()
//
//
//
//
//@end


@implementation JUMusicTool


+(instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    static JUMusicTool *MusicTool = nil;

    dispatch_once(&onceToken, ^{
        
        MusicTool = [[JUMusicTool alloc]init];
    });
    
    return MusicTool;
    
}



-(void)playWithURL:(NSString *)url{
    
    
    self.audioPlayer = nil;
    
    if (!url) return;
    
    self.audioPlayer = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:url]];

    [self.audioPlayer play];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"MusicLessonDidPlay" object:nil];

    
}

//播放音乐
-(void)setPlayingLessonModel:(JUListenLessonModel *)playingLessonModel{
    
    _playingLessonModel = playingLessonModel;
    
    if (playingLessonModel) {
        
        [self playWithURL:playingLessonModel.play_url];

    }
    
    
}



-(void)play{
    
    if (self.audioPlayer) {
        [self.audioPlayer play];
    }
}


-(void)pause{
    
    
    if (self.audioPlayer) {
        
        [self.audioPlayer pause];
        
    }
    
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
