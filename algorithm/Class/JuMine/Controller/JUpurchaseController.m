//
//  JUpurchaseController.m
//  algorithm
//
//  Created by 周磊 on 16/9/14.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUpurchaseController.h"
#import "JUPurchaseCell.h"

#import "JUPurchaseModel.h"

#import "JUCourseDetailViewController.h"
#import "JULiveCourseDetailController.h"

#import "JUCoverView.h"
#import "JUShoppingCarController.h"
#import "JUShoppingCarOrderController.h"
#import "JUPurchaseManager.h"

#import "JULiveDetailController.h"
@interface JUpurchaseController ()

@property(nonatomic, strong) NSMutableArray<JUPurchaseModel *> *purchesArray;

@property(nonatomic, strong) JUCoverView *coverView;

@property(nonatomic, strong) NSMutableArray *tempArray;

@end

static NSString * const PurchaseCell = @"PurchaseCell";

static NSString * const appPurchaseGoodsID = @"appPurchaseGoodsID";


@implementation JUpurchaseController



-(NSMutableArray *)purchesArray{
    
    if (!_purchesArray) {
        _purchesArray = [NSMutableArray array];
    }
    
    return _purchesArray;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.automaticallyAdjustsScrollViewInsets = YES;
    
    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
        
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"appPurchase" ofType:@"plist"];
        NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:bundlePath];
        NSArray *array = dic[@"data"][@"courses"];
        self.tempArray = [JUPurchaseModel mj_objectArrayWithKeyValuesArray:array];

    }
    
    
    [self setNaviationBar];
    
    [self setupViews];
    
    
    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
        
      NSMutableArray *array = [NSMutableArray array];
      NSMutableArray *goodArray = [[NSUserDefaults standardUserDefaults] objectForKey:appPurchaseGoodsID];
        
        [self.tempArray enumerateObjectsUsingBlock:^(JUPurchaseModel *  _Nonnull purchaseModel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            
            [goodArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([purchaseModel.course_id isEqualToString:obj]) {
                    [array addObject:purchaseModel];
                }
            }];
        }];
        
        
        
        self.purchesArray = array;
        
        [self loadingViews];
        
        
    }
    
    
    
    
    
    
    
    //当从已经购买界面进来时
    
    if ([JuuserInfo.showstring isEqualToString:@"0"] && self.restorePurchased) {

        
        NSMutableArray *purchaseArray = [NSMutableArray array];
        NSMutableArray *goodsArray = [NSMutableArray array];
        
        JUPurchaseManager *manager = [JUPurchaseManager shareManager];
        [manager restoreCompletedTransactionsSuccess:^{
            
            [MBProgressHUD hideHUD];

            
        } failure:^{
            
            [MBProgressHUD hideHUD];

            
        }];
        [MBProgressHUD showMessage:@"数据加载中"];
        JULog(@"数据加载中————————————————————————————————————>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n\n\n\n\n\n\n\n\\n\n");
        __weak typeof(self) weakSelf = self;
        manager.callblock = ^(JUPaymentTransactionState state, NSMutableArray *array){
            if (state==JUPaymentTransactionStateRestored && [array count]) {
                
                for (JUPurchaseModel * purchaseModel in weakSelf.tempArray) {
                    
                    [array enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        if ([obj isEqualToString:purchaseModel.course_id]) {
                            
                            [goodsArray addObject:obj];
                            
                            [purchaseArray addObject:purchaseModel];
                            *stop = YES;
                            
                            JULog(@"------- %@", obj);
                        }
                    }];
                }
                
                [[NSUserDefaults standardUserDefaults] setObject:goodsArray forKey:appPurchaseGoodsID];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                weakSelf.purchesArray = purchaseArray;
                [weakSelf loadingViews];
                
            }
            
            
            
        };
        

        
    
    
    
    }
    
    
    
    if ([JuuserInfo.showstring isEqualToString:@"0"]) return;
    
    [self makeDate];

}

-(void)setNaviationBar{
    
self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"btn_black_back" highImage:nil];
    
  
    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [button setTitle:@"恢复购买" forState:(UIControlStateNormal)];
        button.titleLabel.font = UIptfont(14);
        UIColor *color = Kcolor16rgb(@"#0099ff", 1);
        
        UIColor *grayColor = Kcolor16rgb(@"#dddddd", 1);
        [button setBackgroundImage:[UIImage imageWithColor:grayColor] forState:(UIControlStateNormal)];
        button.frame = CGRectMake(0, 0, 70, 30);
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;

        [button addTarget:self action:@selector(restorePurchase) forControlEvents:(UIControlEventTouchUpInside)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        
        button.userInteractionEnabled = NO;

    
        
        JUPurchaseManager *manager = [JUPurchaseManager shareManager];
        
        
        if (manager.productsArray.count) {
            
            button.userInteractionEnabled = YES;
            [button setBackgroundImage:[UIImage imageWithColor:color] forState:(UIControlStateNormal)];

            JULog(@"早已经初始化");
            
        }else{
            
            [manager startRequestWithArray:nil];
            
            manager.requestSucceedBlock = ^(NSArray * productsArray){
                JULog(@" 初始化");

                button.userInteractionEnabled = YES;
                [button setBackgroundImage:[UIImage imageWithColor:color] forState:(UIControlStateNormal)];

            };
        }
   

    }
    
}

//返回

