//
//  JUVideoModel.m
//  algorithm
//
//  Created by 周磊 on 16/9/9.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUVideoModel.h"

@implementation JUVideoModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             
             //对应两个值
             
             @"descp": @[@"descp", @"description"]
             
             };
    
    
}




@end
