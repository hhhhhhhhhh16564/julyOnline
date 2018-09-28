//
//  JUCouponController.h
//  algorithm
//
//  Created by pro on 16/9/12.
//  Copyright © 2016年 Julyonline. All rights reserved.
//


//优惠码

#import "JUBaseViewController.h"

@interface JUCouponController : JUBaseViewController

@property(nonatomic, strong) NSString *cid;


@property(nonatomic, copy) globalBlock myBlock;

@property(nonatomic, copy) globalBlock couponBlock;


//button上的字体文字
@property(nonatomic, strong) NSString *buttonString;

@end
