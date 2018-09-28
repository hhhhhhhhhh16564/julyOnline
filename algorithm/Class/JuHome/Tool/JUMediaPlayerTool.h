//
//  JUMediaPlayerTool.h
//  algorithm
//
//  Created by 周磊 on 17/3/1.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JULessonModel.h"
#import "JUMediaPlayer.h"


@interface JUMediaPlayerTool : NSObject
@property(nonatomic, strong) JUMediaPlayer *mediaPlayer;
//@property(nonatomic, strong) NSString *play_urlString;

+(instancetype)shareInstance;

-(void)playVideoWithLessonModel:(JULessonModel *)lessonModel;

-(void)play;
-(void)pause;
-(void)stop;
@end
