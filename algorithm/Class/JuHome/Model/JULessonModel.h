//
//  JULessonModel.h
//  七月算法_iPad
//
//  Created by 周磊 on 16/6/1.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUModel.h"
typedef enum{
   
    JUUnSelected,  //没有选择状态
    JUCompleted,   //完成下载
    JUSeleted      //已将选择下载
    
    
}LessonState;


@class JUDownloadInfo;

@interface JULessonModel : JUModel
//课程类别  17
@property(nonatomic, strong) NSString *course_id;

//时长 13:58
@property(nonatomic, strong) NSString *duration;


@property (nonatomic,assign) CGFloat totalTime;

// 播放id与播放地址有关
@property(nonatomic, strong) NSString *ID;

//是否免费 1
@property(nonatomic, strong) NSString *is_free;

//名字 十分钟搞定LCS
@property(nonatomic, strong) NSString *name;


// http://v.julyedu.com/web/course/17/9.mp4
@property(nonatomic, strong) NSString *play_url;

//  21M
@property(nonatomic, strong) NSString *size;

//次序 0
@property(nonatomic, strong) NSString *sort;

//图片 56c99c12ef284.png
@property(nonatomic, strong) NSString *thumb_img;
//图片的具体网址,不用拼接，同thumb_img;
@property(nonatomic, strong) NSString *img;

@property (nonatomic,assign,getter=isM3u8Video) BOOL m3u8Video;

// 21
@property(nonatomic, strong) NSString *video_size;


//展示课程状态的枚举值，已经完成下载， 已经选择，未选择
@property(nonatomic, assign) LessonState lessonstate;


//所属课程的图片
@property(nonatomic, strong) NSString *image_name;

//所属课程的名字
@property(nonatomic, strong) NSString *course_tile;

//次数 41579
@property(nonatomic, strong) NSString *play_times;

#pragma mark 增加扩充字段.为了使用方便

//记录播放时间
@property (nonatomic,assign) NSInteger timeRecord;


//本地最后更新时间
@property (nonatomic,assign) NSUInteger timestamp;


//记录是否播放过该视频（特指已经下载的视频，下载的视频是否显示小圆点）  默认没有播放
@property (nonatomic,assign)BOOL isPlayed;


//播放进度为百分之百,显示该视频已经播放完成
@property (nonatomic,assign) BOOL isPlayCompleted;

//播放的百分比的字符串

@property(nonatomic, strong) NSString *perCentageString;


//course目录的路径（用于计算该课程目录下的所有视频的大小）
@property(nonatomic, strong) NSString *courseDestinationPath;


//删除某一个视频的路径
@property(nonatomic, strong) NSString *deletelessonPath;



//下载文件的存放路径
@property(nonatomic, strong) NSString *destinationPath;

// 原下载文件的的路径
@property(nonatomic, strong) NSString *sourcePath;


//存放在数据库里的 主字段（用户的id,和资源的url
//（现在已经改为uid courseID  id)
@property(nonatomic, strong) NSString *databaseUidUrl;
//绑定的记录文件下载的信息
-(JUDownloadInfo *)downloadInfo;

//绑定记录播放进度的lessonModel
-(JULessonModel *)lessonModel;





////与.m3u8视频本地的播放有关
@property(nonatomic, strong) NSString *documnetrootString;
@property(nonatomic, strong) NSString *contentUrlString;


@end
