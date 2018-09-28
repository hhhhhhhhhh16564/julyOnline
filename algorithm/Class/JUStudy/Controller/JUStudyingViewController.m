//
//  JUStudyingViewController.m
//  algorithm
//
//  Created by yanbo on 17/9/15.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUStudyingViewController.h"
#import "JURefreshFooter.h"
#import "JURefeshHeader.h"
#import "JURecordCell.h"
#import "JUStudyingRecorderModel.h"
#import "JUCourseDetailViewController.h"

#import "YBLiveController.h"

#import "JULiveDetailController.h"


static  NSString * const studyingViewCell = @"studyingViewCell";

@interface JUStudyingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UIView *footView;

@property(nonatomic, strong) UIView *contentView;

@property(nonatomic, strong) NSMutableArray *mainDataArray;
@property(nonatomic, strong) YBNetManager *manager;

@property (nonatomic,assign) NSUInteger pageIndex;
@end

@implementation JUStudyingViewController
- (YBNetManager *)manager
{
    if (!_manager) {
        _manager = [[YBNetManager alloc]init];
    }
    return _manager;
}
-(UIView *)footView{
    

    if (!_footView) {
        
        UIView *footView = [[UIView alloc]init];
        footView.frame = CGRectMake(0, 0, Kwidth, Kwidth*0.4*0.72+15+15);
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture)];
        [footView addGestureRecognizer:tapGesture];
        
        
        UIImageView *imv = [[UIImageView alloc]init];
        imv.image = [UIImage imageNamed:@"add_class_icon"];
        [footView addSubview:imv];
        
        [imv mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.left.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(Kwidth*0.4, Kwidth*0.4*0.72));
            
        }];
        
        
        UILabel *addLabel = [[UILabel alloc]init];
        addLabel.textColor = Kcolor16rgb(@"333333", 1);
        addLabel.text = @"添加课程";
        addLabel.font = UIptfont(15);
        [footView addSubview:addLabel];
        
        [addLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(imv);
            make.left.equalTo(imv.mas_right).offset(20);
            
        }];
        
        
        
        UIImageView *arrowImv = [[UIImageView alloc]init];
        arrowImv.image = [UIImage imageNamed:@"lujing_icon"];
        [footView addSubview:arrowImv];
        
        [arrowImv mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(imv);
            
            make.right.equalTo(footView.mas_right).offset(-20);
            
        }];
        
        _footView = footView;
        
    }
    return _footView;
    
}
-(void)tapGesture{
    
    
 
    NSUInteger count =  self.tabBarController.childViewControllers.count;
    

    YBLiveController *liveVC = nil;
    
    for (int i = 0; i < count; i++) {
        UIViewController *VC = self.tabBarController.childViewControllers[i];
        
        UIViewController *chilvc =  VC.childViewControllers[0];
        
        if ([chilvc isKindOfClass:[YBLiveController class]]) {
            liveVC = (YBLiveController *)chilvc;
            break;
        }
    }
    
    
    [liveVC SelectedIndex:0];
    
    
    
    [self.tabBarController setSelectedIndex:1];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self setup_subViews];
}

-(void)setup_subViews{
    
    UIView *conentView = [[UIView alloc]init];
    conentView.frame = self.view.bounds;
    
    
    [self.view addSubview:conentView];
    self.contentView = conentView;

    UITableView *mainTableView = [[UITableView alloc]init];
    mainTableView.frame = self.contentView.bounds;
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:mainTableView];
    self.mainTableView = mainTableView;

    [self.mainTableView registerClass:[JURecordCell class] forCellReuseIdentifier:studyingViewCell];
    
    self.mainTableView.mj_header = [JURefeshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    
//    [self.mainTableView.mj_header beginRefreshing];
    self.mainTableView.tableFooterView = self.footView;
    self.mainTableView.mj_footer = [JURefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];

}


