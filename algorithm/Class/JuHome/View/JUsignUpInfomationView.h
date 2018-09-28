//
//  JUsignUpInfomationView.h
//  algorithm
//
//  Created by 周磊 on 16/8/24.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUUserInfoModel.h"



@class UserInformationView;



@interface UserInformationView : UIView

-(instancetype)initWithFrame:(CGRect)frame name:(NSString *)name placeholder:(NSString *)placeholder valueText:(NSString *)valueText;

//填写的文字
@property(nonatomic, strong) NSString *valueText;


//左边的label
@property(nonatomic, strong) NSString *labelText;

//右边的提示文字
@property(nonatomic, strong) NSString *placeholder;


//装label文字和提示文字
@property(nonatomic, strong) NSArray<NSString *> *array;


@end




@interface JUsignUpInfomationView : UIScrollView

-(instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic,copy) void(^block)();

//用户信息
@property(nonatomic, strong)  JUUserInfoModel *userInfoModel;










@end
