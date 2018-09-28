//
//  NSMutableAttributedString+Extension.h
//  algorithm
//
//  Created by 周磊 on 17/1/25.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSMutableAttributedString (Extension)


//设置指定范围的字体
-(NSMutableAttributedString *)font:(CGFloat)font color:(UIColor *)color range:(NSRange)range;

//设置所有字体
-(NSMutableAttributedString *)font:(CGFloat)font color:(UIColor *)color;

//设置指字体
-(NSMutableAttributedString *)font:(CGFloat)font color:(UIColor *)color str:(NSString *)str;



//设置指定范围的字体
-(NSMutableAttributedString *)customFont:(UIFont *)font color:(UIColor *)color range:(NSRange)range;

//设置所有字体
-(NSMutableAttributedString *)customFont:(UIFont *)font color:(UIColor *)color;

//设置指字体
-(NSMutableAttributedString *)customFont:(UIFont *)font color:(UIColor *)color str:(NSString *)str;


@end
