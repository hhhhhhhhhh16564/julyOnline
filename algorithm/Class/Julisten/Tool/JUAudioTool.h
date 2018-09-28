//
//  JUAudioTool.h
//  algorithm
//
//  Created by 周磊 on 16/12/14.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JUListenLessonModel.h"


@interface JUAudioTool : NSObject

+(instancetype)shareInstance;


//所有的音乐
@property(nonatomic, strong) NSMutableArray<JUListenLessonModel *> *lessonArray;


//正在播放的音乐
-(JUListenLessonModel *)playingMusic;

//上一首音乐
-(JUListenLessonModel *)previousMusic;

//下一首音乐
-(JUListenLessonModel *)nextMusic;



@end
