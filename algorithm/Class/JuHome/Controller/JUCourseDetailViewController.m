//
//  JUCourseDetailViewController.m
//  七月算法_iPad
//
//  Created by 周磊 on 16/6/1.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUCourseDetailViewController.h"
#import "JULessonRecordDatabase.h"

#import "JUCoursesModel.h"
#import "JULessonModel.h"
#import "JUTeacherModel.h"
#import "JUCourseListViewController.h"
#import "JUTeacherListViewController.h"

//#import "JUPlayVideoViewController.h"


#import "JUBaseNavigationController.h"
#import "ButtonView.h"

#import "JUCommentsController.h"

#import "JUMediaPlayerTool.h"
#import "JUAsyncSocketManager.h"

@interface JUCourseDetailViewController ()
@property(nonatomic, strong) UILabel *simpdescritionLab;

//课程数组
@property(nonatomic, strong) NSMutableArray *courseArray;

//lessons
@property(nonatomic, strong) NSMutableArray *lessonArray;

//teacher
@property(nonatomic, strong) NSMutableArray *teacherArray;

//总view
@property(nonatomic, strong) UIView *contentView;

//下边部分
@property(nonatomic,strong)UIView *bottomView;

//目录的view
@property(nonatomic, strong) UIView *listView;


//上部的放置播放器的ImageView
@property(nonatomic, strong) UIImageView *topImageView;

@property(nonatomic, strong) JUCourseListViewController *courseListTableViewVC;
@property(nonatomic, strong) JUTeacherListViewController *teacherListTableViewVC;

@property(nonatomic, strong) JUCommentsController *commentVC;




//展示的controller
@property(nonatomic, strong) UIViewController *showController;



@end


@implementation JUCourseDetailViewController

#pragma 懒加载
-(NSMutableArray *)courseArray{
    if (_courseArray == nil) {
        _courseArray = [NSMutableArray array];
    }
    
    return _courseArray;
}

-(NSMutableArray *)lessonArray{
    if (_lessonArray == nil) {
        _lessonArray = [NSMutableArray array];
    }
    
    return _lessonArray;
}
-(NSMutableArray *)teacherArray{
    if (_teacherArray == nil) {
        _teacherArray = [NSMutableArray array];
    }
    return _teacherArray;
}

#pragma **************************************

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self addnotification];
    [self connectToSocket];
    
    self.title = self.course_title;
    [self setChildrenController];
    [self setupViews];
    [self makeData];
 
    
}

-(void)addnotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MediaPlayerStartplayVedio) name:startplayVedioNotification object:nil];
    
}
-(void)MediaPlayerStartplayVedio{
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       
                       NSString *VideoID = [JUMediaPlayerTool shareInstance].mediaPlayer.VideoID;
                       __weak typeof(self) weakSelf = self;
                       [self.lessonArray enumerateObjectsUsingBlock:^(JULessonModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                           if ([obj.ID isEqualToString:VideoID]) {
                               
                               NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                               [weakSelf.courseListTableViewVC.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                               
                               //给课程设置图片
                               NSURL *url = [NSURL URLWithString:obj.img];
                               [weakSelf.topImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"bigloading"]];
                               
                               
                               *stop = YES;
                           }
                           
                           
                           
                       }];
                       
                       
                   });
    
    
}
#pragma  mark 视图布局

-(void)setChildrenController{

    //教师数组
    JUTeacherListViewController *teacherVC = [[JUTeacherListViewController alloc]init];
    [self addChildViewController:teacherVC];
    self.teacherListTableViewVC = teacherVC;
    
    //课程下的视频数组
    JUCourseListViewController *courseListVC = [[JUCourseListViewController alloc]init];
    [self addChildViewController:courseListVC];
    self.courseListTableViewVC = courseListVC;
    
    JUCommentsController *commentVC = [[JUCommentsController alloc]init];
    [self addChildViewController:commentVC];
    self.commentVC = commentVC;
    
}

-(void)setupViews{
    UIView *contentView = [[UIView alloc]init];
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
    __weak typeof(self) weakSelf = self;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
        
    }];
    
    //这一句必须要加，要先刷新界面
    [self.view layoutIfNeeded];
    
    
    //上部view
    UIImageView *topImageView = [[UIImageView alloc]init];
    //    topImageView.backgroundColor = [UIColor redColor];
    topImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:topImageView];
    self.topImageView = topImageView;
    
    if (self.lessonModel) {
        
        //给课程设置图片
        NSURL *url = [NSURL URLWithString:self.lessonModel.img];
        [topImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"bigloading"]];
        
    }

    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(Kwidth*2/3);
        
    }];
    
    
    [self.view layoutIfNeeded];
    
    
   
