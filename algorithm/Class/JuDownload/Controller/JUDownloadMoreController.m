//
//  JUDownloadMoreController.m
//  algorithm
//
//  Created by pro on 16/7/17.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUDownloadMoreController.h"

#import "JUDownloadMoreTableViewHeadView.h"

#import "JUDownloadMoreViewCell.h"

#import "JUCourseDetailViewController.h"
#import "JUUnNetPlayController.h"

//#import "JUDownloadMoreHeaderView.h"

static NSString *downloadMoreHeaderViwe = @"downloadMoreHeaderViwe";
static NSString *downloadMoreCell = @"downloadMoreCell";

@interface JUDownloadMoreController ()

@end

@implementation JUDownloadMoreController

#pragma mark 视图布局
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    // Do any additional setup after loading the view.
}

-(void)setupViews{
    
    
    self.title = self.lessonModel.course_tile;
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[JUDownloadMoreViewCell class] forCellReuseIdentifier:downloadMoreCell];

    
    JUDownloadMoreTableViewHeadView *tableHeadView = [[JUDownloadMoreTableViewHeadView alloc]init];
    tableHeadView.lessonModel = self.lessonModel;
    tableHeadView.frame = CGRectMake(0, 0, Kwidth, 115);
    self.tableView.tableHeaderView = tableHeadView;
    
    UIView *footView = [[UIView alloc]init];
//    footView.backgroundColor = [UIColor grayColor];
    footView.frame = CGRectMake(0, 0, Kwidth, 50);
    self.tableView.tableFooterView = footView;
    

    UIButton *morebutton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    morebutton.frame = footView.bounds;
//    morebutton.layer.borderColor = [Hcgray(1) CGColor];
//    morebutton.layer.borderWidth = 2*KMultiplier;
    [morebutton setTitle:@"下载更多" forState:(UIControlStateNormal)];
    [morebutton.titleLabel setFont:UIptfont(16)];
    [morebutton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    [morebutton setTitleColor:Hmblue(1) forState:(UIControlStateNormal)];
    [morebutton addTarget:self action:@selector(moredownloadAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [morebutton setImage:[UIImage imageNamed:@"more_add_icon"] forState:(UIControlStateNormal)];
    [footView addSubview:morebutton];
}



#pragma mark 代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JUDownloadMoreViewCell *cell = [tableView dequeueReusableCellWithIdentifier:downloadMoreCell forIndexPath:indexPath];
    JUDownloadInfo *downloadInfo = self.downloadMoreArray[indexPath.row];
    NSString *nametext = [NSString stringWithFormat:@"%ld. %@",(long)indexPath.row+1,downloadInfo.lessonModel.name];
   cell.lessonNameLabel.text = nametext;

    
    cell.lessonModel = downloadInfo.lessonModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.downloadMoreArray.count;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [JUUmengStaticTool event:JUUmengStaticDownload key:JUUmengParamDownloaded value:@"CourseClick"];

    
    JUDownloadInfo *downloadInfo = self.downloadMoreArray[indexPath.row];
    JULessonModel *lessonModel = downloadInfo.lessonModel;
    
    if (networkingType == NotReachable) {
        
        JUUnNetPlayController *playVC = [[JUUnNetPlayController alloc]init];
        playVC.lessonModel = lessonModel;
        playVC.course_id = lessonModel.course_id;
        playVC.course_title = lessonModel.course_tile;
        [self.navigationController pushViewController:playVC animated:NO];
        

    }else{
        
        JUCourseDetailViewController *courseDetainVc = [[JUCourseDetailViewController alloc]init];
        courseDetainVc.lessonModel = lessonModel;
        courseDetainVc.course_id = lessonModel.course_id;
        courseDetainVc.course_title = lessonModel.course_tile;
        courseDetainVc.isAutoPlay = YES;        
        [self.navigationController pushViewController:courseDetainVc animated:NO];
        
    }
    
    
    
    
    

    

    

    
    
    
}

#pragma mark 滑动删除
//指定tableview的编辑样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
    
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    [JUUmengStaticTool event:JUUmengStaticDownload key:JUUmengParamDownloaded value:@"CourseSlide"];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [JUUmengStaticTool event:JUUmengStaticDownload key:JUUmengParamDownloaded value:@"CourseDelete"];

    
    JUDownloadInfo *downloadinfo = self.downloadMoreArray[indexPath.row];
    
    //删除任务 先删除数据库  删除视频
    //mannaager封装方法，直接传入url和destationpath就可
    JUDownloadManager *manager = [JUDownloadManager shredManager];

    
    [manager removeForUrl:downloadinfo.lessonModel.play_url file:downloadinfo.lessonModel.deletelessonPath lessonModel:downloadinfo.lessonModel];
}

//指定哪些行可以被编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;//所有行被编辑
    
}







#pragma mark 响应方法
-(void)moredownloadAction:(UIButton*)button{
    
    
  
    JUDownloadInfo *downloadInfo = [self.downloadMoreArray firstObject];
    JULessonModel *lessonModel = downloadInfo.lessonModel;
    
    JUCourseDetailViewController *courseDetainVc = [[JUCourseDetailViewController alloc]init];
    
    courseDetainVc.course_id = lessonModel.course_id;
    courseDetainVc.course_title = lessonModel.course_tile;
    
    [self.navigationController pushViewController:courseDetainVc animated:NO];
    
    
}





#pragma mark 其它方法


#pragma mark  系统方法

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
    
}



















@end
