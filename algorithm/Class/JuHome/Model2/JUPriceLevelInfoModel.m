//
//  JUPriceLevelInfoModel.m
//  algorithm
//
//  Created by 周磊 on 16/9/12.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUPriceLevelInfoModel.h"

@implementation JUPriceLevelInfoModel

-(instancetype)init{
    
    if (self = [super init]) {
        //id是特殊类型，需要在这里声明一下
        [JUPriceLevelInfoModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            
            return @{
                     
                     @"category_id" : @"id"
                     
                     };

        }];
    }
    return self;
    
}

//传一个数字，找出对应的价格值
-(NSString *)priceWithNumber:(NSUInteger)number{
    
    NSString *key = [NSString stringWithFormat:@"price%zd",number];
    
    
    return [self valueForKey:key];

}

//如果没有发现key
- (nullable id)valueForUndefinedKey:(NSString *)key{
    
  return @"";
  
}







@end
