//
//  JUCourseCellView.m
//  algorithm
//
//  Created by pro on 16/7/6.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUCourseCellView.h"

@implementation JUCourseCellView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    
    self.centerLabel.font = UIptfont(14);
    self.centerLabel.textColor = [UIColor blackColor];

}

@end
