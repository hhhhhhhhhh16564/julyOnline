//
//  JUCourseRecoderModel.m
//  七月算法_iPad
//
//  Created by pro on 16/6/22.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUCourseRecoderModel.h"

@implementation JUCourseRecoderModel
-(instancetype)init{
    
    if (self = [super init]) {
        //id是特殊类型，需要在这里声明一下
        [JUCourseRecoderModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            
            return @{
                     
                     @"mydescription" : @"description",
                     @"last_video" : @"last_lesson"
                     };
            
            
        }];
        
        
    }
    return self;
    
}

@end
