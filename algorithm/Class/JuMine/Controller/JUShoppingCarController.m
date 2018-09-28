//
//  JUShoppingCarController.m
//  algorithm
//
//  Created by 周磊 on 17/1/18.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUShoppingCarController.h"
#import "JUShoppingCarCell.h"
#import "JUShoppingCarModel.h"
#import "JUCoverView.h"
#import "JUDiscountRulesController.h"
#import "JUapplyController.h"
#import "NSArray+Extension.h"
#import "JULoginViewController.h"
#import "YBLiveController.h"
@interface JUShoppingCarController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>


{
    NSString * _courseID;
    
}



@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) UIView *footView;
@property(nonatomic, strong) UILabel *priceLabel;

@property(nonatomic, strong) NSMutableArray *shoppingCarArray;

@property(nonatomic, strong) NSString *totalPrice;

@property(nonatomic, strong) UIButton *chooseAllButton;

@property(nonatomic, strong) UIButton *calcuteButton;

//用来记录是否已经选中改按钮
//@property (nonatomic,strong) NSMutableDictionary *recoderDict;

//返回的修改购物车的数组
@property(nonatomic, strong) NSMutableArray<JUShoppingCarModel *> *changeArray;


@property(nonatomic, strong) JUCoverView *coverView;

@property(nonatomic, strong) NSString *purchaseTotalPrice;

@property(nonatomic, strong) NSMutableArray *stringArray;

@end

static NSString *const shoppingCell = @"shoppingCarCell";

@implementation JUShoppingCarController



/*
 

 
 */

-(NSMutableArray<JUShoppingCarModel *> *)changeArray{
    
    if (!_changeArray) {
        _changeArray = [NSMutableArray array];
    }
    return _changeArray;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shoppingCarSelectedNotification) name:JUShoppingCarSelectedNotification object:nil];
    

    self.navigationItem.title = @"购物车";
    [self setup_SubViews];
    
//    [self makeData];

    [self loginAction];

    
}

// 从支付页面返回要重新请求数据

-(void)comeBackFromPayController{
    
//    [self makeData];
    
}

-(void)setup_SubViews{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    [self setup_tableview];
    [self setFootView];
    
    [self setup_CoverView];
    
}


-(void)setup_tableview{
    
    CGRect tableViewFrame =  CGRectMake(0, 64, Kwidth, Kheight-64-34);
    self.tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = HCanvasColor(1);
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[JUShoppingCarCell class] forCellReuseIdentifier:shoppingCell];
    
}


