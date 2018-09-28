//
//  JUCourseRecoderModel.h
//  七月算法_iPad
//
//  Created by pro on 16/6/22.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUModel.h"
#import "JULastLessonModel.h"
//学习记录的Model
@interface JUCourseRecoderModel : JUModel

//
//course_id = 18,
//image_name = 55e85e81d50c8.jpg,
//course_title = 机器学习公开课,
//logo = https://www.julyedu.com/Public/Image/55e85e81d50c8.jpg
//last_time = 1466522693



/*
 
 "course_id": 45,
 "course_title": "机器学习应用班",
 "image_name": "http://www.julyedu.com/Public/Image/8a64460e67.jpg",
 "description": "",
 "last_time": 1493166705,
 
 "last_video": {
 "video_id": 500,
 "video_name": "第8课 第三节 共轭函数与拉格朗日对偶函数",
 "play_url": "http://v2.julyedu.com/ts/41/500/67677aaf.m3u8",
 "video_time": 345
 }
 */

@property(nonatomic, strong) NSString *course_id;
@property(nonatomic, strong) NSString *image_name;
@property(nonatomic, strong) NSString *course_title;
@property(nonatomic, strong) NSString *logo;
@property(nonatomic, strong) NSString *last_time;
@property(nonatomic, strong) NSString *mydescription;

@property(nonatomic, strong) JULastLessonModel *last_video;










@end
