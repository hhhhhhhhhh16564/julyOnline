//
//  JUapplyCell.h
//  algorithm
//
//  Created by 周磊 on 17/1/24.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUShoppingCarModel.h"
@interface JUapplyCell : UITableViewCell
@property(nonatomic, strong) JUShoppingCarModel *shoppingCarModel;


@property (nonatomic,copy) globalBlock disPriceBlock;
@property (nonatomic,copy) globalBlock couponCodeBlock;

@end