-(void)setFootView{
    
    //尾部确认订单
    UIView *footView = [[UIView alloc]init];
    footView.frame = CGRectMake(0, Kheight-44, Kwidth, 44);
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    self.footView = footView;
    
    
    UIView *lineView3= [[UIView alloc]init];
    lineView3.backgroundColor = HCommomSeperatorline(1);
    lineView3.frame = CGRectMake(0, 0, Kwidth, 0.5);
    [footView addSubview:lineView3];
    
    
    UIButton *chooseAllButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [UIButton buttonWithNormalTitle:@"全选" selectedTitle:@"取消全选" titlefont:15 titleColor:nil button:chooseAllButton];
    chooseAllButton.selected = YES;
    [chooseAllButton addTarget:self action:@selector(chooseAllButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];

    [chooseAllButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    
    [UIButton buttonWithNormalImage:[UIImage imageNamed:@"daixuan@shop"] selectedImage:[UIImage imageNamed:@"duihao@icon"] button:chooseAllButton];
    
    chooseAllButton.frame = CGRectMake(10, 0, 90, 44);
    [self.footView addSubview:chooseAllButton];
    self.chooseAllButton = chooseAllButton;
    
    
    
    UILabel *totalLable = [[UILabel alloc]init];
    totalLable.font = UIptfont(17);
    CGFloat fragmentWidth = (Kwidth-110)*0.3333;
    totalLable.frame = CGRectMake(fragmentWidth, 0, fragmentWidth, 44);
    totalLable.textAlignment = NSTextAlignmentRight;
    totalLable.text = @"合计:";
    [self.footView addSubview:totalLable];
    
    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
        totalLable.text = @"优惠价:";
    }
    
    
    UILabel *priceLabel = [[UILabel alloc]init];
    priceLabel.font = UIptfont(17);
    priceLabel.textColor = [UIColor redColor];
    priceLabel.frame = CGRectMake(fragmentWidth * 2, 0, fragmentWidth, 44);
    priceLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.footView addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    
    
    UIButton *calculateButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    calculateButton.frame = CGRectMake(Kwidth-110, 0, 110, 44);
    UIColor *backgroundImageColor = Kcolor16rgb(@"#18b4ed", 1);
    //    [confirmButton setBackgroundImage:[UIImage imageWithColor:backgroundImageColor] forState:(UIControlStateNormal)];
    
    [calculateButton setBackgroundColor:backgroundImageColor];
    [calculateButton setTitle:@"结算 (0)" forState:(UIControlStateNormal)];
   
    
    [calculateButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    [calculateButton.titleLabel setFont:UIptfont(17)];
    
    [calculateButton addTarget:self action:@selector(calculateButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
     self.calcuteButton = calculateButton;
    [self.footView addSubview:calculateButton];
    
}

-(void)setup_CoverView{
    
    JUCoverView *coverView = [[JUCoverView alloc]init];

    coverView.backgroundColor = HCanvasColor(1);
    coverView.frame = CGRectMake(0, 64, Kwidth, Kheight-64);
//    coverView.imageRect = CGRectMake(0, 120, 138.5, 133);
    [coverView.button setTitle:@"去选课" forState:(UIControlStateNormal)];
    coverView.button.frame = CGRectMake(0, 0, 84, 24);
    
    coverView.labelOneString = @"空空如也，快去选几门课吧!";
    coverView.imageName = @"shop@empty";
    
    __weak typeof(self) weakSelf = self;
    
    coverView.buttonBlock = ^{
    
        
        
        NSUInteger count =  weakSelf.tabBarController.childViewControllers.count;
        
        
        YBLiveController *liveVC = nil;
        
        for (int i = 0; i < count; i++) {
            UIViewController *VC = weakSelf.tabBarController.childViewControllers[i];
            UIViewController *chilvc =  VC.childViewControllers[0];
            if ([chilvc isKindOfClass:[YBLiveController class]]) {
                liveVC = (YBLiveController *)chilvc;
                break;
            }
        }
        
        [liveVC SelectedIndex:0];
        
        
        weakSelf.tabBarController.selectedIndex = 1;

        [weakSelf.navigationController popToRootViewControllerAnimated:NO];
    
    };
    
    
    [self.view addSubview: coverView];
    
    
    self.coverView = coverView;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
       JUShoppingCarCell *cell = [tableView dequeueReusableCellWithIdentifier:shoppingCell forIndexPath:indexPath];
    
    __weak typeof(self) weakSelf = self;
    
    //删除
    
    cell.deleteBlock = ^(NSString *courseID){
        
        _courseID = courseID;
 
        [weakSelf decideDeleteCourse];
        
        
    };
    
    //优惠规则
    
//    cell.discountRuleBlock = ^(JUShoppingCarModel *shoppingCarModel){
//        
//        //优惠规则
//        JUDiscountRulesController *disCountVC = [[JUDiscountRulesController alloc]init];
//        disCountVC.course_id = shoppingCarModel.course_id;
//        
//        disCountVC.price_level = shoppingCarModel.level;
//        
//        [weakSelf.navigationController pushViewController:disCountVC animated:NO];
//
//    };
    
    
    

    cell.shoppingCarModel = self.shoppingCarArray[indexPath.row];
 
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //加10是因为重新设置cell的fram时高度减去10,所以这儿要加上10
    
    // 90是固定高度，
    return 90+Kwidth*0.3334*0.72+10-44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.shoppingCarArray.count;
}


#pragma mark 响应事件

-(void)calculateButtonAction:(UIButton *)sender{
    [JUUmengStaticTool event:JUUmengStaticShoppingCart key:JUUmengStaticShoppingCart value:@"Buy"];

    NSMutableArray  *array = [NSMutableArray array];
    
    [self.shoppingCarArray enumerateObjectsUsingBlock:^(JUShoppingCarModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.isSelected == YES) {
            [array addObject:obj.course_id];
        }
        
    }];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *jsonString = array.jsonStringEncoded;
    
    if (![jsonString length]) {
        jsonString = @" ";
    }
    
    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
//    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
//    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    dict[@"course_id"] = jsonString;

    
    if ([array count]) {
        
        JUapplyController *applyVc = [[JUapplyController alloc]init];
        applyVc.dict = dict;
        applyVc.purchaseTotalPrice = self.purchaseTotalPrice;
        [self.navigationController pushViewController:applyVc animated:NO];

    }else{
        
        [sender showWithView:nil text:@"你还没有选择课程" duration:1.5];
        
        
    }
    

    JUlogFunction
}




-(void)chooseAllButtonClicked:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        [self.shoppingCarArray enumerateObjectsUsingBlock:^(JUShoppingCarModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            obj.isSelected = YES;
            
        }];
        
    }else{
        
        
        [self.shoppingCarArray enumerateObjectsUsingBlock:^(JUShoppingCarModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            obj.isSelected = NO;
            
        }];
        
        
    }
    
    
    [self.tableView reloadData];
    [self shoppingCarSelectedNotification];
 
    
}


#pragma mark 通知方法

-(void)shoppingCarSelectedNotification{
    
    NSMutableArray *array = [NSMutableArray array];
    [self.shoppingCarArray enumerateObjectsUsingBlock:^(JUShoppingCarModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.isSelected) {
            
            [array addObject:obj.course_id];
        }
        
    }];
    
    NSString *countString = [NSString stringWithFormat:@"结算 (%zd)", array.count];
    [self.calcuteButton setTitle:countString forState:(UIControlStateNormal)];
    
    
    if (array.count == self.shoppingCarArray.count) {
        
        self.chooseAllButton.selected = YES;
    }else{
        
        self.chooseAllButton.selected = NO;
    }
    
#pragma mark 判断是否购物车为空
    
    [self loadingViews];
    

    
    if (![array count]){
        
        self.priceLabel.text = [NSString stringWithFormat:@"¥0"];
        
        return;
        
    }

//    [SVProgressHUD showWithStatus:@"正在加载中" maskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在加载中"];

    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    YBNetManager *manager = [[YBNetManager alloc]init];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    NSString *jsonString = array.jsonStringEncoded;
    
    dict[@"course_id"] = jsonString;
    
    JULog(@"%@", dict);
    
    [self.changeArray removeAllObjects];
    
    __weak typeof(self) weakSelf = self;

    [manager POST:changeShoppingCarURL parameters:dict headdict:JuuserInfo.headDit constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } progress:^(NSProgress * _Nonnull Progress) {
        
        
    } success:^(NSURLSessionDataTask *task, NSDictionary * responseObject) {
        
//        JULog(@"%@", responseObject);
        
        [SVProgressHUD dismiss];
        
        if ([[responseObject[@"errno"] description] isEqualToString:@"0"]) {
            
            weakSelf.stringArray = array;
            
            weakSelf.changeArray = [JUShoppingCarModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"course"]];
            
            [weakSelf.changeArray enumerateObjectsUsingBlock:^(JUShoppingCarModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                obj.isSelected = YES;
                
            }];
            
            weakSelf.totalPrice = [responseObject[@"data"][@"total"] description];

            
            NSMutableArray *tempArray = [weakSelf.shoppingCarArray mutableCopy];
            
            [tempArray enumerateObjectsUsingBlock:^(JUShoppingCarModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                for (JUShoppingCarModel *Model in weakSelf.changeArray) {
                    
                    if ([Model.course_id isEqualToString:obj.course_id]) {
                        
                        
                        [weakSelf.shoppingCarArray replaceObjectAtIndex:idx withObject:Model];
                        
                        
                    }
      
                }
  
            }];
        
            
            [weakSelf calcuteReloadTable];
        
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        JULog(@"%@", error);
        
        [SVProgressHUD dismiss];

    }];
    
    
    
}

