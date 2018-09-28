//
//  JUChooseView.m
//  algorithm
//
//  Created by 周磊 on 16/8/24.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUChooseView.h"
#import "JUButton.h"


@interface JUChooseView ()


@property(nonatomic, strong) UIView *lineView;

@property(nonatomic, strong) JUButton *firstbutton;

@property(nonatomic, strong) JUButton *secondButton;

@property(nonatomic, strong) JUButton *selectedButton;

@property(nonatomic, strong) UILabel *label;

@end



@implementation JUChooseView



-(instancetype)initWithFrame:(CGRect)frame categoryString:(NSString *)categoryString{
    
    
    self = [super initWithFrame:frame];
    
    
    if (self) {
      
        self.backgroundColor = [UIColor whiteColor];

        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = HCommomSeperatorline(1);
        [self addSubview:lineView];
        self.lineView = lineView;
        
        
        UILabel *lable = [[UILabel alloc]init];
        lable.font = UIptfont(15);
        lable.text = categoryString;
        lable.textAlignment = NSTextAlignmentLeft;
        [self addSubview:lable];
        self.label = lable;
        
        
        
        JUButton *firstButton = [JUButton buttonWithType:(UIButtonTypeCustom)];
        
        [self buttonWithTitle:@"" button:firstButton];
        
        self.firstbutton = firstButton;
        
        
        
        JUButton *secondButton = [JUButton buttonWithType:(UIButtonTypeCustom)];
        
        [self buttonWithTitle:@"" button:secondButton];
        
        self.secondButton = secondButton;
        
        
        [self buttonAction:self.firstbutton];
           
        
    }
    
    
    
    
    
    return self;

    
}


-(void)buttonWithTitle:(NSString *)title button:(JUButton *)button{
    
    [button setTitle:title forState:(UIControlStateNormal)];
    
    [button setImage:[UIImage imageNamed:@"login_check_btn_pre"] forState:(UIControlStateSelected)];
    
    [button setImage:[UIImage imageNamed:@"login_check_btn"] forState:(UIControlStateNormal)];
    
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, -8)];
    
    [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    
    [self addSubview:button];
}


-(void)setArray:(NSArray<NSString *> *)array{
    
    _array = array;
    
    
    [self.firstbutton setTitle:array[0] forState:(UIControlStateNormal)];
    
    [self.secondButton setTitle:array[1] forState:(UIControlStateNormal)];
    
    
    
}


-(void)buttonAction:(JUButton *)button{
    
    if (button == self.selectedButton) {
        return;
    }

     self.selectedButton.selected = NO;
    
     button.selected = !button.selected;
    
     self.selectedButton = button;
    
    

    
    
    
    
    if (self.block) {
        
        self.block(button);
    }
    
}


//设置选中按钮的setter方法
-(void)setSeletedIndex:(NSUInteger)seletedIndex{
    
    if (seletedIndex == 0) {
        

        [self buttonAction:self.firstbutton];
        
    }else if (seletedIndex == 1){
        
        [self buttonAction:self.secondButton];
        
    }
    
}

//设置选中按钮的getter方法
-(NSUInteger)seletedIndex{
    
    if (self.selectedButton == self.firstbutton) {
      
        return 0;
        
    }else{
        return 1;
    }
}






-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.lineView.frame = CGRectMake(0, 0, self.width_extension, 0.5);
    self.lineView.bottom_extension = self.height_extension;
    
    self.label.frame = CGRectMake(0, 0, Kwidth*0.33, self.height_extension);


    
    self.firstbutton.frame = CGRectMake(self.label.right_extension, 0, Kwidth*0.25, self.height_extension);

    self.secondButton.frame = CGRectMake(self.firstbutton.right_extension, 0, Kwidth*0.25, self.height_extension);
    
    
}


















@end
