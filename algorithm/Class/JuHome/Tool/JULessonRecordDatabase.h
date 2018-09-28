//
//  JULessonRecordDatabase.h
//  algorithm
//
//  Created by 周磊 on 16/7/19.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import <Foundation/Foundation.h>
#define lessonRecordDatabase [JULessonRecordDatabase shareInstance]

@class JULessonModel;

//课程记录的数据库
@interface JULessonRecordDatabase : NSObject


-(NSString *)dataBasePath;

+(instancetype)shareInstance;

//创建课程的记录的表
-(void)createLessonRecordDatabase;

//增
-(void)addLessonModel:(JULessonModel *)lessonModel;
//删  暂时不需要

//-(void)deleteLessonModel:(JULessonModel *)lessonModel;

//改
-(void)updateLessonModel:(JULessonModel *)lessonModel;

//查
-(JULessonModel *)getLessonModel:(JULessonModel *)lessonModel;













@end
