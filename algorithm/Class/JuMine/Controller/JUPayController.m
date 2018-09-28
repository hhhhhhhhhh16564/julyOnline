//
//  JUPayController.m
//  algorithm
//
//  Created by 周磊 on 17/2/6.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUPayController.h"
#import "JUShoppingCarController.h"
#import "JUDiscountRulesController.h"
#import "JUPayManager.h"
#import "JUPayCell.h"
#import "JUShoppingCarModel.h"
#import "JUPayCategoryView.h"
#import "JUpurchaseController.h"
#import "JULiveCourseDetailController.h"
#import <StoreKit/StoreKit.h>
#import "JULiveDetailController.h"
static NSString * const payCell = @"payCell";

@interface JUPayController ()<UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) DiscountRulesCellView *orderIDView;

@property(nonatomic, strong) DiscountRulesCellView *payPriceView;

@property(nonatomic, strong) NSMutableArray<JUShoppingCarModel*> *orderArray;

@property(nonatomic, strong) JUButton *selectedButton;

@property(nonatomic, strong) NSString *type;

@property(nonatomic, strong) UIButton *enlistButton;
@property(nonatomic, strong) NSArray *products;
@property(nonatomic, strong) SKProduct *purchaseProduct;

@end

@implementation JUPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(payOrderSucceedAction:) name:JUPayOrderSucceedNotification object:nil];

    
    [self setup_SubViews];
    [self setupInPurchase];

    
    if ([self.is_free isEqualToString:@"1"]) {
        
        [self payOrderSucceedAction:nil];
        
        return;
    }
    
    
    [self makeData];
    
}



-(void)setup_SubViews{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNav];
    [self setup_tableview];
    [self setHeaderView];
    [self setFootView];
    [self gotoPayView];
    

}


-(void)setNav{
    self.navigationItem.leftBarButtonItem =   [UIBarButtonItem itemWithTarget:self action:@selector(leftItemAction) image:@"btn_black_back" highImage:nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"在线支付";
}

#pragma mark
-(void)setup_tableview{
    
    CGRect tableViewFrame =  CGRectMake(0, 64, Kwidth, Kheight-64-44);
    self.tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = HCanvasColor(1);
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[JUPayCell class] forCellReuseIdentifier:payCell];
    
}
-(void)setHeaderView{
  
    UIView *headView = [[UIView alloc]init];
    headView.frame = CGRectMake(0, 0, Kwidth, 64);
    
    
    //订单号
    DiscountRulesCellView *orderView = [[DiscountRulesCellView alloc]init];
    orderView.frame = CGRectMake(0, 10, Kwidth, 44);
    orderView.categoryLabel.text = @"订单号";
    orderView.priceLabel.text = self.orderID;
    orderView.priceLabel.textColor = Hcgray(1);
    self.orderIDView = orderView;
    [headView addSubview:orderView];
    

    self.tableView.tableHeaderView = headView;
    

}
-(void)setFootView{
    
    UIView *footView = [[UIView alloc]init];
    footView.frame = CGRectMake(0, 0, 0, 202);
    
    UIView *payPriceBackView = [[UIView alloc]init];
    payPriceBackView.frame = CGRectMake(0, 0, Kwidth, 59);
    [footView addSubview:payPriceBackView];
    
   //支付金额View
    DiscountRulesCellView *payPriceView = [[DiscountRulesCellView alloc]init];
    payPriceView.frame = CGRectMake(0, 5, Kwidth, 44);
    payPriceView.categoryLabel.text= @"支付金额";
    payPriceView.priceLabel.textColor = [UIColor redColor];
    [payPriceBackView addSubview:payPriceView];
    self.payPriceView = payPriceView;
    
//支付宝
    
    // type 1代表微信   2代表支付宝
    JUPayCategoryView *payTreasureView = [[JUPayCategoryView alloc]initWithImage:@"pay_logo_zhifubao" text:@"支付宝支付"];
    
    payTreasureView.frame = CGRectMake(0, 59, Kwidth, 44);
    
    __weak typeof(self) weakSelf = self;
    payTreasureView.myblock = ^(JUButton *button){
        
        weakSelf.selectedButton.selected = NO;
        
        weakSelf.selectedButton = button;
        
        weakSelf.type = @"2";
        
    };
    
    [footView addSubview:payTreasureView];
    
    payTreasureView.checkButton.selected = YES;
    weakSelf.selectedButton = payTreasureView.checkButton;
    
    self.type = @"2";
    
    
    
    
    // 微信
    JUPayCategoryView *weChatPayView = [[JUPayCategoryView alloc]initWithImage:@"pay_logo_weixin" text:@"微信支付"];
    weChatPayView.frame = CGRectMake(0, 103, Kwidth, 44);
    
    weChatPayView.myblock = ^(JUButton *button){
        weakSelf.selectedButton.selected = NO;
        weakSelf.selectedButton = button;
        weakSelf.type = @"1";
    };
    
    [footView addSubview:weChatPayView];
    

    // 警示信息
    //提示警告信息
    UIView *cuecardView = [[UIView alloc]init];
    cuecardView.frame = CGRectMake(0, weChatPayView.bottom_extension, Kwidth, 55);
    [footView addSubview:cuecardView];
    
    UIImageView *signNoticeView = [[UIImageView alloc]init];
    signNoticeView.frame = CGRectMake(12, 10, 12, 12);
    signNoticeView.image = [UIImage imageNamed:@"apply_sign_notice"];
    [cuecardView addSubview:signNoticeView];
    UILabel *signNoticeLabel = [[UILabel alloc]init];
    signNoticeLabel.frame = CGRectMake(signNoticeView.right_extension+8, signNoticeView.y_extension-1.5, cuecardView.width_extension-44, 45);
    signNoticeLabel.text = @"请在24小时内完成支付, 否则届时系统将关闭该订单\n\n\n";
    //label的字体从顶部显示
    signNoticeLabel.lineBreakMode = NSLineBreakByCharWrapping;
    signNoticeLabel.textColor = HCOrange(1);
    signNoticeLabel.font = UIptfont(12);
    signNoticeLabel.numberOfLines = 0;
    [cuecardView addSubview:signNoticeLabel];

    self.tableView.tableFooterView = footView;
  
    
    
    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
        
        //        payTreasureView = nil;
        //        weChatPayView = nil;
        //        cuecardView = nil;
        
        [payTreasureView removeFromSuperview];
        
        [weChatPayView removeFromSuperview];
        
        [cuecardView removeFromSuperview];
        
        
    }
    

}


