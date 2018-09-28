//
//  JUDownloadManager.h
//  archiviewroot
//
//  Created by pro on 16/6/6.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JUDownloader.h"
#import "JULessonModel.h"
#define KFJUDownloadMaxTaskCount 1
@interface JUDownloadManager : NSObject
+(instancetype)shredManager;

//正在下载的url, 因为需求是一次只能下载一个,所以下载某个人物时要取消之前的下载
@property(nonatomic, strong) NSString *downloadingUrlstring;

//正在下载的downloader,用于获取下载的进度
@property(nonatomic, strong) JUDownloader *downloader;




/**
 *  断点下载
 *
 *  @param urlString        下载的链接
 *  @param destinationPath  下载的文件的保存路径
 *  @param  process         下载过程中回调的代码块，会多次调用
 *  @param  completion      下载完成回调的代码块
 *  @param  failure         下载失败的回调代码块
 */
-(void)downloadWithUrlString:(NSString *)urlString
                      toPath:(NSString *)destinationPath
                     process:(ProcessHandle)process
                  completion:(CompletionHandle)completion
                     failure:(FailureHandle)failure
                lessonModel:(JULessonModel *)lessonModel;



/**
 *  暂停下载
 *
 *  @param url 下载的链接
 */
-(void)cancelDownloadTask:(NSString *)url;
/**
 *  暂停所有下载
 */
-(void)cancelAllTasks;

/**
 *  彻底移除正在下载任务
 *
 *  @param url  下载链接
 *  @param path 文件路径
 */
-(void)removeForUrl:(NSString *)url file:(NSString *)path lessonModel:(JULessonModel *)lessonModel ;


/**
 *  获取上一次的下载进度
 *
 *  @param url 下载链接
 *
 *  @return 下载进度
 */
-(float)lastProgress:(NSString *)url;


/**
 *  获取文件已下载的大小和总大小,格式为:已经下载的大小/文件总大小,如：12.00M/100.00M。
 *
 *  @param url 下载链接
 *
 *  @return 有文件大小及总大小组成的字符串
 */
-(NSString *)filesSize:(NSString *)url;



//取消缓存的任务
-(void)cancelWaittingTask:(NSString *)urlstring;

//从队列中取出一个下载： 当任务正在下载时，点击这个按钮让任务取消，需要从缓存任务中取出一个下载
-(void)downloadTaskFromWaitingTsaks;

//点击注销按钮结束所有下载的任务
-(void)downloadTaskWillBeTerminate:(NSNotification *)notifi;

//正在下载的数量
-(NSInteger)downloadingCount;

@end





























