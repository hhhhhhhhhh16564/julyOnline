//
//  JUPriceLevelInfoModel.h
//  algorithm
//
//  Created by 周磊 on 16/9/12.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUModel.h"

@interface JUPriceLevelInfoModel : JUModel

@property (nonatomic, strong) NSString *is_level;

@property (nonatomic, strong) NSString *price1;

@property (nonatomic, strong) NSString *price2;

//预计是课程的类别ID 暂时没什么作用
@property (nonatomic, strong) NSString *category_id;

@property (nonatomic, strong) NSString *price3;

@property (nonatomic, strong) NSString *price4;

@property (nonatomic, strong) NSString *price5;

@property (nonatomic, strong) NSString *price6;

@property (nonatomic, strong) NSString *course_id;


-(NSString *)priceWithNumber:(NSUInteger)number;




@end
