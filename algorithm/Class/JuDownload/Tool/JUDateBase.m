//
//  JUDateBase.m
//  archiviewroot
//
//  Created by 周磊 on 16/6/6.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUDateBase.h"
#import "FMDatabase.h"
#import "JUDownloadInfo.h"
#import <libkern/OSAtomic.h>
#import <pthread.h>

@interface JUDateBase ()
{
    
    pthread_mutex_t _lock;

}

#pragma mark ********
//都用atomic加锁，效率会降低，以后会修改

@property(nonatomic, strong) NSString *dataseBasePath;

//多线程会冲突//所以用automic
@property(atomic, strong) JUDownloadInfo *downloadInfo;

//已经下载的
@property(nonatomic, strong) NSMutableArray *downloadedArray;

//没下载完成的
@property(nonatomic, strong) NSMutableArray *downloadingArray;



@end

@implementation JUDateBase;
+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static JUDateBase *datebase = nil;
    dispatch_once(&onceToken, ^{
        
        datebase = [[JUDateBase alloc]init];
        [[NSNotificationCenter defaultCenter] addObserver:datebase selector:@selector(selectDownloadFindDate:) name:@"selectDownloadFindDate" object:nil];
        
        //查到已经下载的视频  进度等于1
        [[NSNotificationCenter defaultCenter] addObserver:datebase selector:@selector(downloadedModelFindDate:) name:@"downloadedModelFindDate" object:nil];
 
        //查到正在下载的视频   进度小于1
        [[NSNotificationCenter defaultCenter] addObserver:datebase selector:@selector(downloadingModelFindDate:) name:@"downloadingModelFindDate" object:nil];
        
    });
    
    return datebase;
    
}
//数据库的存放路径
-(NSString *)dataseBasePath
{
    if (_dataseBasePath == nil) {
        
     NSString *pathes = NSSearchPathForDirectoriesInDomains(algorithmDowonloadMediaCachPath, NSUserDomainMask, YES)[0];
     _dataseBasePath = [pathes stringByAppendingPathComponent:@"download_sqlite.db"];
        
    }
    
    return _dataseBasePath;
}


-(FMDatabaseQueue *)downloadBaseQueue
{
    
    if (_downloadBaseQueue == nil) {
        _downloadBaseQueue = [FMDatabaseQueue databaseQueueWithPath:self.dataseBasePath];
    }
    return _downloadBaseQueue;
    
}
//创建一个关于下载的表
-(void)createTableWithDownload{
    //清空是为了防止重新打开一个任务的冲突
    
    
    
    [self.downloadBaseQueue inDatabase:^(FMDatabase *db) {
        
    
        BOOL success = [db executeUpdateWithFormat:@"create table if not exists download (d_id integer primary key autoincrement not null,d_downloadURL text unique ,d_progress real, d_totalLength integer, d_urlString text, d_destinationPath text, d_partID integer,d_allPartID integer,d_downloadstatus integer,d_lessonmodel blob, d_userid text)"];
        if (success) {
           
//            JULog(@"创建表成功啊回复哈市的画风还是得");

        }else{
            JULog(@"创建表失败");
        }
        
    }];
    
    
}


//刚开始时，把所有的字段都贮存一下，之后，主要是修改下载修改进度
-(void)addDownloadData:(JUDownloadInfo *)downloadInfo{
    
    
    [self.downloadBaseQueue inDatabase:^(FMDatabase *db) {
        
        JULessonModel *lessonmodel = downloadInfo.lessonModel;
        
         NSData *data = [NSKeyedArchiver archivedDataWithRootObject:lessonmodel];
        
        
        BOOL result = [db executeUpdateWithFormat:@"insert into download (d_downloadURL, d_progress,d_totalLength,d_urlString , d_destinationPath,d_partID, d_allPartID,d_downloadstatus,d_lessonmodel, d_userid) values (%@, %f, %ld, %@, %@, %ld, %ld, %d, %@, %@)", downloadInfo.downloadURL, downloadInfo.progress, (long)downloadInfo.totalLength, downloadInfo.urlString, downloadInfo.destinationPath, (long)downloadInfo.partID, (long)downloadInfo.allPartID, downloadInfo.downloadstatus, data, downloadInfo.user_id];
        
        if (result) {
            NSLog(@"插入成功");
        }else{
            
            NSLog(@"插入失败");
        }

    }];
    
}

