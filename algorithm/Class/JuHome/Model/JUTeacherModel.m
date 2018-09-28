//
//  JUTeacherModel.m
//  七月算法_iPad
//
//  Created by 周磊 on 16/6/1.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUTeacherModel.h"

@implementation JUTeacherModel

-(instancetype)init{
    
    if (self = [super init]) {
        //id是特殊类型，需要在这里声明一下
        [JUTeacherModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            
            return @{
                     
                     @"ID" : @"id"
                     
                     };
            
        }];
        
    }
    return self;
    
}


@end
