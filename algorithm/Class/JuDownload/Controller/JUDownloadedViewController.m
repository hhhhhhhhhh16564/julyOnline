//
//  JUDownloadedViewController.m
//  algorithm
//
//  Created by pro on 16/7/16.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUDownloadedViewController.h"
#import "JUDownloadedViewCell.h"
#import "JUDownloadInfo.h"
#import "JUDateBase.h"
#import "JUDownloadMoreController.h"
#import "JUCoverView.h"

static NSString *downloadedViewCell = @"downloadedViewCell";

@interface JUDownloadedViewController ()
@property(nonatomic, strong) NSMutableArray *downloadedArray;


@property(nonatomic, strong) JUCoverView *coverView;

//如果用户已经点击了课程，查看该课程下的所有下载视频，但该课程的另有视频正在下载，下载完成后，要更改，刷新页面
//要实现这个需求，需要保存用户点击的页面的id修改相应的元数据（不能用第几个课程表示，因为正在下载过程中，课程的个数可能增加
@property(nonatomic, strong) JUDownloadMoreController *downloadMoreVC;//用户点击时push出来的控制器


//所有数据的字典，用于根据id找到对应的数组
@property(nonatomic, strong) NSMutableDictionary *downloadedDict;

//courseid
@property(nonatomic, strong) NSString *courseID;


@end

@implementation JUDownloadedViewController
#pragma mark 将数据库中所有下载的视频找出来，并根据他们的ID 添加添加到不同的数组，最后装进一个大数组
//监听视频下载完成的通知，和删除视频的通知
-(NSMutableArray *)downloadedArray{
    
    
    if (!JuuserInfo.isLogin) {
        
        _downloadedArray = [NSMutableArray array];

        return _downloadedArray;
    }
    
    
    if ([_downloadedArray count]) {
        return _downloadedArray;
    }
    
    _downloadedArray = [NSMutableArray array];
    
    NSMutableArray *downloadedArray = [mydatabase findModelWithDownloaded];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //先遍历数组添加到字典中
    [downloadedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JUDownloadInfo *downloadinfo = obj;
        //取出课程的courseId，并作为key值
        NSString *courseID = downloadinfo.lessonModel.course_id;
        NSMutableArray *lessonArray = dict[courseID];
        
        if (!lessonArray) {
            lessonArray = [NSMutableArray array];
            //该数组添加视频
            [lessonArray addObject:downloadinfo];
            
        }else{
            
            [lessonArray addObject:downloadinfo];
            
        }
    

//        //课程数组添加数组,有该key就修改，没有就添加
        [dict setObject:lessonArray  forKey:courseID];
        
        
    }];
    
    self.downloadedDict = dict;
    //遍历字典的Key值,排序，使之有序,按课程id顺序排列,一定要排序，因为字典是无序的，之后会出错
    NSArray *keyArray = [dict allKeys];
    
    if (keyArray.count > 1) {
        keyArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            
            NSString *str1 = obj1;
            NSString *str2 = obj2;
            
            return ([str1 integerValue] > [str2 integerValue]);
            
        }];
    }
    
    
    //找出对应的数组添加
    
    [keyArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *str = obj;
        NSMutableArray *array = dict[str];
        

//   具体的视频信息也要排序，按照id递增排序     
        [array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            
                            JUDownloadInfo *info1 = obj1;
                            JUDownloadInfo *info2 = obj2;
                            NSString *str1 = info1.lessonModel.ID;
                            NSString *str2 = info2.lessonModel.ID;
                            return ([str1 integerValue] > [str2 integerValue]);
     
        }];
        
        
        
        
        
        [_downloadedArray addObject:array];
        
        
    }];
    
    
    
    return _downloadedArray;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
 
    [self.tableView registerClass:[JUDownloadedViewCell class] forCellReuseIdentifier:downloadedViewCell];
    

    JUCoverView *coverView = [[JUCoverView alloc]init];
    coverView.frame = CGRectMake(0, 0, Kwidth, Kheight-49-64);
    [self.tableView addSubview:coverView];
    self.coverView = coverView;
    self.coverView.hidden = YES;

    //添加观察者，下载删除时要刷新页面
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didDeletedownloadedVides:) name:JUDidDeletedownloadedVides object:nil];
    //下载完成时，也要刷新页面
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downloadTaskDidFinishDownloading:) name:JuDownloadTaskDidFinishDownloadingNotification object:nil];
    
}
#pragma mark 视图布局
//-(void)p_setupSubViews{
//    
//    
//}

