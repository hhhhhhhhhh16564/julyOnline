//
//  JUMediaModel.h
//  algorithm
//
//  Created by 周磊 on 17/2/23.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import <Foundation/Foundation.h>
//播放的资源
@interface JUMediaModel : NSObject

//播放的标题 optional
@property(nonatomic, strong) NSString *title;
//视频的URL, 必须设置 requied
@property(nonatomic, strong) NSURL *VideoURL;


/** 视频封面本地图片 optional */
@property (nonatomic, strong) NSString *placeholderImage;
//视频的总时间 optional
@property(nonatomic, assign) NSTimeInterval totalTime;
//当前播放时间 optional
@property(nonatomic, assign) NSTimeInterval currentTime;
//起始播放时间
@property (nonatomic,assign) NSTimeInterval beginTime;
//默认没有下载
@property (nonatomic,assign, getter=isDownloaded) BOOL downloaded;

//是否是m3u8文件
@property (nonatomic,assign, getter=isM3u8File)BOOL m3u8File;

//播放下载的视频要搭建本地服务器，当进入后台超过10分钟后，就会出问题需要重新初始化改视频，但是视图页面可以重置，给用户一种错觉
@property (nonatomic,assign) BOOL resetServerPlay;

@end
