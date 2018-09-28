//
//  JUListenLessonController.m
//  algorithm
//
//  Created by 周磊 on 16/12/14.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUListenLessonController.h"

#import "JULessonCell.h"

#import "JUMusicTool.h"

#import "JUAudioTool.h"

#import "JUAudioTool.h"



NSString * const lessonCell = @"lessonCell";

@interface JUListenLessonController ()<UITableViewDelegate, UITableViewDataSource>
{
    CGFloat _bottomInset;
    
}



@property(nonatomic, strong) UITableView *tableView;


@property(strong, nonatomic) UILabel *leftLabel;
@property(strong, nonatomic) UILabel *rightLabel;
@property(strong, nonatomic) UISlider *slider;


@property(strong, nonatomic) UIButton *playButton;

@property(strong, nonatomic) UIButton *previousButton;

@property(strong, nonatomic) UIButton *nextButton;

@property(nonatomic, strong) NSTimer *timer;

@property(nonatomic, strong) UIProgressView *progresView;



@end

@implementation JUListenLessonController

-(NSTimer *)timer{
    
    if (!_timer) {
        
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(reloadTimeLabel) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
        
    }
    
    
    return _timer;
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [[UIImage imageNamed:@"1111_goback"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:(UIBarButtonItemStyleDone) target:self action:@selector(back)];
    
    
    JUAudioTool *audioTool = [JUAudioTool shareInstance];
    audioTool.lessonArray = self.dataArray;
    self.title = [self.dataArray firstObject].course_tile;
    

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(MusicLessonDidPlay) name:@"MusicLessonDidPlay" object:nil];
    


    
    self.navigationController.navigationBar.translucent = NO;
    
    [self setupTableViews];
    
    [self setControlView];
    
    self.leftLabel.text = [self timeSecondToString:0];
    self.rightLabel.text = [self timeSecondToString:1800];
    
}
-(void)back{
    
    [self.navigationController popViewControllerAnimated:NO];
}


-(void)setupTableViews{
    
    _bottomInset = 150;
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.frame = CGRectMake(0, 0, Kwidth, Kheight-64-_bottomInset);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[JULessonCell class] forCellReuseIdentifier:lessonCell];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_register_background"]];
    
}

