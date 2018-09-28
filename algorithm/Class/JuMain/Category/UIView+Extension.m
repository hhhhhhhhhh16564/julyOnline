

#import "UIView+Extension.h"

@implementation UIView (Extension)

/**
 *  x
 *
 *  @param extension_x <#extension_x description#>
 */

-(void)setX_extension:(CGFloat)x_extension{
    CGRect fram = self.frame;
    fram.origin.x = x_extension;
    self.frame = fram;
}

- (CGFloat)x_extension
{
    return self.frame.origin.x;
}





/**
 *  y
 *
 *  @param extension_y <#extension_y description#>
 */

-(void)setY_extension:(CGFloat)y_extension{
    
    CGRect frame = self.frame;
    
    frame.origin.y = y_extension;
    self.frame = frame;
    
}

- (CGFloat)y_extension
{
    return self.frame.origin.y;
}



/**
 *  width
 *
 *  @param extension_width <#extension_width description#>
 */


- (void)setWidth_extension:(CGFloat)width_extension{
    CGRect frame = self.frame;
    
    frame.size.width = width_extension;
    self.frame = frame;
}
- (CGFloat)width_extension
{
    return self.frame.size.width;
}



/**
 *  height
 *
 *  @param extension_height <#extension_height description#>
 */
- (void)setHeight_extension:(CGFloat)height_extension{
    CGRect frame = self.frame;
    frame.size.height = height_extension;
    self.frame = frame;
}

- (CGFloat)height_extension
{
    return self.frame.size.height;
}




/**
 *  centerx
 *
 *  @param extension_centerX <#extension_centerX description#>
 */
-(void)setCenterX_extension:(CGFloat)centerX_extension{
    CGPoint center = self.center;
    center.x = centerX_extension;

   self.center = center;
    
}



- (CGFloat)centerX_extension{
    return self.center.x;
}


/**
 *  centerY
 *
 *  @param extension_centerY <#extension_centerY description#>
 */
-(void)setCenterY_extension:(CGFloat)centerY_extension

{
    
    CGPoint center = self.center;
    center.y = centerY_extension;
    self.center = center;
    
}


- (CGFloat)centerY_extension
{
    return self.center.y;
}



/**
 *  size
 *
 *  @param extension_size <#extension_size description#>
 */

- (void)setSize_extension:(CGSize)size_extension
{
    CGRect frame = self.frame;
    frame.size = size_extension;
    self.frame = frame;
}

- (CGSize)size_extension
{
    return self.frame.size;
}

/**
 *  origin
 *
 *  @param extension_origin <#extension_origin description#>
 */
- (void)setOrigin_extension:(CGPoint)origin_extension
{
    CGRect frame = self.frame;
    frame.origin = origin_extension;
    self.frame = frame;
}

- (CGPoint)origin_extension{
    return self.frame.origin;
}


-(void)setBottom_extension:(CGFloat)bottom_extension{
    
    self.y_extension = bottom_extension - self.height_extension;
    
    
}


-(CGFloat)bottom_extension{
    
    
    return CGRectGetMaxY(self.frame);
}


-(CGFloat)right_extension{
    
    
    return CGRectGetMaxX(self.frame);
}



-(void)setRight_extension:(CGFloat)right_extension{
    
    self.x_extension = right_extension - self.width_extension;
    
    
}







-(NSString *)logframe{
    
    
    return NSStringFromCGRect(self.frame);
    
    
}




-(NSString *)logcenter{
    
    return NSStringFromCGPoint(self.center);
}




-(NSString *)logContentInset{
    
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scorllview = (UIScrollView *)self;
        return NSStringFromUIEdgeInsets(scorllview.contentInset);
        
    }else{
        
        return @"没有这个属性";
    }
    
    
}





//设置在父控件中X居中

-(void)X_centerInSuperView{
    
    if (!self.superview)return;
    
    self.x_extension = self.superview.width_extension*0.5-self.width_extension*0.5;
    
    
}

//设置在父控件中Y居中

-(void)Y_centerInSuperView{
    if (!self.superview)return;

    
    self.y_extension = self.superview.height_extension*0.5-self.height_extension*0.5;

    
}

//设置在父控件中XY居中

-(void)XY_centerInSuperView{

    if (!self.superview)return;

    self.x_extension = self.superview.width_extension*0.5-self.width_extension*0.5;
    self.y_extension = self.superview.height_extension*0.5-self.height_extension*0.5;

    
}


+ (instancetype)viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}



-(void)removeAllSubViews{
    
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
}
-(CGRect)rectInWindow{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    return [self convertRect:self.bounds toView:window];
    
}


-(BOOL)intersectWithView:(UIView *)view{
    
    
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if (view == nil) {
        view = window;
    }
    

    CGRect selfrRect = [self convertRect:self.bounds toView:window];
    
    CGRect viewRect = [view convertRect:view.bounds toView:window];
    
    
    return CGRectIntersectsRect(selfrRect, viewRect);
    
}

-(void)colorForSubviews{
    
    for (UIView *view in self.subviews) {
        UIColor *randColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1];
        
        view.backgroundColor = randColor;
        
    }
    
    
}

// 添加topLineView
-(UIView *)addTopLineViewHeight:(CGFloat)height Color:(UIColor *)color{
    
    UIView *topLineView = [[UIView alloc]init];
    topLineView.backgroundColor = color;
    topLineView.frame = CGRectMake(0, 0,CGRectGetWidth(self.bounds), height);
    [self addSubview:topLineView];
    
    return topLineView;
}

//添加bottonLineView

-(UIView *)addBottomLineViewHeight:(CGFloat)height Color:(UIColor *)color{
    
    
    UIView *bottomLineView = [[UIView alloc]init];
    bottomLineView.backgroundColor = color;
    bottomLineView.frame = CGRectMake(0, CGRectGetHeight(self.bounds)-height,CGRectGetWidth(self.bounds), height);
    [self addSubview:bottomLineView];
    
    return bottomLineView;
    
}



-(UIView *)addViewAtViewY:(CGFloat)ViewY viewHeight:(CGFloat)ViewHeight Color:(UIColor *)color{
    
    UIView *View = [[UIView alloc]init];
    View.backgroundColor = color;
    View.frame = CGRectMake(0, ViewY, CGRectGetWidth(self.bounds), ViewHeight);
    [self addSubview:View];
    
    return View;
    
    
}














@end
