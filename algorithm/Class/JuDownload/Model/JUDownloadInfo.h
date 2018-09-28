//
//  JUDownloadInfo.h
//  archiviewroot
//
//  Created by 周磊 on 16/6/6.
//  Copyright © 2016年 zhl. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "JULessonModel.h"
typedef enum {
    JUDownloadStateNone = 0,     // 闲置状态（除后面几种状态以外的其他状态）
    JUDownloadStateWillResume,   // 即将下载（等待下载）
    JUDownloadStateResumed,      // 下载中
    JUDownloadStateSuspened,     // 暂停中
    JUDownloadStateCompleted     // 已经完全下载完毕
}DownloadState;

@interface JUDownloadInfo : NSObject

@property(nonatomic, strong) NSString *downloadURL;

//下载的进度
@property (nonatomic,assign) float progress;

//要下载的文件的总长度
@property(nonatomic, assign) long long totalLength;

//下载文件的URL路径
@property(nonatomic, strong) NSString *urlString;

//下载文件的存放路径
@property(nonatomic, strong) NSString *destinationPath;

/**
 *正在下载的m3u8文件片段数
 */
@property(nonatomic, assign) NSInteger partID;



//userid

@property(nonatomic, strong) NSString *user_id;

/**
 *
   m3u8文件的下载总片段数目
 */

@property(nonatomic, assign) NSInteger allPartID;

@property(nonatomic, assign) DownloadState downloadstatus;
@property(nonatomic, strong) JULessonModel *lessonModel;

@end
