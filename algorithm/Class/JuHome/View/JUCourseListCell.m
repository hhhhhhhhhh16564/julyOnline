//
//  JUCourseListCell.m
//  七月算法_iPad
//
//  Created by 周磊 on 16/6/1.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUCourseListCell.h"
#import "JULessonModel.h"
#import "JULoginViewController.h"
#import "AppDelegate.h"
#import "JUTabBarController.h"
#import "JUMediaPlayerTool.h"

@interface JUCourseListCell ()<UIAlertViewDelegate, JUMediaPlayerDelegate>

{


    
    CGFloat _stateButtonBotoom;
    
}



@property(nonatomic, strong) UIView *lineView;

@property(nonatomic, strong) UILabel *durationLab;

@property(nonatomic, strong) UILabel *sizeLabel;


//百分比
@property(nonatomic, strong) UIButton *percentageButton;

//时间
@property(nonatomic, strong) UIButton *durationButton;

//大小
@property(nonatomic, strong) UIButton *sizeButton;

@property(nonatomic, strong) UIButton *stateButton;

@property(nonatomic, strong) UILabel *completeLabel;

@property(nonatomic, strong) UILabel *downloadingLabel;



// 因为有两个alterView,所以加一个字符串加以判别
@property(nonatomic, copy) NSString *identifierString;



@end

@implementation JUCourseListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self p_makeupViews1];

//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changePlayedVedioNameColorNotification:) name:changePlayedVedioNameColorNotification object:nil];
        
        self.identifierString = @"";
        
        
    }
    
    return self;
    
}


-(void)p_makeupViews1{
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = HCanvasColor(1);
    [self.contentView addSubview:line];
    self.lineView = line;
    
    
    UILabel *namelab = [[UILabel alloc]init];
    namelab.font = UIptfont(12);
    [self.contentView addSubview:namelab];
    self.nameLab = namelab;
    
    
    UIButton *percentageButton = [UIButton buttonWithType:(UIButtonTypeCustom)];

    UIColor *grayColor = Kcolor16rgb(@"666666", 1);

    
    [percentageButton setTitleColor:grayColor forState:(UIControlStateNormal)];
    [percentageButton setTitleColor:Hmblue(1) forState:(UIControlStateSelected)];
    [percentageButton setImage:[UIImage imageNamed:@"pinglun@played-0"] forState:(UIControlStateNormal)];
    [percentageButton.titleLabel setFont:UIptfont(9)];
    [percentageButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 2.5, 0, -2.5)];
    [percentageButton setImageEdgeInsets:UIEdgeInsetsMake(0, -2.5, 0, 2.5)];
    percentageButton.userInteractionEnabled = NO;
    [self.contentView addSubview:percentageButton];
    self.percentageButton = percentageButton;
    
    
    
    
    UIButton *durationButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [durationButton setTitleColor:grayColor forState:(UIControlStateNormal)];
    [durationButton setImage:[UIImage imageNamed:@"pinglun@time-0"] forState:(UIControlStateNormal)];
    [durationButton.titleLabel setFont:UIptfont(9)];
    [durationButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 2.5, 0, -2.5)];
    [durationButton setImageEdgeInsets:UIEdgeInsetsMake(0, -2.5, 0, 2.5)];
    durationButton.userInteractionEnabled = NO;
    [self.contentView addSubview:durationButton];
    self.durationButton = durationButton;
    
    
    
    UIButton *sizeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [sizeButton setTitleColor:grayColor forState:(UIControlStateNormal)];
    [sizeButton.titleLabel setFont:UIptfont(9)];
    [sizeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 2.5, 0, -2.5)];
    [sizeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -2.5, 0, 2.5)];
    sizeButton.userInteractionEnabled = NO;
    [sizeButton setImage:[UIImage imageNamed:@"pinglun@wenjian@lit"] forState:(UIControlStateNormal)];
    [self.contentView addSubview:sizeButton];
    self.sizeButton = sizeButton;
    
    
    
    UILabel *completeLabel = [[UILabel alloc]init];
    completeLabel.text = @"该课程已看完";
    completeLabel.textAlignment = NSTextAlignmentCenter;
    completeLabel.textColor = [UIColor whiteColor];
    completeLabel.backgroundColor = Kcolor16rgb(@"0099FF", 1);
    completeLabel.layer.cornerRadius = 3;
    completeLabel.layer.masksToBounds = YES;
    completeLabel.font = UIptfont(8);
    [self.contentView addSubview:completeLabel];
    completeLabel.hidden = YES;
    self.completeLabel = completeLabel;
    
    
    
    UIButton *stateButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    
    [stateButton addTarget:self action:@selector(stateButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];

    [self.contentView addSubview:stateButton];
    self.stateButton = stateButton;
    
    
    UILabel *downloadingLabel = [[UILabel alloc]init];
    downloadingLabel.text = @"下载中";
    downloadingLabel.textColor = Kcolor16rgb(@"0099FF", 1);
    downloadingLabel.font = UIptfont(9);
    [self.contentView addSubview:downloadingLabel];
    self.downloadingLabel = downloadingLabel;
    
}



