//
//  UIButton+Extension.m
//  algorithm
//
//  Created by 周磊 on 16/10/13.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "UIButton+Extension.h"
#import "UIColor+JUClour.h"

@interface CategoryButton ()


@end


@implementation CategoryButton


-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    
    UIImage *image = [self imageForState:(UIControlStateNormal)];
   
    return CGRectMake((contentRect.size.width-image.size.width)*0.5, (contentRect.size.height-image.size.height)*0.5, image.size.width, image.size.height);
    
    
    
}

+(CategoryButton *)buttonWithbuttonImage:(UIImage *)image{
    
    
    
    CategoryButton *button = [CategoryButton buttonWithType:(UIButtonTypeCustom)];
    
    if (image) {
        
        [button setImage:image forState:(UIControlStateNormal)];
    }
    

    return button;
    
}




@end






@implementation UIButton (Extension)


//设置button的正常背景图片和选中的背景图片
//设置button的正常背景图片和选中的背景图片
+(UIButton *)buttonWithNormalBgImage:(id)normalBgImage
                     selectedBgImage:(id)selectedBgImage
                              button:(UIButton *)button{
    
    if (button == nil) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    
    
    

    if (normalBgImage) {
        [button setBackgroundImage:[self imageWithparmsImage:normalBgImage] forState:(UIControlStateNormal)];
    }
    
    
    if (selectedBgImage) {
        
        [button setBackgroundImage:[self imageWithparmsImage:selectedBgImage] forState:(UIControlStateSelected)];
    }
    


    return button;
}


+(UIButton *)buttonWithNormalImage:(id)normalImage
                     selectedImage:(id)selectedImage
                            button:(UIButton *)button{
    
    
    
    if (button == nil) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    
    
    
    
    if (normalImage) {
        [button setImage:[self imageWithparmsImage:normalImage] forState:(UIControlStateNormal)];
    }
    
    
    if (selectedImage) {
        
        [button setImage:[self imageWithparmsImage:selectedImage] forState:(UIControlStateSelected)];
    }
    
    
    
    return button;
    
    
    
    
}







//设置button的正常状态的字体 和高亮状态下的字体
+(UIButton *)buttonWithTitle:(NSString *)title
                   titlefont:(CGFloat )fontNumber
            normalTitleColor:(UIColor *)normalColor
          selectedTitleColor:(UIColor *)selectedColor
                hightedColor:(UIColor *)hightedColor
                      button:(UIButton *)button{
    
    
    
    
    
    if (button == nil) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    
    [button setTitle:title forState:(UIControlStateNormal)];
    if (fontNumber != 0) {
        
        [button.titleLabel setFont:[UIFont systemFontOfSize:fontNumber]];
    }
    
    
    
    
    if (normalColor) {
        [button setTitleColor:normalColor forState:(UIControlStateNormal)];
    }
    
    if (selectedColor) {
         [button setTitleColor:selectedColor forState:(UIControlStateSelected)];
    }
    
    
    if (hightedColor) {
        [button  setTitleColor:hightedColor forState:(UIControlStateHighlighted)];
    }
    
    
    
    
    return button;
}



//设置button的正常状态的字体 和选中状态下的字体
+(UIButton *)buttonWithNormalTitle:(NSString *)normalTitle
                     selectedTitle:(NSString *)selectedTitle
                         titlefont:(CGFloat )fontNumber
                        titleColor:(UIColor *)titleColor
                            button:(UIButton *)button{
    if (button == nil) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    
    
    
    [button setTitle:normalTitle forState:(UIControlStateNormal)];
    
    if (selectedTitle) {
        
        [button setTitle:selectedTitle forState:(UIControlStateSelected)];
    }
    
    
    if (fontNumber != 0) {
        
        [button.titleLabel setFont:[UIFont systemFontOfSize:fontNumber]];
    }
    
    
    if (!titleColor) {
        titleColor = [UIColor blackColor];
    }
    

        [button setTitleColor:titleColor forState:(UIControlStateNormal)];

    
    
    return button;
    
    
    
}


//根据颜色 生成对应的背景图片，给button设置  正常状态下和高亮状态下
+(UIButton *)buttonWithNormalColor:(id)normalColor
                      hightedColor:(id)hightedColor
                     selectedColor:(id)selectedColor
                            Button:(UIButton *)button{
    if (button == nil) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    
    if (normalColor) {
        [button setBackgroundImage:[self imageWithColor:normalColor] forState:(UIControlStateNormal)];
        
    }
    
    if (selectedColor) {
        [button setBackgroundImage:[self imageWithColor:selectedColor] forState:(UIControlStateSelected)];

    }
    
    
    if (hightedColor) {
        
        [button setBackgroundImage:[self imageWithColor:hightedColor] forState:(UIControlStateHighlighted)];

    }
    

    return button;
}





+(UIButton *)buttonWithImage:(id)image
                       title:(NSString *)title
                   titlefont:(CGFloat)fontNumber
                  titleColor:(UIColor *)color
                      button:(UIButton *)button{
    
    
    if (button == nil) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    
     if (image) {
        [button setImage:[self imageWithparmsImage:image] forState:(UIControlStateNormal)];

    }
    
    
    if (title) {
        [button setTitle:title forState:(UIControlStateNormal)];
    }
    
    if (fontNumber != 0) {
        [button.titleLabel setFont:[UIFont systemFontOfSize:fontNumber]];
    }
    
    if (color) {
        [button setTitleColor:color forState:(UIControlStateNormal)];
    }
    return button;
}





+(UIImage *)imageWithColor:(id)UndeterminedColor{
    
    UIColor *color = nil;
    
    if ([UndeterminedColor isKindOfClass:[NSString class]] && [UndeterminedColor hasPrefix:@"#"]) {
        
        color = [UIColor colorWithHexString:UndeterminedColor alpha:1];
        
    }else if ([UndeterminedColor isKindOfClass:[UIColor class]]){
        
        color = UndeterminedColor;
    }else{
        
        color = [UIColor clearColor];
    }
    
  return [UIImage imageWithColor:color];
    
}


+(UIImage *)imageWithparmsImage:(id)parmsImage{
    

    UIImage *image = nil;
    
    if ([parmsImage isKindOfClass:[UIImage class]]) {
        image = parmsImage;
        
    }else if ([parmsImage isKindOfClass:[NSString class]]){
        
        image = [UIImage imageNamed:parmsImage];
    
     
    }
    
    
    
    return image;
    
}

-(void)buttonSpaceImageWithTitle:(CGFloat)space{
    
    space = space * 0.5;
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, -space, 0, space)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, space, 0, -space)];
    
    
    
    
    
}












+(__kindof UIButton *)buttonWithImage:(UIImage *)image{
    
    return [CategoryButton buttonWithImage:image];
    
}

+(__kindof UIButton *)createButton{
    
    
    return [UIButton buttonWithType:(UIButtonTypeCustom)];
}



@end
