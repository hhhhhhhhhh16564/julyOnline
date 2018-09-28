//
//  JUUnNetPlayController.h
//  algorithm
//
//  Created by 周磊 on 17/2/17.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUBaseViewController.h"

@interface JUUnNetPlayController : JUBaseViewController

@property(nonatomic, strong) NSString *course_id;
@property(nonatomic, strong) NSString *course_title;

@property (nonatomic,assign)BOOL isAutoPlay;


//出来页面就播放需要字段信息
@property(nonatomic, strong) JULessonModel *lessonModel;



@end
