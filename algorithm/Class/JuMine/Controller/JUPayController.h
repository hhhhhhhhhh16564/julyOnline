//
//  JUPayController.h
//  algorithm
//
//  Created by 周磊 on 17/2/6.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUBaseViewController.h"

@interface JUPayController : JUBaseViewController

@property(nonatomic, strong) NSString *orderID;

@property(nonatomic, strong) NSString *is_free;
@property(nonatomic, strong) NSString *purchaseTotalPrice;


@property(nonatomic, strong) NSMutableArray *purchaseArray;
@end
