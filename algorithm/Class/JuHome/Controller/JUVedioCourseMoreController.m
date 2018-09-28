//
//  JUVedioCourseMoreController.m
//  algorithm
//
//  Created by 周磊 on 16/9/14.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUVedioCourseMoreController.h"
#import "JUVideoModel.h"
#import "JUCourseDetailViewController.h"
#import "JUVideoCourseMoreCell.h"
#import "JURefeshHeader.h"
#import "JURefreshFooter.h"


static NSString * const VideoCourseMoreCell = @"VedioCourseMoreController";

@interface JUVedioCourseMoreController ()

@property(nonatomic, strong) NSMutableArray<JUVideoModel *> *vidoeCoursesArray;

@property(nonatomic, strong) YBNetManager *manager;

@property (nonatomic,assign) NSUInteger pageIndex;

@end


@implementation JUVedioCourseMoreController


-(NSMutableArray *)vidoeCoursesArray{
    
    if (!_vidoeCoursesArray) {
        _vidoeCoursesArray = [NSMutableArray array];
    }
    
    return _vidoeCoursesArray;
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
    
    
    [self.tableView registerClass:[JUVideoCourseMoreCell class] forCellReuseIdentifier:VideoCourseMoreCell];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

-(void)setupRefresh{
    
    self.tableView.mj_header = [JURefeshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [JURefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
    
    
}

#pragma  mark 代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JUVideoCourseMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:VideoCourseMoreCell forIndexPath:indexPath];
    
  

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.videoModel = self.vidoeCoursesArray[indexPath.row];
    
    cell.lineView.hidden = (indexPath.row == self.vidoeCoursesArray.count-1);

    
   return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 115;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.vidoeCoursesArray.count;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [JUUmengStaticTool event:JUUmengStaticAllVideo key:JUUmengParamCourseClick value:self.CategoryModel.cat_id];

    
    JUCourseDetailViewController *detailVC = [[JUCourseDetailViewController alloc]init];
    
    detailVC.course_id = self.vidoeCoursesArray[indexPath.row].v_course_id;
    detailVC.course_title = self.vidoeCoursesArray[indexPath.row].video_course_name;
    
    [self.navigationController pushViewController:detailVC animated:NO];
    
  
    
    
}






#pragma mark 请求数据

- (void)loadNewTopics
{
    
    self.pageIndex = 1;
    
        JULog(@"%@", [self urlStringWithPage:1]);
    
    [self.manager canceAllrequest];
    
    [self.tableView.mj_footer resetNoMoreData];
    
    
    __weak typeof(self) weakSelf = self;
    [self.manager GET:[self urlStringWithPage:self.pageIndex] parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
        
        
    } success:^(NSURLSessionDataTask *task, NSMutableDictionary * responobject) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        
        if (![[responobject[@"errno"] description] isEqualToString:@"0"]) return ;
        
        
        weakSelf.vidoeCoursesArray = [JUVideoModel mj_objectArrayWithKeyValuesArray:responobject[@"data"][@"video"]];
        
        [weakSelf.tableView reloadData];
        
        if (weakSelf.vidoeCoursesArray.count <5) {
            
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
        
        
        
        NSArray<JUVideoModel *> *morevideoModels = [JUVideoModel mj_objectArrayWithKeyValuesArray:responobject[@"data"][@"video"]];
        weakSelf.tableView.mj_footer.automaticallyHidden = YES;
        
        
        
        if (!morevideoModels.count) {
            
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            


            //
            //            weakSelf.tableView.mj_footer.hidden = YES;
            
            return;
        }
        
        [weakSelf.tableView.mj_footer endRefreshing];
        
        [weakSelf.vidoeCoursesArray addObjectsFromArray:morevideoModels];
        
        [weakSelf.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [weakSelf.tableView.mj_footer endRefreshing];
        
        
        
    }];
    
    
    
    
}







//urlSting
-(NSString *)urlStringWithPage:(NSUInteger)pageIndex{
    
    
    JULog(@"%@", self.CategoryModel);
    
    return [NSString stringWithFormat:@"%@/%@/%zd/5",vedioCourseCatetoryURL2_1, self.CategoryModel.cat_id, pageIndex];
    
    
}



-(void)setCategoryModel:(JUMoreCategoryModel *)CategoryModel{
    
    _CategoryModel = CategoryModel;
    
    
//    JULog(@"%@", CategoryModel);
    [CategoryModel logObjectExtension_YanBo];
    //    [self makeDate];
    
    
    
}

@end
