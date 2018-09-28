//
//  JURecommendModel.m
//  algorithm
//
//  Created by pro on 17/9/23.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JURecommendModel.h"
#import "JULiveModel.h"
@implementation JURecommendModel
+(NSDictionary *)mj_objectClassInArray{
    
    return @{
             @"course" : @"JULiveModel"
             
             
             };
    
}

@end
