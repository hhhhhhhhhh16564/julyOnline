//
//  JUListenLessonModel.h
//  algorithm
//
//  Created by 周磊 on 16/12/1.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JUListenLessonModel : NSObject

@property (nonatomic, strong) NSString *course_id;

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *course_tile;

@property (nonatomic, strong) NSString *play_url;

@property (nonatomic, strong) NSString *duration;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *image_name;


@property(nonatomic, strong) NSString *teacher;

@property (nonatomic,assign) CGFloat totalTime;

@end
