//
//  JUShoppingCarOrderModel.h
//  algorithm
//
//  Created by 周磊 on 17/2/7.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUModel.h"
#import "JUOrderModel.h"

@interface JUShoppingCarOrderModel : JUModel

// 合计
@property (nonatomic, strong) NSString *amount;

//
@property (nonatomic, strong) NSArray<JUOrderModel *> *course;

// 	优惠券优惠
@property (nonatomic, strong) NSString *coupon_amount;

//实付款
@property (nonatomic, strong) NSString *pay_amount;

//老学员优惠
@property (nonatomic, strong) NSString *discount;

//支付时间戳 0未支付
@property (nonatomic, strong) NSString *pay_time;

//订单的id
@property (nonatomic, strong) NSString *oid;


// 计算cell的高度
@property (nonatomic,assign) CGFloat ShoppingCarOrderHeight;



//计算cell的tableview的高度
@property (nonatomic,assign) CGFloat tableViewHeight;



@end
