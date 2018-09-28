//
//  JUMediaView.m
//  algorithm
//
//  Created by 周磊 on 17/2/22.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUMediaView.h"
#import "Masonry.h"
#import <CoreMotion/CoreMotion.h>


@interface  JUMediaView ()<UIGestureRecognizerDelegate>

//顶部的view
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UIButton *multipleButton;

//返回的按钮
@property(nonatomic, strong) UIButton *backButton;

@property(nonatomic, strong)UIActivityIndicatorView *activity;
@property(nonatomic, strong) UILabel *horizontalPanTimeLabel;

@property(nonatomic, strong) UIView *bottomView;
@property(nonatomic, strong) UIButton *playButton;
@property(nonatomic, strong) UILabel *timeLabel;
//全屏半屏 切换的button
@property(nonatomic, strong) UIButton *switchButton;

//是否是全屏播放
@property (nonatomic,assign,getter=isFullScreen) BOOL fullScreen;
/** 显示控制层 */
@property (nonatomic, assign, getter=isShowingControlView) BOOL showingControlView;

@property(nonatomic, strong) CMMotionManager *mManager;

@property (nonatomic,assign, getter=isSwitchOperation) BOOL switchOperation;

@end


@implementation JUMediaView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor blackColor];
    if (self) {
        
        [self set_upSubView];
        [self addgesture];
        [self resetControlView];
        
    }

    return self;
}

-(CMMotionManager *)mManager{
    
    if (!_mManager) {
        _mManager = [[CMMotionManager alloc]init];
    }
    
    return _mManager;
}





-(UIProgressView *)bufferProgressView{
    if (!_bufferProgressView) {
        _bufferProgressView = [[UIProgressView alloc]init];
        [_bufferProgressView setProgressTintColor:kColorRGB(0, 124, 255, 1)];
    }
    return _bufferProgressView;
}


-(UIActivityIndicatorView *)activity{
    if (!_activity) {
        _activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activity.userInteractionEnabled = NO;
        _activity.color = [UIColor blackColor];
    }
    return _activity;
}
   //顶部的View
-(UIView *)topView{
    
    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = Kcolor16rgb(@"#000000", 0.7);
    }
    return _topView;
}

-(UIButton *)multipleButton{
    if (!_multipleButton) {
        _multipleButton =[UIButton buttonWithType:(UIButtonTypeCustom)];
        [_multipleButton addTarget:self action:@selector(multipleButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _multipleButton;
}

-(UILabel *)multipleLabel{
    if (!_multipleLabel) {
        _multipleLabel = [[UILabel alloc]init];
        _multipleLabel.alpha = 0;
        _multipleLabel.userInteractionEnabled = NO;
        _multipleLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        _multipleLabel.font = UIptfont(15);
        _multipleLabel.textColor = [UIColor whiteColor];
        _multipleLabel.layer.borderWidth = 1;
        _multipleLabel.layer.cornerRadius = 2;
        _multipleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    
    return _multipleLabel;
    
}






//返回按钮
-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_backButton setImage:[UIImage imageNamed:@"vidio_back_btn"] forState:(UIControlStateNormal)];
        [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _backButton;
}

//标题按钮
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
         _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = UIptfont(15);
        _titleLabel.textColor = Kcolor16rgb(@"ffffff", 1);
    }
    return _titleLabel;
}

-(UILabel *)horizontalPanTimeLabel{
    if (!_horizontalPanTimeLabel) {
        _horizontalPanTimeLabel = [[UILabel alloc]init];
        _horizontalPanTimeLabel.userInteractionEnabled = NO;
        _horizontalPanTimeLabel.textAlignment = NSTextAlignmentCenter;
        _horizontalPanTimeLabel.textColor = [UIColor whiteColor];
        _horizontalPanTimeLabel.backgroundColor = Kcolor16rgb(@"#000000", 1);
    }
    return _horizontalPanTimeLabel;
}

-(UILabel *)warningLabel{
    if (!_warningLabel) {
        _warningLabel = [[UILabel alloc]init];
        _warningLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        _warningLabel.textColor = [UIColor whiteColor];
        _warningLabel.textAlignment = NSTextAlignmentCenter;
        _warningLabel.text = @"视频资源发生错误";
        _warningLabel.userInteractionEnabled = NO;
        _warningLabel.font = UIptfont(16);
        _warningLabel.layer.cornerRadius = 3;
        
    }
    
    return _warningLabel;
    
}


//底部的View
-(UIView *)bottomView{
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = Kcolor16rgb(@"#000000", 0.7);
    }
    return _bottomView;
}