-(void)gotoPayView{
    
    
    UIButton *enlistButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    enlistButton.frame = CGRectMake(0, Kheight-44, Kwidth, 44);
    [enlistButton.titleLabel setFont:UIptfont(17)];
    [enlistButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [enlistButton setTitle:@"去支付" forState:(UIControlStateNormal)];
    
    UIColor *normalColor = Kcolor16rgb(@"#18b4ed", 1);
    [enlistButton setBackgroundImage:[UIImage imageWithColor:normalColor] forState:(UIControlStateNormal)];
    
    
    UIColor *selectedColor = Kcolor16rgb(@"#2ca6e0", 1);
    [enlistButton setBackgroundImage:[UIImage imageWithColor:selectedColor] forState:(UIControlStateHighlighted)];
    
    [enlistButton addTarget:self action:@selector(confirmPayment:) forControlEvents:(UIControlEventTouchUpInside)];
    self.enlistButton = enlistButton;
    [self.view addSubview:enlistButton];

    
    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
        
        UIColor *unSelectedColor  =  Kcolor16rgb(@"#dddddd", 1);
        
        [enlistButton setBackgroundImage:[UIImage imageWithColor:unSelectedColor] forState:(UIControlStateNormal)];
        
        enlistButton.userInteractionEnabled = NO;
  
    }

}

#pragma mark 返回上一层
#pragma mark  返回上一次

-(void)leftItemAction{
    
    
    __weak typeof(self) weakSelf = self;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:nil message:@"确定要放弃支付" preferredStyle:(UIAlertControllerStyleAlert)];
        
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            
            
            
        }];
        
        UIAlertAction *desAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf back];
            
        }];
        
        
        [alterVC addAction:cancelAction];
        [alterVC addAction:desAction];
        
        [self presentViewController:alterVC animated:NO completion:^{
            
            
        }];
        
        
    }else{
        
        UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:@"确定要放弃支付" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alterView show];
        
        
    }
    
    
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        
        [self back];
        
    }else{
        
        
    }
    
}

