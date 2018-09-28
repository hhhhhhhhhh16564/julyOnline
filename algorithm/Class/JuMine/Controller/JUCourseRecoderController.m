//
//  JUCourseRecoderController.m
//  algorithm
//
//  Created by pro on 16/7/14.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUCourseRecoderController.h"
#import "JURecordCell.h"
#import "JUCourseRecoderModel.h"

#import "JUCourseDetailViewController.h"
#import "JUCoverView.h"
#import "JURefeshHeader.h"
#import "JURefreshFooter.h"

static NSString *recordCell = @"JURecordCell1111111";
@interface JUCourseRecoderController ()
@property(nonatomic, strong) JUCoverView *coverView;

//课程记录
@property(nonatomic, strong) NSMutableArray * mainDataArray;

@property (nonatomic,assign) NSInteger pageIndex;

@property(nonatomic, strong) YBNetManager *manager;


@end

@implementation JUCourseRecoderController



-(NSMutableArray *)mainDataArray{
    
    
    if (_mainDataArray==nil) {
        
        _mainDataArray = [NSMutableArray array];
    }
    
    return _mainDataArray;
    
}

-(YBNetManager *)manager{
    
    if (!_manager) {
        _manager = [[YBNetManager alloc]init];
    }
    return _manager;
}


#pragma mark 视图布局
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationItem.title = @"学习记录";
    [self.tableView registerClass:[JURecordCell class] forCellReuseIdentifier:recordCell];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    JUCoverView *coverView = [[JUCoverView alloc]init];
    coverView.frame = CGRectMake(0, 0, Kwidth, Kheight-49-64);
    self.coverView = coverView;

    [self setupRefresh];
    
}

-(void)setupRefresh{

    //刷新数据
    self.tableView.mj_header = [JURefeshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    [self.tableView.mj_header beginRefreshing];
    
    //加载更多数据
    self.tableView.mj_footer = [JURefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

#pragma mark 代理方法

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    JURecordCell *cell = [tableView dequeueReusableCellWithIdentifier:recordCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
    JUCourseRecoderModel *courseRecoderModel = self.mainDataArray[indexPath.row];
//    cell.courseRecoderModel = courseRecoderModel;

    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 30+Kwidth*0.33*0.72;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.mainDataArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JUCourseDetailViewController *detaiVC = [[JUCourseDetailViewController alloc]init];
    
         detaiVC.isAutoPlay = YES;

        JUCourseRecoderModel *recoderModel = self.mainDataArray[indexPath.row];
        
        detaiVC.course_id = recoderModel.course_id;
        detaiVC.course_title = recoderModel.course_title;
        
        JULessonModel *lessonModel = [[JULessonModel alloc]init];
        lessonModel.play_url = recoderModel.last_video.play_url;
        lessonModel.ID = recoderModel.last_video.video_id;
        lessonModel.course_id = recoderModel.course_id;
        lessonModel.name = recoderModel.last_video.video_name;
//       lessonModel.img = recoderModel.last_lesson.logo;

        detaiVC.lessonModel = lessonModel;
 
    JULog(@"%@  %@   %@", detaiVC.lessonModel.course_id, detaiVC.lessonModel.ID,detaiVC.lessonModel.play_url);

    [self.navigationController pushViewController:detaiVC animated:NO];

}


#pragma mark 其它方法
//课程记录
//-(void)makeStudyRecoderDate{
//    
//    __weak typeof(self) weakSelf = self;
//    
//    YBNetManager *mannager = [[YBNetManager alloc]init];
//    
//    
//    
//    [mannager GET:getCourseRecoder parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
//        
//        
//    } success:^(NSURLSessionDataTask *task, id responobject) {
//        
////        JULog(@"%@", responobject);
//
//        NSMutableDictionary *dict = responobject[@"w_learn"];
//        //移除之前的所有数据，重新开始加载数据
//        
//        if (dict[@"courses"]) {
//            weakSelf.mainDataArray = [JUCourseRecoderModel mj_objectArrayWithKeyValuesArray:dict[@"courses"]];
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self loadingViews];
//        });
//        
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//        
//        JULog(@"%@", error);
//        
//    }];
//    
//}











-(void)loadingViews{

    [self.coverView removeFromSuperview];
    
    if (!self.mainDataArray.count) {
            self.coverView.labelOneString = @"学习记录空空如也";
            self.coverView.labelTwoString = @"赶紧去学习吧";
            self.coverView.imageName = @"emty_studyRecoder";
        
        [self.tableView addSubview:self.coverView];
        
        return;

    }

    
    [self.tableView reloadData];
    
    
}


#pragma makr 响应方法

#pragma mark 系统方法
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:HCanvasColor(1)];
    //设置title的字体颜色和样式
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor blackColor];
    dict[NSFontAttributeName] = UIptfont(34*KMultiplier);
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
//    [self makeStudyRecoderDate];
    
    [self loadNewTopics];
    
}



#pragma mark 请求数据  数据加载


- (void)loadNewTopics
{


    self.pageIndex = 1;
    
    [self.manager canceAllrequest];
    
    [self.tableView.mj_footer resetNoMoreData];
    
    
    __weak typeof(self) weakSelf = self;
    [self.manager GET:[self urlStringWithPage:self.pageIndex] parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, NSMutableDictionary * responobject) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        
        if (![[responobject[@"errno"] description] isEqualToString:@"0"]) return ;
        
//        JULog(@"%@", responobject);
        
        weakSelf.mainDataArray = [JUCourseRecoderModel mj_objectArrayWithKeyValuesArray:responobject[@"data"][@"record"]];

        
       
        
//        [weakSelf.tableView reloadData];
        
        [self loadingViews];
        
        if (weakSelf.mainDataArray.count <5) {
            
            weakSelf.tableView.mj_footer.hidden = YES;
            
            
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
         JULog(@"%@", error);
        [weakSelf.tableView.mj_header endRefreshing];

        
    }];
    
   


    
    
    
}


- (void)loadMoreTopics
{
    
    self.pageIndex++;
    
    [self.manager canceAllrequest];
    
    __weak typeof(self) weakSelf = self;
    
    [self.tableView.mj_footer resetNoMoreData];
    
    
    
    [self.manager GET:[self urlStringWithPage:self.pageIndex] parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, NSMutableDictionary * responobject) {
        
        if (![[responobject[@"errno"] description] isEqualToString:@"0"]) return ;
        NSArray  *moreLiveModels = [JUCourseRecoderModel mj_objectArrayWithKeyValuesArray:responobject[@"data"][@"record"]];
        weakSelf.tableView.mj_footer.automaticallyHidden = YES;
        
        if (!moreLiveModels.count) {
            
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                        
            return;
        }
        
        [weakSelf.tableView.mj_footer endRefreshing];
        
        [weakSelf.mainDataArray addObjectsFromArray:moreLiveModels];

        [weakSelf.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (weakSelf.mainDataArray.count) {
            
            
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
            return ;
            
        }
        
        
        
        [weakSelf.tableView.mj_footer endRefreshing];
        
        
    }];
    
    
    
    
}



//urlSting
-(NSString *)urlStringWithPage:(NSUInteger)pageIndex{
    
    return [NSString stringWithFormat:@"%@/%zd/5", getUserLearnRecord2, self.pageIndex];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
