//
//  JUMyCouponViewController.m
//  algorithm
//
//  Created by 周磊 on 17/1/22.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUMyCouponViewController.h"
#import "JUMyCouponViewCell.h"
#import "JUCoverView.h"
#import "JUMyCouponModel.h"
#import "JURefeshHeader.h"
#import "JURefreshFooter.h"
#import "YBLiveController.h"
#import "UIScrollView+Extension.h"
#import "JULiveCourseMoreController.h"
#import "YBLiveController.h"
#import "JULiveCourseDetailController.h"
#import "JULiveDetailController.h"

static NSString * const myCouponCell = @"myCouponCell";

@interface JUMyCouponViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *mainTableView;
@property(nonatomic, strong) JUCoverView *coverView;

@property(nonatomic, strong) NSMutableArray<JUMyCouponModel *> *couponModelArray;

@property(nonatomic, strong) YBNetManager *manager;

@property (nonatomic,assign) NSUInteger pageIndex;
@property(nonatomic, strong) UIView *headerView;
@property(nonatomic, strong) UITextField *tf;

@property(nonatomic, strong) UIButton *exchangeButton;

@end

@implementation JUMyCouponViewController

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
    
    self.navigationItem.title = @"优惠券";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = HCanvasColor(1);
    [self setup_subViews];
    [self setupRefresh];
    
    
    
}

