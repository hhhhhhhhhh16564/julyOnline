//
//  JULiveModel.h
//  algorithm
//
//  Created by 周磊 on 16/9/9.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUModel.h"

@interface JULiveModel : JUModel

//直播首页
@property (nonatomic, strong) NSString *price0;

@property (nonatomic, strong) NSString *sort;

@property (nonatomic, strong) NSString *price1;

@property (nonatomic, strong) NSString *descp;

@property (nonatomic, strong) NSString *image;

@property (nonatomic, strong) NSString *course_name;

@property (nonatomic, strong) NSString *course_id;

@property(nonatomic, strong) NSString *v_course_id;


//直播课程更多
@property (nonatomic, strong) NSString *image_name;

@property (nonatomic, strong) NSString *simpledescription;

@property (nonatomic, strong) NSString *course_title;

@end
