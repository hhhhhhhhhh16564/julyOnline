//
//  JULastLessonModel.m
//  七月算法_iPad
//
//  Created by pro on 16/6/22.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JULastLessonModel.h"

@implementation JULastLessonModel
-(instancetype)init{
    
    if (self = [super init]) {
        //id是特殊类型，需要在这里声明一下
        [JULastLessonModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            
            return @{
                     
                     @"lessonId" : @"id"
                     
                     };
            
            
        }];
        
        
    }
    return self;
    
}

@end
