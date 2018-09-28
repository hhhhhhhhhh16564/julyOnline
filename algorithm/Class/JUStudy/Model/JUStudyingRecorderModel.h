//
//  JUStudyingRecorderModel.h
//  algorithm
//
//  Created by yanbo on 17/9/21.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUModel.h"

@interface JUStudyingRecorderModel : JUModel


@property (nonatomic, strong) NSString *course_qq;

@property (nonatomic, strong) NSString *image_name;

@property (nonatomic, strong) NSString *last_lesson;

@property (nonatomic, strong) NSString *ago;

@property (nonatomic, strong) NSString *v_course_id;

@property (nonatomic, strong) NSString *simpledescription;

@property (nonatomic, strong) NSString *seconds;

@property (nonatomic, strong) NSString *lesson_name;

@property (nonatomic, strong) NSString *course_title;

@property (nonatomic, strong) NSString *course_id;

@property (nonatomic,assign) BOOL is_free;


@end
