//
//  JUCourseListCell.h
//  七月算法_iPad
//
//  Created by 周磊 on 16/6/1.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUBaseTableViewCell.h"
@class JULessonModel;


@interface JUCourseListCell : JUBaseTableViewCell

@property(nonatomic, strong) JULessonModel *lessonModel;

@property(nonatomic, strong) UILabel *nameLab;

@end