-(UIButton *)playButton{
    if (!_playButton) {
     _playButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_playButton setImage:[UIImage imageNamed:@"video_play_btn"] forState:(UIControlStateNormal)];
    _playButton.showsTouchWhenHighlighted = YES;
    [_playButton setImage:[UIImage imageNamed:@"video_pause_btn"] forState:(UIControlStateSelected)];
    [_playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _playButton;
}

-(UISlider *)slider{
    if (!_slider) {
       _slider = [[UISlider alloc]init];
        _slider.layer.cornerRadius = 1.5;
        [_slider setThumbImage:[UIImage imageNamed:@"time_key"] forState:(UIControlStateNormal)];
        [_slider setMinimumTrackTintColor:Hmblue(1)];
        UIColor *tintColor = Kcolor16rgb(@"#282828", 1)
        [_slider setMaximumTrackTintColor:tintColor];
        
        // slider开始滑动事件
        [_slider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [_slider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [_slider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];

        UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSliderAction:)];
        [_slider addGestureRecognizer:sliderTap];
        
        
        
    }
    return _slider;
}
-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = UIptfont(11);
        _timeLabel.textColor = Kcolor16rgb(@"b4b4b4", 1);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
    
}

-(UIButton *)switchButton{
    if (!_switchButton) {
        _switchButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_switchButton addTarget:self action:@selector(switchAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_switchButton setImage:[UIImage imageNamed:@"video_fullScreen_btn"] forState:(UIControlStateNormal)];
    }
    
    return _switchButton;
}



-(void)set_upSubView{
    
    [self addSubview:self.activity];
    
    [self addSubview:self.topView];
    [self.topView addSubview:self.backButton];
    [self.topView addSubview:self.titleLabel];
    [self.topView addSubview:self.multipleButton];
    [self.multipleButton addSubview:self.multipleLabel];
    
    
    [self addSubview:self.horizontalPanTimeLabel];
    [self addSubview:self.bottomView];
    [self addSubview:self.warningLabel];
    
    [self.bottomView addSubview:self.bufferProgressView];
    [self.bottomView addSubview:self.playButton];
    [self.bottomView addSubview:self.slider];
    [self.bottomView addSubview:self.timeLabel];
    [self.bottomView addSubview:self.switchButton];
    
}


#pragma mark 添加手势
-(void)addgesture{
    //单击手势
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.numberOfTapsRequired = 1; // 单击
    singleTap.delegate = self;
    [self addGestureRecognizer:singleTap];
    
    //双击手势
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2; // 双击
    doubleTap.delegate = self;
    [self addGestureRecognizer:doubleTap];
    
    //平移手势
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    pan.delegate = self;
    [self addGestureRecognizer:pan];
  
}


#pragma mark 设置约束

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.activity mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.warningLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(180, 50));
    }];
    
    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
        
    }];
    
    //图片大小伟11*20
    [self.backButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(70, 50));
        make.centerY.equalTo(self.topView);
    }];
    
    [self.multipleButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 50));
        make.right.equalTo(self.topView.mas_right).offset(-30);
        make.centerY.equalTo(self.topView);
        
    }];
    
    [self.multipleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.multipleButton);
        make.size.mas_equalTo(CGSizeMake(80, 30));
        
    }];
    
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backButton.mas_right).offset(0);
        make.centerY.equalTo(self.backButton);
        
    }];
    
    
    [self.horizontalPanTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(150, 40));
        
    }];
    
    
    //底部的view
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    
    [self.playButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.centerY.equalTo(self.bottomView);
        
    }];
    
    [self.slider mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.playButton.mas_right).offset(0);
        make.height.mas_equalTo(50);
        make.centerY.equalTo(self.bottomView);
        make.right.equalTo(self.timeLabel.mas_left).offset(-12);
        
    }];
    
     [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.slider.mas_right).offset(12);
        make.centerY.equalTo(self.bottomView);
        make.right.equalTo(self.switchButton.mas_left).offset(-3);
        
    }];
    
    [self.switchButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.timeLabel.mas_right).offset(3);
        make.centerY.equalTo(self.bottomView);
        make.right.mas_equalTo(self.bottomView.mas_right).offset(-3);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        
        
    }];
    
    
    [self.bufferProgressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView);
        make.height.mas_equalTo(2);
        make.width.equalTo(self.slider);
        make.left.equalTo(self.slider);
        
    }];
    
}