//返回上一层
-(void)back{
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ( [vc isKindOfClass:[JUShoppingCarController class]]) {
            
            JUShoppingCarController *shoppingVC = (JUShoppingCarController *)vc;
            [shoppingVC comeBackFromPayController];
            
            [self.navigationController popToViewController:shoppingVC animated:NO];
            
            return;
        }
        
        if ( [vc isKindOfClass:[JULiveCourseDetailController class]]) {
            [self.navigationController popToViewController:vc animated:NO];
            
            return;
        }
        
        if ( [vc isKindOfClass:[JULiveDetailController class]]) {
            [self.navigationController popToViewController:vc animated:NO];
            
            return;
        }
        
        
    }

    NSInteger count = self.navigationController.viewControllers.count;
    if (count < 3) return;
    UIViewController *vc = self.navigationController.viewControllers[count-3];
    [self.navigationController popToViewController:vc animated:NO];
    
    
}


#pragma mark响应方法 支付
-(void)confirmPayment:(UIButton *)sender{
    
    [JUUmengStaticTool event:JUUmengStaticOnlinePay key:JUUmengStaticOnlinePay value:@"Payment"];



    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
        
        [self buyProduct:self.purchaseProduct];
        
        [MBProgressHUD showMessage:@"正在购买中"];
        
    }else{
        
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        dict[@"oid"] = self.orderID;
        dict[@"type"] = self.type;
        JULog(@"%@", dict);
        
        [JUPayManager payOrderActionWithDict:dict];
    
    
    }
    
    
    JUlogFunction
    
}


#pragma mark tableview的代理方法



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JUPayCell *cell = [tableView dequeueReusableCellWithIdentifier:payCell forIndexPath:indexPath];
    cell.shoppingCarModel = self.orderArray[indexPath.row];
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return Kwidth*0.288+32;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.orderArray.count;
}

#pragma mark 数据请求

-(void)makeData{

    YBNetManager *manager = [[YBNetManager alloc]init];
    
    __weak typeof(self) weakSelf = self;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", orderDetailURL, self.orderID];
    
    [manager GET:urlString parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
        
    } success:^(NSURLSessionDataTask *task, NSDictionary * responobject) {
        
//        JULog(@"----------%@", responobject);
        
        NSString *responseCode = [responobject[@"errno"] description];

        if ([responseCode isEqualToString:@"0"]) {
            
         weakSelf.orderArray = [JUShoppingCarModel mj_objectArrayWithKeyValuesArray:responobject[@"data"][@"course"]];
        weakSelf.payPriceView.priceLabel.text = [NSString stringWithFormat:@"¥%@",responobject[@"data"][@"pay"]];
            
            if ([JuuserInfo.showstring isEqualToString:@"0"]) {
                
                weakSelf.payPriceView.priceLabel.text = [NSString stringWithFormat:@"¥%@",weakSelf.purchaseTotalPrice];
            }
            
            

         [weakSelf.tableView reloadData];
        [weakSelf scrollViewToBottom:NO];
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        JULog(@"%@",error);
        
    }];
  
}

// 滚动到最底部
- (void)scrollViewToBottom:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
        
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:animated];
        
    }
    
}




#pragma mark 通知中心

-(void)payOrderSucceedAction:(NSNotification *)notifi{
    
    [JUUmengStaticTool event:JUUmengStaticPaySuccess key:JUUmengStaticPaySuccess value:JUUmengStaticPaySuccess];
    JUlogFunction
    self.view.hidden = YES;
    
    JUpurchaseController *purchaseVC = [[JUpurchaseController alloc]init];
    [self.navigationController pushViewController:purchaseVC animated:NO];
    
}





-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [JUUmengStaticTool event:JUUmengStaticOnlinePay key:JUUmengStaticOnlinePay value:JUUmengStaticPV];
    
    //添加观察者
    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //移除观察者
    
    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
        
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
        
    }
    
}



- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}



#pragma mark 内购设置

