//
//  JULiveCoursesCell.h
//  algorithm
//
//  Created by 周磊 on 16/8/22.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JULiveModel.h"

@interface JULiveCoursesCell : UICollectionViewCell
@property(nonatomic, strong) JULiveModel *liveModel;
@property(nonatomic, strong) UIView *lineView;

@end