#pragma mark 按钮点击事件
-(void)playButtonAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(ju_MediaView:playButtonAction:)]) {
        [self.delegate ju_MediaView:self playButtonAction:sender];
    }
}


-(void)switchAction:(UIButton *)sender{

    if (self.fullScreen) {
        [self pauseAutoScreenAction];
        
        [self normalScreenPlay];
    }else{
        [self fullScreenPlay];
    }
    
    //转换时要先显示顶部和底部，一段时间后隐藏
    self.showingControlView = YES;
    
}


-(void)backButtonAction:(UIButton *)sender{
    
    [self pauseAutoScreenAction];
    
    [self normalScreenPlay];
    self.showingControlView = YES;
}

-(void)multipleButtonClicked:(UIButton *)sender{
    
    if ([self.delegate respondsToSelector:@selector(ju_MediaView:multipleButtonAction:)]) {
        [self.delegate ju_MediaView:self multipleButtonAction:sender];
    }
    
    self.showingControlView = YES;
    
}

-(void)progressSliderTouchBegan:(UISlider *)sender{
    
    if ([self.delegate respondsToSelector:@selector(ju_MediaView:progressSliderTouchBegan:)]) {
        [self.delegate ju_MediaView:self progressSliderTouchBegan:sender];
    }
    
}

-(void)progressSliderValueChanged:(UISlider *)sender{
    
    JULog(@"slider滑动中");
    
    if ([self.delegate respondsToSelector:@selector(ju_MediaView:progressSliderValueChanged:)]) {
        [self.delegate ju_MediaView:self progressSliderValueChanged:sender];
    }
    
    
}

-(void)progressSliderTouchEnded:(UISlider *)sender{
    if ([self.delegate respondsToSelector:@selector(ju_MediaView:progressSliderTouchEnded:)]) {
        [self.delegate ju_MediaView:self progressSliderTouchEnded:sender];
    }
    
}

-(void)tapSliderAction:(UITapGestureRecognizer *)tap{
    
    CGPoint point = [tap locationInView:self.slider];
    if (point.x < 0 || point.x >= self.slider.frame.size.width)return;
    CGFloat percentage = point.x / self.slider.frame.size.width;
    if ([self.delegate respondsToSelector:@selector(ju_MediaView:tapSliderAction:percentage:)]) {
        [self.delegate ju_MediaView:self tapSliderAction:tap percentage:percentage];
    }
}




#pragma 手势事件
-(void)handleSingleTap:(UITapGestureRecognizer *)tap{
//    JULog(@"单击手势");
    if (tap.numberOfTouches==1) {
        self.showingControlView = !self.showingControlView;

    }
}

-(void)handleDoubleTap:(UITapGestureRecognizer *)tap{
//    JULog(@"双击手势");
    if ([self.delegate respondsToSelector:@selector(ju_MediaView:doubleTapAction:)]) {
        [self.delegate ju_MediaView:self doubleTapAction:tap];
    }
    
}

-(void)panGesture:(UIPanGestureRecognizer *)pan{
//    JULog(@"单击手势滑动");
    if ([self.delegate respondsToSelector:@selector(ju_MediaView:panAction:)]) {
        [self.delegate ju_MediaView:self panAction:pan];
    }    
}
//手势的位置是否有效
-(BOOL)gestureIsFunctioned:(UIGestureRecognizer *)gesture{
    
    CGPoint location = [gesture locationInView:gesture.view];
    return !(CGRectContainsPoint(self.topView.frame, location) || CGRectContainsPoint(self.bottomView.frame, location));
    
}

#pragma mark 显示隐藏
-(void)setShowingControlView:(BOOL)showingControlView{
    
    _showingControlView = showingControlView;
    if (_showingControlView) {
        [self showControView];
        //如果正在进行手势操作就不要延时隐藏
        if (!_gestureManipulate)[self delayHiddenControView];
    }else{
        [self hiddenControView];
    }
}

-(void)setGestureManipulate:(BOOL)gestureManipulate{
    _gestureManipulate = gestureManipulate;
    
    [self setShowingControlView:YES];
}

//显示
-(void)showControView{
    [UIView cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenControView) object:nil];
    [UIView animateWithDuration:0.5 animations:^{
        self.bottomView.alpha = 1;
        self.topView.alpha = self.isFullScreen;
        _showingControlView = YES;
    }];
  
}
//隐藏
-(void)hiddenControView{
    
        [UIView animateWithDuration:1.5 animations:^{
            self.topView.alpha = 0;
            self.bottomView.alpha = 0;
            _showingControlView = NO;
        }];
}
//延时隐藏
-(void)delayHiddenControView{
    [UIView cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenControView) object:nil];
    [self performSelector:@selector(hiddenControView) withObject:nil afterDelay:8];
}




