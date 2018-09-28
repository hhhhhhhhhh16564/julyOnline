//
//  JUMoreCategoryModel.m
//  algorithm
//
//  Created by 周磊 on 16/9/14.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUMoreCategoryModel.h"

@implementation JUMoreCategoryModel
-(instancetype)init{
    
    if (self = [super init]) {
        //id是特殊类型，需要在这里声明一下
        [JUMoreCategoryModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            
            return @{
                     
                     @"category_id" : @"id"
                     
                     };
            
        }];
    }
    return self;
    
}
@end
