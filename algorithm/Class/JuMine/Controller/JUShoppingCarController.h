//
//  JUShoppingCarController.h
//  algorithm
//
//  Created by 周磊 on 17/1/18.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUBaseViewController.h"

@interface JUShoppingCarController : JUBaseViewController

//从study页面过来的
@property(nonatomic, strong) NSString *ID;

//从支付页面返回
-(void)comeBackFromPayController;

@end
