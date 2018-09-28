//
//  JUTeacherListCell.h
//  七月算法_iPad
//
//  Created by pro on 16/6/2.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUBaseTableViewCell.h"

@class JUTeacherModel;
@interface JUTeacherListCell : JUBaseTableViewCell

@property(nonatomic, strong) JUTeacherModel *teacherModel;
+(CGFloat)calculateHeightwithString:(JUTeacherModel *)teacherModel;
@end
