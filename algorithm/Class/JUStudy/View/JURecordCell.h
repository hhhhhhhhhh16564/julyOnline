//
//  JURecordCell.h
//  algorithm
//
//  Created by 周磊 on 16/7/21.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUBaseTableViewCell.h"

#import "JUStudyingRecorderModel.h"

@interface JURecordCell : JUBaseTableViewCell


//学习记录的Model



@property(nonatomic, strong) JUStudyingRecorderModel *recorderModel;
@end