-(void)back{
    

    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        //购物车购买返回 购物车
        if ( [vc isKindOfClass:[JUShoppingCarController class]]) {
            JUShoppingCarController *shoppingVC = (JUShoppingCarController *)vc;
            [shoppingVC comeBackFromPayController];
            
            [self.navigationController popToViewController:vc animated:NO];
            
            
            return;
        }
        // 正常购买返回
        if ( [vc isKindOfClass:[JULiveCourseDetailController class]]) {
            

            [self.navigationController popToViewController:vc animated:NO];
            return;
            
            
        }
        
        if ( [vc isKindOfClass:[JULiveDetailController class]]) {
            
            
            [self.navigationController popToViewController:vc animated:NO];
            return;
            
            
        }
        
        // 订单页面
        if ( [vc isKindOfClass:[JUShoppingCarOrderController class]]) {
            JUShoppingCarOrderController *shoppingOrderVC = (JUShoppingCarOrderController *)vc;
            
            [shoppingOrderVC comeBackFromPurchaseController];
            
    
            [self.navigationController popToViewController:vc animated:NO];
            
            
            
            return;
        }
        
    }
    
    [self.navigationController popToRootViewControllerAnimated:NO];

}






-(void)setupViews{
    

    self.navigationItem.title = @"已购课程";


    [self.tableView registerClass:[JUPurchaseCell class] forCellReuseIdentifier:PurchaseCell];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    JUCoverView *coverView = [[JUCoverView alloc]init];
    coverView.frame = CGRectMake(0, 0, Kwidth, Kheight-49-64);
    self.coverView = coverView;
    
}


#pragma  mark 代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JUPurchaseCell *cell = [tableView dequeueReusableCellWithIdentifier:PurchaseCell forIndexPath:indexPath];
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    

    cell.purchaseModel = self.purchesArray[indexPath.row];

    cell.lineView.hidden = (indexPath.row == self.purchesArray.count-1);

    
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.purchesArray.count;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JUCourseDetailViewController *detailVC = [[JUCourseDetailViewController alloc]init];
    
    detailVC.course_id = self.purchesArray[indexPath.row].v_id;
    detailVC.course_title = self.purchesArray[indexPath.row].course_title;
    
    JULog(@"%@", detailVC.course_id);
    
    if ([detailVC.course_id isEqualToString:@"0"]) {
        
        
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        GMToast *toasts = [[GMToast alloc]initWithView:window text:@"暂无视频" duration:1.5];
        [toasts show];
        return;
        
    }
    
    
    
    [self.navigationController pushViewController:detailVC animated:NO];
    
    
    
    
}

//内购恢复购买
-(void)restorePurchase{
    
    NSMutableArray *purchaseArray = [NSMutableArray array];
    NSMutableArray *goodsArray = [NSMutableArray array];
    
    JUPurchaseManager *manager = [JUPurchaseManager shareManager];
    [manager restoreCompletedTransactionsSuccess:^{
        
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"恢复购买成功"];
        
    } failure:^{
        
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"恢复购买失败"];
        
    }];
    [MBProgressHUD showMessage:@"恢复购买中"];
    
    __weak typeof(self) weakSelf = self;
    manager.callblock = ^(JUPaymentTransactionState state, NSMutableArray *array){
        if (state==JUPaymentTransactionStateRestored && [array count]) {
            
            for (JUPurchaseModel * purchaseModel in weakSelf.tempArray) {
                
                [array enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                   
                    if ([obj isEqualToString:purchaseModel.course_id]) {
                        
                        [goodsArray addObject:obj];
                        
                        [purchaseArray addObject:purchaseModel];
                        *stop = YES;
                        
                        JULog(@"------- %@", obj);
                    }
                }];
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:goodsArray forKey:appPurchaseGoodsID];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            weakSelf.purchesArray = purchaseArray;
            [weakSelf loadingViews];
            
        }
        
        
        
    };
    
    
}

#pragma mark 请求数据
-(void)makeDate{
    
    YBNetManager *mannger = [[YBNetManager alloc]init];
    
    [mannger GET:myCoursesURL parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, NSDictionary *responobject) {

        
//        [responobject writeToFile:@"/Users/julyonline/Desktop/study_YY/appPurchase.plist" atomically:YES];
        
//                JULog(@"%@", responobject);
        
        if (![responobject[@"data"][@"courses"] count]) {
            
            [self loadingViews];
            
            return ;

        }
        self.purchesArray = [JUPurchaseModel mj_objectArrayWithKeyValuesArray:responobject[@"data"][@"courses"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadingViews];
            
            [self.tableView reloadData];
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
        
}
-(void)loadingViews{
    
    [self.coverView removeFromSuperview];

    if (!self.purchesArray.count) {
        
        self.coverView.labelOneString = @"暂时没有购买的课程";
        self.coverView.labelTwoString = @"赶紧去购买吧";
        self.coverView.imageName = @"empty_box_sign";
        
        if ([JuuserInfo.showstring isEqualToString:@"0"]) {
            
            self.coverView.labelTwoString = @"请点击恢复购买按钮或者去购买吧";

        }
        
        
        [self.tableView addSubview:self.coverView];
        
        return;
        
    }
    
    
    [self.tableView reloadData];
    
    
}



#pragma mark 系统方法

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    [self.navigationController.navigationBar setBarTintColor:HCanvasColor(1)];
    //设置title的字体颜色和样式
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor blackColor];
    dict[NSFontAttributeName] = UIptfont(34*KMultiplier);
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    
    
}






@end
