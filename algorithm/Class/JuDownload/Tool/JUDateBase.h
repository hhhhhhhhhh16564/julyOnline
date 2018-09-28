//
//  JUDateBase.h
//  archiviewroot
//
//  Created by 周磊 on 16/6/6.
//  Copyright © 2016年 zhl. All rights reserved.
//

//记录下载信息的数据库


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FMDatabaseQueue.h"

#define mydatabase [JUDateBase shareInstance]
@class JUDownloadInfo;

@interface JUDateBase : NSObject

+(instancetype)shareInstance;


@property(nonatomic, strong) FMDatabaseQueue *downloadBaseQueue;
-(NSString *)dataseBasePath;

//创建下载的表

-(void)createTableWithDownload;

//添加数据
-(void)addDownloadData:(JUDownloadInfo *)downloadInfo;

//更改数据

-(void)updateDownloadTable:(JUDownloadInfo *)downloadInfo;

//更改文件的总大小
-(void)updateSizeofile:(JUDownloadInfo *)downloadInfo;

//更改文件的总片段数目以及正在下载的片段数
-(void)updatepartIdAndAllPartID:(JUDownloadInfo *)downloadInfo;

//更改视频的下载状态
-(void)updateDownloadStatus:(JUDownloadInfo *)downloadInfo;

//程序启动时，设置所有未下载完成的视频的状态为 暂停状态
-(void)changedDownloadStatusOnAppLaunch;



//查找数据
//-(void)selectDownloadTable:(NSString *)downloadURL;

//删除数据
-(void)deleteDownloadTable:(NSString *)downloadURL;


//查找数据返回一个模型（因为查找用到了block,要用到通知将block中的数据传递出去）
-(JUDownloadInfo *)findModelWithDownloadTable:(NSString *)downloadURL;

//查找一组模型，已下载视频
-(NSMutableArray *)findModelWithDownloaded;


//查找一组模型，未下载完成视频
-(NSMutableArray *)findModelWithDownloading;

// 查找一组模型， 暂停下载的视频
//-(NSMutableArray *)findModelWithPaused;



//


@end
