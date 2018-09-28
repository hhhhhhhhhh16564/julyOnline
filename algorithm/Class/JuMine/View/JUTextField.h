//
//  JUTextField.h
//  algorithm
//
//  Created by pro on 16/7/7.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JUTextField;

@protocol JUTextFieldDelegat <NSObject>

-(void)textfieldShouldEditing:(UITextField *)textfield;

@end



@interface JUTextField : UIView
@property(nonatomic, strong) UITextField *tf;

//第一响应者不天会用，用这个属性判断是否在输入
@property(nonatomic, assign) BOOL isinput;

//输入框是否有文字
@property(nonatomic, assign) BOOL isHaveWord;


@property(nonatomic, weak) id<JUTextFieldDelegat> delegate;


-(instancetype)initWithImage:(NSString *)imageName placeholder:(NSString *)placeholder;


@end
