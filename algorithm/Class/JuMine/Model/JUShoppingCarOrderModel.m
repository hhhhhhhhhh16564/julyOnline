//
//  JUShoppingCarOrderModel.m
//  algorithm
//
//  Created by 周磊 on 17/2/7.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUShoppingCarOrderModel.h"

@implementation JUShoppingCarOrderModel

+(NSDictionary *)mj_objectClassInArray{
    
    return @{
             
             @"course" : @"JUOrderModel"
             
             };
    
}

-(NSString *)coupon_amount{
    
    
    return [NSString stringWithFormat:@"-%@",_coupon_amount];
}

-(NSString *)discount{
    
    
    return [NSString stringWithFormat:@"-%@",_discount];
    
    
}

-(NSString *)pay_amount{
    
    return [NSString stringWithFormat:@"¥%@",_pay_amount];

}



-(CGFloat)tableViewHeight{
    
    if (_tableViewHeight)return _tableViewHeight;
    
    _tableViewHeight = 0;
    
    // 顶部的偏移量
    _tableViewHeight += 1;
    
    
    // 所有cell的高度
    JUOrderModel *orderModel = [self.course firstObject];
    
    _tableViewHeight += orderModel.orderHeight * self.course.count;
    
    return  _tableViewHeight;
    
    
    
}

-(CGFloat)ShoppingCarOrderHeight{
    
    if (_ShoppingCarOrderHeight) return _ShoppingCarOrderHeight;
    
    _ShoppingCarOrderHeight = 0;
    
    // 订单号底部
    _ShoppingCarOrderHeight += 44;
    
    // tableView的高度
    _ShoppingCarOrderHeight += self.tableViewHeight;
    
    
    //合计顶部
    _ShoppingCarOrderHeight += 10;
    
    // 三个label后， 优惠券label的底部
    _ShoppingCarOrderHeight += 18*3;
    
    //分割线底部(距离上边为10，高度为1）
    _ShoppingCarOrderHeight += 11;
    
    
    // 分割线下边的部分
    _ShoppingCarOrderHeight += 44;
    
    // 设置cell之间的间距
    _ShoppingCarOrderHeight += 10;
    
    
    return _ShoppingCarOrderHeight;
}


@end