-(void)setup_subViews{

    CGRect tableViewFrame =  CGRectMake(0, 64, Kwidth, Kheight-64);
    self.mainTableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.backgroundColor = HCanvasColor(1);
    self.mainTableView.yb_insetT = 56;
    [self.view addSubview:self.mainTableView];
    [self.mainTableView registerClass:[JUMyCouponViewCell class] forCellReuseIdentifier:myCouponCell];
    
    
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.frame = CGRectMake(0, 64, Kwidth, 56);
    UITextField *tf = [[UITextField alloc]init];
    [tf addTarget:self action:@selector(editingChanged:) forControlEvents:(UIControlEventEditingChanged)];
    tf.frame = CGRectMake(12, 10, Kwidth-36-84, 36);
    tf.placeholder = @" 请输入优惠码";
    tf.layer.cornerRadius = 3;
    
    UIColor *borderColor = Kcolor16rgb(@"dddddd", 1);
    tf.layer.borderColor = borderColor.CGColor;
    tf.layer.borderWidth = 1;
    [headerView addSubview:tf];
    self.tf = tf;
    
    
    UIButton *exchangeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [exchangeButton setTitle:@"兑换" forState:(UIControlStateNormal)];
    [exchangeButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    UIColor *normolColor = Kcolor16rgb(@"#cccccc", 1);
    UIColor *selectedColor = Kcolor16rgb(@"#0099ff", 1);
    exchangeButton.userInteractionEnabled = NO;
    [exchangeButton setBackgroundImage:[UIImage imageWithColor:normolColor] forState:(UIControlStateNormal)];
    [exchangeButton setBackgroundImage:[UIImage imageWithColor:selectedColor] forState:(UIControlStateSelected)];
    exchangeButton.layer.cornerRadius = 3;
    exchangeButton.titleLabel.font = UIptfont(18);
    exchangeButton.layer.masksToBounds = YES;
    exchangeButton.frame = CGRectMake(tf.right_extension+12, 10, 84, 36);
    [headerView addSubview:exchangeButton];
    [exchangeButton addTarget:self action:@selector(exchangeButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.exchangeButton = exchangeButton;
    [self.view addSubview:headerView];
    self.headerView = headerView;

    

    [self setup_CoverView];
}

-(void)editingChanged:(UITextField *)tf{
    
    if ([tf.text length]) {
        self.exchangeButton.selected = YES;
        self.exchangeButton.userInteractionEnabled = YES;
        
    }else{
        self.exchangeButton.selected = NO;
        self.exchangeButton.userInteractionEnabled = NO;

    }
    
    
}

-(void)exchangeButtonClicked:(UIButton *)button{
    
    YBNetManager *manager = [[YBNetManager alloc]init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"code"] = self.tf.text;
    __weak typeof(self) weakSelf = self;
    [manager GET:couponExchangeURL parameters:dict headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
    } success:^(NSURLSessionDataTask *task, NSDictionary * responobject) {
        
        JULog(@"兑换优惠券: %@", responobject);
        if (![responobject count]) return;
        if ([[responobject[@"errno"] description] isEqualToString:@"0"]) {
            
            [weakSelf loadNewTopics];
            [weakSelf showWithView:nil text:@"兑换成功" duration:1.5];
            
            
        }else{
            NSString *msg = [responobject[@"msg"] description];
            [weakSelf showWithView:nil text:msg duration:1.5];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        JULog(@"error:  %@", error);
    }];
    

    
//    self.tf.text = @"1D9D885ECE";
//
//    NSArray *array = @[
//                              @"CEE11060E5",
//                              @"74A96BAC03",
//                              @"2BFFB51122",
//                              @"E8A23AC68D",
//                              @"4DEB69CE44"
//                                                         ];    
//    if (![self.tf.text length]) {
//        [self showWithView:nil text:@"请输入优惠码" duration:1.5];
//        return;
//    }
//    
//    
//    
//    for (int i = 0; i < array.count ; i++) {
//        self.tf.text = array[i];
//        
//        
//        
//        
//        
//        
//        
//        
//        sleep(1);
//
//        
//        YBNetManager *manager = [[YBNetManager alloc]init];
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[@"code"] = self.tf.text;
//        __weak typeof(self) weakSelf = self;
//        [manager GET:couponExchangeURL parameters:dict headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
//        } success:^(NSURLSessionDataTask *task, NSDictionary * responobject) {
//            
//            JULog(@"兑换优惠券: %@", responobject);
//            if (![responobject count]) return;
//            if ([[responobject[@"errno"] description] isEqualToString:@"0"]) {
//                
//                [weakSelf loadNewTopics];
//                [weakSelf showWithView:nil text:@"兑换成功" duration:1.5];
//                
//                
//            }else{
//                NSString *msg = [responobject[@"msg"] description];
//                [weakSelf showWithView:nil text:msg duration:1.5];
//            }
//            
//            
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            JULog(@"error:  %@", error);
//        }];
//        
//        
//    }
//    
//    
//    
//    
    
    


    
}

-(void)setup_CoverView{
    
    JUCoverView *coverView = [[JUCoverView alloc]init];
    coverView.backgroundColor = HCanvasColor(1);
    coverView.frame = CGRectMake(0, -56, Kwidth, Kheight-64);
//    coverView.imageRect = CGRectMake(0, 120, 136.5, 134);
    

    self.coverView = coverView;
}

-(void)setupRefresh{
    //刷新数据
    self.mainTableView.mj_header = [JURefeshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    [self.mainTableView.mj_header beginRefreshing];
    self.mainTableView.mj_header.ignoredScrollViewContentInsetTop = 56;
    //加载更多数据
    self.mainTableView.mj_footer = [JURefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
  
}


#pragma mark 代理方法


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.couponModelArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    JUMyCouponViewCell *couponCell = [tableView dequeueReusableCellWithIdentifier:myCouponCell forIndexPath:indexPath];
    couponCell.allCouponModel = self.couponModelArray[indexPath.row];
    return couponCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 98;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    JULog(@"偏移量： %f", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y <= -scrollView.yb_insetT) {
        self.headerView.y_extension = -scrollView.contentOffset.y+64-56;
    }else{
        self.headerView.y_extension = 64;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     JUMyCouponModel *couponModel = self.couponModelArray[indexPath.row];
    
    if ([couponModel.limit_course isEqualToString:@"0"]) {
        
        YBLiveController *liveVC = [[YBLiveController alloc]init];
        [self.navigationController pushViewController:liveVC animated:NO];
        
    }else{
        
//        JULiveCourseDetailController *livcVC = [[JULiveCourseDetailController alloc]init];
//        livcVC.course_id = couponModel.limit_course;
//        livcVC.course_name = couponModel.course_title;
//        
//        [self.navigationController pushViewController:livcVC animated:YES];
        
        
        
        JULiveDetailController *liveDetailVC = [[JULiveDetailController alloc]init];
        liveDetailVC.course_id = couponModel.limit_course;
        liveDetailVC.course_name = couponModel.course_title;
        [self.navigationController pushViewController:liveDetailVC animated:NO];
        
    }
    
    
    
}



#pragma mark 请求数据  数据加载


- (void)loadNewTopics
{
    self.pageIndex = 1;
    
    [self.manager canceAllrequest];
    
    [self.mainTableView.mj_footer resetNoMoreData];
    
    
    __weak typeof(self) weakSelf = self;
    
    JULog(@"%@",  JuuserInfo.headDit);
    
    
    [self.manager GET:[self urlStringWithPage:self.pageIndex] parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
        
    } success:^(NSURLSessionDataTask *task, NSMutableDictionary * responobject) {
//        JULog(@"优惠券： %@", responobject);
        [weakSelf.mainTableView.mj_header endRefreshing];
        
        if (![responobject[@"data"] count]) {
            [self loadingViews];
        }
        if (![[responobject[@"errno"] description] isEqualToString:@"0"]) return ;
        weakSelf.couponModelArray = [JUMyCouponModel mj_objectArrayWithKeyValuesArray:responobject[@"data"]];
        [weakSelf loadingViews];
        if (weakSelf.couponModelArray.count <8) {
            weakSelf.mainTableView.mj_footer.hidden = YES;
        }
        [weakSelf.mainTableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        JULog(@"%@",error);
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
        
        [weakSelf.mainTableView.mj_footer endRefreshing];

        
        JULog(@"%@", responobject);
        if (![[responobject[@"errno"] description] isEqualToString:@"0"]){
            [weakSelf.mainTableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        
        NSArray<JUMyCouponModel *> *moreCouponModels = [JUMyCouponModel mj_objectArrayWithKeyValuesArray:responobject[@"data"]];
        weakSelf.mainTableView.mj_footer.automaticallyHidden = YES;

        if (!moreCouponModels.count) {
            
            [weakSelf.mainTableView.mj_footer endRefreshingWithNoMoreData];
            
            return;
        }

        [weakSelf.couponModelArray addObjectsFromArray:moreCouponModels];
    
        [weakSelf.mainTableView reloadData];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        if (weakSelf.couponModelArray.count) {
            [weakSelf.mainTableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        [weakSelf.mainTableView.mj_footer endRefreshing];
    }];
    
}



//urlSting
-(NSString *)urlStringWithPage:(NSUInteger)pageIndex{
    
    return [NSString stringWithFormat:@"%@/%zd/8",allMyCouponURL, pageIndex];

    
}


//判断是否为空
-(void)loadingViews{
    [self.coverView removeFromSuperview];
    if (!self.couponModelArray.count) {
        self.coverView.labelOneString = @"你还没有优惠券哦 ！";
        self.coverView.imageName = @"empty@youhuiquan";
        [self.mainTableView addSubview:self.coverView];
    }
    [self.mainTableView reloadData];
}

/*
 static NSString * const myCouponCell = @"myCouponCell";
 
 @interface JUMyCouponViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
 
 @property(nonatomic, strong) UICollectionView *collectionView;
 @property(nonatomic, strong) JUCoverView *coverView;
 
 @property(nonatomic, strong) NSMutableArray<JUMyCouponModel *> *couponModelArray;
 
 @property(nonatomic, strong) YBNetManager *manager;
 
 @property (nonatomic,assign) NSUInteger pageIndex;
 
 //因为后台错误，加一个字段区分
 //@property (nonatomic,assign) NSInteger arrayCount;
 
 @end
 
 @implementation JUMyCouponViewController
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
 
 self.navigationItem.title = @"优惠券";
 
 self.automaticallyAdjustsScrollViewInsets = NO;
 self.view.backgroundColor = HCanvasColor(1);
 
 
 [self setup_subViews];
 
 [self setupRefresh];
 
 }
 
 
 
 -(void)setup_subViews{
 
 CGRect rect = CGRectMake(10, 64, Kwidth-20, Kheight-64);
 
 CGFloat insetWitdth = 10;
 
 UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
 
 CGFloat  cellWidth = (Kwidth-insetWitdth*2-6)*0.5;
 
 
 layout.itemSize = CGSizeMake(cellWidth, cellWidth*1.3);
 
 layout.minimumLineSpacing = 6;
 layout.minimumInteritemSpacing = 6;
 
 UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:layout];
 collectionView.contentInset = UIEdgeInsetsMake(insetWitdth, 0 , insetWitdth, 0);
 collectionView.backgroundColor = HCanvasColor(1);
 collectionView.delegate = self;
 collectionView.dataSource = self;
 [self.view addSubview:collectionView];
 self.collectionView = collectionView;
 
 [self.collectionView registerClass:[JUMyCouponViewCell class] forCellWithReuseIdentifier:myCouponCell];
 
 
 
 
 [self setup_CoverView];
 
 
 
 }
 -(void)setup_CoverView{
 
 JUCoverView *coverView = [[JUCoverView alloc]init];
 coverView.backgroundColor = HCanvasColor(1);
 coverView.frame = CGRectMake(0, 64, Kwidth, Kheight-64);
 coverView.imageRect = CGRectMake(0, 120, 136.5, 134);
 coverView.textColor = Kcolor16rgb(@"#666666", 1);
 
 self.coverView = coverView;
 
 }
 
 -(void)setupRefresh{
 //刷新数据
 self.collectionView.mj_header = [JURefeshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
 [self.collectionView.mj_header beginRefreshing];
 
 
 //加载更多数据
 self.collectionView.mj_footer = [JURefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
 
 
 
 }
 
 
 #pragma mark 代理方法
 
 
 
 -(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
 
 return self.couponModelArray.count;
 }
 
 -(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
 
 JUMyCouponViewCell *couponCell = [collectionView dequeueReusableCellWithReuseIdentifier:myCouponCell forIndexPath:indexPath];
 __weak typeof(self) weakSelf = self;
 couponCell.goUseBlcok = ^(JUMyCouponModel *couponModel){
 
 UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
 pasteBoard.string = couponModel.code;
 
 YBLiveController *ybVC = [[YBLiveController alloc]init];
 [weakSelf.navigationController pushViewController:ybVC animated:NO];
 
 
 };
 
 
 couponCell.couponModel = self.couponModelArray[indexPath.row];
 
 return couponCell;
 
 }
 
 
 
 
 #pragma mark 请求数据  数据加载
 
 
 - (void)loadNewTopics
 {
 
 self.pageIndex = 1;
 
 [self.manager canceAllrequest];
 
 [self.collectionView.mj_footer resetNoMoreData];
 
 
 __weak typeof(self) weakSelf = self;
 [self.manager GET:[self urlStringWithPage:self.pageIndex] parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
 
 
 } success:^(NSURLSessionDataTask *task, NSMutableDictionary * responobject) {
 
 
 [weakSelf.collectionView.mj_header endRefreshing];
 
 if (![[responobject[@"errno"] description] isEqualToString:@"0"]) return ;
 
 
 weakSelf.couponModelArray = [JUMyCouponModel mj_objectArrayWithKeyValuesArray:responobject[@"data"][@"coupon"]];
 
 [weakSelf loadingViews];
 
 if (weakSelf.couponModelArray.count <8) {
 
 weakSelf.collectionView.mj_footer.hidden = YES;
 
 
 }
 
 [weakSelf.collectionView reloadData];
 
 
 } failure:^(NSURLSessionDataTask *task, NSError *error) {
 
 JULog(@"%@",error);
 
 [weakSelf.collectionView.mj_header endRefreshing];
 
 }];
 
 }
 
 - (void)loadMoreTopics
 {
 
 self.pageIndex++;
 
 [self.manager canceAllrequest];
 
 __weak typeof(self) weakSelf = self;
 
 [self.collectionView.mj_footer resetNoMoreData];
 
 
 [self.manager GET:[self urlStringWithPage:self.pageIndex] parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
 
 
 
 } success:^(NSURLSessionDataTask *task, NSMutableDictionary * responobject) {
 
 [weakSelf.collectionView.mj_footer endRefreshing];
 
 
 if (![[responobject[@"errno"] description] isEqualToString:@"0"]) return ;
 
 
 
 NSArray<JUMyCouponModel *> *moreCouponModels = [JUMyCouponModel mj_objectArrayWithKeyValuesArray:responobject[@"data"][@"coupon"]];
 weakSelf.collectionView.mj_footer.automaticallyHidden = YES;
 
 
 
 if (!moreCouponModels.count) {
 
 [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
 
 return;
 }
 
 
 [weakSelf.couponModelArray addObjectsFromArray:moreCouponModels];
 
 [weakSelf.collectionView reloadData];
 
 
 
 
 } failure:^(NSURLSessionDataTask *task, NSError *error) {
 
 
 
 if (weakSelf.couponModelArray.count) {
 
 
 [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
 
 return ;
 
 }
 
 [weakSelf.collectionView.mj_footer endRefreshing];
 
 }];
 
 }
 
 
 
 //urlSting
 -(NSString *)urlStringWithPage:(NSUInteger)pageIndex{
 
 return [NSString stringWithFormat:@"%@/%zd/8",myCouponCodeURL, pageIndex];
 
 
 }
 
 
 
 
 
 //判断是否为空
 -(void)loadingViews{
 
 [self.coverView removeFromSuperview];
 
 if (!self.couponModelArray.count) {
 
 self.coverView.labelOneString = @"你还没有优惠券哦 ！";
 //        self.coverView.labelTwoString = @"赶紧去购买吧";
 self.coverView.imageName = @"empty@youhuiquan";
 [self.collectionView addSubview:self.coverView];
 
 
 }
 
 [self.collectionView reloadData];
 
 }

 
 */







@end
