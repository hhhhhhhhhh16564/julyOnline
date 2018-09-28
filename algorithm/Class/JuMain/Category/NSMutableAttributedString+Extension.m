//
//  NSMutableAttributedString+Extension.m
//  algorithm
//
//  Created by 周磊 on 17/1/25.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "NSMutableAttributedString+Extension.h"

@implementation NSMutableAttributedString (Extension)

//设置所有字体

-(NSMutableAttributedString *)font:(CGFloat)font color:(UIColor *)color{
    


    
    [self font:font color:color range:NSMakeRange(0, [self length])];
    
    return self;
    
}

//设置指定范围的字体
-(NSMutableAttributedString *)font:(CGFloat)font color:(UIColor *)color range:(NSRange)range{
    
    if (font) {

    
        UIFont *textFont = [UIFont systemFontOfSize:font];
        
        [self addAttribute:NSFontAttributeName value:textFont range:range];
   

    
    }
    
    if (color) {
        
        [self addAttribute:NSForegroundColorAttributeName value:color range:range];
    }

    return self;
    
    
    
}


-(NSMutableAttributedString *)font:(CGFloat)font color:(UIColor *)color str:(NSString *)str{

 
    NSRange range = [self.mutableString rangeOfString:str options:0];

    [self font:font color:color range:range];
    
    
    return self;
    
}














//设置指定范围的字体
-(NSMutableAttributedString *)customFont:(UIFont *)font color:(UIColor *)color range:(NSRange)range{
    
    
    if (font) {
        
        [self addAttribute:NSFontAttributeName value:font range:range];

    }
    
    if (color) {
        
        [self addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
    
    return self;
}

//设置所有字体
-(NSMutableAttributedString *)customFont:(UIFont *)font color:(UIColor *)color{
    
    
    [self customFont:font color:color range:NSMakeRange(0, [self length])];
    
    return self;

}

//设置指字体
-(NSMutableAttributedString *)customFont:(UIFont *)font color:(UIColor *)color str:(NSString *)str{
    
        NSRange range = [self.mutableString rangeOfString:str options:0];
        [self customFont:font color:color range:range];

    return self;
}










@end
