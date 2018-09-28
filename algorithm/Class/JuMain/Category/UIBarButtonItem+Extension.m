

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)
/**
 *  创建一个item
 *  
 *  @param target    点击item后调用哪个对象的方法
 *  @param action    点击item后调用target的哪个方法
 *  @param image     图片
 *  @param highImage 高亮的图片
 *
 *  @return 创建完的item
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage
{
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    
    if (highImage) {
        
        [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
  
    }
    
    // 设置尺寸
    CGSize size = btn.currentImage.size;
   
    btn.size_extension = CGSizeMake(size.width+5, size.height+5);
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

/**
 *
 *
 *

 */

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action title:(NSString *)title{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
   
    [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    
//    [btn setBackgroundColor:[UIColor redColor]];
    
    [btn setTitle:title forState:(UIControlStateNormal)];
    [btn setTitleColor:Hmblue(1)forState:(UIControlStateNormal)];
    
    [btn.titleLabel setFont:UIptfont(14)];
    
    btn.size_extension = CGSizeMake(30, 30);
//    [btn setImage:[UIImage imageNamed:@"delete"] forState:(UIControlStateNormal)];

    return [[UIBarButtonItem alloc] initWithCustomView:btn];
  
}

-(UIBarButtonItem *)itemWithtitlesize:(CGFloat)fontsize color:(UIColor *)titleColor UIBarButonItem:(UIBarButtonItem *)barButtonItem{
    
    
    
    // 设置普通状态
    // key：NS****AttributeName
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = titleColor;
    
    
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:fontsize];
    
    [barButtonItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    

    
    return barButtonItem;
    
    
}


@end