//更改进度
-(void)updateDownloadTable:(JUDownloadInfo *)downloadInfo{
    
   [self.downloadBaseQueue inDatabase:^(FMDatabase *db) {
       
       
       BOOL result = [db executeUpdateWithFormat:@"update download set d_progress = %f where d_downloadURL = %@", downloadInfo.progress, downloadInfo.downloadURL];
       
       if (result) {
//           NSLog(@"更新成功");
       }else{
           
           NSLog(@"更新失败");
       }

   }];
}
//更改文件的总大小
-(void)updateSizeofile:(JUDownloadInfo *)downloadInfo{
    
    [self.downloadBaseQueue inDatabase:^(FMDatabase *db) {
        
        
        BOOL result = [db executeUpdateWithFormat:@"update download set d_totalLength = %lu  where d_downloadURL = %@", (long)downloadInfo.totalLength, downloadInfo.downloadURL];
        
        if (result) {
//            NSLog(@"更新成功");
        }else{
            
            NSLog(@"更新失败");
        }
        
    }];
}
//更改文件的总片段数目以及正在下载的片段数

-(void)updatepartIdAndAllPartID:(JUDownloadInfo *)downloadInfo{
    
    [self.downloadBaseQueue inDatabase:^(FMDatabase *db) {
        
        
        BOOL result = [db executeUpdateWithFormat:@"update download set d_partID = %lu,d_allPartID = %lu where d_downloadURL = %@", (long)downloadInfo.partID, (long)downloadInfo.allPartID, downloadInfo.downloadURL];
        
        if (result) {
//            NSLog(@"更新成功");
        }else{
            
            NSLog(@"更新失败");
        }
        
    }];
    
    
    
}
//更改视频的下载状态
-(void)updateDownloadStatus:(JUDownloadInfo *)downloadInfo{
    
    [self.downloadBaseQueue inDatabase:^(FMDatabase *db) {
        
        
        BOOL result = [db executeUpdateWithFormat:@"update download set d_downloadstatus = %d  where d_downloadURL = %@", downloadInfo.downloadstatus, downloadInfo.downloadURL];
        
        if (result) {
            //            NSLog(@"更新成功");
        }else{
            
            JULog(@"更新更新下载状态失败");
        }
        
    }];

}
-(void)changedDownloadStatusOnAppLaunch{
    
    [self createTableWithDownload];
    
    [self.downloadBaseQueue inDatabase:^(FMDatabase *db) {
        
        
        BOOL result = [db executeUpdateWithFormat:@"update download set d_downloadstatus = 3  where d_downloadstatus != 4"];
        
        if (result) {
            //            NSLog(@"更新成功");
        }else{
            
            JULog(@"更新更新下载状态失败");
        }
        
    }];

    
    
    
}





//删除数据
-(void)deleteDownloadTable:(NSString *)downloadURL{
    

    
    [self.downloadBaseQueue inDatabase:^(FMDatabase *db) {
        BOOL resulet = [db executeUpdateWithFormat:@"delete from download where d_downloadURL = %@",downloadURL];
        
//            JULog(@"%@", downloadURL);
        
        
        if (resulet) {
            
//            JULog(@"删除成功");
            
        }else{
            
//            JULog(@"删除失败");
        }
        
        
        
        
    }];
    
}


