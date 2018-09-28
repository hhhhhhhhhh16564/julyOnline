//
//  JUShareButton.m
//  algorithm
//
//  Created by 周磊 on 16/10/14.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUShareButton.h"

@implementation JUShareButton





-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageView.y_extension = 0;
    self.imageView.centerX_extension = self.width_extension*0.5;
    
    self.titleLabel.width_extension = self.width_extension+30;
    self.titleLabel.x_extension = -15;

    self.titleLabel.bottom_extension = self.height_extension-9;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = UIptfont(13);
    self.titleLabel.textColor = Kcolor16rgb(@"333333", 1);
}








@end
