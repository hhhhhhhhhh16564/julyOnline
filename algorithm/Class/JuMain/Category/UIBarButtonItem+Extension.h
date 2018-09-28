

#import <UIKit/UIKit.h>


@interface UIBarButtonItem (Extension)
//图片的
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;


-(UIBarButtonItem *)itemWithtitlesize:(CGFloat)fontsize color:(UIColor *)titleColor UIBarButonItem:(UIBarButtonItem *)barButtonItem;

//文字的
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action title:(NSString *)title;

@end
