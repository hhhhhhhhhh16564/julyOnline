//
//  YBTitleView.m
//  algorithm
//
//  Created by 周磊 on 16/9/6.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "YBTitleView.h"
#import "YBTitleButton.h"
#import "UIView+Extension.h"

@interface YBTitleView ()

@property(nonatomic, strong) YBTitleButton *lastButton;

@property(nonatomic, strong) YBTitleButton *selectedButton;



@end




@implementation YBTitleView



-(UIView *)bottomLineView{
    
    if (_bottomLineView == nil) {
        _bottomLineView = [[UIView alloc]init];
        _bottomLineView.backgroundColor = Hmblue(1);
        _bottomLineView.layer.cornerRadius = 1;
        
        [self addSubview:_bottomLineView];
    }
    return _bottomLineView;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        
    }
    
    return self;
    
}


-(void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
  

  
    
    
        for (UIView *view in self.subviews) {
            
            if ([view isKindOfClass:[YBTitleButton class]]) {
                
                [view removeFromSuperview];
                
//                NSLog(@"%@", view);
                
            }
  
        }
        
    
    
    
    for (NSUInteger i = 0; i < titleArray.count; i++) {
        
        YBTitleButton *titleButton = [YBTitleButton buttonWithType:(UIButtonTypeCustom)];
  
        [titleButton setTitle:titleArray[i] forState:(UIControlStateNormal)];
        
        titleButton.tag = i+100;
        
        [titleButton addTarget:self action:@selector(titleButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
        [self addSubview:titleButton];

    }

    

    
    
    
    

}

-(void)titleButtonAction:(YBTitleButton *)titleButton{
    

    self.selectedButton.selected = NO;
    
    titleButton.selected = YES;
    
    self.selectedButton = titleButton;

    if (self.Blcok) {
        
        self.Blcok(titleButton);
    }

    CGRect rect = titleButton.frame;
    rect.size.width = self.width_extension;
    rect.origin.x = rect.origin.x-(self.width_extension/2-titleButton.width_extension/2);
    
    if (rect.origin.x < 0) {
        rect.origin.x = 0;
    }
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [self scrollRectToVisible:rect animated:NO];

        self.bottomLineView.width_extension = self.selectedButton.width_extension-self.buttonSpacing;
        self.bottomLineView.centerX_extension = self.selectedButton.centerX_extension;
        
    }];
    
    

}
-(void)titliButtonClicked:(NSUInteger)index{
    //如果传入的数值过大，什么也不做
    if (index > _titleArray.count-1)return;
        
    YBTitleButton *titleButton = (YBTitleButton *)[self viewWithTag:index+100];
    
    [self titleButtonAction:titleButton];
    
}

//button的间距
-(CGFloat)buttonSpacing{
    
    if (_buttonSpacing == 0) {
        _buttonSpacing = 10;
    }
    
    return _buttonSpacing;
}

//字体的大小

-(UIFont *)font{
    
    if (!_font) {
        
        //默认字体大小是15
        
        _font = [UIFont systemFontOfSize:15];
    }

    return _font;
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
  //因为这个方法会执行两次，所以清空
    self.lastButton = nil;
    

    for (NSUInteger i = 0; i < _titleArray.count; i++) {
        
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSFontAttributeName] = self.font;
        CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
        
        
      CGFloat buttonWidth =[_titleArray[i] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
        

        
        YBTitleButton *titleButton = (YBTitleButton *)[self viewWithTag:i+100];
        
        [titleButton.titleLabel setFont:self.font];
        
         buttonWidth = buttonWidth+self.buttonSpacing;
        
        CGFloat buttonHeight = self.height_extension;
        
        CGFloat buttonX = self.lastButton.right_extension;
        
        CGFloat buttonY = 0;
        
        titleButton.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
    
        self.lastButton = titleButton;
        
    }
    
    self.bottomLineView.frame = CGRectMake(0, self.height_extension-2, 0, 2);
    
    
    self.bottomLineView.width_extension = self.selectedButton.width_extension-self.buttonSpacing;
    self.bottomLineView.centerX_extension = self.selectedButton.centerX_extension;
    
    self.contentSize = CGSizeMake(self.lastButton.right_extension, self.height_extension);
    
}




@end
