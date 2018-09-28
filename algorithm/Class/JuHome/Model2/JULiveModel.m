//
//  JULiveModel.m
//  algorithm
//
//  Created by 周磊 on 16/9/9.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JULiveModel.h"

@implementation JULiveModel

-(NSString *)price1{
    
    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
      
        if ([_course_id isEqualToString:@"47"]) {
            
            
            return @"1198";
            
        }else if ([_course_id isEqualToString:@"56"]){
            
            return @"1198";
            
        }else if ([_course_id isEqualToString:@"46"]){
            
            
            return @"1498";
            
        }
 
 
    }
    

    return _price1;
}



-(NSString *)price0{
    
    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
        

        NSUInteger nowPricee   = [self.price1 integerValue];
        
        NSInteger previousPricee = [_price0 integerValue];
        
        if (nowPricee >= previousPricee) {
            
            _price0 = [NSString stringWithFormat:@"%zd",nowPricee+200];
        }
   
        
    }
    
    
    return _price0;
    
    
}





@end
