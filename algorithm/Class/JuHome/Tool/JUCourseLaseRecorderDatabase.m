//
//  JUCourseLaseRecorderDatabase.m
//  algorithm
//
//  Created by pro on 16/11/27.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUCourseLaseRecorderDatabase.h"

#import "FMDB.h"

#import "JULessonModel.h"

@interface JUCourseLaseRecorderDatabase ()

@property(nonatomic, strong) NSString *dataBasePath;
@property(nonatomic, strong) FMDatabase *recorDatabase;

@end



@implementation JUCourseLaseRecorderDatabase

+(instancetype)shareInstance{
    
    
    
    static dispatch_once_t onceToken;
    static JUCourseLaseRecorderDatabase * recorDatabase = nil;
    dispatch_once(&onceToken, ^{
        
        recorDatabase = [[JUCourseLaseRecorderDatabase alloc]init];
        
        [recorDatabase createLessonRecordDatabase];
        
    });
    
    return recorDatabase;
    
}



//数据库地址
-(NSString *)dataBasePath{
    if (_dataBasePath == nil) {
        NSString *pathes = NSSearchPathForDirectoriesInDomains(algorithmDowonloadMediaCachPath, NSUserDomainMask, YES)[0];
        _dataBasePath = [pathes stringByAppendingPathComponent:@"CourseLaseRecorder_sqlite.db"];
    }
    return _dataBasePath;
}

//创建表
-(void)createLessonRecordDatabase{
    
    self.recorDatabase = [FMDatabase databaseWithPath:self.dataBasePath];
    
    if ([self.recorDatabase open]) {
        
        JULog(@"数据库打开成功");
        
        // 表二  记录某个课程下播放的最近
//                NSString *sqstring2 = @"create table if not exists lastLessonRecoder(l_id integer primary key autoincrement not NULL,l_courseID unique, l_playUrl text , l_lessonModel blob)";
        
        
              NSString *sqstring2 = @"create table if not exists lastLessonRecoder(l_id integer primary key autoincrement not NULL,l_courseID, l_playUrl text ,l_lessonID text,  l_userCourseID text unique ,l_lessonModel blob, uid text)";
                BOOL result2 = [self.recorDatabase executeUpdate:sqstring2];
                if (result2) {
//                    JULog(@"创建表2成功");
    
                }else{
                    JULog(@"创建表2失败");
                }
    }
    
}









//*****************//

//向数据库中增加语句

-(void)lastLessonRecoderAddLessonModel:(JULessonModel *)lessonModel{
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:lessonModel];
    
    NSString * userCourseID = [JuuserInfo.uid stringByAppendingString:lessonModel.course_id];
    
        //    l_courseID unique, l_playUrl text , l_lessonModel blob)";
    BOOL result = [self.recorDatabase executeUpdateWithFormat:@"insert into lastLessonRecoder (l_courseID, l_playUrl, l_lessonID, l_userCourseID,  l_lessonModel, uid) values (%@, %@, %@, %@, %@, %@)", lessonModel.course_id, lessonModel.play_url, lessonModel.ID, userCourseID, data, JuuserInfo.uid];
    
    if (result) {
        JULog(@"插入数据成功");
    }else{
             JULog(@"插入数据失败");
    }
}

//修改

-(void)lastLessonRecoderUPdateLessonModel:(JULessonModel *)lessonModel{
    
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:lessonModel];
    
    BOOL result = [self.recorDatabase executeUpdateWithFormat:@"update lastLessonRecoder set l_playUrl = %@, l_lessonModel = %@ where l_courseID = %@ and uid = %@", lessonModel.play_url, data, lessonModel.course_id, JuuserInfo.uid];
    
    if (result) {
        
        JULog(@"更改成功");
        
    }else{
        JULog(@"更改失败");
    }
    
}

//查找

-(JULessonModel *)lastLessonRecoderGetLessonModel:(JULessonModel *)lessonModel{
    
    
    JULessonModel *returnlessonModel = nil;
    
    FMResultSet *result = [self.recorDatabase executeQueryWithFormat:@"select l_lessonModel from lastLessonRecoder where l_courseID = %@ and uid = %@", lessonModel.course_id, JuuserInfo.uid];
    
    
    while ([result next]) {
        
        NSData *data = [result dataForColumn:@"l_lessonModel"];
        returnlessonModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
    }
    return returnlessonModel;
}
















@end