-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.contentView.frame = self.view.bounds;
    self.mainTableView.frame = self.contentView.bounds;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    JURecordCell *cell = [tableView dequeueReusableCellWithIdentifier:studyingViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.backgroundColor = RandomColor;
    
    JUStudyingRecorderModel *recorderModel = self.mainDataArray[indexPath.row];
    
    cell.recorderModel = recorderModel;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    
    JUStudyingRecorderModel *recorderModel = self.mainDataArray[indexPath.row];

 
    
    JUCourseDetailViewController *detailVC = [[JUCourseDetailViewController alloc]init];
    detailVC.course_title = recorderModel.course_title;
    detailVC.course_id = recorderModel.course_id;
    [self.navigationController pushViewController:detailVC animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Kwidth*0.4*0.72+15+10;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
 
    return self.mainDataArray.count;
}





#pragma mark 数据处理


- (void)loadNewTopics
{
    
    if (!JuuserInfo.isLogin) {
        [self.mainDataArray removeAllObjects];
        [self.mainTableView reloadData];
        [self.mainTableView.mj_header endRefreshing];

        return;
        
    }
    
    
    self.pageIndex = 1;
    
    [self.manager canceAllrequest];
    
    [self.mainTableView.mj_footer resetNoMoreData];
    
    
    __weak typeof(self) weakSelf = self;
    [self.manager GET:[self urlStringWithPage:self.pageIndex] parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
        
    } success:^(NSURLSessionDataTask *task, NSMutableDictionary * responobject) {
  
        JULog(@"%@", responobject);

//        JULog(@"----------- : %@", responobject);

        [weakSelf.mainTableView.mj_header endRefreshing];
        
        // 如果是404的话，代表没有数据
        if ([[responobject[@"errno"] description] isEqualToString:@"404"]){
            
            weakSelf.mainDataArray = nil;
            [weakSelf.mainTableView reloadData];
            
        }
        
        if (![[responobject[@"errno"] description] isEqualToString:@"0"]) return ;
        
        weakSelf.mainDataArray = [JUStudyingRecorderModel mj_objectArrayWithKeyValuesArray:responobject[@"data"][@"record"]];
        

//        [UIView createPropertyCodeWithDict:responobject[@"data"][@"record"]];
        
        [weakSelf.mainTableView reloadData];
        
        if (weakSelf.mainDataArray.count <10) {
            
            weakSelf.mainTableView.mj_footer.hidden = YES;

        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        JULog(@"%@", error);

        [weakSelf.mainTableView.mj_header endRefreshing];
        
    }];
    
    
    
    
    
}

- (void)loadMoreTopics
{
    
    self.pageIndex++;
    
    [self.manager canceAllrequest];
    
    __weak typeof(self) weakSelf = self;
    
    [self.mainTableView.mj_footer resetNoMoreData];
    
    
    [self.manager GET:[self urlStringWithPage:self.pageIndex] parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
        
        
    } success:^(NSURLSessionDataTask *task, NSMutableDictionary * responobject) {
        
        if (![[responobject[@"errno"] description] isEqualToString:@"0"]) return ;

        NSArray *moreDataModels = [JUStudyingRecorderModel mj_objectArrayWithKeyValuesArray:responobject[@"data"][@"record"]];
        weakSelf.mainTableView.mj_footer.automaticallyHidden = YES;
        
        if (!moreDataModels.count) {
            
            [weakSelf.mainTableView.mj_footer endRefreshingWithNoMoreData];
            
            return;
        }
        
        [weakSelf.mainTableView.mj_footer endRefreshing];
        
        [weakSelf.mainDataArray addObjectsFromArray:moreDataModels];
        [weakSelf.mainTableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (weakSelf.mainDataArray.count) {

            [weakSelf.mainTableView.mj_footer endRefreshingWithNoMoreData];
            return ;
            
        }

        [weakSelf.mainTableView.mj_footer endRefreshing];
    }];
    
    
    
    
}



//urlSting
-(NSString *)urlStringWithPage:(NSUInteger)pageIndex{
    
    return [NSString stringWithFormat:@"%@/%zd/10",V30StudyingCourse, pageIndex];
    
}





-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

//    JULog(@"11111111111");
//    [self loadNewTopics];
    
}

-(void)view_WillAppear:(BOOL)animated{
    
//    JULog(@"0000000");
    [self loadNewTopics];
    
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
