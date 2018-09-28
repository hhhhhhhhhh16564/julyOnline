//
//  JUListenCourseModel.h
//  algorithm
//
//  Created by 周磊 on 16/12/1.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JUListenLessonModel.h"



@interface JUListenCourseModel : NSObject


@property (nonatomic, strong) NSString *course_category;

@property (nonatomic, strong) NSString *play_times;

@property (nonatomic, strong) NSString *course_id;

@property (nonatomic, strong) NSMutableArray<JUListenLessonModel *> *lessons;

@property (nonatomic, strong) NSString *simpledescription;

@property (nonatomic, strong) NSString *course_title;

@property (nonatomic, strong) NSString *image_name;



@end
