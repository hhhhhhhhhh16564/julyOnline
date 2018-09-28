//
//  JUUserInformationView.m
//  algorithm
//
//  Created by 周磊 on 16/8/23.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUUserInformationView.h"

@interface JUUserInformationView ()

@property(nonatomic, strong) UIImageView *imv;

@property(nonatomic, strong) UILabel *label;

@property(nonatomic, strong) NSString *imageName;


@end

@implementation JUUserInformationView



-(instancetype)initWithFrame:(CGRect)frame Image:(NSString *)imageName str:(NSString *)str{
    
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupVies];
        
     
        self.imageName = imageName;
        self.str = str;
        
        
        
    }
    return self;
    

}

-(void)setupVies{
    
    
    UIImageView *imageView = [[UIImageView alloc]init];
    
    [self addSubview:imageView];
    
    self.imv = imageView;
    
    
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = UIptfont(14);
    
    [self addSubview:label];
    
    self.label = label;
    

    
}

-(void)setImageName:(NSString *)imageName{
    if (!imageName) {
        return;
    }
    
    
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    self.imv.image = image;
    
}


-(void)setStr:(NSString *)str{
    
    if (!str) {
        
        return;
    }
    
    
    self.label.text = str;
    
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.imv.frame = CGRectMake(0, 0, 18, 18);
    [self.imv Y_centerInSuperView];
    
    
    self.label.frame = CGRectMake(self.imv.right_extension+8, 0, self.width_extension-26, 14);
    [self.label Y_centerInSuperView];
    
    
}






@end
