

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x_extension;
@property (nonatomic, assign) CGFloat y_extension;
@property (nonatomic, assign) CGFloat centerX_extension;
@property (nonatomic, assign) CGFloat centerY_extension;
@property (nonatomic, assign) CGFloat width_extension;
@property (nonatomic, assign) CGFloat height_extension;
@property (nonatomic, assign) CGSize size_extension;
@property (nonatomic, assign) CGPoint origin_extension;




//设置最底部
@property (nonatomic,assign) CGFloat bottom_extension;
//设置最右边
@property (nonatomic,assign) CGFloat right_extension;






//

//为了打印frame方便
@property(nonatomic, strong,readonly) NSString *logframe;

@property(nonatomic, strong,readonly) NSString *logcenter;

@property(nonatomic, strong,readonly) NSString *logContentInset;






//  设置  当前视图在父视图中的位置， x居中   y居中   xy居中

#pragma mark 必须先设置宽度和高度, 并且已经添加到父视图中
//设置在父控件中X居中

-(void)X_centerInSuperView;

//设置在父控件中Y居中

-(void)Y_centerInSuperView;

//设置在父控件中XY居中

-(void)XY_centerInSuperView;



+ (instancetype)viewFromXib;


//移除所有的子控件
-(void)removeAllSubViews;


// 该View在Window上的frame

-(CGRect)rectInWindow;


//是否与某个view重叠

-(BOOL)intersectWithView:(UIView *)view;




//调试 设置子控件的颜色

-(void)colorForSubviews;





// 添加topLineView
-(UIView *)addTopLineViewHeight:(CGFloat)height Color:(UIColor *)color;

//添加bottonLineView

-(UIView *)addBottomLineViewHeight:(CGFloat)height Color:(UIColor *)color;



// 在某个个高度上添加一个高度的View

-(UIView *)addViewAtViewY:(CGFloat)ViewY viewHeight:(CGFloat)ViewHeight Color:(UIColor *)color;




@end