//    JULog(@"################## %@", topImageView.logframe);
    
    
    
    
    UIButton *centerpalyButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [centerpalyButton setImage:[UIImage imageNamed:@"video_center_play"] forState:(UIControlStateNormal)];
    [centerpalyButton addTarget:self action:@selector(palyButtonDiclicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [topImageView addSubview:centerpalyButton];
    
    [centerpalyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topImageView.mas_centerX);
        make.centerY.equalTo(topImageView.mas_top).offset(Kwidth/3);
        
    }];
    
    
    
//    JUPlayerController *player = [[JUPlayerController alloc]initWithSuperView:topImageView];
//    player.view.hidden = YES;
//    self.player = player;
    
    JUMediaPlayerTool *tool = [JUMediaPlayerTool shareInstance];
    tool.mediaPlayer.frame = CGRectMake(0, 0, Kwidth, Kwidth*2/3);
    tool.mediaPlayer.hidden = YES;
    [topImageView addSubview:tool.mediaPlayer];
    
    
    //下部view
    UIView *bottomView = [[UIView alloc]init];
    //    bottomView.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:bottomView];
    self.bottomView = bottomView;
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.top.equalTo(topImageView.mas_bottom);
    }];
    
    
    
    UIView *listView = [[UIView alloc]init];
    //    listView.backgroundColor = [UIColor blueColor];
    [bottomView addSubview:listView];
    self.listView = listView;
    
    [listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.top.mas_equalTo(0);
        make.height.mas_equalTo(40.5);
        
        
    }];
    
    //上部分割线
    UIView *linetopView = [[UIView alloc]init];
    linetopView.backgroundColor = HCommomSeperatorline(1);
    [listView addSubview:linetopView];
    
    [linetopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        
    }];
    
    
    //下部分割线
    UIView *lineBottomView = [[UIView alloc]init];
    lineBottomView.backgroundColor = HCommomSeperatorline(1);
    [listView addSubview:lineBottomView];
    
    [lineBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        
    }];
    
    //简介 目录  下载
    NSArray *array = @[@"简介", @"目录", @"评论"];
    ButtonView *buttonView = [[ButtonView alloc]initWithTitleArray:array];
    


    buttonView.selectedTitleColor = Hmblue(1);
    buttonView.normalTitleColor = Hmblack(1);
    buttonView.fontsize = 15;
    buttonView.lineColor = Hmblue(1);

    
    
    [listView addSubview:buttonView];

  
    
    [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.equalTo(linetopView.mas_bottom);
        make.bottom.equalTo(lineBottomView.mas_top);
    }];
  
    
    buttonView.indexBlock = ^(NSInteger index){
        
        [weakSelf.showController.view removeFromSuperview];
        
        UIViewController *vc = weakSelf.childViewControllers[index];
        weakSelf.showController = vc;
     
        [weakSelf.bottomView addSubview:weakSelf.showController.view];
        
        [weakSelf.showController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.bottom.mas_equalTo(0);
            make.top.mas_equalTo(listView.mas_bottom);
            
            
        }];
        
        
    };
  
    //设置默认选中第一个按钮，这句话一定要写在上边的block下边
    [buttonView setButtonClicked:1];

    
}

