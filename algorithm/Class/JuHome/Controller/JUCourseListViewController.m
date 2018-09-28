//
//  JUCourseListViewController.m
//  七月算法_iPad
//
//  Created by 周磊 on 16/6/1.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUCourseListViewController.h"
#import "JUCourseListCell.h"
#import "JULessonModel.h"
#import "JUMediaPlayerTool.h"
static NSString *courseListViewCell = @"courseListViewCell";
@interface JUCourseListViewController ()



@end

@implementation JUCourseListViewController


-(NSMutableArray *)CourselessonArray
{

    if (_CourselessonArray == nil) {
        
        _CourselessonArray = [NSMutableArray array];
    }
    
    return _CourselessonArray;
    
}

-(void)viewDidLoad
{
    
    [super viewDidLoad];
    
 
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downloadTaskDidFinishDownloadingNotification:) name:JuDownloadTaskDidFinishDownloadingNotification object:nil];
    
//    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changePlayedVedioNameColorNotification:) name:changePlayedVedioNameColorNotification object:nil];
//    
    
   
   //去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[JUCourseListCell class] forCellReuseIdentifier:courseListViewCell];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
  JUCourseListCell *cell =  [tableView dequeueReusableCellWithIdentifier:courseListViewCell forIndexPath:indexPath];
    //设置选中时没有背景色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JULessonModel *model = self.CourselessonArray[indexPath.row];

    
    NSString *nametext = [NSString stringWithFormat:@"%ld.  %@",(long)(indexPath.row+1),model.name];
    cell.nameLab.text = nametext;
    cell.lessonModel = model;
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.CourselessonArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [JUUmengStaticTool event:JUUmengStaticPlayerDetail key:JUUmengParamCatalogue value:@"ClickProgram"];

    
    JULessonModel *lessonModel = self.CourselessonArray[indexPath.row];
    if (JuuserInfo.isLogin) {
        
        JULessonModel *returenLessonModel = [lessonRecordDatabase getLessonModel:lessonModel];
        
        if (returenLessonModel) {
            lessonModel.timeRecord = returenLessonModel.timeRecord;
            lessonModel.isPlayed = returenLessonModel.isPlayed;
            lessonModel.timestamp = returenLessonModel.timestamp;

            [lessonRecordDatabase updateLessonModel:lessonModel];
        }else{
            [lessonRecordDatabase addLessonModel:lessonModel];
        }
        //需要添加时间戳
    }
        JUMediaPlayerTool *playTool = [JUMediaPlayerTool shareInstance];
        [playTool playVideoWithLessonModel:lessonModel];
    
        JULog(@"%@  %@   %@", lessonModel.play_url, lessonModel.course_id, lessonModel.ID);
    
        [self.tableView reloadData];

}


-(void)downloadTaskDidFinishDownloadingNotification:(NSNotification *)notifi{
    //给状态改变一点时间
    
    [self delayReloadData];
    
}


-(void)changePlayedVedioNameColorNotification:(NSNotification *)notifi{
    

    [self delayReloadData];
    
}


-(void)delayReloadData{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       
                       [self.tableView reloadData];
                       
                   });
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [JUUmengStaticTool event:JUUmengStaticPlayerDetail key:JUUmengParamCatalogue value:JUUmengStaticPV];
}


#pragma mark 系统方法
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}











@end
