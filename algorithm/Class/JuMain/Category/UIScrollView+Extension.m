//
//  UIScrollView+Extension.m
//  ybRefreshExample
//
//  Created by 周磊 on 16/12/1.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "UIScrollView+Extension.h"

@implementation UIScrollView (Extension)


- (void)setYb_insetT:(CGFloat)yb_insetT
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = yb_insetT;
    self.contentInset = inset;
}

- (CGFloat)yb_insetT
{
    return self.contentInset.top;
}

- (void)setYb_insetB:(CGFloat)yb_insetB
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = yb_insetB;
    self.contentInset = inset;
}

- (CGFloat)yb_insetB
{
    return self.contentInset.bottom;
}

- (void)setYb_insetL:(CGFloat)yb_insetL
{
    UIEdgeInsets inset = self.contentInset;
    inset.left = yb_insetL;
    self.contentInset = inset;
}

- (CGFloat)yb_insetL
{
    return self.contentInset.left;
}

- (void)setYb_insetR:(CGFloat)yb_insetR
{
    UIEdgeInsets inset = self.contentInset;
    inset.right = yb_insetR;
    self.contentInset = inset;
}

- (CGFloat)yb_insetR
{
    return self.contentInset.right;
}

- (void)setYb_offsetX:(CGFloat)yb_offsetX
{
    CGPoint offset = self.contentOffset;
    offset.x = yb_offsetX;
    self.contentOffset = offset;
}

- (CGFloat)yb_offsetX
{
    return self.contentOffset.x;
}

- (void)setYb_offsetY:(CGFloat)yb_offsetY
{
    CGPoint offset = self.contentOffset;
    offset.y = yb_offsetY;
    self.contentOffset = offset;
}

- (CGFloat)yb_offsetY
{
    return self.contentOffset.y;
}

- (void)setYb_contentW:(CGFloat)yb_contentW
{
    CGSize size = self.contentSize;
    size.width = yb_contentW;
    self.contentSize = size;
}

- (CGFloat)yb_contentW
{
    return self.contentSize.width;
}

- (void)setYb_contentH:(CGFloat)yb_contentH
{
    CGSize size = self.contentSize;
    size.height = yb_contentH;
    self.contentSize = size;
}

- (CGFloat)yb_contentH
{
    return self.contentSize.height;
}








@end
