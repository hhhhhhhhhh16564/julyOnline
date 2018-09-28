//
//  JUDownloadingViewController.m
//  七月算法_iPad
//
//  Created by pro on 16/6/18.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUDownloadingViewController.h"
#import "JUDownloadingViewCell.h"
#import "JUDownloadManager.h"
#import "JUDownloadInfo.h"
#import "JUDateBase.h"
#import "JUCoverView.h"
#import "JUCoverView.h"
static NSString *downloadingViewCell = @"downloadingViewCell";
@interface JUDownloadingViewController ()

@property(nonatomic, strong) NSMutableArray *downloadingArray;

@property(nonatomic, strong) JUCoverView *coverView;

@property (nonatomic,assign) BOOL isRefresh;


@end

@implementation JUDownloadingViewController

-(NSMutableArray *)downloadingArray{
    
    if (!JuuserInfo.isLogin) {
        _downloadingArray = [NSMutableArray array];
        return _downloadingArray;
    }
    
    if ([_downloadingArray count]) {
        return _downloadingArray;
    }
    
    _downloadingArray = [mydatabase findModelWithDownloading];
    return _downloadingArray;
}

#pragma mark 视图布局
-(void)viewDidLoad
{
    [super viewDidLoad];
    
     self.automaticallyAdjustsScrollViewInsets = NO;


    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[JUDownloadingViewCell class] forCellReuseIdentifier:downloadingViewCell];
    
    
    
    JUCoverView *coverView = [[JUCoverView alloc]init];
    coverView.frame = CGRectMake(0, 0, Kwidth, Kheight-49-64);
    [self.tableView addSubview:coverView];
    self.coverView = coverView;
    self.coverView.hidden = YES;


#pragma mark监听下载完成时删除这一行
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downloadStateDidChangeNotification:) name:JUDownloadStateDidChangeNotification object:nil];
    
    // 网络发生变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(netWorkingDidChangedNotification:) name:JUNetWorkingDidChangedNotification object:nil];
    
}

#pragma mark  代理方法

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JUDownloadingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:downloadingViewCell forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    JUDownloadInfo *downloadinfo = self.downloadingArray[indexPath.row];
   [self downloadVideo:cell lessonModel:downloadinfo indexpath:indexPath];
    
    
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    

    
    return self.downloadingArray.count;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
    
}
#pragma mark 滑动删除
//指定tableview的编辑样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return UITableViewCellEditingStyleDelete;
    
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [JUUmengStaticTool event:JUUmengStaticDownload key:JUUmengParamDownloading value:@"ProgramSlide"];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [JUUmengStaticTool event:JUUmengStaticDownload key:JUUmengParamDownloading value:@"ProgramDelete"];

    JUDownloadInfo *downloadinfo = self.downloadingArray[indexPath.row];
    
    //删除任务 先删除数据库  删除视频
    //mannaager封装方法，直接传入url和destationpath就可以
    JUDownloadManager *manager = [JUDownloadManager shredManager];
    
    

    [manager removeForUrl:downloadinfo.lessonModel.play_url file:downloadinfo.lessonModel.deletelessonPath lessonModel:downloadinfo.lessonModel];
    
    
    [_downloadingArray removeAllObjects];
    
    [self hidenCoverView];
    [self.tableView reloadData];
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [JUUmengStaticTool event:JUUmengStaticDownload key:JUUmengParamDownloading value:@"DownloadingClick"];

}




#pragma mark 其它方法
// 下载完成

-(void)downloadStateDidChangeNotification:(NSNotification *)notifi{
    
    if (!self.isRefresh)return;
    self.isRefresh = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.18* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_downloadingArray removeAllObjects];
        
        [self.tableView reloadData];
        [self hidenCoverView];
        self.isRefresh = YES;
        
//        JULog(@"刷新数据（）（）（（）（）（）（）（）（");
    });
}



-(void)netWorkingDidChangedNotification:(NSNotification *)notifi{
    
    [[JUDownloadManager shredManager]downloadTaskWillBeTerminate:nil];
    [mydatabase changedDownloadStatusOnAppLaunch];

    [_downloadingArray removeAllObjects];
    
    [self.tableView reloadData];
    
    
}