//根据uidurl查找一条数据
-(void)selectDownloadTable:(NSString *)downloadURL{
    self.downloadInfo = nil;
    
    
    __block JUDownloadInfo *downloadInfo = [[JUDownloadInfo alloc]init];
    
    
    [self.downloadBaseQueue inDatabase:^(FMDatabase *db) {
        
        
        FMResultSet *result = [db executeQueryWithFormat:@"select d_downloadURL,d_progress,d_totalLength,d_urlString,d_destinationPath,d_partID,d_allPartID,d_downloadstatus,d_lessonmodel, d_userid from download where d_downloadURL = %@",downloadURL];
        
        while ([result next]) {
            
            NSString *downloadURL = [result stringForColumn:@"d_downloadURL"];
            float progress = [result doubleForColumn:@"d_progress"];
            NSInteger totalLength = [result longForColumn:@"d_totalLength"];
            NSString *urlstring = [result stringForColumn:@"d_urlString"];
            
            NSString *destinationPath = [result stringForColumn:@"d_destinationPath"];
            NSInteger partID = [result longForColumn:@"d_partID"];
            NSInteger allpartID = [result longForColumn:@"d_allPartID"];
            NSInteger downloadstatus = [result longForColumn:@"d_downloadstatus"];
            NSData *data =[result dataForColumn:@"d_lessonmodel"];
            NSString *d_userID = [result stringForColumn:@"d_userid"];
            
            JULessonModel *lessonModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            downloadInfo.downloadURL = downloadURL;
            downloadInfo.progress = progress;
            downloadInfo.totalLength = totalLength;
            downloadInfo.urlString = urlstring;
            downloadInfo.destinationPath = destinationPath;
            downloadInfo.partID = partID;
            downloadInfo.allPartID = allpartID;
            downloadInfo.downloadstatus = downloadstatus;
            downloadInfo.lessonModel = lessonModel;
            downloadInfo.user_id = d_userID;
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"selectDownloadFindDate" object:downloadInfo];
            
        }
        
    }];
    
}