#pragma mark 代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JUDownloadedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:downloadedViewCell forIndexPath:indexPath];
    NSMutableArray *array = self.downloadedArray[indexPath.row];
    
    
    cell.lessonArray = array;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.downloadedArray.count;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 115;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    [JUUmengStaticTool event:JUUmengStaticDownload key:JUUmengParamDownloaded value:@"DownloadedClick"];

    JUDownloadMoreController *downloadMore = [[JUDownloadMoreController alloc]init];
    downloadMore.downloadMoreArray = self.downloadedArray[indexPath.row];
    
    self.downloadMoreVC = downloadMore;
    JUDownloadInfo *downloadInfo = [downloadMore.downloadMoreArray firstObject];
    
    downloadMore.lessonModel = downloadInfo.lessonModel;
    
    self.courseID = downloadInfo.lessonModel.course_id;
    [self.navigationController pushViewController:downloadMore animated:NO];
    
}
#pragma mark 滑动删除
//指定tableview的编辑样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
     NSMutableArray *array = self.downloadedArray[indexPath.row];
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JUDownloadInfo *downloadinfo = obj;
        JUDownloadManager *manager = [JUDownloadManager shredManager];
                
        
        [manager removeForUrl:downloadinfo.lessonModel.play_url file:downloadinfo.lessonModel.deletelessonPath lessonModel:downloadinfo.lessonModel];
 
    }];
    
    [_downloadedArray removeAllObjects];
    [self.tableView reloadData];
    
}

//指定哪些行可以被编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;//所有行被编辑
    
}

#pragma mark 响应方法


#pragma mark 其它方法
-(void)hidenCoverView{
    
    //没有数据，不隐藏
    if (!self.downloadedArray.count) {
        self.coverView.hidden = NO;
        self.coverView.labelOneString = @"我的下载空空如也,";
        self.coverView.labelTwoString = @"赶快去下载吧";
        self.coverView.imageName = @"empty_box_sign";
        return;
        
    }else{
        
        self.coverView.hidden = YES;
    }
    
}
#pragma mark 通知中心消息
-(void)didDeletedownloadedVides:(NSNotification *)notifi{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_downloadedArray removeAllObjects];
        
        [self hidenCoverView];
        
        //刷新数据重新从数据库中获取一遍
        [self downloadedArray];

        [self.tableView reloadData];
          //给model出来的页面更改元数据
        NSMutableArray *array = self.downloadedDict[self.courseID];
        if (array) {
            self.downloadMoreVC.downloadMoreArray = array;
            [self.downloadMoreVC.tableView reloadData];

    
        }else{
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        
   
        
    });
    
    
    
    
}
//已经完成下载
-(void)downloadTaskDidFinishDownloading:(NSNotification *)notifi{
    
    //必须等下载状态改变后才刷新数据，下载状态改变也接受相同的通知，所以等待0.5秒后执行
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_downloadedArray removeAllObjects];
        
        //数组中肯定有之，隐藏
        self.coverView.hidden = YES;
        
    
        //刷新数据重新从数据库中获取一遍
        [self.tableView reloadData];
        [self downloadedArray];
        //给model出来的页面更改元数据
        NSMutableArray *array = self.downloadedDict[self.courseID];
        if (array) {
            self.downloadMoreVC.downloadMoreArray = array;
            [self.downloadMoreVC.tableView reloadData];
        }
        
    });
    
}


#pragma mark 系统方法

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [JUUmengStaticTool event:JUUmengStaticDownload key:JUUmengParamDownloaded value:JUUmengStaticPV];
    
    if (!JuuserInfo.isLogin) {//未登录，不隐藏
        self.coverView.hidden = NO;
        self.coverView.labelOneString = @"你还未登录";
        self.coverView.labelTwoString = @"无法查看下载视频";
        self.coverView.imageName = @"empty_login_sign";
        return;
    }else{
        self.coverView.hidden = YES;
    }
    
    [_downloadedArray removeAllObjects];

    [self hidenCoverView];
    
    [self.tableView reloadData];

    
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    self.tableView.contentOffset = CGPointMake(0, 0);

}

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    JUlogFunction
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