-(void)downloadVideo:(JUDownloadingViewCell *)downloadCell lessonModel:(JUDownloadInfo *)downloadinfo indexpath:(NSIndexPath *)indexPath{
    
    __weak typeof(self) weakSelf = self;
    downloadCell.downloadinfo = downloadinfo;
    
    JULessonModel *lessonModel= downloadinfo.lessonModel;
    NSString *nametext = [NSString stringWithFormat:@"%ld.  %@",(long)indexPath.row+1,lessonModel.name];
    downloadCell.lessonNameLabel.text = nametext;
    
    
    __weak typeof(downloadCell) weakcell = downloadCell;
    
    
    downloadCell.downloadBlock = ^(UIButton *button){
        
        [JUUmengStaticTool event:JUUmengStaticDownload key:JUUmengParamDownloading value:@"ProgramgClick"];

        
        JUDownloadInfo *downloadinfo = lessonModel.downloadInfo;
        
        JULog(@"点击了按钮: %@", lessonModel.play_url);
        
        JUDownloadManager *mannager = [JUDownloadManager shredManager];
        
        if (downloadinfo.downloadstatus == JUDownloadStateResumed) {
            //暂停下载,即取消任务
            [mannager cancelDownloadTask:downloadinfo.urlString];
            //从队列中取出一个下载
            [mannager downloadTaskFromWaitingTsaks];
            
            //            weakcell.statusLabel.text = @"暂停下载";
            
            //暂停下载
        }else if (downloadinfo.downloadstatus == JUDownloadStateSuspened || downloadinfo.downloadstatus == JUDownloadStateWillResume){
            
            if (networkingType == ReachableViaWWAN) {
                
                if ([[[UIDevice currentDevice] systemVersion] floatValue ] >= 8.0) {
                    UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:@"你确定下载该视频吗" message:@"当前网络环境下载视频可能会耗费手机流量" preferredStyle:(UIAlertControllerStyleAlert)];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {

                    }];
                    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                        
                        //开始下载
                        //取消正在下载的任务
                        [mannager cancelDownloadTask:mannager.downloadingUrlstring];
                        
                        //开启一个新的任务
                        [mannager downloadWithUrlString:lessonModel.play_url toPath:lessonModel.destinationPath process:^(float progress, NSString *sizeString, NSString *speedString) {
                            
                            //              weakcell.statusLabel.text = @"正在下载";
                            
                        } completion:^{
                            
                            
                        } failure:^(NSError *error) {
                            
                            
                        }lessonModel:lessonModel];
                        
                        weakcell.downloadinfo = downloadinfo;

                    }];
                    
                    [alterVC addAction:cancelAction];
                    [alterVC addAction:confirmAction];
                    
                    [weakSelf.navigationController presentViewController:alterVC animated:NO completion:nil];
                    
                    
                }else{
                    //开始下载
                    //取消正在下载的任务
                    [mannager cancelDownloadTask:mannager.downloadingUrlstring];
                    
                    //开启一个新的任务
                    [mannager downloadWithUrlString:lessonModel.play_url toPath:lessonModel.destinationPath process:^(float progress, NSString *sizeString, NSString *speedString) {
                        
                        //              weakcell.statusLabel.text = @"正在下载";
                        
                    } completion:^{
                        
                        
                    } failure:^(NSError *error) {
                        
                        
                    }lessonModel:lessonModel];
                    
                    
                }
                
            }else{
                
                //开始下载
                //取消正在下载的任务
                [mannager cancelDownloadTask:mannager.downloadingUrlstring];
                
                //开启一个新的任务
                [mannager downloadWithUrlString:lessonModel.play_url toPath:lessonModel.destinationPath process:^(float progress, NSString *sizeString, NSString *speedString) {
                    
                    //              weakcell.statusLabel.text = @"正在下载";
                    
                } completion:^{
                    
                    
                } failure:^(NSError *error) {
                    
                    
                }lessonModel:lessonModel];
            }
        }else{
        }
    };
    weakcell.downloadinfo = downloadinfo;
}
-(void)hidenCoverView{
    //没有数据，不隐藏
    if (!self.downloadingArray.count) {
        
        self.coverView.hidden = NO;
        self.coverView.labelOneString = @"暂无下载任务";
        self.coverView.labelTwoString = @"快去下载吧";
        self.coverView.imageName = @"empty_download_sign";
        
        
        return;
    }else{
        
        self.coverView.hidden = YES;
    }
}

#pragma mark 其它方法

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [JUUmengStaticTool event:JUUmengStaticDownload key:JUUmengParamDownloading value:JUUmengStaticPV];
    self.isRefresh = YES;
    if (!JuuserInfo.isLogin) {//未登录，不隐藏
        self.coverView.hidden = NO;
        self.coverView.labelOneString = @"你还未登录";
        self.coverView.labelTwoString = @"无法查看下载视频";
        self.coverView.imageName = @"empty_login_sign";
        return;
    }else{
        self.coverView.hidden = YES;
    }
    [_downloadingArray removeAllObjects];
    [self hidenCoverView];
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    JUlogFunction
}




@end
