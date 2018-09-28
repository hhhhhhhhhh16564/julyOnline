//
//  JUCourseDetailViewController.h
//  七月算法_iPad
//
//  Created by 周磊 on 16/6/1.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUBaseViewController.h"

#import "JULessonModel.h"
//播放详情页面控制器
@interface JUCourseDetailViewController : JUBaseViewController
@property(nonatomic, strong) NSString *course_id;
@property(nonatomic, strong) NSString *course_title;
//是否自动播放
@property (nonatomic,assign)BOOL isAutoPlay;
//出来页面就播放需要字段信息 lessonModel必须包含lessonID 和courseID
@property(nonatomic, strong) JULessonModel *lessonModel;

@end
