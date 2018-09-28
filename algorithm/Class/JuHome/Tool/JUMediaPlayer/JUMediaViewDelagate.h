//
//  JUMediaViewDelagate.h
//  algorithm
//
//  Created by 周磊 on 17/2/23.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol JUMediaViewDelagate <NSObject>

-(void)ju_MediaView:(UIView *)mediaView doubleTapAction:(UITapGestureRecognizer *)sender;
-(void)ju_MediaView:(UIView *)mediaView panAction:(UIPanGestureRecognizer *)sender;
-(void)ju_MediaView:(UIView *)mediaView playButtonAction:(UIButton *)sender;
-(void)ju_MediaView:(UIView *)mediaView multipleButtonAction:(UIButton *)sender;

-(void)ju_MediaView:(UIView *)mediaView progressSliderTouchBegan:(UISlider *)sender;
-(void)ju_MediaView:(UIView *)mediaView progressSliderValueChanged:(UISlider *)sender;
-(void)ju_MediaView:(UIView *)mediaView progressSliderTouchEnded:(UISlider *)sender;

-(void)ju_MediaView:(UIView *)mediaView tapSliderAction:(UITapGestureRecognizer *)sender percentage:(CGFloat)percentage;

@end