-(void)setupInPurchase{
    
    if ([JuuserInfo.showstring isEqualToString:@"1"])return;
    
    //去自己的服务器拿到所有想卖商品的ID，之前已经配置好存贮服务器或本地
    NSArray *productIDArray = @[@"com.july.edu.algorithm_46", @"com.july.edu.algorithm_47", @"com.july.edu.algorithm_56", @"com.july.edu.algorithm_93", @"com.july.edu.algorithm_102", @"com.july.edu.algorithm_103", @"com.july.edu.algorithm_149"];
    
    //拿着ID跟苹果请求可卖的商品
    NSSet *productIdSet = [NSSet setWithArray:productIDArray];
    
    SKProductsRequest *request = [[SKProductsRequest alloc]initWithProductIdentifiers:productIdSet];
    request.delegate = self;
    [request start];
    
}



//实现请求的代理方法
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    __block NSUInteger courseID;
    courseID = 0;
    [self.purchaseArray enumerateObjectsUsingBlock:^(JUShoppingCarModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        courseID += [obj.course_id intValue];
        
        
    }];
    
    
    
    NSString *productID = [NSString stringWithFormat:@"com.july.edu.algorithm_%d",(int)courseID];
    
    self.products = response.products;
    
    for (SKProduct *product in self.products) {
        JULog(@"%@", product.productIdentifier);
        
        if ([product.productIdentifier isEqualToString:productID]) {
            
            [self setnormalColor:self.enlistButton];
            
            //购买商品
            
            self.purchaseProduct = product;
            
            //            [self buyProduct:product];
            
//            break;
        }
        
        
        
    }
    
    JULog(@"购买ID： %@", self.purchaseProduct.productIdentifier);

    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    
    //请求失败隐藏信息
    [MBProgressHUD hideHUD];
    
}



-(void)buyProduct:(SKProduct *)product{
    
    //1. 创建票据
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    //2. 将票据加到交易队列中
    [[SKPaymentQueue defaultQueue]addPayment:payment];
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    
    
    //    SKPaymentTransactionStatePurchasing,  正在购买
    //    SKPaymentTransactionStatePurchased,   已经购买(购买成功)
    //    SKPaymentTransactionStateFailed,      购买失败
    //    SKPaymentTransactionStateRestored,    恢复购买
    //
    //    SKPaymentTransactionStateDeferred     未决定
    
    
    
    for (SKPaymentTransaction *transation in transactions) {
        
        [MBProgressHUD hideHUD];
        switch (transation.transactionState) {
                
            case SKPaymentTransactionStatePurchasing:{
                JULog(@"用户正在购买");
                break;
            }
            case SKPaymentTransactionStatePurchased:{
                JULog(@"购买成功，将对应的商品展示给用户");
                
                [self applepay];
                
                [MBProgressHUD showSuccess:@"购买成功"];
                
                [queue finishTransaction:transation];
                
                
                break;
            }
            case SKPaymentTransactionStateFailed:{
                
                [MBProgressHUD showError:@"购买失败"];
                
                [queue finishTransaction:transation];
                
                JULog(@"购买失败");
                break;
            }
            case SKPaymentTransactionStateRestored:{
                JULog(@"恢复购买,将对应的商品给用户");
                [queue finishTransaction:transation];
                break;
            }
                
            case SKPaymentTransactionStateDeferred:{
                JULog(@"未决定");
                break;
            }
                
            default:
                break;
        }
        
    }
    
    
}


-(void)applepay{
    
    __weak typeof(self) weakSelf = self;
    
    YBNetManager *manager = [[YBNetManager alloc]init];
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    
    parms[@"oid"] = self.orderID;
    
    JULog(@"%@", self.orderID);
    JULog(@"%@", JuuserInfo.headDit);
    
    [manager POST:applepayURL parameters:parms headdict:JuuserInfo.headDit constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } progress:^(NSProgress * _Nonnull Progress) {
        
    } success:^(NSURLSessionDataTask *task, NSMutableDictionary * responseObject) {
        
        JULog(@"%@", responseObject);
        
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            
            [weakSelf payOrderSucceedAction:nil];
            
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        JULog(@"提交失败");
        
    }];
    
    
    
    
    
    
}

-(void)setnormalColor:(UIButton *)button{
    UIColor *normalColor = Kcolor16rgb(@"#18b4ed", 1);
    [button setBackgroundImage:[UIImage imageWithColor:normalColor] forState:(UIControlStateNormal)];
    
    button.userInteractionEnabled = YES;
    
}



@end
