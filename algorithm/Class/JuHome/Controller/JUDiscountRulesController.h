//
//  JUDiscountRulesController.h
//  algorithm
//
//  Created by 周磊 on 16/8/25.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUBaseViewController.h"
@class DiscountRulesCellView;

@interface DiscountRulesCellView : UIView


//多个地方要用，左边的间距 ,默认是12;
@property (nonatomic,assign) CGFloat space;

@property(nonatomic, strong) UILabel *categoryLabel;
@property(nonatomic, strong) UILabel *priceLabel;

@property (nonatomic,assign) BOOL isHiddenLine;

@end








@interface JUDiscountRulesController : JUBaseViewController

@property(nonatomic, strong) NSString *course_id;

@property(nonatomic, strong) NSString  *price_level;


@end
