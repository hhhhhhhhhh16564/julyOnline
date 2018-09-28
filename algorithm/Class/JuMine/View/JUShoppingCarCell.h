//
//  JUShoppingCarCell.h
//  algorithm
//
//  Created by 周磊 on 17/1/18.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUShoppingCarModel.h"

@interface JUShoppingCarCell : UITableViewCell

@property(nonatomic, strong) JUShoppingCarModel *shoppingCarModel;

@property (nonatomic,copy) globalBlock deleteBlock;
@property (nonatomic,copy) globalBlock discountRuleBlock;
//优惠规则


@end