-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.nameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.left.mas_equalTo(15);
        make.width.mas_lessThanOrEqualTo(Kwidth-15-55-8);
        
    }];
    

    [self.durationButton mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.percentageButton.mas_right).offset(18);
        make.bottom.mas_equalTo(-7);
        make.width.mas_equalTo(60);
        
    }];
    
    
    [self.sizeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.durationButton.mas_right).offset(15);
        make.bottom.mas_equalTo(-7);
        make.width.mas_equalTo(45);

    }];
    
    
    [self.completeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.nameLab.mas_right).offset(8);
        make.height.mas_equalTo(14);
        
        make.centerY.equalTo(self.nameLab.mas_centerY);
        make.width.mas_equalTo(55);
        
        
    }];
    
    
    [self.stateButton mas_remakeConstraints:^(MASConstraintMaker *make) {

     //图片给的太小，要扩大响应去
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(_stateButtonBotoom);
        make.size.mas_equalTo(CGSizeMake(48, 32));
        
     
    }];
    

    [self.percentageButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(49);
        make.bottom.mas_equalTo(-7);
        make.width.mas_equalTo(50);
   
    }];

    [self.downloadingLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.stateButton.mas_centerX);
        make.bottom.mas_equalTo(-7);
        
    
    }];
    
    
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-5);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
        
        
    }];
}


-(void)setLessonModel:(JULessonModel *)lessonModel
{
   

    _lessonModel = lessonModel;
    
    _stateButtonBotoom = 0;
    
//    JULog(@"%f", lessonModel.totalTime);
    
//    JULessonModel *ll = [[JULessonRecordDatabase shareInstance]getLessonModel:lessonModel];
 
//    self.nameLab.text = [NSString stringWithFormat:@"ID: %@ ||  %zd",ll.ID,  ll.timeRecord ];
    
    [self.durationButton setTitle:lessonModel.duration forState:(UIControlStateNormal)];
    [self.sizeButton setTitle:lessonModel.size forState:(UIControlStateNormal)];
    
    [self.percentageButton setTitle:self.lessonModel.perCentageString forState:(UIControlStateNormal)];
    
    
    if (lessonModel.isPlayCompleted) {
        
        self.completeLabel.hidden = NO;
        
        [self.percentageButton setTitle:@"100%" forState:(UIControlStateNormal)];

        
    }else{
        
        self.completeLabel.hidden = YES;
        
    }
    
    [self setPlayingSubview];
    
   
    
    
    
    
    switch (lessonModel.downloadInfo.downloadstatus) {
        case JUDownloadStateCompleted:{//下载完成
            
            [self.stateButton setImage:[UIImage imageNamed:@"pinglun@delete"] forState:(UIControlStateNormal)];
            
            break;
        }
        case JUDownloadStateWillResume:{//等待下载
            
            
            [self.stateButton setImage:[UIImage imageNamed:@"pinglun@wating"] forState:(UIControlStateNormal)];
            break;
        }
        case JUDownloadStateResumed:{//正在下载
            [self.stateButton setImage:[UIImage imageNamed:@"pinglun@loading"] forState:(UIControlStateNormal)];
            
            _stateButtonBotoom = -13;
            self.downloadingLabel.hidden = NO;
            
            
            break;
        }
        case JUDownloadStateSuspened:{//下载暂停时 显示等待的图标
            
            [self.stateButton setImage:[UIImage imageNamed:@"pinglun@wating"] forState:(UIControlStateNormal)];
            
            break;
        }
            
        case JUDownloadStateNone:{//闲置状态
            
            [self.stateButton setImage:[UIImage imageNamed:@"pinglun@download@normal"] forState:(UIControlStateNormal)];
            
            break;
        }

        default:
            break;
    }
    
}

//点击button响应事件

-(void)stateButtonClicked:(UIButton *)button{
    
    [JUUmengStaticTool event:JUUmengStaticPlayerDetail key:JUUmengParamCatalogue value:@"Download"];

    
    switch (_lessonModel.downloadInfo.downloadstatus) {
            
        case JUDownloadStateCompleted:{//下载完成  点击删除
            

        JUMediaPlayerTool *playtool = [JUMediaPlayerTool shareInstance];
        if ([playtool.mediaPlayer.lessonModel.ID isEqualToString:self.lessonModel.ID]) {
            [self showWithView:nil text:@"你正在观看该视频, 不能删除" duration:1.5];
            return;
            
        }

            
            
            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"确定要删除该视频吗" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            self.identifierString = @"删除";
            
            [alterView show];
            
            
            break;
        }
        case JUDownloadStateWillResume:{//等待下载  点击没反应
            
            
            break;
        }
        case JUDownloadStateResumed:{//正在下载   点击没反应

            
            break;
        }
        case JUDownloadStateNone:{//闲置状态  // 点击下载
            
            [self downLoadAction:button];
            
            break;
        }
        default:
            break;
    }
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (buttonIndex) {

        
        if ([self.identifierString isEqualToString:@"删除"]) {
            
            [self deleteDownloading:self.lessonModel];

        }else if ([self.identifierString isEqualToString:@"下载"]){
            
            [self confirmDownloadLessonVideo];
            
        }
        
    }
    
    self.identifierString = @"";
    
    
}



