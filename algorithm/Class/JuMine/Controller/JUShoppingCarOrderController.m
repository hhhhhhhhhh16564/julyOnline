//
//  JUShoppingCarOrderController.m
//  algorithm
//
//  Created by 周磊 on 17/2/7.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUShoppingCarOrderController.h"
#import "JUMyOrderTableViewCell.h"
#import "JUCoverView.h"
#import "JURefeshHeader.h"
#import "JURefreshFooter.h"
#import "JUShoppingCarOrderModel.h"
#import "JUPayController.h"
static NSString *ShoppingCarOrderCell = @"ShoppingCarOrderCell";

@interface JUShoppingCarOrderController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) JUCoverView *coverView;
@property(nonatomic, strong) YBNetManager *manager;

@property (nonatomic,assign) NSUInteger pageIndex;

@property(nonatomic, strong) NSMutableArray<JUShoppingCarOrderModel *> *shoppingCarOrderArray;


// 上次加载请求的个数，用于删除后请求，如果上次个数小于4,就没必要请求了
@property (nonatomic,assign) NSInteger lastCount;

// 每页加载个数
@property (nonatomic,assign) NSInteger pageCount;

@end

@implementation JUShoppingCarOrderController

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
    
    self.navigationItem.title = @"我的订单";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = HCanvasColor(1);
    
    
    _pageCount = 10;
    
    _lastCount = _pageCount;
    [self setup_subViews];
    
    
    
    [self setupRefresh];
    
}



-(void)setup_subViews{

    [self setup_tableview];
    
    [self setup_CoverView];
    
    
    
}

-(void)setup_tableview{
    
    CGRect tableViewFrame =  CGRectMake(0, 74, Kwidth, Kheight-74);
    self.tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = HCanvasColor(1);
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[JUMyOrderTableViewCell class] forCellReuseIdentifier:ShoppingCarOrderCell];
    
}


-(void)setup_CoverView{
    
    JUCoverView *coverView = [[JUCoverView alloc]init];
    
    coverView.frame = CGRectMake(0, 64, Kwidth, Kheight-64);
    
    self.coverView = coverView;;

    
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
    
    JUMyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ShoppingCarOrderCell forIndexPath:indexPath];
    
    __weak typeof(self) weakSelf = self;
    
    cell.deleteOrderBlock = ^(JUShoppingCarOrderModel *shoppingCarOrderModel){
        
        [weakSelf deleteOrder:shoppingCarOrderModel];
        
    };
    
    
    cell.goPayBlock = ^(JUShoppingCarOrderModel *shoppingCarOrderModel){
        
        [weakSelf goPay:shoppingCarOrderModel];
        
    };
    
    
    
    cell.shoppingCarOrderModel = self.shoppingCarOrderArray[indexPath.row];
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    return  [self.shoppingCarOrderArray[indexPath.row] ShoppingCarOrderHeight];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.shoppingCarOrderArray.count;
}




- (void)loadNewTopics
{
    
    self.pageIndex = 1;
    
    [self.manager canceAllrequest];
    
    [self.tableView.mj_footer resetNoMoreData];
    
    
    __weak typeof(self) weakSelf = self;
    [self.manager GET:[self urlStringWithPage:self.pageIndex] parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
        
    } success:^(NSURLSessionDataTask *task, NSMutableDictionary * responobject) {
        
        JULog(@"ggggg  %@", responobject);
        
        [weakSelf.tableView.mj_header endRefreshing];
        
        if (![[responobject[@"errno"] description] isEqualToString:@"0"]) return ;
        
        
        weakSelf.shoppingCarOrderArray = [JUShoppingCarOrderModel mj_objectArrayWithKeyValuesArray:responobject[@"data"][@"orders"]];
        
        [weakSelf loadingViews];
        
        if (weakSelf.shoppingCarOrderArray.count < _pageCount) {
            
            weakSelf.tableView.mj_footer.hidden = YES;
            
            
        }
        
        [weakSelf.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        JULog(@"%@",error);
        
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
        
        [weakSelf.tableView.mj_footer endRefreshing];
        
        
//        JULog(@"fffffffff  %@",responobject);
        if (![[responobject[@"errno"] description] isEqualToString:@"0"]) return ;
        
        
        
        NSArray<JUShoppingCarOrderModel *> *moreOrderModels = [JUShoppingCarOrderModel mj_objectArrayWithKeyValuesArray:responobject[@"data"][@"orders"]];
        weakSelf.tableView.mj_footer.automaticallyHidden = YES;
        
        _lastCount = [moreOrderModels count];
        

        
        
        [weakSelf.shoppingCarOrderArray addObjectsFromArray:moreOrderModels];
        
        [weakSelf loadingViews];
        
        [weakSelf.tableView reloadData];
        
        if (!moreOrderModels.count) {
            
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
            return;
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        

        if (weakSelf.shoppingCarOrderArray.count) {
            
            
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
            return ;
            
        }
        
        
        
        [weakSelf.tableView.mj_footer endRefreshing];
        
        
    }];
    
    
    
    
}


//urlSting
-(NSString *)urlStringWithPage:(NSUInteger)pageIndex{
    
    return [NSString stringWithFormat:@"%@/%zd/%zd",shoppingCarOrderURL, pageIndex,_pageCount];
    
}


#pragma mark 删除订单

-(void)deleteOrder:(JUShoppingCarOrderModel *)shoppingCarOrderModel{
    
    __weak typeof(self) weakSelf = self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue ] >= 8.0) {
        UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:nil message:@"确定从购物车删除该课程吗？"preferredStyle:(UIAlertControllerStyleAlert)];
        
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf confirmdeleteOrder:shoppingCarOrderModel];
            
        }];
        
        [alterVC addAction:cancelAction];
        [alterVC addAction:confirmAction];
        
        [self.navigationController presentViewController:alterVC animated:NO completion:nil];
        
        
    }else{
        
        [self confirmdeleteOrder:shoppingCarOrderModel];
    }
    
    
}

