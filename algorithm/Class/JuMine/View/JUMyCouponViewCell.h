//
//  JUMyCouponViewCell.h
//  algorithm
//
//  Created by 周磊 on 17/1/22.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JUMyCouponModel.h"

@interface JUMyCouponViewCell : UITableViewCell

//使用的优惠券
@property(nonatomic, strong) JUMyCouponModel *usingCouponModel;


//所有的优惠券
@property(nonatomic, strong) JUMyCouponModel *allCouponModel;


//@property (nonatomic,assign) BOOL showCheckButton;
//@property(nonatomic, copy) globalBlock checkButtonBlock;

@end
