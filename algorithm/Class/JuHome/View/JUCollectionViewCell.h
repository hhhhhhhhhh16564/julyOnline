//
//  JUCollectionViewCell.h
//  七月算法_iPad
//
//  Created by 周磊 on 16/5/25.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUBuyRecordModel.h"
#import "JUVideoModel.h"

@interface JUCollectionViewCell : UICollectionViewCell

//主页的model
@property(nonatomic, strong) JUVideoModel *videoModel;

@end