#pragma mark 删除购物车商品

-(void)decideDeleteCourse{
    __weak typeof(self) weakSelf = self;
    
 
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue ] >= 8.0) {
        UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:nil message:@"确定从购物车删除该课程吗？"preferredStyle:(UIAlertControllerStyleAlert)];
        
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf deleteCourseFromShoppingCar];
        }];
        
        [alterVC addAction:cancelAction];
        [alterVC addAction:confirmAction];
        
        [self.navigationController presentViewController:alterVC animated:NO completion:nil];
        
        
    }else{
        
        
        UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:@"确定从购物车删除该课程吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alterView show];
        
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex) {
        [self deleteCourseFromShoppingCar];
    }
}

-(void)deleteCourseFromShoppingCar{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", removeFromShoppingCarURL,_courseID];
    __weak typeof(self) weakSelf = self;
    
    YBNetManager *manager = [[YBNetManager alloc]init];
    
    [manager GET:urlString parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
        
    } success:^(NSURLSessionDataTask *task, NSDictionary * responobject) {
        
        if ([[responobject[@"errno"] description] isEqualToString:@"0"]) {
            
            
            [responobject showWithView:nil text:@"删除商品成功" duration:1.5];
            
            
            NSMutableArray *tempArray = [weakSelf.shoppingCarArray mutableCopy];
            
            
            for (JUShoppingCarModel *model in tempArray) {
                
                if ([model.course_id isEqualToString:_courseID]) {
                    
                    [weakSelf.shoppingCarArray removeObject:model];
                    
                }
                
            }
            
            
            [self shoppingCarSelectedNotification];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
        
    }];
    
    
    
}


