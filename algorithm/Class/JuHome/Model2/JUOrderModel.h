//
//  JUOrderModel.h
//  algorithm
//
//  Created by 周磊 on 16/9/13.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUModel.h"

@interface JUOrderModel : JUModel
@property (nonatomic, strong) NSString *image_name;

@property (nonatomic, strong) NSString *price0;

@property (nonatomic, strong) NSString *price1;



@property (nonatomic, strong) NSString *oid;

@property (nonatomic, strong) NSString *course_title;

@property (nonatomic, strong) NSString *course_id;
#pragma mark 添加购物车之后
//购买时支付价
@property (nonatomic, strong) NSString *pay_amount;

//购买时售价
@property (nonatomic, strong) NSString *amount;

//优惠金额
@property (nonatomic, strong) NSString *coupon_amount;

// 添加购物车后我的订单中 的tableView的cell的高度
@property (nonatomic,assign) CGFloat orderHeight;






@end
