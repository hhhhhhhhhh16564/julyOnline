//
//  JUMusicTool.h
//  algorithm
//
//  Created by 周磊 on 16/12/14.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JUListenLessonModel.h"
#import <AVFoundation/AVFoundation.h>
@interface JUMusicTool : NSObject

+(instancetype)shareInstance;

//-(void)playWithURL:(NSString *)url;
-(void)play;
-(void)pause;

@property(nonatomic, strong) AVPlayer *audioPlayer;
@property(nonatomic, strong) JUListenLessonModel *playingLessonModel;



@end