#pragma mark 请求数据
-(void)makeData{
    
    
    __weak typeof(self) weakSelf = self;
    YBNetManager *manager = [[YBNetManager alloc]init];
    
//    JULog(@"购物车商品%@", JuuserInfo.headDit);

    
    [manager GET:getShoppingCarURL parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
        
    } success:^(NSURLSessionDataTask *task, NSDictionary * responobject) {
        
//        JULog(@"购物车商品成功%@", responobject);

        if ([[responobject[@"errno"] description] isEqualToString:@"0"]) {
           
            weakSelf.shoppingCarArray = [JUShoppingCarModel mj_objectArrayWithKeyValuesArray:responobject[@"data"][@"course"]];
            
            [weakSelf.shoppingCarArray enumerateObjectsUsingBlock:^(JUShoppingCarModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                obj.isSelected = YES;
                
            }];
            
            
            weakSelf.totalPrice = [responobject[@"data"][@"total"] description];
            NSString *countString = [NSString stringWithFormat:@"结算 (%zd)", weakSelf.shoppingCarArray.count];
            
            [self.calcuteButton setTitle:countString forState:(UIControlStateNormal)];
            
            [weakSelf loadingViews];
            
             self.priceLabel.text = [NSString stringWithFormat:@"¥%@", self.totalPrice];
            
             [weakSelf shoppingCarSelectedNotification];
        }
 
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
//        JULog(@"购物车商品error: %@",error);
        
        
        

    }];
    
    
    
    
}


#pragma mark刷新数据

-(void)calcuteReloadTable{
    
    [self.tableView reloadData];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", self.totalPrice];
    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
        __block NSInteger courseID;
        courseID = 0;
        [self.shoppingCarArray enumerateObjectsUsingBlock:^(JUShoppingCarModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.isSelected) {
                courseID += [obj.course_id integerValue];
            
            }
        }];
        
        NSString *totalPrice = nil;
        self.purchaseTotalPrice = @"";
  
        if (courseID) {
            
            switch (courseID) {
                case 46:{
                    
                    totalPrice = @"1498";
                    break;
                }
                case 47:{
                    totalPrice = @"1198";
                    
                    break;
                }
                case 56:{
                    totalPrice = @"1198";
                    
                    break;
                }
                case 93:{
                    totalPrice = @"2598";
                    
                    break;
                }
                case 102:{
                    totalPrice = @"2598";
                    
                    break;
                }
                case 103:{
                    totalPrice = @"2298";
                    
                    break;
                }
                case 149:{
                    totalPrice = @"3298";
                    
                    break;
                }
                    
                default:
                    break;
            }
 
            self.purchaseTotalPrice = totalPrice;
            self.priceLabel.text = [NSString stringWithFormat:@"¥%@", totalPrice];
  
        }
 
    }

}


#pragma mark 系统方法



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    [JUUmengStaticTool event:JUUmengStaticShoppingCart key:JUUmengStaticShoppingCart value:JUUmengStaticPV];
    [self makeData];
    
 
    if ([self.ID isEqualToString:@"study"]) {
        if (!JuuserInfo.isLogin) {
            [self.navigationController popViewControllerAnimated:NO];
        }
        
        
    }
    
    
    
}

-(void)loginAction{
    if (!JuuserInfo.isLogin) {
        JULoginViewController *loginVC = [[JULoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:NO];
    }
    
    
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:HCanvasColor(1)];

}




//判断是否为空
-(void)loadingViews{
    
    [self.coverView removeFromSuperview];
    
    [JUUmengStaticTool event:JUUmengStaticShoppingCart key:JUUmengStaticShoppingCart intValue:self.shoppingCarArray.count];
    
    if (!self.shoppingCarArray.count) {
        
        self.coverView.labelOneString = @"空空如也，快去选几门课吧!";
        self.coverView.imageName = @"shop@empty";
        
        [self.view addSubview:self.coverView];
        
        
    }
    
    [self.tableView reloadData];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
