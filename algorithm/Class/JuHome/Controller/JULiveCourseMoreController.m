//
//  JULiveCourseMoreController.m
//  algorithm
//
//  Created by 周磊 on 16/9/13.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JULiveCourseMoreController.h"
#import "JULiveCourseMoreCell.h"
#import "JULiveModel.h"
#import "JULiveCourseDetailController.h"
#import "JURefeshHeader.h"
#import "JURefreshFooter.h"
#import "JULiveDetailController.h"
#import "JULiveDetailController.h"
static NSString * const liveCourseMoreCell = @"liveCourseMoreCell";
@interface JULiveCourseMoreController ()

@property(nonatomic, strong) NSMutableArray<JULiveModel *> *liveCoursesArray;

@property(nonatomic, strong) YBNetManager *manager;

@property (nonatomic,assign) NSUInteger pageIndex;


//因为后台错误，加一个字段区分
@property (nonatomic,assign) NSInteger arrayCount;

@end

@implementation JULiveCourseMoreController

-(NSMutableArray *)liveCoursesArray{
    
    if (!_liveCoursesArray) {
        _liveCoursesArray = [NSMutableArray array];
    }
    
    return _liveCoursesArray;
}


- (YBNetManager *)manager
{
    if (!_manager) {
        _manager = [[YBNetManager alloc]init];
    }
    return _manager;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupViews];
    
    [self setupRefresh];

}

-(void)setupViews{
    
    
    [self.tableView registerClass:[JULiveCourseMoreCell class] forCellReuseIdentifier:liveCourseMoreCell];
 
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

-(void)setupRefresh{
   
    
    //刷新数据
    self.tableView.mj_header = [JURefeshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    [self.tableView.mj_header beginRefreshing];
    
    //加载更多数据
    self.tableView.mj_footer = [JURefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}




#pragma  mark 代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JULiveCourseMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:liveCourseMoreCell forIndexPath:indexPath];
    
    cell.liveModel = self.liveCoursesArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.lineView.hidden = (indexPath.row == self.liveCoursesArray.count-1);
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 30+Kwidth*0.4*0.72;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.liveCoursesArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [JUUmengStaticTool event:JUUmengStaticAllLiveCourse key:JUUmengParamCourseClick value:self.CategoryModel.category_id];

    
    if ([JuuserInfo.showstring isEqualToString:@"1"]) {
        
        JULiveDetailController *liveDetailVC = [[JULiveDetailController alloc]init];
        JULiveModel *liveModel = self.liveCoursesArray[indexPath.row];
        
        liveDetailVC.course_id = liveModel.course_id;
        liveDetailVC.course_name = liveModel.course_name;
        [self.navigationController pushViewController:liveDetailVC animated:NO];
        
    }else{
        
        
            JULiveCourseDetailController *detailVc = [[JULiveCourseDetailController alloc]init];
        
            JULiveModel *liveModel = self.liveCoursesArray[indexPath.row];
        
            detailVc.course_id = liveModel.course_id;
            detailVc.course_name = liveModel.course_name;
        
        
            [self.navigationController pushViewController:detailVc animated:NO];
        
        
        
    }
    
   
    
 
    
    

    
    
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
        
        
        weakSelf.liveCoursesArray = [JULiveModel mj_objectArrayWithKeyValuesArray:responobject[@"data"][@"courses"]];

        [weakSelf.tableView reloadData];
        
        if (weakSelf.liveCoursesArray.count <5) {
            
            weakSelf.tableView.mj_footer.hidden = YES;
            
            
        }

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
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
        
  
        
        NSArray<JULiveModel *> *moreLiveModels = [JULiveModel mj_objectArrayWithKeyValuesArray:responobject[@"data"][@"courses"]];
              weakSelf.tableView.mj_footer.automaticallyHidden = YES;
        
        if (!moreLiveModels.count) {
            
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
//
//            weakSelf.tableView.mj_footer.hidden = YES;
            
            return;
        }
        
       [weakSelf.tableView.mj_footer endRefreshing];
        
        [weakSelf.liveCoursesArray addObjectsFromArray:moreLiveModels];
        
        
        weakSelf.arrayCount = weakSelf.liveCoursesArray.count;
        
        
        [weakSelf.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (weakSelf.liveCoursesArray.count) {
            
            
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
            return ;
            
        }
        
        
        
        [weakSelf.tableView.mj_footer endRefreshing];
        
        
    }];
    
    
    
    
}



//urlSting
-(NSString *)urlStringWithPage:(NSUInteger)pageIndex{
    
   return [NSString stringWithFormat:@"%@/%@/%zd/5",liveCourseCatetoryURL2_1, self.CategoryModel.category_id, pageIndex];

}



-(void)setCategoryModel:(JUMoreCategoryModel *)CategoryModel{
    
    _CategoryModel = CategoryModel;
    
    
//    [self makeDate];
    
}

















@end
