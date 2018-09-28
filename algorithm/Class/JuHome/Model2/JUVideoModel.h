//
//  JUVideoModel.h
//  algorithm
//
//  Created by 周磊 on 16/9/9.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUModel.h"

@interface JUVideoModel : JUModel

//视频课程首页Model

@property (nonatomic, strong) NSString *video_name;

@property (nonatomic, strong) NSString *course_id;

@property (nonatomic, strong) NSString *descp;

@property (nonatomic, strong) NSString *image;

@property (nonatomic, strong) NSString *sort;


//视频课程更多
@property (nonatomic, strong) NSString *video_course_name;

@property (nonatomic, strong) NSString *v_course_id;


@property (nonatomic, strong) NSString *logo;


@end
