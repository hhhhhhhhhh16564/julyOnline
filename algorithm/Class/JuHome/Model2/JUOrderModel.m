//
//  JUOrderModel.m
//  algorithm
//
//  Created by 周磊 on 16/9/13.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUOrderModel.h"

@implementation JUOrderModel


-(CGFloat)orderHeight{
    
    if (_orderHeight)return _orderHeight;
    
    
    _orderHeight = 0;
    
    
  
    //imv的顶部
    _orderHeight += 5;
    
    //imv的底部
    _orderHeight += Kwidth *0.288;
    
    //分割线的顶部
    _orderHeight += 5;
    
    //分割线的底部
    _orderHeight += 0.5;
    
    return _orderHeight;
    
}





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




-(NSString *)pay_amount{
    
    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
        
        if ([_course_id isEqualToString:@"47"]) {
            
            
            return @"1198";
            
        }else if ([_course_id isEqualToString:@"56"]){
            
            return @"1198";
            
        }else if ([_course_id isEqualToString:@"46"]){
            
            
            return @"1498";
            
        }
        
        
    }
    
    
    return _pay_amount;
}


@end
