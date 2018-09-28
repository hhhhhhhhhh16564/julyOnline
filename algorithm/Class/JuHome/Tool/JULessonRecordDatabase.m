//
//  JULessonRecordDatabase.m
//  algorithm
// 
//  Created by 周磊 on 16/7/19.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JULessonRecordDatabase.h"
#import "FMDB.h"
#import "JULessonModel.h"
#import "NSDate+Extension.h"

@interface JULessonRecordDatabase ()

@property(nonatomic, strong) NSString *dataBasePath;
@property(nonatomic, strong) FMDatabase *recorDatabase;


@end


@implementation JULessonRecordDatabase

+(instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    static JULessonRecordDatabase * recorDatabase = nil;
    dispatch_once(&onceToken, ^{
        
        recorDatabase = [[JULessonRecordDatabase alloc]init];
        
        [recorDatabase createLessonRecordDatabase];
        
    });
    
    return recorDatabase;

}

//数据库地址
-(NSString *)dataBasePath{
    
    if (_dataBasePath == nil) {
        
        NSString *pathes = NSSearchPathForDirectoriesInDomains(algorithmDowonloadMediaCachPath, NSUserDomainMask, YES)[0];
        _dataBasePath = [pathes stringByAppendingPathComponent:@"lessonRecord_sqlite.db"];
        
    }
    
    return _dataBasePath;
    
}

//创建表
-(void)createLessonRecordDatabase{
    
    self.recorDatabase = [FMDatabase databaseWithPath:self.dataBasePath];
    
    if ([self.recorDatabase open]) {
        
        JULog(@"数据库打开成功");
       
        NSString *sqString = @"create table if not exists lesson (l_id integer primary key autoincrement not NULL, l_courseID text, l_lessonID text, l_playUrl text , l_timeRecord integer,l_timestamp integer, l_isPlayed integer, l_userlessonID text unique, l_lessonModel blob, uid text)";
        
     BOOL result = [self.recorDatabase executeUpdate:sqString];
        
        if (result) {
            
//            JULog(@"创建表成功");
            
        }else{
            JULog(@"创建表失败");
            
        }

    }
    
}

//增

-(void)addLessonModel:(JULessonModel *)lessonModel{
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:lessonModel];
    
    NSString *userlessonID = [JuuserInfo.uid stringByAppendingString:lessonModel.ID];
    
    BOOL result = [self.recorDatabase executeUpdateWithFormat:@"insert into lesson (l_courseID, l_lessonID, l_playUrl, l_timeRecord, l_timestamp, l_isPlayed, l_userlessonID, l_lessonModel, uid) values (%@, %@, %@, %d, %d, %d, %@, %@, %@)", lessonModel.course_id, lessonModel.ID, lessonModel.play_url, (int)lessonModel.timeRecord, (int)lessonModel.timestamp,lessonModel.isPlayed,userlessonID,data, JuuserInfo.uid];
    
    if (result) {
        JULog(@"插入数据成功");
    }else{
        
     JULog(@"插入数据失败");
        
    }
    
    
}
//删

//-(void)deleteLessonModel:(JULessonModel *)lessonModel{

//}

//改
-(void)updateLessonModel:(JULessonModel *)lessonModel{
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:lessonModel];

    
//    BOOL result = [self.recorDatabase executeUpdateWithFormat:@"update lesson set l_courseID = %@, l_lessonID = %@, l_timeRecord = %ld, l_isPlayed = %d ,l_lessonModel = %@ where l_playUrl = %@ and uid = %@ ", lessonModel.course_id, lessonModel.ID, (long)lessonModel.timeRecord, lessonModel.isPlayed, data, lessonModel.play_url, JuuserInfo.uid ];
    
    
    BOOL result = [self.recorDatabase executeUpdateWithFormat:@"update lesson set l_playUrl = %@, l_timeRecord = %d, l_isPlayed = %d, l_timestamp = %d, l_lessonModel = %@ where l_lessonID = %@ and uid = %@ ", lessonModel.play_url, (int)lessonModel.timeRecord, lessonModel.isPlayed,(int)lessonModel.timestamp ,data, lessonModel.ID, JuuserInfo.uid ];
    
    if (result) {
//        JULog(@"更改成功");
    }else{
        JULog(@"更改失败");
    }
}

//传一个lessonModel ,在数据库里，根据它的播放url，查找一个新的lessonModel ，找到它的播放时间，从指定的时间开始播放
-(JULessonModel *)getLessonModel:(JULessonModel *)lessonModel{
    
//   JULog(@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n  %@ ", lessonModel.play_url);
    
    
    JULessonModel *returnlessonModel = nil;
    
//    FMResultSet *result = [self.recorDatabase executeQueryWithFormat:@"select l_lessonModel from lesson where l_playUrl = %@ or l_lessonID = %@", lessonModel.play_url,lessonModel.ID];
    
    
        FMResultSet *result = [self.recorDatabase executeQueryWithFormat:@"select l_lessonModel from lesson where l_lessonID = %@ and uid = %@", lessonModel.ID, JuuserInfo.uid];
    
    while ([result next]) {
        
        NSData *data = [result dataForColumn:@"l_lessonModel"];
        returnlessonModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
    }
    return returnlessonModel;
}






@end
