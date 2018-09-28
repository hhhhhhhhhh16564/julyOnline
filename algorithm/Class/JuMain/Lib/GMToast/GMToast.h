//
//  GMToast.h
//  GomeEShop
//
//  Created by hu xuesen on 13-3-19.
//  Copyright (c) 2013年 zywx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMToast : UIView
{
    float duration;
}

@property (nonatomic,strong) UILabel *textLable;
- (id)initWithView:(UIView*)view text:(NSString*)text duration:(float)inDuration;

- (id)initWithView:(UIView*)view text:(NSString*)text duration:(float)inDuration customWidth:(CGFloat)customWidth;


- (void)show;

@end
