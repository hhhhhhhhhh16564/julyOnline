//
//  JUBaseTableViewCell.m
//  七月算法_iPad
//
//  Created by 周磊 on 16/6/1.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUBaseTableViewCell.h"

@implementation JUBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self p_setupViews];
        
        
    }
    return self;
    
    
    
    
}

/**
 *  自雷去实现该方法
 */
-(void)p_setupViews{
    
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