-(void)setControlView{
    
    UIView *controlView = [[UIView alloc]init];
    controlView.backgroundColor = [UIColor clearColor];
    controlView.frame = CGRectMake(0, self.tableView.bottom_extension, Kwidth, _bottomInset);
    [self.view addSubview:controlView];
    
    UIView *topView = [[UIView alloc]init];
    topView.frame = CGRectMake(0, 20, Kwidth, 40);
    [controlView addSubview:topView];
    
    UIView *bottomView = [[UIView alloc]init];

    CGFloat bottomView_Y = topView.bottom_extension-10;
    
    bottomView.frame = CGRectMake(0, bottomView_Y, Kwidth, controlView.height_extension-bottomView_Y);
    [controlView addSubview:bottomView];
    
    
    
    UIProgressView *progressView = [[UIProgressView alloc]init];
    progressView.progressTintColor = kColorRGB(0, 124, 255, 1);
    progressView.frame = CGRectMake(0, 0, Kwidth-100, 20);
    progressView.userInteractionEnabled = NO;
    [topView addSubview:progressView];
    [progressView XY_centerInSuperView];
    self.progresView = progressView;
    
    
    
    
    //topView
    UISlider *slider = [[UISlider alloc]init];
    [slider setThumbImage:[UIImage imageNamed:@"time_key"] forState:(UIControlStateNormal)];

    slider.minimumTrackTintColor = kColorRGB(0, 0, 255, 1);
    slider.frame = CGRectMake(0, 0, Kwidth-100, 20);
    slider.alpha = 0.5;
    [slider addTarget:self action:@selector(sliderClicked:) forControlEvents:(UIControlEventValueChanged)];

    
    [topView addSubview:slider];
    [slider XY_centerInSuperView];
    self.slider = slider;
    

    UILabel *leftLabel = [[UILabel alloc]init];
    leftLabel.frame = CGRectMake(0, 0, self.slider.x_extension, 20);

    [self set_TimeLabel:leftLabel];
    
    [topView addSubview:leftLabel];
    [leftLabel Y_centerInSuperView];
    self.leftLabel = leftLabel;
    
    
    UILabel *rightLabel = [[UILabel alloc]init];
    [self set_TimeLabel:rightLabel];
    rightLabel.frame = CGRectMake(self.slider.right_extension, 0, self.slider.x_extension, 20);
    [topView addSubview:rightLabel];
    [rightLabel Y_centerInSuperView];
    self.rightLabel = rightLabel;
    
    

    
    //bottomView
    
    UIButton *playButton = [UIButton createButton];
    playButton.frame = CGRectMake(0, 0, 60, 60);
    [bottomView addSubview:playButton];
    [playButton addTarget:self action:@selector(playButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];

    [playButton setBackgroundImage:[UIImage imageNamed:@"111Pause"] forState:(UIControlStateNormal)];
    [playButton setBackgroundImage:[UIImage imageNamed:@"111Play"] forState:(UIControlStateSelected)];
    [playButton XY_centerInSuperView];
     self.playButton = playButton;
    
    
    
    UIButton *previousButton = [UIButton createButton];
     previousButton.alpha = 0.4;
    [previousButton addTarget:self action:@selector(previousButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];

    CGFloat Side_button_width = 30;
    CGFloat button_space = 40;
    [previousButton setBackgroundImage:[UIImage imageNamed:@"111Previous"] forState:(UIControlStateNormal)];
    previousButton.frame = CGRectMake(playButton.x_extension-button_space-Side_button_width, 0, Side_button_width, Side_button_width);
    [bottomView addSubview:previousButton];
    [previousButton Y_centerInSuperView];
    self.previousButton = previousButton;
    
    
    
    
    
    UIButton *nextButton = [UIButton createButton];
    nextButton.alpha = 0.4;
    [nextButton addTarget:self action:@selector(nextButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"111Next"] forState:(UIControlStateNormal)];
    nextButton.frame = CGRectMake(playButton.right_extension+button_space, 0, Side_button_width, Side_button_width);
    [bottomView addSubview:nextButton];
    [nextButton Y_centerInSuperView];
    self.nextButton = nextButton;
    
   
//    [controlView colorForSubviews];

    
}

-(void)set_TimeLabel:(UILabel *)lable{
    
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor whiteColor];
    lable.font = UIptfont(13);
    lable.alpha = 0.7;
}

-(void)sliderClicked:(UISlider *)slider{
    
    JUMusicTool *tool = [JUMusicTool shareInstance];

    if (!tool.playingLessonModel)return;
    
    if (slider.value >= self.progresView.progress * tool.playingLessonModel.totalTime) {
        
        slider.value = self.progresView.progress * tool.playingLessonModel.totalTime;
    }
    
    

    CMTime cmtime = CMTimeMake(slider.value, 1);
    
    [tool.audioPlayer seekToTime:cmtime];
    
    [tool play];
    
    
}

-(void)playButtonClicked:(UIButton *)sender{
    
        JUMusicTool *tool = [JUMusicTool shareInstance];
    
    if (tool.playingLessonModel) {
        
        if (tool.audioPlayer.rate == 1) {
            [tool pause];
            
        }else{
            
            [tool play];
        }

    }else{
        
        tool.playingLessonModel = [self.dataArray firstObject];
    }
    
    
    
    
    [self setPlayButtonState];
}


-(void)setPlayButtonState{
    
    JUMusicTool *tool = [JUMusicTool shareInstance];
    
    if (tool.audioPlayer.rate == 1) {
        self.playButton.selected = YES;
       
    }else{
        
        self.playButton.selected = NO;
       
    }
    
    
}

-(void)previousButtonClicked:(UIButton *)sender{
    
    [self remove_Observer];
    
    [[JUAudioTool shareInstance] previousMusic];
    
    
}
-(void)nextButton:(UIButton *)sender{
      [self remove_Observer];
    [[JUAudioTool shareInstance] nextMusic];
    
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JULessonCell *cell = [tableView dequeueReusableCellWithIdentifier:lessonCell forIndexPath:indexPath];
//    cell.backgroundColor = RandomColor;
    
//    __weak typeof(self) weakSelf = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    cell.lessonModel = self.dataArray[indexPath.row];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self remove_Observer];
    
    
    JUListenLessonModel *lessonModel = self.dataArray[indexPath.row];

    
    JUMusicTool *tool = [JUMusicTool shareInstance];
    
    tool.playingLessonModel = lessonModel;
    
    
    [self setPlayButtonState];
    
}

#pragma mark 通知
-(void)MusicLessonDidPlay{
    
    
    self.progresView.progress = 0;
     JUMusicTool *tool = [JUMusicTool shareInstance];
    
    [self killTimer];

//    [self reloadTimeLabel];
    

    [self timer];
    
    self.slider.minimumValue = 0;
    self.slider.maximumValue = (CGFloat)tool.playingLessonModel.totalTime;
    
    [self.tableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       
                       [tool.audioPlayer.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
                       
                   });
    
    
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
          JUMusicTool *tool = [JUMusicTool shareInstance];
        
        //计算出缓冲进度的长度
        NSTimeInterval timeInterval = [self availableDuration];
        
        self.progresView.progress = (float)(timeInterval/ tool.playingLessonModel.totalTime);
        
    }
    
    
}


