//
//  JUCategoryModel.m
//  七月算法_iPad
//
//  Created by 周磊 on 16/5/31.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUCategoryModel.h"

@implementation JUCategoryModel

-(instancetype)init{
    
    self = [super init];
    if (self) {
     
        
     [JUCategoryModel mj_setupObjectClassInArray:^NSDictionary *{
        
         return @{
                  
                    @"courses" : @"JUCoursesModel"
                  
                  };
         
  
         
         
     }];
        
    }
    
    return self;
}


@end
