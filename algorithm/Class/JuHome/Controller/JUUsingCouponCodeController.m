//
//  JUUsingCouponCodeController.m
//  algorithm
//
//  Created by 周磊 on 17/5/9.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUUsingCouponCodeController.h"
#import "JUMyCouponViewCell.h"
#import "JUCoverView.h"
#import "JUMyCouponModel.h"
#import "JURefeshHeader.h"
#import "JURefreshFooter.h"
#import "YBLiveController.h"
#import "UIScrollView+Extension.h"

static NSString * const myCouponCell = @"myCouponCell";

@interface JUUsingCouponCodeController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *mainTableView;
@property(nonatomic, strong) JUCoverView *coverView;

//@property(nonatomic, strong) NSMutableArray<JUMyCouponModel *> *couponModelArray;

@property(nonatomic, strong) NSMutableArray *validCouponArray;

@property(nonatomic, strong) NSMutableArray *invalidCouponArray;

@property(nonatomic, strong) YBNetManager *manager;

@property (nonatomic,assign) NSUInteger pageIndex;
@property(nonatomic, strong) UIView *headerView;

@property(nonatomic, strong) UITextField *tf;

@property(nonatomic, strong) UIButton *exchangeButton;

@end

@implementation JUUsingCouponCodeController


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
    
    self.navigationItem.title = @"选择优惠券";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.view.backgroundColor = HCanvasColor(1);
    [self setup_subViews];
    [self setupRefresh];
    
//    self.couponModelArray = [NSMutableArray array];
//    for (int i = 0; i < 15; i++) {
//        
//        JUMyCouponModel *model = [[JUMyCouponModel alloc]init];
//        model.category = arc4random() % 3;
//        model.selected = (model.category == 2);
//       
//        [self.couponModelArray addObject:model];
//        
//    }
//    
    
    
}

-(void)setup_subViews{
    
    CGRect tableViewFrame =  CGRectMake(0, 64, Kwidth, Kheight-64);
    self.mainTableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.mainTableView.backgroundColor = HCanvasColor(1);
    self.mainTableView.backgroundColor = [UIColor whiteColor];
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
    
    
//    
//    UIView *footView = [[UIView alloc]init];
//    footView.backgroundColor = [UIColor whiteColor];
////    footView.backgroundColor = [UIColor greenColor];
//    footView.frame = CGRectMake(0, self.mainTableView.height_extension-61-headerView.height_extension, Kwidth, 61);
//    [self.mainTableView addSubview:footView];
//    self.footView = footView;
//  
//    
//    UIButton *confirmUsingButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [confirmUsingButton setTitle:@"确认使用" forState:(UIControlStateNormal)];
//    UIColor *titleColor = Kcolor16rgb(@"0099ff", 1);
//    [confirmUsingButton setTitleColor:titleColor forState:(UIControlStateNormal)];
//    confirmUsingButton.titleLabel.font = UIptfont(18);
//    confirmUsingButton.layer.borderColor = titleColor.CGColor;
//    confirmUsingButton.layer.cornerRadius = 4;
//    confirmUsingButton.layer.borderWidth = 1;
//    confirmUsingButton.frame = CGRectMake(0, 0, Kwidth-24, 44);
//    [footView addSubview:confirmUsingButton];
//    [confirmUsingButton XY_centerInSuperView];
//    [confirmUsingButton addTarget:self action:@selector(confirmUsingButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];


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
    

    
    
    
       
    
}

-(void)setup_CoverView{
    
    JUCoverView *coverView = [[JUCoverView alloc]init];
    coverView.backgroundColor = HCanvasColor(1);
    coverView.frame = CGRectMake(0, -56, Kwidth, Kheight-64);
//    coverView.imageRect = CGRectMake(0, 120, 136.5, 134);
//    coverView.textColor = Kcolor16rgb(@"#666666", 1);
    
    self.coverView = coverView;
}