#pragma mark 全屏半屏
-(void)fullScreenPlay{
    if (!self.window)return;

    if (self.isFullScreen)return;
    self.fullScreen = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationNone)];

    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [UIView animateWithDuration:0.5 animations:^{
        [self removeFromSuperview];
        [keyWindow addSubview:self];
        
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(Kheight);
            make.height.mas_equalTo(Kwidth);
            make.center.equalTo(keyWindow);

        }];
        
        self.layer.sublayers.firstObject.frame = CGRectMake(0, 0, Kheight, Kwidth);
        
        self.transform = CGAffineTransformMakeRotation(M_PI_2);
        
    }];
}

-(void)normalScreenPlay{
    if (!self.window)return;
    if (!self.isFullScreen)return;
    self.fullScreen = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationNone)];
    [UIView animateWithDuration:0.5 animations:^{
        [self removeFromSuperview];
        [self.FatherView addSubview:self];
        
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.top.and.bottom.mas_equalTo(0);
            
        }];
        self.layer.sublayers.firstObject.frame = self.FatherView.bounds;

        self.transform = CGAffineTransformIdentity;

    }];
    
}

-(void)setFullScreen:(BOOL)fullScreen{
    _fullScreen = fullScreen;
    
    NSString *imageName = _fullScreen ? @"video_window_btn" : @"video_fullScreen_btn";
    self.multipleLabel.alpha = _fullScreen;
    
    [self.switchButton setImage:[UIImage imageNamed:imageName] forState:(UIControlStateNormal)];

}

#pragma mark 重置参数

//设置默认值
-(void)resetControlView{
    self.switchOperation = NO;
    self.fullScreen = NO;
    self.timeLabel.text = @"00:00/00:00";
    
//    self.slider.value = 0;
    //self.multipleLabel.text = @"X1.0倍";
    self.showBufferProgress = NO;
    
    self.showHorizontalPanTimeLabel = NO;
    [self playButtonState:YES];
    [self loadAnimated:YES color:[UIColor whiteColor]];
    self.warningLabel.hidden = YES;

    NSString *multipleNumber = @"1.0";
    [[NSUserDefaults standardUserDefaults] setObject:multipleNumber forKey:mediaPlayerMultipleNumberKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.multipleLabel.text = [NSString stringWithFormat:@"X%@倍", multipleNumber];

    
    //因为进度条的跳动会感觉不好，所以开始时隐藏bottomView, 1秒后显示
    self.bottomView.alpha = 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       self.gestureManipulate = NO;
                   });
    
}


#pragma mark 和plaer的交互
-(void)playButtonState:(BOOL)isPlay{
    if (isPlay) {
        self.playButton.selected = YES;
    }else{
        self.playButton.selected = NO;
    }
    
    
}

-(void)setShowBufferProgress:(BOOL)showBufferProgress{
    _showBufferProgress = showBufferProgress;
    self.bufferProgressView.alpha = showBufferProgress;
}

-(void)loadAnimated:(BOOL)animated color:(UIColor *)color{
    if (!color)color = [UIColor blackColor];
    self.activity.color = color;
    
    if (animated) {
        [self.activity startAnimating];
    }else{
        [self.activity stopAnimating];
    }

}
-(void)setShowHorizontalPanTimeLabel:(BOOL)showHorizontalPanTimeLabel{
    
    _showHorizontalPanTimeLabel = showHorizontalPanTimeLabel;
    self.horizontalPanTimeLabel.alpha = _showHorizontalPanTimeLabel;
}

-(void)setAutoScreenRotation:(BOOL)autoScreenRotation{
    
    if (_autoScreenRotation == autoScreenRotation) {
        
        return;
    }
    
    _autoScreenRotation = autoScreenRotation;
    
    if (autoScreenRotation) {
        [self startAutoScreenRotation];
    }else{
        [self stopAutoScreenRotation];
    }
    
    
}

-(void)setAllowToolBarResponsed:(BOOL)allowToolBarResponsed{
    
    self.bottomView.userInteractionEnabled = allowToolBarResponsed;
    
}