#pragma mark 确定删除订单
-(void)confirmdeleteOrder:(JUShoppingCarOrderModel *)shoppingCarOrderModel{

    
    YBNetManager *manager = [[YBNetManager alloc]init];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",deleteOrderURL,shoppingCarOrderModel.oid];
    
    [manager GET:urlString parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, NSDictionary * responobject) {
        //        JULog(@"hhhh %@", responobject);
        
        if (![[responobject[@"errno"] description] isEqualToString:@"0"]) return ;
        
        NSMutableArray<JUShoppingCarOrderModel *> *tempArray = [self.shoppingCarOrderArray mutableCopy];
        __weak typeof(self) weakSelf = self;
        
        
        [tempArray enumerateObjectsUsingBlock:^(JUShoppingCarOrderModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.oid isEqualToString:shoppingCarOrderModel.oid]) {
                [weakSelf.shoppingCarOrderArray removeObject:obj];
                
                
                [weakSelf.tableView reloadData];
                //删除后判断个数，如果个数小于三个要自动加载数据, 防止实际上账号里还有数据但是，但是页面上没有了
                if (self.shoppingCarOrderArray.count < _pageCount-1) {
                    
                    //每次加载四个，如果上次加载是4个，就重新加载，否则，说明数据请求完毕，不需要加载,只需要刷新就可以了
                    
                    if (_lastCount == _pageCount) {
                        
                        [weakSelf loadMoreTopics];
                        
                    }else{
                        
                        [self loadingViews];
                        [self.tableView reloadData];
                        
                    }
                    
                    
                    
                    
                }else{
                    
                    [weakSelf.tableView reloadData];
                    
                    
                }
                
                
                *stop = YES;
                
            }
            
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
    

    
    
}





#pragma mark支付
-(void)goPay:(JUShoppingCarOrderModel *)shoppingCarOrderModel{
    
    JUPayController *payVC = [[JUPayController alloc]init];
    payVC.orderID = shoppingCarOrderModel.oid;
    [self.navigationController pushViewController:payVC animated:NO];
    
}










-(void)comeBackFromPurchaseController{
    
    NSInteger arrayCount = self.shoppingCarOrderArray.count;
    
    if (!arrayCount)return;
    
    
  NSString *urlString = [NSString stringWithFormat:@"%@/%zd/%zd",shoppingCarOrderURL, 1,arrayCount];
    
    
    __weak typeof(self) weakSelf = self;
    [self.manager GET:urlString parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
        
    } success:^(NSURLSessionDataTask *task, NSMutableDictionary * responobject) {
        
        if (![[responobject[@"errno"] description] isEqualToString:@"0"]) return ;
        
        
        weakSelf.shoppingCarOrderArray = [JUShoppingCarOrderModel mj_objectArrayWithKeyValuesArray:responobject[@"data"][@"orders"]];
        
        [weakSelf.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        JULog(@"%@",error);
        
    }];
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

//判断是否为空
-(void)loadingViews{
    
    [self.coverView removeFromSuperview];
    
    if (!self.shoppingCarOrderArray.count) {
        
        self.coverView.labelOneString = @"暂时没有订单";
        self.coverView.imageName = @"empty_box_sign";
        [self.view addSubview:self.coverView];
        
    }
    
    
    
    
}


@end
