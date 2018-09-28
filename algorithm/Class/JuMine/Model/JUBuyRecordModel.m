//
//  JUBuyRecordModel.m
//  七月算法_iPad
//
//  Created by pro on 16/6/28.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUBuyRecordModel.h"

@implementation JUBuyRecordModel

-(instancetype)init{
    
    if (self = [super init]) {
        //id是特殊类型，需要在这里声明一下
        [JUBuyRecordModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            
            return @{
                     
                     @"courseDescription" : @"description"
                     
                     };
            
        }];
        
    }
    return self;
    
}



@end
