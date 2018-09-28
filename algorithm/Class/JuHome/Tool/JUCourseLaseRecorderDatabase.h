//
//  JUCourseLaseRecorderDatabase.h
//  algorithm
//
//  Created by pro on 16/11/27.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import <Foundation/Foundation.h>

#define courseLaseRecorder111  [JUCourseLaseRecorderDatabase shareInstance]

@interface JUCourseLaseRecorderDatabase : NSObject

-(NSString *)dataBasePath;
+(instancetype)shareInstance;

-(void)createLessonRecordDatabase;

//记录某个course下的播放视频

//向数据库中增加语句

-(void)lastLessonRecoderAddLessonModel:(JULessonModel *)lessonModel;



//修改

-(void)lastLessonRecoderUPdateLessonModel:(JULessonModel *)lessonModel;


//查找

-(JULessonModel *)lastLessonRecoderGetLessonModel:(JULessonModel *)lessonModel;



@end