-(void)setupRefresh{
    //刷新数据
    self.mainTableView.mj_header = [JURefeshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    [self.mainTableView.mj_header beginRefreshing];
    self.mainTableView.mj_header.ignoredScrollViewContentInsetTop = 56;

    
}
#pragma mark 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.couponModelArray.count;
    
    if (section == 0) {
        return self.validCouponArray.count;
    }else{
        return self.invalidCouponArray.count;
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JUMyCouponViewCell *couponCell = [tableView dequeueReusableCellWithIdentifier:myCouponCell forIndexPath:indexPath];
    
    JUMyCouponModel *couponModel = nil;
    
    if (indexPath.section == 0) {
        
        couponModel = self.validCouponArray[indexPath.row];
        couponModel.isCanUsed = YES;
    }else{
        
        couponModel = self.invalidCouponArray[indexPath.row];
        couponModel.isCanUsed = NO;

    }
    
    
    couponCell.usingCouponModel = couponModel;
    
    return couponCell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 98;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1)return;
    
    
    if (networkingType == NotReachable) {
        
        [self showWithView:nil text:@"请检查你的网络" duration:1.5];
        return;
    }
    
    
    
    JUMyCouponModel *couponModel = self.validCouponArray[indexPath.row];

    if (couponModel.selected) {//取消使用
        [self.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
        [self cancelCoupon:couponModel];
    }else{//去使用
        [self selectCoupon:couponModel];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.validCouponArray.count) {
            return 0;
        }else{
            return 210;
        }
     
    }else if(section == 1){
        
        if (self.invalidCouponArray.count) {
            return 44;
        }else{
            return 0;
        }

        
    }
    
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    

    UIView *sectionHeadView = [[UIView alloc]init];
    sectionHeadView.backgroundColor = [UIColor whiteColor];
    return sectionHeadView;
    
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{


    
    
    
    if (section == 0) {

        JUCoverView *coverView = [[JUCoverView alloc]init];
        coverView.imageViewTop = 50;
        coverView.labelTop = 5;
        coverView.frame = view.bounds;
        coverView.labelOneString = @"暂无该课程可用的优惠券 ！";
        coverView.imageName = @"empty@youhuiquan";
        
        
        
        [view addSubview:coverView];
        

        
    }else if(section == 1){
        UIView *seperatorView = [[UIView alloc]init];
        seperatorView.backgroundColor = Kcolor16rgb(@"e7eaf1", 1);
        seperatorView.frame = CGRectMake(0, 0, Kwidth-24, 1);
        [view addSubview:seperatorView];
        
        
        
        UILabel *label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        label.frame = CGRectMake(0, 0, 180, 30);
        label.font = UIptfont(14);
        label.textColor = Kcolor16rgb(@"#333333", 1);
        [view addSubview:label];
        
        [label XY_centerInSuperView];
        [seperatorView XY_centerInSuperView];
        label.text = @"不可用的优惠券";
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//        JULog(@"偏移量： %f", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y <= -scrollView.yb_insetT) {
//        self.headerView.y_extension = -scrollView.contentOffset.y+64-56;
        self.headerView.y_extension = -scrollView.contentOffset.y+8;

    }else{
        self.headerView.y_extension = 64;
    }
    
}




//判断是否为空
-(void)loadingViews{
    

    
    [self.coverView removeFromSuperview];
    if (!self.invalidCouponArray.count && !self.validCouponArray) {
        self.coverView.labelOneString = @"你还没有优惠券哦 ！";
        //        self.coverView.labelTwoString = @"赶紧去购买吧";
        self.coverView.imageName = @"empty@youhuiquan";
        [self.mainTableView addSubview:self.coverView];


    }
    [self.mainTableView reloadData];
}

#pragma mark数据处理

//-(void)dealSourceDate:(JUMyCouponModel *)couponModel{
//    
//    BOOL isSelected = couponModel.selected;
//    
//    //如果是使用的
//    [self.validCouponArray enumerateObjectsUsingBlock:^(JUMyCouponModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        obj.selected = NO;
//    }];
//    
//    if (isSelected) {
//    }else{//如果之前没被选中现在是选中状态
//        couponModel.selected = YES;
//    }
//    [self.mainTableView reloadData];
//}


-(void)loadNewTopics{
    __weak typeof(self) weakSelf = self;

    YBNetManager *manager = [[YBNetManager alloc]init];

    NSString *urlString = [NSString stringWithFormat:@"%@%@", checkCourseCouponURL,self.courseID];
    
    [manager GET:urlString parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, NSDictionary * responobject) {
        
        [weakSelf.mainTableView.mj_header endRefreshing];
        
//        JULog(@"%@", responobject);
        
        if ([[responobject[@"errno"] description] isEqualToString:@"0"]) {

            //有效的
            weakSelf.validCouponArray = [JUMyCouponModel mj_objectArrayWithKeyValuesArray:responobject[@"data"][@"valid_coupons"]];
            
            //已经使用的
            NSArray *inuse_couponArray = [JUMyCouponModel mj_objectArrayWithKeyValuesArray:responobject[@"data"][@"inuse_coupon"]];
            
            [inuse_couponArray enumerateObjectsUsingBlock:^(JUMyCouponModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.selected = YES;
                [weakSelf.validCouponArray insertObject:obj atIndex:idx];
            }];
            
            //无效的
            weakSelf.invalidCouponArray = [JUMyCouponModel mj_objectArrayWithKeyValuesArray:responobject[@"data"][@"invalid_coupons"]];
            
            [weakSelf.mainTableView reloadData];
            
        }else{
            
            [weakSelf showWithView:nil text:responobject[@"msg"] duration:1.5];
            
        }
 
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        JULog(@"%@", error);
        [weakSelf.mainTableView.mj_header endRefreshing];

        
    }];

}

-(void)selectCoupon:(JUMyCouponModel *)couponModel{
    __weak typeof(self) weakSelf = self;
    YBNetManager *manager = [[YBNetManager alloc]init];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@",couponSelectURL, self.courseID, couponModel.ID];
    
    [manager GET:urlString parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
  
        
    } success:^(NSURLSessionDataTask *task, NSDictionary * responobject) {
        
//        JULog(@"使用优惠券: %@", responobject);
        if ([[responobject[@"errno"] description] isEqualToString:@"0"]) {
            
            [weakSelf.navigationController popViewControllerAnimated:NO];
        }else{
            
            [weakSelf showWithView:nil text:responobject[@"msg"] duration:1.5];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
    
    
    
    
}

-(void)cancelCoupon:(JUMyCouponModel *)couponModel{
    
    __weak typeof(self) weakSelf = self;
    YBNetManager *manager = [[YBNetManager alloc]init];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",couponCancelURL, self.courseID ];
    
    [manager GET:urlString parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
        
        
    } success:^(NSURLSessionDataTask *task, NSDictionary * responobject) {
        
//        JULog(@"使用优惠券: %@", responobject);
        if ([[responobject[@"errno"] description] isEqualToString:@"0"]) {
            
            couponModel.selected = NO;
            
            [self loadNewTopics];
            
            [weakSelf showWithView:nil text:@"已经取消使用优惠券" duration:0.5];
        }else{
            
            [weakSelf showWithView:nil text:responobject[@"msg"] duration:1.5];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
    
    
    
    
    
}
























@end