// 下载视频

-(void)downLoadAction:(UIButton *)sender{

    
    
    //如果没有网路，返回
    
    if (JuuserInfo.isLogin == NO) {
        
        JULoginViewController *loginVC = [[JULoginViewController alloc]init];

        AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        JUBaseNavigationController *navc = [appdelegate.window.rootViewController.childViewControllers firstObject];
        
        [navc pushViewController:loginVC animated:NO];
        
        return;
        
    }
    
    
    
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    
    
    if (networkingType == NotReachable) {
        
        GMToast *toast = [[GMToast alloc]initWithView:keywindow  text:@"请检查你的网络" duration:1.5];
        [toast show];
        
        return;
    }

    
    
    if (networkingType == ReachableViaWWAN) {
        
//        GMToast *toast = [[GMToast alloc]initWithView:keywindow  text:@"你正在用手机流量下载" duration:1.5];
//        [toast show];
//        
     
        UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"你确定下载该视频吗" message:@"当前网络环境下载视频可能会耗费手机流量" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        self.identifierString = @"下载";
        
        [alterView show];
        
        return;
        
        
    }
    
    
    
    [self confirmDownloadLessonVideo];
    



    
}

// 确定下载视频
-(void)confirmDownloadLessonVideo{
    //全部下载要先查看下载状态，如果状态是JUDownloadStateNone,就下载
    if (_lessonModel.downloadInfo.downloadstatus == JUDownloadStateNone) {
        
        if ([JUDownloadManager shredManager].downloadingCount) {
            
            //有下载的话 设置为等待下载
            [self.stateButton setImage:[UIImage imageNamed:@"pinglun@wating"] forState:(UIControlStateNormal)];
            
            
        }else{
            
            //无下载的话设施为下载
            
            [self.stateButton setImage:[UIImage imageNamed:@"pinglun@loading"] forState:(UIControlStateNormal)];
            
            _stateButtonBotoom = -13;
            
            self.downloadingLabel.hidden = NO;
            
            [self setNeedsLayout];
            
        }
        
        JULessonModel *recordLessonModle = [lessonRecordDatabase getLessonModel:_lessonModel];
        if (!recordLessonModle) {
            [lessonRecordDatabase addLessonModel:_lessonModel];
        }
        
        [[JUDownloadManager shredManager] downloadWithUrlString:_lessonModel.play_url toPath:_lessonModel.destinationPath process:^(float progress, NSString *sizeString, NSString *speedString) {
            
        } completion:^{
            
        } failure:^(NSError *error) {
            
        } lessonModel:_lessonModel];
        
    };
    
    
    
}







//删除下载视频

-(void)deleteDownloading:(JULessonModel *)lessonModel{
    
    
    [self.stateButton setImage:[UIImage imageNamed:@"pinglun@download@normal"] forState:(UIControlStateNormal)];

    
    JUDownloadInfo *downloadinfo = lessonModel.downloadInfo;
    
    //删除任务 先删除数据库  删除视频
    //mannaager封装方法，直接传入url和destationpath就可
    JUDownloadManager *manager = [JUDownloadManager shredManager];

    
    [manager removeForUrl:downloadinfo.lessonModel.play_url file:downloadinfo.lessonModel.deletelessonPath lessonModel:downloadinfo.lessonModel];
  
}



//设置正在播放的cell的lable颜色，和百分比按钮

-(void)setPlayingSubview{
    
    _stateButtonBotoom = 0;
    self.downloadingLabel.hidden = YES;
    self.percentageButton.selected = NO;

    //播放字体显示蓝色
    JUMediaPlayerTool *playtool = [JUMediaPlayerTool shareInstance];
    if ([playtool.mediaPlayer.VideoID isEqualToString:self.lessonModel.ID]) {
        
         self.nameLab.textColor = Hmblue(1);
        self.percentageButton.selected = YES;
        playtool.mediaPlayer.delegate = self;
    }else{
        
        self.nameLab.textColor = Hmblack(1);
 
    }
    
    
}

#pragma mark 代理方法

-(void)ju_MediaPlayer:(JUMediaPlayer *)mediaplayer currentPlayTime:(CGFloat)currentTime{
    self.nameLab.textColor = Hmblack(1);
    self.percentageButton.selected = NO;

    if ([mediaplayer.VideoID isEqualToString:self.lessonModel.ID]) {
        
        self.nameLab.textColor = Hmblue(1);
        self.percentageButton.selected = YES;
        NSString *percentage = [NSString stringWithFormat:@"%.0f%%",currentTime*100 / self.lessonModel.totalTime];
        if ([percentage isEqualToString:@"-0%"])percentage = @"0%";
        [self.percentageButton setTitle:percentage forState:(UIControlStateNormal)];
    }
    
}



- (void)dealloc
{
    
    [JUMediaPlayerTool shareInstance].mediaPlayer.delegate = nil;
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

@end
