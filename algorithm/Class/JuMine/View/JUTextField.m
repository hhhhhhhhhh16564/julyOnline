//
//  JUTextField.m
//  algorithm
//
//  Created by pro on 16/7/7.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUTextField.h"

@interface JUTextField ()<UITextFieldDelegate>

@property(nonatomic, strong) UIImageView *imv;

@property(nonatomic, strong) UIView *lineView;
@property(nonatomic, strong) NSString *imageName;


@end



@implementation JUTextField

-(instancetype)initWithImage:(NSString *)imageName placeholder:(NSString *)placeholder{
    
    self = [super init];
    
    if (self) {
        UIImageView *imv = [[UIImageView alloc]init];
        imv.image = [UIImage imageNamed:imageName];
        [self addSubview:imv];
//        imv.backgroundColor = [UIColor redColor];
        
        self.imv = imv;
        
        self.imageName = imageName;
        
        UITextField *tf = [[UITextField alloc]init];
        tf.font = UIptfont(14);
        tf.placeholder = placeholder;
        
//        tf.backgroundColor = [UIColor greenColor];
        [self addSubview:tf];
        
        self.tf = tf;
        self.tf.delegate = self;
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = HSpecialSeperatorline(1);
        [self addSubview:lineView];
        
        self.lineView = lineView;
        
        
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    __weak typeof(self) weakSelf = self;
    
    
    [self.imv mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.mas_left).offset(30);
        make.width.mas_equalTo(18);
        make.centerY.equalTo(weakSelf.mas_centerY);
    
        if([weakSelf.imageName isEqualToString:@"login_name_icon"]) {
            
            make.height.mas_equalTo(18);
            
        }else if([weakSelf.imageName isEqualToString:@"login_password_icon"]){
            
             make.height.mas_equalTo(20);
            
        }else if([weakSelf.imageName isEqualToString:@"login_mail_icon"]){
            
             make.height.mas_equalTo(14);
            
        }else{
            
            make.height.mas_equalTo(18);
            
        }
        
        
//        login_name_icon
//        login_password_icon

        
    }];
    
    [self.tf mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.imv.mas_right).with.offset(12);
        
        make.right.equalTo(weakSelf.mas_right).with.offset(-30);
        
        make.centerY.equalTo(weakSelf.mas_centerY);
        
        make.height.mas_equalTo(40);
        
        
    }];
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(weakSelf).with.offset(30);
        make.right.equalTo(weakSelf).with.offset(-30);
        make.bottom.equalTo(weakSelf);
        make.height.mas_equalTo(0.5);
        
        
        
    }];
    

    
    
}

-(BOOL)isHaveWord{
    
    return [self.tf.text length];
    
}



#pragma mark代理方法

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    self.isinput = YES;
    
    if ([self.delegate respondsToSelector:@selector(textfieldShouldEditing:)]) {
        
        [self.delegate textfieldShouldEditing:textField];
        
           }
    
    
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    self.isinput = NO;
    
    
    return YES;
}


-(BOOL)canBecomeFirstResponder{
    return YES;
}


@end
