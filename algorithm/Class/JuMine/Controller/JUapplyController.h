//
//  JUapplyController.h
//  algorithm
//
//  Created by 周磊 on 17/1/24.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUBaseViewController.h"
#import "JUShoppingCarModel.h"

@interface JUapplyController : JUBaseViewController
@property(nonatomic, strong) NSMutableArray<JUShoppingCarModel *> *shoppingCarArray;

@property(nonatomic, strong) NSMutableDictionary *dict;

@property(nonatomic, strong) NSString *purchaseTotalPrice;


@end
