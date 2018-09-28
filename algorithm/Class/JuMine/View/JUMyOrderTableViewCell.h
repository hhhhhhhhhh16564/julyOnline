//
//  JUMyOrderTableViewCell.h
//  algorithm
//
//  Created by 周磊 on 17/1/25.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUShoppingCarOrderModel.h"
@class JUMyOrderTableViewSubCell;

@interface JUMyOrderTableViewSubCell : UITableViewCell

@property(nonatomic, strong) JUOrderModel *orderModel;
@end






@interface JUMyOrderTableViewCell : UITableViewCell

@property(nonatomic, strong) JUShoppingCarOrderModel *shoppingCarOrderModel;

//删除订单
@property(nonatomic, copy) globalBlock deleteOrderBlock;



//去支付
@property(nonatomic, copy) globalBlock goPayBlock;

@end
