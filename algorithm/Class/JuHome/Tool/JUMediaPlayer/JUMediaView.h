//
//  JUMediaView.h
//  algorithm
//
//  Created by 周磊 on 17/2/22.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUMediaViewDelagate.h"

@interface JUMediaView : UIView
-(instancetype)initWithFrame:(CGRect)frame;
@property(nonatomic, strong) UILabel *titleLabel;
//进度条
@property(nonatomic, strong) UISlider *slider;
// 缓冲条
@property(nonatomic, strong) UIProgressView *bufferProgressView;

@property(nonatomic, weak)UIView *FatherView;
//显示倍数的label
@property(nonatomic, strong) UILabel *multipleLabel;

@property(nonatomic, strong) UILabel *warningLabel;



@property (nonatomic,weak) id<JUMediaViewDelagate> delegate;
//是否正在进行手势操作
@property (nonatomic,assign,getter=isGestureManipulate) BOOL gestureManipulate;

//是否隐藏中间显示时间的timeLabel
@property (nonatomic,assign,getter=isShowHorizontalPanTimeLabel) BOOL showHorizontalPanTimeLabel;
//是否显示缓冲条
@property (nonatomic,assign, getter=isShowBufferProgress) BOOL showBufferProgress;
//是否自动屏幕旋转
@property (nonatomic,assign, getter=isAutoScreenRotation) BOOL autoScreenRotation;

//允许工具栏交互
@property (nonatomic,assign) BOOL allowToolBarResponsed;

//播放按钮状态
-(void)playButtonState:(BOOL)isPlay;

//重置
-(void)resetControlView;


//加载动画
-(void)loadAnimated:(BOOL)animated color:(UIColor *)color;

//更改时间
-(void)reFreshTimeLabelWithCurrentTiem:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime;






@end

































