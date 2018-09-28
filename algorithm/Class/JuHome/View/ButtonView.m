//
//  ButtonView.m
//  algorithm
//
//  Created by pro on 16/7/13.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "ButtonView.h"
#import "JUButton.h"

@interface ButtonView ()
@property(nonatomic, strong) NSArray *titleArray;

@property(nonatomic, strong) NSMutableArray *buttonArray;
@property(nonatomic, strong) JUButton *selectedButton;
@property(nonatomic, strong) UIView *lineView;

@end

@implementation ButtonView

-(NSMutableArray *)buttonArray{
    
    if (_buttonArray == nil) {
        _buttonArray = [NSMutableArray array];
    }
    
    return _buttonArray;
    
}


-(instancetype)initWithTitleArray:(NSArray *)titleArray{
    self = [super init];
    
    if (self) {
        self.titleArray = titleArray;
        [self p_setupViews];
    }
    
    return self;
    
}

-(void)p_setupViews{
  
    for (int i = 0 ; i < self.titleArray.count; i++) {
        
        JUButton *button = [JUButton buttonWithType:(UIButtonTypeCustom)];
        button.tag = 1000+i;
        [self.buttonArray addObject:button];
        
        [self addSubview:button];
        
    }
    
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    self.lineView = lineView;
    
  
    
}
//设置buton的属性
-(void)setButtonAttribute:(JUButton *)button{
    NSInteger index = button.tag - 1000;
    

  
    if (self.normalTitleColor) {
        [button setTitleColor:self.normalTitleColor forState:(UIControlStateNormal)];
    }
    
    if (self.selectedTitleColor) {
      [button setTitleColor:self.selectedTitleColor forState:(UIControlStateSelected)];


    }
    
    if ([self.titleArray[index] isKindOfClass:[NSString class]]) {
    [button setTitle:self.titleArray[index] forState:(UIControlStateNormal)];
    }
    
    if (self.fontsize) {
        
        [button.titleLabel setFont:[UIFont systemFontOfSize:self.fontsize]];
    }
    
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)setButtonClicked:(NSInteger)index{
  
 
    JUButton *button = [self viewWithTag:index+1000];
    [self buttonClicked:button];
    
    
}


-(void)buttonClicked:(JUButton *)button{
    
    if (self.selectedButton != button) {

        self.selectedButton.selected = NO;
        button.selected = !button.selected;
        self.selectedButton = button;
        
//        CGFloat buttonWidth = self.width_extension/self.titleArray.count;
         NSInteger index = self.selectedButton.tag - 1000;
        
        if (self.indexBlock) {
            
            self.indexBlock(index);
            
        }
        
       //设置需要刷新
        [UIView animateWithDuration:0.5 animations:^{
            
            [self setNeedsLayout];
            
        }];
        
      

    }
    
}


-(void)layoutSubviews{
    
    
    [super layoutSubviews];
     __weak typeof(self) weakSelf = self;
    
    if (self.lineColor) {
        self.lineView.backgroundColor = self.lineColor;
    }
    
    CGFloat buttonWidth = self.width_extension/weakSelf.titleArray.count;
    
 
        [self.buttonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            JUButton *button = obj;
            [weakSelf setButtonAttribute:button];
            
            
            [button mas_remakeConstraints:^(MASConstraintMaker *make) {

                make.width.mas_equalTo(buttonWidth);
                make.centerY.equalTo(weakSelf.mas_centerY);
                make.left.equalTo(weakSelf.mas_left).offset(idx * buttonWidth);

               
            }];
            
            
        }];
        

    
//    NSInteger index = self.selectedButton.tag - 1000;
//    JULog(@"%@", self.selectedButton);
    
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(1.5);
        make.bottom.equalTo(weakSelf.mas_bottom);
        if (self.button_Width) {
            make.width.mas_equalTo(self.button_Width).priorityMedium(100);
            
    
        }else{
           make.width.mas_equalTo(buttonWidth);
       
        }
        
      
        if (self.selectedButton) {
            make.centerX.equalTo(self.selectedButton);
            
        }
        
        
        
    }];
    

    
}





@end
