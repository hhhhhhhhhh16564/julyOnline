//
//  GMToast.m
//  GomeEShop
//
//  Created by hu xuesen on 13-3-19.
//  Copyright (c) 2013年 zywx. All rights reserved.
//

#import "GMToast.h"
//#import "GMComVariable.h"

@interface GMToast ()

@property(nonatomic, strong) NSTimer *timer;
@end


@implementation GMToast

#define minWidth    150
#define maxWidth    200
#define toastheight 120

@synthesize textLable;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithView:(UIView*)view text:(NSString*)text duration:(float)inDuration customWidth:(CGFloat)customWidth{
    
    int width = minWidth;
    int height = toastheight;
    CGSize size = [self sizeWithText:text font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(width-20, MAXFLOAT)];
    
    JULog(@"%f  %f", size.width, size.height);
    
    if (size.width > width-20)
    {
        if (size.width < maxWidth-20)
        {
            width = ceilf(size.width)+20;
            height = ceilf(size.height)+20;
        }
        else
        {
            width = maxWidth;
            CGSize size1 = [self sizeWithText:text font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(width-20, MAXFLOAT)];
            if (size1.height < toastheight-20)
            {
                height = ceilf(size1.height) + 20;
            }
        }
    }
    else
    {
        
        width = ceilf(size.width)+20;
        height = ceilf(size.height)+20;
    }
    
    width = width + 35;
    height = height-10;
    
    CGRect rect = CGRectMake((view.bounds.size.width-width)/2, (view.bounds.size.height-height)/2, width, height);
    self = [super initWithFrame:rect];
    if (self) {
        // Initialization code
        self.layer.cornerRadius = 6;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        self.alpha = 0;
        
        duration = inDuration;
        
        textLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.bounds.size.width-20, height-20)];
        textLable.backgroundColor = [UIColor clearColor];
        textLable.font = [UIFont systemFontOfSize:15];
        textLable.textColor = [UIColor whiteColor];
        textLable.textAlignment = NSTextAlignmentCenter;
        textLable.numberOfLines = 0;
        //        textLable.lineBreakMode = g_LineBreakByCharWrapping;
        textLable.text = text;
        [self addSubview:textLable];
        
        [view addSubview:self];
        
        [view XY_centerInSuperView];
        [textLable XY_centerInSuperView];
    }
    return self;
    
    
    
}


- (id)initWithView:(UIView*)view text:(NSString*)text duration:(float)inDuration
{
    int width = minWidth;
    int height = toastheight;
    CGSize size = [self sizeWithText:text font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(width-20, MAXFLOAT)];
    if (size.width > width-20)
    {
        if (size.width < maxWidth-20)
        {
            width = ceilf(size.width)+20;
            height = ceilf(size.height)+20;
        }
        else
        {
            width = maxWidth;
            CGSize size1 = [self sizeWithText:text font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(width-20, MAXFLOAT)];
            if (size1.height < toastheight-20)
            {
                height = ceilf(size1.height) + 20;
            }
        }
    }
    else
    {
        width = ceilf(size.width)+20;
        height = ceilf(size.height)+20;
    }
    
    CGRect rect = CGRectMake((view.bounds.size.width-width)/2, (view.bounds.size.height-height)/2, width, height);
    self = [super initWithFrame:rect];
    if (self) {
        // Initialization code
        self.layer.cornerRadius = 6;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        self.alpha = 0;
        
        duration = inDuration;
        
        textLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.bounds.size.width-20, height-20)];
        textLable.backgroundColor = [UIColor clearColor];
        textLable.font = [UIFont systemFontOfSize:15];
        textLable.textColor = [UIColor whiteColor];
        textLable.textAlignment = NSTextAlignmentCenter;
        textLable.numberOfLines = 0;
//        textLable.lineBreakMode = g_LineBreakByCharWrapping;
        textLable.text = text;
        [self addSubview:textLable];
        
        [view addSubview:self];
    }
    return self;
}

- (void)show {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    }];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(closeToast) userInfo:nil repeats:NO];
    self.timer = timer;
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)closeToast{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    if (!text || !text.length) {
        return CGSizeZero;
    }
    
    NSDictionary *attrs = @{NSFontAttributeName : font};
    
    CGRect rect = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    
    return rect.size;
}
- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
    
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
