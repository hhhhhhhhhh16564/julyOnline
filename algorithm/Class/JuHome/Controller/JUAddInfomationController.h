//
//  JUAddInfomationController.h
//  algorithm
//
//  Created by yanbo on 17/10/19.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUBaseViewController.h"
#import "JUUserInfoModel.h"
@interface JUAddInfomationController : JUBaseViewController
@property(nonatomic, strong)  JUUserInfoModel *userInfoModel;

@property(nonatomic, strong) NSString *course_ID;






// 支付价格
// type 为1是 参团价格  type为2是补交尾款

@property(nonatomic, strong) NSString *price;
//
//
//// type是1 参团，  2 补交尾款
@property(nonatomic, strong) NSString *addPartType;

// 补交尾款的oid
@property(nonatomic, strong) NSString *oid2;

@end
