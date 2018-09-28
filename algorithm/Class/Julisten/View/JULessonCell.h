//
//  JULessonCell.h
//  algorithm
//
//  Created by 周磊 on 16/12/14.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUListenLessonModel.h"

@interface JULessonCell : UITableViewCell

@property(nonatomic, strong)JUListenLessonModel *lessonModel;

@property(nonatomic, copy) dispatch_block_t block;


@end
