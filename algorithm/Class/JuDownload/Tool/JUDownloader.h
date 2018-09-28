//
//  JUDownloader.h
//  archiviewroot
//
//  Created by 周磊 on 16/6/6.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JUDownloadInfo.h"


//下载过程中回调的代码块，3个参数分别为：下载进度、已下载部分大小/文件大小构成的字符串(如:1.15M/5.27M)、
//以及文件下载速度字符串(如:512Kb/s)
typedef void (^ProcessHandle)(float progress,NSString *sizeString,NSString *speedString);
typedef void (^CompletionHandle)();
typedef void (^FailureHandle)(NSError *error);

@interface JUDownloader : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

//下载过程中回调的代码块，会多次调用。
@property(nonatomic,copy)ProcessHandle process;
//下载完成回调的代码块
@property(nonatomic,copy,readonly)CompletionHandle completion;
//下载失败的回调代码块
@property(nonatomic,copy,readonly)FailureHandle failure;

//主要是用来传递UID  courseID  lessonID
@property(nonatomic, strong) JULessonModel *lessonModel;


//下载的类
@property(nonatomic,strong)NSURLConnection *con;
@property(nonatomic, strong) JUDownloadInfo *downloadInfo;
@property(nonatomic, strong) NSString *uidDownloadrul;
/**
 * 获取对象的类方法
 */



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
                     failure:(FailureHandle)failure;

/**
 *  取消下载
 */
-(void)cancel;

/**
 * 获取上一次的下载进度
 */
-(float)lastProgress:(NSString *)url;
/**获取文件已下载的大小和总大小,格式为:已经下载的大小/文件总大小,如：12.00M/100.00M。
 *
 * @param url 下载链接
 */
-(NSString *)filesSize:(NSString *)url;


@end
