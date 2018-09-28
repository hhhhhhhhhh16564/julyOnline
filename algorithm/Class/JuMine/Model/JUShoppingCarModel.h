//
//  JUShoppingCarModel.h
//  algorithm
//
//  Created by 周磊 on 17/1/23.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUModel.h"

@interface JUShoppingCarModel : JUModel


/*
 "course_id": 63,
 "course_title": "矩阵与凸优化班",
 "simpledescription": "2次矩阵 1次概率 3次凸优化及其应用",
 "image_name": "http://www.julyedu.com/Public/Image/427e9ba0af.png",
 "price0": 600,
 "price1": 99,
 "coupon": 36445,
 "coupon_amount": 50,
 "coupon_num": 4
 
 */
@property (nonatomic, strong) NSString *image_name;

@property (nonatomic, strong) NSString *price0;

@property (nonatomic, strong) NSString *price1;

@property (nonatomic, strong) NSString *level;

@property (nonatomic, strong) NSString *simpledescription;

@property (nonatomic, strong) NSString *level_price;

@property (nonatomic, strong) NSString *level_info;

@property (nonatomic, strong) NSString *course_title;

@property (nonatomic, strong) NSString *course_id;

@property (nonatomic, strong) NSString *coupon_num;

//优惠码
@property (nonatomic, strong) NSString *coupon;

// 优惠金额
@property (nonatomic, strong) NSString *coupon_amount;


#pragma mark 支付页面用的 ***
//之前的价格
@property(nonatomic, strong) NSString *amount;

// 实际支付价格
@property(nonatomic, strong) NSString *pay_amount;

# pragma mark ***


//是否选中
@property (nonatomic,assign) BOOL isSelected;








@end