#pragma mark 其它方法
-(void)makeData{
    
    JULoadingView *loadingView = [JULoadingView shareInstance];
    __weak typeof(self) weakSelf = self;
    loadingView.failureBlock = ^{
        
        [weakSelf makeData];
        
    };
    
    [self.view addSubview:loadingView];
    
    [loadingView beginLoad];
    
    
    
    
    YBNetManager *mannger = [[YBNetManager alloc]init];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", courseURL,self.course_id];
    
//
    
    NSLog(@"%@", urlString);
    
    [mannger GET:urlString parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
        
    } success:^(NSURLSessionDataTask *task, id responobject) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
//        JULog(@"%@", responobject);
        
        [loadingView loadSuccess];
        
        
        if (responobject) {
            
            if (responobject[@"course"]) {
                JUCoursesModel *model = [JUCoursesModel mj_objectWithKeyValues:responobject[@"course"]];

                //头视图
                [weakSelf.teacherListTableViewVC setHeadViewWithSimpleDescription:model.simpledescription];
                
                
                [weakSelf.courseArray addObject:model];
                
            }
            
            if (responobject[@"lessons"]) {
                
                self.lessonArray = [JULessonModel mj_objectArrayWithKeyValuesArray:responobject[@"lessons"]];

//                //重新复赋值刷新数据
                weakSelf.courseListTableViewVC.CourselessonArray = [weakSelf.lessonArray mutableCopy];
                JULessonModel *lessonModel = [weakSelf.lessonArray firstObject];
                
                weakSelf.commentVC.lessonModel = lessonModel;
                //添加到数据库
//                [self.lessonArray enumerateObjectsUsingBlock:^(JULessonModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    
//                    [[JULessonRecordDatabase shareInstance] addLessonModel:obj];
//                    
//                }];
   
                if (weakSelf.lessonModel) { //传有值
                    
                }else{ //没有值，默认该课程下最后播放的
                    
                    if (JuuserInfo.isLogin) {
                        weakSelf.lessonModel = [courseLaseRecorder111 lastLessonRecoderGetLessonModel:lessonModel];

                    }
                    if (!weakSelf.lessonModel) { //如果还没有, 默认第一个
                    weakSelf.lessonModel = lessonModel;
                    }
                }
                
                [weakSelf.lessonArray enumerateObjectsUsingBlock:^(JULessonModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if ([obj.ID isEqualToString:weakSelf.lessonModel.ID]) {
                        
                        weakSelf.lessonModel = obj;
                        
                        
                        
                        *stop = YES;
                    }
                }];
                
                
                weakSelf.navigationItem.title = self.lessonModel.course_tile;
                
                NSURL *url = [NSURL URLWithString:weakSelf.lessonModel.img];
                [weakSelf.topImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"bigloading"]];
                [weakSelf.courseListTableViewVC.tableView reloadData];
 
                [weakSelf autoPlayVideo];
                
                //tableView滚动
                [weakSelf MediaPlayerStartplayVedio];
                

            }

            if (responobject[@"teacher"]) {
                weakSelf.teacherArray = [JUTeacherModel mj_objectArrayWithKeyValuesArray:responobject[@"teacher"]];
                   weakSelf.teacherListTableViewVC.teacherListArray = weakSelf.teacherArray;
                    [weakSelf.teacherListTableViewVC.tableView reloadData];

                //                JULog(@"teacherarray :  %@", responobject[@"teacher"]);
                
            }
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        
        [loadingView loadFailure];
        if (error) {
            JULog(@"%@", error);
        }
        
        
    }];
    
}


#pragma mark 响应方法

-(void)palyButtonDiclicked:(UIButton *)button{
    if (self.lessonModel) {
        
        JUMediaPlayerTool *playTool = [JUMediaPlayerTool shareInstance];
        [playTool playVideoWithLessonModel:self.lessonModel];
        
        JULog(@"*********::: %@", self.lessonModel.play_url);
        [self.courseListTableViewVC.tableView reloadData];

    }
 
    
    
}
-(void)autoPlayVideo{
    if (!self.isAutoPlay)return;
    [self palyButtonDiclicked:nil];
    self.isAutoPlay = NO;

}


//系统的方法
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    JUMediaPlayerTool *playTool = [JUMediaPlayerTool shareInstance];
    
    [playTool pause];

}




-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [JUUmengStaticTool event:JUUmengStaticPlayerDetail key:JUUmengStaticPV value:JUUmengStaticPV];

    JUMediaPlayerTool *playTool = [JUMediaPlayerTool shareInstance];
    [playTool play];
    
}

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    JUMediaPlayerTool *playTool = [JUMediaPlayerTool shareInstance];
    
    [playTool stop];
    
    
    JUlogFunction

    
}



#pragma mark 连接到socket

-(void)connectToSocket{
    
    JUAsyncSocketManager *manager = [JUAsyncSocketManager shareManager];
    
    NSString *host = @"record.julyedu.com";
    uint16_t port = 8002;
    
    [manager ju_connentToHost:host onPort:port delegateQueue:dispatch_get_global_queue(0, 0) connect:^{
        
        
    } failure:^(NSError *error) {
        
        
    } sendSuccess:^(long tag) {
        
        
    } receiveData:^(id data, long tag) {
        
        
    }];
    
    
}

@end