////查找下载状态等于完成
-(void)findDownloadedModel{

    __block NSMutableArray *downloadArray = [NSMutableArray array];
    
    /**
    
     JUDownloadStateNone = 0,     // 闲置状态（除后面几种状态以外的其他状态）
     JUDownloadStateWillResume,   // 即将下载（等待下载）
     JUDownloadStateResumed,      // 下载中
     JUDownloadStateSuspened,     // 暂停中
     JUDownloadStateCompleted     // 已经完全下载完毕
     
     */
    
    [self.downloadBaseQueue inDatabase:^(FMDatabase *db) {
        
        
        FMResultSet *result = [db executeQueryWithFormat:@"select d_downloadURL,d_progress,d_totalLength,d_urlString,d_destinationPath,d_partID,d_allPartID, d_downloadstatus, d_lessonmodel,d_userid from download where d_downloadstatus = 4 and d_userid = %@", JuuserInfo.uid];
        
        while ([result next]) {
          JUDownloadInfo *downloadInfo = [[JUDownloadInfo alloc]init];
            
            NSString *downloadURL = [result stringForColumn:@"d_downloadURL"];
            float progress = [result doubleForColumn:@"d_progress"];
            NSInteger totalLength = [result longForColumn:@"d_totalLength"];
            NSString *urlstring = [result stringForColumn:@"d_urlString"];
            
            NSString *destinationPath = [result stringForColumn:@"d_destinationPath"];
            NSInteger partID = [result longForColumn:@"d_partID"];
            NSInteger allpartID = [result longForColumn:@"d_allPartID"];
            NSInteger downloadstatus = [result longForColumn:@"d_downloadstatus"];
            NSData *data =[result dataForColumn:@"d_lessonmodel"];
            NSString *d_userID = [result stringForColumn:@"d_userid"];
            
            JULessonModel *lessonModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            downloadInfo.downloadURL = downloadURL;
            downloadInfo.progress = progress;
            downloadInfo.totalLength = totalLength;
            downloadInfo.urlString = urlstring;
            downloadInfo.destinationPath = destinationPath;
            downloadInfo.partID = partID;
            downloadInfo.allPartID = allpartID;
            downloadInfo.downloadstatus = downloadstatus;
            downloadInfo.lessonModel = lessonModel;
            downloadInfo.user_id = d_userID;
            

            [downloadArray addObject:downloadInfo];
            
            
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadedModelFindDate" object:downloadArray];
        
    }];
 
}

//查找下载状态  不等于完成
-(void)findDownloadingModel{
    __block NSMutableArray *downloadArray = [NSMutableArray array];
    /**
     
     JUDownloadStateNone = 0,     // 闲置状态（除后面几种状态以外的其他状态）
     JUDownloadStateWillResume,   // 即将下载（等待下载）
     JUDownloadStateResumed,      // 下载中
     JUDownloadStateSuspened,     // 暂停中
     JUDownloadStateCompleted     // 已经完全下载完毕
     
     */

    
    [self.downloadBaseQueue inDatabase:^(FMDatabase *db) {
        
        
        FMResultSet *result = [db executeQueryWithFormat:@"select d_downloadURL,d_progress,d_totalLength,d_urlString,d_destinationPath,d_partID,d_allPartID, d_downloadstatus,d_lessonmodel,d_userid from download where d_downloadstatus != 4 and d_userid = %@ order by d_id asc", JuuserInfo.uid];
        
        while ([result next]) {
            JUDownloadInfo *downloadInfo = [[JUDownloadInfo alloc]init];
            
            NSString *downloadURL = [result stringForColumn:@"d_downloadURL"];
            float progress = [result doubleForColumn:@"d_progress"];
            NSInteger totalLength = [result longForColumn:@"d_totalLength"];
            NSString *urlstring = [result stringForColumn:@"d_urlString"];
            
            NSString *destinationPath = [result stringForColumn:@"d_destinationPath"];
            NSInteger partID = [result longForColumn:@"d_partID"];
            NSInteger allpartID = [result longForColumn:@"d_allPartID"];
            NSInteger downloadstatus = [result longForColumn:@"d_downloadstatus"];
            NSData *data =[result dataForColumn:@"d_lessonmodel"];
            NSString *d_userID = [result stringForColumn:@"d_userid"];
            
            JULessonModel *lessonModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            downloadInfo.downloadURL = downloadURL;
            downloadInfo.progress = progress;
            downloadInfo.totalLength = totalLength;
            downloadInfo.urlString = urlstring;
            downloadInfo.destinationPath = destinationPath;
            downloadInfo.partID = partID;
            downloadInfo.allPartID = allpartID;
            downloadInfo.downloadstatus = downloadstatus;
            downloadInfo.lessonModel = lessonModel;
            downloadInfo.user_id = d_userID;
            
            
            
            

            [downloadArray addObject:downloadInfo];
            
            
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadingModelFindDate" object:downloadArray];
        
    }];
    
    
    
}




#pragma mark 查找方法

-(JUDownloadInfo *)findModelWithDownloadTable:(NSString *)downloadURL{
    

    pthread_mutex_lock(&_lock);
        [self selectDownloadTable:downloadURL];
        if (!self.downloadInfo) {
            self.downloadInfo = [[JUDownloadInfo alloc]init];
        }
    pthread_mutex_lock(&_lock);
        return self.downloadInfo;
    
}
//查找一组模型，已下载视频
-(NSMutableArray *)findModelWithDownloaded{
    pthread_mutex_lock(&_lock);

        [self findDownloadedModel];
        
        if (!self.downloadedArray) {
            
            self.downloadedArray = [NSMutableArray array];
            
        }
    
    pthread_mutex_lock(&_lock);

        return self.downloadedArray;

    
}



//查找一组模型，未下载完成视频
-(NSMutableArray *)findModelWithDownloading{
 
    pthread_mutex_lock(&_lock);

        [self findDownloadingModel];
        
        if (!self.downloadingArray) {
            
            self.downloadingArray = [NSMutableArray array];
        }
    
    pthread_mutex_lock(&_lock);

        return self.downloadingArray;

}

#pragma mark 通知
//接受到通知时的方法

//根据url查找
-(JUDownloadInfo *)selectDownloadFindDate:(NSNotification *)notification{
 
        self.downloadInfo = nil;
        JUDownloadInfo *downloadinfo= notification.object;
        self.downloadInfo = downloadinfo;
        return downloadinfo;

}

//下载完成
-(void)downloadedModelFindDate:(NSNotification *)notification{
    
    self.downloadedArray = notification.object;
    
 
}


//未完成
-(void)downloadingModelFindDate:(NSNotification *)notification{
    
    self.downloadingArray = notification.object;

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