-(void)remove_Observer{
    
    JUMusicTool *tool = [JUMusicTool shareInstance];
    
    [tool.audioPlayer.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

- (NSTimeInterval)availableDuration{
    
      JUMusicTool *tool = [JUMusicTool shareInstance];
    
    NSArray *loadeTimeRanges = [[tool.audioPlayer currentItem] loadedTimeRanges];
    
    //获取缓冲区域
    CMTimeRange timeRange = [loadeTimeRanges.firstObject CMTimeRangeValue];
    
    //缓冲区域的开始
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    
    //缓冲区域的持续时间
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    
    //计算缓冲进度
    NSTimeInterval result = startSeconds + durationSeconds;
    
    
    return result;
    
    
    
    
}



-(void)reloadTimeLabel{
    
     JUMusicTool *tool = [JUMusicTool shareInstance];
    
     AVPlayer *player = tool.audioPlayer;
    
        
        CGFloat nowSecond =  player.currentTime.value * 1.0 / player.currentTime.timescale;

        CGFloat totalSecond = player.currentItem.duration.value * 1.0 /  player.currentItem.duration.timescale;
    

        
        self.leftLabel.text = [self timeSecondToString:nowSecond];
        self.rightLabel.text = [self timeSecondToString:totalSecond];
    
       self.slider.value = nowSecond;
    
    
    
}

-(NSString *)timeSecondToString:(NSTimeInterval)duration{
    
    int second = duration/1000*1000;
    NSString *time = nil;
    if(duration>=60){
        time = [NSString stringWithFormat:@"%d:%02d",(second/60),(second%60)];
    }else{
        time = [NSString stringWithFormat:@"00:%02d",second];
    }
    return time;
}




-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    

    [self killTimer];

    
    JUMusicTool *tool = [JUMusicTool shareInstance];
    
    [self remove_Observer];
    tool.playingLessonModel = nil;
    tool.audioPlayer = nil;
 
    
    
    
}

-(void)killTimer{
    
    [self.timer invalidate];
    
    self.timer = nil;
    
    
}

- (void)dealloc
{

    JUlogFunction
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];

    

}


@end
