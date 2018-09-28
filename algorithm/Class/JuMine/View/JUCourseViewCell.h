//
//  JUCourseViewCell.h
//  algorithm
//
//  Created by pro on 16/7/6.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUBaseTableViewCell.h"
#import "JUCourseCellView.h"
@interface JUCourseViewCell : JUBaseTableViewCell
@property(nonatomic, strong) JUCourseCellView *cellView;
@property(nonatomic, strong) UIView *lineView;

@end
