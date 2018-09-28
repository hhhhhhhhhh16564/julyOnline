//
//  JUMenuView.m
//  algorithm
//
//  Created by 周磊 on 16/10/17.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUMenuView.h"



#import "UIView+Extension.h"

@interface JUMenuView ()

{
    
    CGFloat _margin;
}

@property(nonatomic, strong) YBTitleButton *selectedButton;

@property(nonatomic, strong) UIView *topLineView;

@end


@implementation JUMenuView

-(UIView *)topLineView{
    
    if (!_topLineView) {
        
        _topLineView = [[UIView alloc]init];
        _topLineView.backgroundColor = HCanvasColor(1);
        
        [self addSubview:_topLineView];
        
    }
    return _topLineView;
}





- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        _margin = 11;
    }
    return self;
}


-(void)setButtonArray:(NSArray<NSString *> *)buttonArray{
    
    _buttonArray = buttonArray;
    
    
    NSUInteger count = buttonArray.count;
    

    for (NSUInteger i = 0; i < count; i++) {
        
        YBTitleButton *titleButton = [YBTitleButton buttonWithType:(UIButtonTypeCustom)];
//        [titleButton setTitle:buttonArray[i] forState:(UIControlStateNormal)];
    
//        titleButton.layer.cornerRadius = 5;
//        titleButton.layer.borderWidth = 1;
//        titleButton.layer.borderColor = [HSpecialSeperatorline(1) CGColor];
//        titleButton.layer.masksToBounds = YES;

        
        UIColor *normalColor = Kcolor16rgb(@"#F4F4F4", 1);
        
        [UIButton buttonWithNormalColor:normalColor hightedColor:nil selectedColor:[UIColor whiteColor] Button:titleButton];
        
        UIColor *blueColor = Kcolor16rgb(@"#0099ff", 1);
        
        [UIButton buttonWithTitle:buttonArray[i] titlefont:14 normalTitleColor:[UIColor blackColor] selectedTitleColor:blueColor hightedColor:nil button:titleButton];
        
        titleButton.tag = i+100;
        
        [titleButton addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self addSubview:titleButton];
        
    }
    
}


-(void)MenubuttonClicked:(NSUInteger)index{
    //如果传入的数值过大，什么也不做
    if (index > _buttonArray.count-1)return;
    
    
    self.clickType = 0;
    
    self.isClicked = NO;
    
    YBTitleButton *MenuButton = (YBTitleButton *)[self viewWithTag:index+100];
    
    self.clickType = 2;
    
    [self buttonAction:MenuButton ];
    
    self.clickType = 1;
    
    self.isClicked = YES;

    
}


-(void)buttonAction:(YBTitleButton *)button{
    if (self.selectedButton == button) return;
    
    if (self.clickType == 2) {

        
    }else{
        
        self.clickType  = 1;
                
    }
    
    
    self.selectedButton.selected = !self.selectedButton.selected;
    
    button.selected = !button.selected;
    
    self.selectedButton = button;
    
    
    
    if (self.buttonBlcok) {
        
        self.buttonBlcok(button);
    }
    
}


//button的间距
-(CGFloat)buttonSpacing{
    
    if (_buttonSpacing == 0) {
        _buttonSpacing = 11;
    }
    
    return _buttonSpacing;
}

//字体的大小

-(UIFont *)font{
    
    if (!_font) {
        
        //默认字体大小是15
        
        _font = [UIFont systemFontOfSize:14];
    }
    
    return _font;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    int lineCount = 4;
    
    if (ISIPhone4 | ISIPhone5) {
        
        lineCount = 3;
        
    }
    
    self.topLineView.frame = CGRectMake(0, -0.5, Kwidth, 1);
    
    CGFloat buttonWidth = (Kwidth-_margin*2-self.buttonSpacing*(lineCount-1))/lineCount;
    CGFloat buttonHeight = 30;
    
    for (int i = 0; i < _buttonArray.count; i++) {
        YBTitleButton *titleButton = (YBTitleButton *)[self viewWithTag:i+100];
        
        int row = i/lineCount;
        int line = i%lineCount;

        CGFloat buttonX = (buttonWidth+self.buttonSpacing)*line;
        
        CGFloat buttonY = (buttonHeight+_margin)*row;
        
        titleButton.frame = CGRectMake(buttonX+_margin, buttonY+_margin, buttonWidth, buttonHeight);
        
        if (i == _buttonArray.count-1) {
            
//            JULog(@"%@", titleButton.logframe);
            
            self.height_extension = titleButton.bottom_extension+_margin;
        
        }
        
    }
 
    
}


@end
