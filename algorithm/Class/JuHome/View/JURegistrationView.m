//
//  JURegistrationView.m
//  algorithm
//
//  Created by 周磊 on 16/8/22.
//  Copyright © 2016年 Julyonline. All rights reserved.
//



#import "JURegistrationView.h"
#import "JUUserInformationView.h"

#import "JUUserInfoModel.h"

@interface JURegistrationView ()

@property(nonatomic, strong) UIView *backView;

@property(nonatomic, strong) UIView *imageView;

@property(nonatomic, strong)JUUserInformationView *nameView;

@property(nonatomic, strong) JUUserInformationView *phoneView;

@property(nonatomic, strong) JUUserInformationView *qqView;

@end


@implementation JURegistrationView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupVies];
        
    }
    return self;
}

-(void)setupVies{
    
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    self.backView = backView;
    [self addSubview:backView];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"apply_icon_arrow"]];
    [self addSubview:imageView];
    self.imageView = imageView;
    
    
    
    JUUserInformationView *nameView = [[JUUserInformationView alloc]initWithFrame:CGRectZero Image:@"apply_icon_name" str:@""];
    self.nameView = nameView;
    
    [self addSubview:nameView];
    
    
    
    

    JUUserInformationView *phoneView = [[JUUserInformationView alloc]initWithFrame:CGRectZero Image:@"apply_icon_phone" str:@""];
    self.phoneView = phoneView;
    
    [self addSubview:_phoneView];
    
    
    
    
    JUUserInformationView *qqView = [[JUUserInformationView alloc]initWithFrame:CGRectZero Image:@"apply_icon_qq" str:@""];
    self.qqView = qqView;
    
    [self addSubview:qqView];

}


-(void)drawRect:(CGRect)rect{
    
    UIImage *whiteImage = [UIImage imageWithColor:[UIColor whiteColor]];
    [whiteImage drawAsPatternInRect:rect];
    
    // 27  4.5
    UIImage *image = [UIImage imageNamed:@"apply_sign_color"];
    
    [image drawAsPatternInRect:rect];

}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    self.backView.height_extension = 91;
    self.backView.width_extension = Kwidth;
    [self.backView XY_centerInSuperView];
    
    
    self.imageView.frame = CGRectMake(self.width_extension-26, 0, 14, 14);
    
    [self.imageView Y_centerInSuperView];
    
    
    
    self.nameView.frame = CGRectMake(12, 20, Kwidth *0.35, 18);
    
    self.phoneView.frame = CGRectMake(self.nameView.right_extension, self.nameView.y_extension, Kwidth *0.4, self.nameView.height_extension);
    
    
    self.qqView.frame = CGRectMake(self.nameView.x_extension, self.nameView.bottom_extension+20, self.nameView.width_extension, self.nameView.height_extension);
    

    
}




//-(void)setName:(NSString *)name{
//    
//    _name = name;
//    
//    self.nameView.str = name;
//    
//}
//
//-(void)setPhoneNumber:(NSString *)phoneNumber{
//    
//    _phoneNumber = phoneNumber;
//    
//    self.phoneView.str = phoneNumber;
//    
//}
//
//-(void)setQqNumber:(NSString *)qqNumber{
//    
//    _qqNumber = qqNumber;
//    
//    self.qqView.str = qqNumber;
//    
//    
//}

-(void)setUserInfoModel:(JUUserInfoModel *)userInfoModel{
    
    _userInfoModel = userInfoModel;
    
    self.nameView.str = userInfoModel.real_name;

    self.phoneView.str = userInfoModel.cellphone;

    
    self.qqView.str = userInfoModel.qq;

    
    
}











@end










