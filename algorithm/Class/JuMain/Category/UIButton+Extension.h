//
//  UIButton+Extension.h
//  algorithm
//
//  Created by 周磊 on 16/10/13.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CategoryButton;


@interface  CategoryButton: UIButton;

+(CategoryButton *)buttonWithbuttonImage:(UIImage *)image;

@end


@interface UIButton (Extension)


//设置button的正常背景图片和选中的背景图片
+(UIButton *)buttonWithNormalBgImage:(id)normalBgImage
                      selectedBgImage:(id)selectedBgImage
                             button:(UIButton *)button;




//设置图片, 不是背景图片
+(UIButton *)buttonWithNormalImage:(id)normalImage
                       selectedImage:(id)selectedImage
                              button:(UIButton *)button;



//根据颜色 生成对应的背景图片，给button设置  正常状态下和高亮状态下
+(UIButton *)buttonWithNormalColor:(id)normalColor
                      hightedColor:(id)hightedColor
                     selectedColor:(id)selectedColor
                            Button:(UIButton *)button;


//设置button的正常状态的字体 和高亮状态下的字体


+(UIButton *)buttonWithTitle:(NSString *)title
                   titlefont:(CGFloat )fontNumber
           normalTitleColor:(UIColor *)normalColor
          selectedTitleColor:(UIColor *)selectedColor
               hightedColor:(UIColor *)hightedColor
                     button:(UIButton *)button;




//设置button的正常状态的字体 和选中状态下的字体

+(UIButton *)buttonWithNormalTitle:(NSString *)normalTitle
                     selectedTitle:(NSString *)selectedTitle
                         titlefont:(CGFloat )fontNumber
                        titleColor:(UIColor *)titleColor
                            button:(UIButton *)button;






//设置button的图片  文字
+(UIButton *)buttonWithImage:(id)image
                       title:(NSString *)title
                   titlefont:(CGFloat)fontNumber
                  titleColor:(UIColor *)color
                      button:(UIButton *)button;


//设置间距 图片和文字
-(void)buttonSpaceImageWithTitle:(CGFloat)space;




+(__kindof UIButton *)buttonWithImage:(UIImage *)image;


+(__kindof UIButton *)createButton;
@end
