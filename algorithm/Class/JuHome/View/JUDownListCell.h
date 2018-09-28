//
//  JUDownListCell.h
//  algorithm
//
//  Created by pro on 16/7/14.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUBaseTableViewCell.h"
@class JULessonModel;

//

@class JUDownListCell;

@protocol JUDownListCellDelegate <NSObject>

//对号的button已经点击
-(void)hookedButtonDidClicked:(JUDownListCell *)listCell;

@end


@interface JUDownListCell : JUBaseTableViewCell

@property(nonatomic, strong) JULessonModel *lessonModel;


@property(nonatomic, strong) UILabel *nameLab;


@property(nonatomic, weak) id<JUDownListCellDelegate> delegate;



@end
