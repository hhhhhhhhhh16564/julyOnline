//
//  JUapplicantCell.m
//  algorithm
//
//  Created by 周磊 on 16/8/23.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUapplicantCell.h"

@interface JUapplicantCell ()


@end

@implementation JUapplicantCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    self.textLabel.textColor = [UIColor blackColor];
    self.textLabel.font = UIptfont(15);
    self.detailTextLabel.font = UIptfont(17);
    self.textLabel.textAlignment = NSTextAlignmentLeft;
    self.detailTextLabel.textAlignment = NSTextAlignmentRight;
    
    self.topSepratorView = [[UIView alloc]init];
    self.topSepratorView.backgroundColor = HCanvasColor(1);
    [self.contentView addSubview:self.topSepratorView];
    
    
   
    return self;
    
}





-(void)layoutSubviews{
    
    
    
    
    [super layoutSubviews];
    
    self.textLabel.x_extension = 12;
    
   self.detailTextLabel.right_extension = self.width_extension-38;
    
    self.accessoryView.x_extension = self.width_extension - 26;
    
    self.topSepratorView.frame = CGRectMake(0, 0, Kwidth, 1);
    
    
}











@end
