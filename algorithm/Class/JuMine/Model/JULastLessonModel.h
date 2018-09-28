//
//  JULastLessonModel.h
//  七月算法_iPad
//
//  Created by pro on 16/6/22.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUModel.h"

@interface JULastLessonModel : JUModel
//last_lesson = {
//    v_course_id = 36,
//    id = 137,
//    name = 第6课 图,
//    logo = http://www.julyedu.com/Public/Image/56f23463369dd.png,
//    thumb_img = 56f23463369dd.png,
//    play_url = http://v.julyedu.com/web/course/36/137.m3u8,
//    duration = 2090,
//    is_free = 0
//},

//
//@property(nonatomic, strong) NSString *v_course_id;
//@property(nonatomic, strong) NSString *lessonId;
//@property(nonatomic, strong) NSString *name;
//@property(nonatomic, strong) NSString *logo;
//@property(nonatomic, strong) NSString *thumb_img;
//@property(nonatomic, strong) NSString *play_url;
//@property(nonatomic, strong) NSString *duration;
//@property(nonatomic, strong) NSString *is_free;




@property(nonatomic, strong) NSString *video_id;
@property(nonatomic, strong) NSString *video_name;
@property(nonatomic, strong) NSString *play_url;
@property(nonatomic, strong) NSString *video_time;




@end