-(void)reFreshTimeLabelWithCurrentTiem:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime{

    if (!self.isShowHorizontalPanTimeLabel) {
        self.timeLabel.text = [NSString stringWithFormat:@"%@/%@",[self timeString:currentTime],[self timeString:totalTime]];
    }
    
    self.horizontalPanTimeLabel.text = [NSString stringWithFormat:@"%@/%@",[self timeString:currentTime],[self timeString:totalTime]];
    self.slider.value = currentTime;
    
//    JULog(@"%f  %f %@", currentTime, totalTime, self.horizontalPanTimeLabel.text);
}

-(NSString *)timeString:(NSTimeInterval)time{
    int second = time/1000*1000;
    if (second >= 60) {
        return [NSString stringWithFormat:@"%d:%02d",(second/60),(second%60)];
    }else{
        return [NSString stringWithFormat:@"00:%02d",second];
    }
}


#pragma mark 手势代理
//iOS  10.3的bug
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{

    return [self gestureIsFunctioned:gestureRecognizer];
    
}

#pragma mark 屏幕旋转

#pragma makr 加速计检测
//利用加速计检测屏幕旋转
-(void)startAutoScreenRotation{
    
    if (![self.mManager isAccelerometerAvailable])return;
    [self.mManager setGyroUpdateInterval:1];
    [self.mManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        
        
        if (self.switchOperation)return;
        
        double x = accelerometerData.acceleration.x;
        double y = accelerometerData.acceleration.y;
        double z = accelerometerData.acceleration.z;

        if (fabs(z) > 0.99) {
            return ;
        }

        if (fabs(y) >= fabs(x) * 3)
        {
            
        }else if(fabs(x) >= fabs(y) * 3){
            // 转化为满屏
            [self fullScreenPlay];
        }
        
        
    }];
    
}

-(void)stopAutoScreenRotation{
    if (![self.mManager isAccelerometerAvailable])return;
    [self.mManager stopAccelerometerUpdates];
}


-(void)pauseAutoScreenAction{
 self.switchOperation = YES;
 [UIView cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeSwitchOperationValue) object:nil];
 [self performSelector:@selector(changeSwitchOperationValue) withObject:nil afterDelay:3];
}

-(void)changeSwitchOperationValue{
    self.switchOperation = NO;
}



#pragma mark通知检测
//利用通知检测屏幕旋转

//-(void)startAutoScreenRotation{
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(handleDeviceOrientationDidChange)
//                                                 name:UIDeviceOrientationDidChangeNotification
//                                               object:nil];
//    
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    
//}
//
//-(void)stopAutoScreenRotation{
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:UIDeviceOrientationDidChangeNotification
//                                                  object:nil];
//    
//    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
//
//}
//
//-(void)handleDeviceOrientationDidChange{
//    
//    //宣告一個UIDevice指標，並取得目前Device的方向
//    UIDevice *device = [UIDevice currentDevice] ;
//    
//    //取得當前Device的方向，來當作判斷敘述。（Device的方向型態為Integer）
//    switch (device.orientation) {
//        case UIDeviceOrientationFaceUp:
//            
//            [self fullScreenPlay];
//            JULog(@"屏幕朝上平躺");
//            break;
//            
//        case UIDeviceOrientationFaceDown:
//            [self fullScreenPlay];
//
//            JULog(@"屏幕朝下平躺");
//            break;
//            
//            //系統無法判斷目前Device的方向，有可能是斜置
//        case UIDeviceOrientationUnknown:
//            JULog(@"未知方向");
//            break;
//            
//        case UIDeviceOrientationLandscapeLeft:
//            [self fullScreenPlay];
//
//            JULog(@"屏幕向左橫置");
//            break;
//            
//        case UIDeviceOrientationLandscapeRight:
//            [self fullScreenPlay];
//
//            JULog(@"屏幕向右橫置");
//            break;
//            
//        case UIDeviceOrientationPortrait:
//            [self normalScreenPlay];
//            JULog(@"屏幕直立");
//            break;
//            
//        case UIDeviceOrientationPortraitUpsideDown:
//            [self normalScreenPlay];
//
//            JULog(@"屏幕直立，上下顛倒");
//            break;
//            
//        default:
//            JULog(@"无法辨别");
//            break;
//    }
// 
//}
//
//-(void)pauseAutoScreenAction{
// self.switchOperation = YES;
// [UIView cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeSwitchOperationValue) object:nil];
// [self performSelector:@selector(changeSwitchOperationValue) withObject:nil afterDelay:3];
//}
//
//-(void)changeSwitchOperationValue{
//    self.switchOperation = NO;
//}




@end
