
#import "UIImage+Ex.h"

@implementation UIImage (Ex)
+ (instancetype)originalImage:(NSString *)name {
    UIImage *img = [UIImage imageNamed:name];
    return [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//根据颜色生成一定大小的背景图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
        
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    
    
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;

    
    
}


@end
