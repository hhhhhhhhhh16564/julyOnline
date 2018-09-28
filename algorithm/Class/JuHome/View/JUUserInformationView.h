//
//  JUUserInformationView.h
//  algorithm
//
//  Created by 周磊 on 16/8/23.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JUUserInformationView : UIView
- (instancetype)initWithFrame:(CGRect)frame Image:(NSString *)imageName str:(NSString *)str;


@property(nonatomic, strong) NSString *str;

@end
