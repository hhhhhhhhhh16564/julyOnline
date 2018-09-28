//
//  JUFreeCourseController.m
//  algorithm
//
//  Created by yanbo on 17/9/21.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUFreeCourseController.h"
#import "JUFreeCollectionCell.h"
#import "JURefeshHeader.h"
#import "JURefreshFooter.h"
#import "JUFreeCourseModel.h"
#import "JUCourseDetailViewController.h"
static NSString * const freeCollectionCell = @"freeCollectionCell";
@interface JUFreeCourseController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, strong) UIView *contentView;

@property(nonatomic, strong) NSMutableArray *mainDataArray;


 
@property(nonatomic, strong) YBNetManager *manager;

@property (nonatomic,assign) NSUInteger pageIndex;
@end

@implementation JUFreeCourseController
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
    
    [self setup_subViews];
}


-(void)setup_subViews{
    
    
    UIView *conentView = [[UIView alloc]init];
    conentView.frame = self.view.bounds;
    [self.view addSubview:conentView];
    self.contentView = conentView;
    
 
    
    CGFloat Kspacing = 15;
    UICollectionViewFlowLayout *flowyout = [[UICollectionViewFlowLayout alloc]init];
    //    flowyout.itemSize = CGSizeMake(kItemWith, kItemHeitht+33.5);
    flowyout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowyout.minimumLineSpacing = 0;
    flowyout.sectionInset = UIEdgeInsetsMake(Kspacing, Kspacing, 0, Kspacing);
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.contentView.bounds collectionViewLayout:flowyout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    //    collectionView.backgroundColor = Kcolor16rgb(@"f4f4f4", 1);
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.bounces = YES;
    collectionView.alwaysBounceVertical = YES;
    self.mainCollectionView = collectionView;
    
    
    self.mainCollectionView.mj_header = [JURefeshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    
    [self.mainCollectionView.mj_header beginRefreshing];
    self.mainCollectionView.mj_footer = [JURefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
    
    [self.contentView addSubview:self.mainCollectionView];
    
    [self.mainCollectionView registerClass:[JUFreeCollectionCell class] forCellWithReuseIdentifier:freeCollectionCell];
    
    
//    self.view.backgroundColor = [UIColor redColor];
//    
//    self.mainCollectionView.backgroundColor = [UIColor greenColor];

}


-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    JULog(@"%@", NSStringFromCGRect(self.view.bounds));
    
    self.contentView.frame = self.view.bounds;
    self.mainCollectionView.frame = self.contentView.bounds;
}


//(Kwidth-15*3)/2
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat kItemWith = (Kwidth-15*3)/2;
    return CGSizeMake(kItemWith, kItemWith * 0.72+10+14+7+12+7+12+15);
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
 
//    JULog(@"%zd", self.mainDataArray.count);
    
    return self.mainDataArray.count;
    
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JUFreeCollectionCell *cell = [self.mainCollectionView dequeueReusableCellWithReuseIdentifier:freeCollectionCell forIndexPath:indexPath];
    cell.freeCourseModel = self.mainDataArray[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JUFreeCourseModel *freeModel = self.mainDataArray[indexPath.row];
    
    JUCourseDetailViewController *detailVC = [[JUCourseDetailViewController alloc]init];
    detailVC.course_id = freeModel.v_course_id;
    detailVC.course_title = freeModel.video_course_name;
    [self.navigationController pushViewController:detailVC animated:NO];
    
    
}

#pragma mark 数据处理


- (void)loadNewTopics
{
    
    self.pageIndex = 1;
    
    [self.manager canceAllrequest];
    
    [self.mainCollectionView.mj_footer resetNoMoreData];
    
    
    __weak typeof(self) weakSelf = self;
    [self.manager GET:[self urlStringWithPage:self.pageIndex] parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
        
        
    } success:^(NSURLSessionDataTask *task, NSMutableDictionary * responobject) {
        
        JULog(@"==========%@", responobject);
        
//        [responobject writeToFile:@"/Users/pro/Desktop/资料/22.plist" atomically:YES];
        
        [weakSelf.mainCollectionView.mj_header endRefreshing];
        
        if (![[responobject[@"errno"] description] isEqualToString:@"0"]) return ;
        
        
        weakSelf.mainDataArray = [JUFreeCourseModel mj_objectArrayWithKeyValuesArray:responobject[@"data"][@"courses"]];
        
        
//        [UIView createPropertyCodeWithDict:responobject[@"data"][@"courses"]];
        
        [weakSelf.mainCollectionView reloadData];
        
        if (weakSelf.mainDataArray.count < 10) {
            
            weakSelf.mainCollectionView.mj_footer.hidden = YES;
            
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [weakSelf.mainCollectionView.mj_header endRefreshing];
        
    }];
    
    
    
    
    
}

- (void)loadMoreTopics
{
    
    self.pageIndex++;
    
    [self.manager canceAllrequest];
    
    __weak typeof(self) weakSelf = self;
    
    [self.mainCollectionView.mj_footer resetNoMoreData];
    
    
    [self.manager GET:[self urlStringWithPage:self.pageIndex] parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
        
        
    } success:^(NSURLSessionDataTask *task, NSMutableDictionary * responobject) {
        
      
        
        
        if (![[responobject[@"errno"] description] isEqualToString:@"0"]) return ;
        NSArray *moreDataModels = [JUFreeCourseModel mj_objectArrayWithKeyValuesArray:responobject[@"data"][@"courses"]];
        weakSelf.mainCollectionView.mj_footer.automaticallyHidden = YES;
        
        if (!moreDataModels.count) {
            
            [weakSelf.mainCollectionView.mj_footer endRefreshingWithNoMoreData];
            
            return;
        }
        
        [weakSelf.mainCollectionView.mj_footer endRefreshing];
        
        [weakSelf.mainDataArray addObjectsFromArray:moreDataModels];
        [weakSelf.mainCollectionView reloadData];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (weakSelf.mainDataArray.count) {
            
            [weakSelf.mainCollectionView.mj_footer endRefreshingWithNoMoreData];
            return ;
            
        }
        
        [weakSelf.mainCollectionView.mj_footer endRefreshing];
    }];
    
    
    
    
}



//urlSting
-(NSString *)urlStringWithPage:(NSUInteger)pageIndex{
    
    return [NSString stringWithFormat:@"%@/%zd/10",V30freeCourses, pageIndex];
    
}


-(void)view_WillAppear:(BOOL)animated{
    
    [self loadNewTopics];
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
