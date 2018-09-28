//
//  JUOnlinepaymentController.m
//  algorithm
//
//  Created by 周磊 on 16/8/29.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUOnlinepaymentController.h"
#import "JUDiscountRulesController.h"
#import "JUPayCategoryView.h"
#import "JULiveCourseView.h"
#import "JUButton.h"
#import "JUPayManager.h"
#import "JUpurchaseController.h"
#import "JULiveCourseDetailController.h"
#import "MBProgressHUD+MJ.h"

//苹果内购
#import <StoreKit/StoreKit.h>
#import "JUPurchaseManager.h"
#import "JULiveDetailController.h"

@interface JUOnlinepaymentController ()<UIAlertViewDelegate>
@property(nonatomic, strong) UIScrollView *contentView;
@property(nonatomic, strong) DiscountRulesCellView *orderView;

@property(nonatomic, strong) DiscountRulesCellView *payPriceView;

@property(nonatomic, strong) JUButton *selectedButton;

@property(nonatomic, strong) NSString *type;

@property(nonatomic, strong) NSArray *products;
@property(nonatomic, strong) SKProduct *purchaseProduct;

@property(nonatomic, strong) UIButton *enlistButton;

// 内购判断该商品是否已经否买
@property (nonatomic,assign) BOOL isPurchased;


@property (nonatomic,assign) BOOL isPurchaseSucceed;

@end

@implementation JUOnlinepaymentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //添加通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(payOrderSucceedAction:) name:JUPayOrderSucceedNotification object:nil];
    
       [self setupSubView];
    
    [self setupInPurchase];
    
    JULog(@"%@", self.orderModel.oid);

    
    
    
}

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
        if ( [vc isKindOfClass:[JULiveCourseDetailController class]]) {
            
            [self.navigationController popToViewController:vc animated:NO];
           
            return;
        }
        
        
        if ( [vc isKindOfClass:[JULiveDetailController class]]) {
            
            [self.navigationController popToViewController:vc animated:NO];
            
            return;
        }
    }
  
    [self.navigationController popViewControllerAnimated:NO];
    
}

-(void)setupSubView{
    
    self.navigationItem.leftBarButtonItem =   [UIBarButtonItem itemWithTarget:self action:@selector(leftItemAction) image:@"btn_black_back" highImage:nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"在线支付";
    
    
    UIScrollView *contentView = [[UIScrollView alloc]init];
    contentView.frame = CGRectMake(0, 64, Kwidth, Kheight-64);
    contentView.contentOffset = CGPointMake(0, 64);

    CGFloat contentsizeHeight = Kheight;
    if (!ISIPhone4) {
        
        contentsizeHeight = Kheight - 64;
        contentView.contentOffset = CGPointMake(0, 0);
        
    }

    contentView.contentSize = CGSizeMake(Kwidth, contentsizeHeight);
    contentView.showsVerticalScrollIndicator = NO;
    contentView.backgroundColor = HCanvasColor(1);
    
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
    

    
    //订单号
    DiscountRulesCellView *orderView = [[DiscountRulesCellView alloc]init];
    orderView.frame = CGRectMake(0, 10, Kwidth, 44);
    orderView.categoryLabel.text = @"订单号";
    orderView.priceLabel.text = self.orderModel.oid;
    orderView.priceLabel.textColor = Hcgray(1);
    [contentView addSubview:orderView];
    self.orderView = orderView;
    
    
    //课程详情
    
    UIView *detailView = [[UIView alloc]init];
    detailView.backgroundColor = [UIColor whiteColor];
    detailView.frame = CGRectMake(0, orderView.bottom_extension+10, Kwidth, 60+Kwidth*0.4*0.72);
    [contentView addSubview:detailView];
    
    UIView *lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = HCommomSeperatorline(1);
    lineView2.frame = CGRectMake(0, 0, Kwidth, 0.5);
    [detailView addSubview:lineView2];
    
 
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"课程详情";
    titleLabel.frame = CGRectMake(12, 0, Kwidth-12, 45);
    titleLabel.font = UIptfont(15);
    [detailView addSubview:titleLabel];
    
    
    JULiveCourseView *liveCourseView = [[JULiveCourseView alloc]init];
    
    liveCourseView.frame = CGRectMake(0, titleLabel.bottom_extension-15, Kwidth, Kwidth*0.4*0.72+30);
    
    [detailView addSubview:liveCourseView];
    
    liveCourseView.orderModel = self.orderModel;
    
    

    //支付金额View
    DiscountRulesCellView *payPriceView = [[DiscountRulesCellView alloc]init];
    payPriceView.frame = CGRectMake(0, detailView.bottom_extension+10, Kwidth, 44);
    payPriceView.categoryLabel.text= @"支付金额";
    payPriceView.priceLabel.text = [NSString stringWithFormat:@"¥%@",self.orderModel.pay_amount];
    payPriceView.priceLabel.textColor = [UIColor redColor];
    [contentView addSubview:payPriceView];
    
    self.payPriceView = payPriceView;
    
    

    
    
#pragma mark  支付宝先隐藏
    JUPayCategoryView *payTreasureView = [[JUPayCategoryView alloc]initWithImage:@"pay_logo_zhifubao" text:@"支付宝支付"];
  
    payTreasureView.frame = CGRectMake(0, payPriceView.bottom_extension+10, Kwidth, 44);
    
    __weak typeof(self) weakSelf = self;
    payTreasureView.myblock = ^(JUButton *button){
        
        weakSelf.selectedButton.selected = NO;
    
        weakSelf.selectedButton = button;
        
        weakSelf.type = @"2";
        
    };

    [contentView addSubview:payTreasureView];
    
    payTreasureView.checkButton.selected = YES;
    weakSelf.selectedButton = payTreasureView.checkButton;
    
    self.type = @"2";
    
    
    
    
    
    JUPayCategoryView *weChatPayView = [[JUPayCategoryView alloc]initWithImage:@"pay_logo_weixin" text:@"微信支付"];
    weChatPayView.frame = CGRectMake(0, payTreasureView.bottom_extension-0.5, Kwidth, 44);
    
    weChatPayView.myblock = ^(JUButton *button){
        
        weakSelf.selectedButton.selected = NO;
        
        weakSelf.selectedButton = button;
        
        weakSelf.type = @"1";

    };
    
    [contentView addSubview:weChatPayView];
    
    

    //提示警告信息
    UIView *cuecardView = [[UIView alloc]init];
    cuecardView.frame = CGRectMake(0, weChatPayView.bottom_extension, Kwidth, 55);
//    cuecardView.backgroundColor = [UIColor greenColor];
    [contentView addSubview:cuecardView];
    
    
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
    

    UIButton *enlistButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    enlistButton.frame = CGRectMake(0, contentsizeHeight-44, Kwidth, 44);
    [enlistButton.titleLabel setFont:UIptfont(17)];
    [enlistButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [enlistButton setTitle:@"去支付" forState:(UIControlStateNormal)];

    [self setnormalColor:enlistButton];
    
    
    UIColor *selectedColor = Kcolor16rgb(@"#2ca6e0", 1);
    [enlistButton setBackgroundImage:[UIImage imageWithColor:selectedColor] forState:(UIControlStateHighlighted)];
    [contentView addSubview:enlistButton];
    [enlistButton addTarget:self action:@selector(confirmPayment:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.enlistButton = enlistButton;

    
    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
        
//        payTreasureView = nil;
//        weChatPayView = nil;
//        cuecardView = nil;
        
        [payTreasureView removeFromSuperview];
        
        [weChatPayView removeFromSuperview];
        
        [cuecardView removeFromSuperview];
        
      UIColor *unSelectedColor  =  Kcolor16rgb(@"#dddddd", 1);
        
      [enlistButton setBackgroundImage:[UIImage imageWithColor:unSelectedColor] forState:(UIControlStateNormal)];
        
        enlistButton.userInteractionEnabled = NO;
        
        
     NSMutableArray *goodArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"appPurchaseGoodsID"];
        
        JULog(@"----:  %@", self.orderModel.course_id);
        
        if ([goodArray containsObject:self.orderModel.course_id]) {
        
            self.isPurchased = YES;
            
            [enlistButton setTitle:@"恢复购买" forState:(UIControlStateNormal)];

        }
        
        
        
        
        

    }

}

-(void)setnormalColor:(UIButton *)button{
    UIColor *normalColor = Kcolor16rgb(@"#18b4ed", 1);
    [button setBackgroundImage:[UIImage imageWithColor:normalColor] forState:(UIControlStateNormal)];

    button.userInteractionEnabled = YES;
    
}



#pragma mark 内购设置

-(void)setupInPurchase{
    
    if ([JuuserInfo.showstring isEqualToString:@"1"])return;
    
    NSString *productID = [NSString stringWithFormat:@"com.july.edu.algorithm_%@",self.orderModel.course_id];

    
    JUPurchaseManager *manager = [JUPurchaseManager shareManager];

    if (manager.productsArray.count) {

        
        for (SKProduct *product in manager.productsArray) {
            if ([product.productIdentifier isEqualToString:productID]) {
                [self setnormalColor:self.enlistButton];
                self.purchaseProduct = product;
                break;
            }
        }
        
        
    }else{
        
        __weak typeof(self) weakSelf = self;
        [manager startRequestWithArray:nil];

        manager.requestSucceedBlock = ^(NSArray * productsArray){
            
            for (SKProduct *product in productsArray) {
                
                if ([product.productIdentifier isEqualToString:productID]) {
                    [weakSelf setnormalColor:self.enlistButton];
                    weakSelf.purchaseProduct = product;
                    break;
                }
                
            }
            
        };
    }
}


-(void)applepay{
    
    __weak typeof(self) weakSelf = self;
    
    YBNetManager *manager = [[YBNetManager alloc]init];
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    
    parms[@"oid"] = self.orderModel.oid;
    
    
    JULog(@"%@", self.orderModel.oid);
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




#pragma mark响应方法
-(void)confirmPayment:(UIButton *)sender{
    
    self.isPurchaseSucceed = NO;
    
    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
        JUPurchaseManager *manager = [JUPurchaseManager shareManager];

        __weak typeof(self) weakSelf = self;
        if (self.isPurchased) {//
            //恢复购买中
            
            [manager restoreCompletedTransactionsSuccess:^{
                
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"恢复购买成功"];
                [weakSelf applepay];

                
            } failure:^{
                
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"恢复购买失败"];
                
            }];
            [MBProgressHUD showMessage:@"恢复购买中"];

            
        }else{
            
      
            
            [manager buyProduct:self.purchaseProduct];
            [MBProgressHUD showMessage:@"正在购买中"];
            
            manager.callblock = ^(JUPaymentTransactionState state, NSMutableArray *array){
                
                switch (state) {
                        //购买中
                    case JUPaymentTransactionStatePurchasing:{
                        break;
                    }
                        //已经购买
                    case JUPaymentTransactionStatePurchased:{
                        
                        weakSelf.isPurchaseSucceed = YES;
                        [weakSelf applepay];
                        break;
                    }
                        //购买失败
                    case JUPaymentTransactionStateFailed:{
                        
                        break;
                    }
                        // 恢复购买
                    case JUPaymentTransactionStateRestored:{
                        
                        
                        break;
                    }
                        
                    default:
                        break;
                }
                
                
            };
     
            
        }
        
        
    }else{

        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        dict[@"oid"] = self.orderModel.oid;
        dict[@"type"] = self.type;
              JULog(@"%@", dict);
        
        [JUPayManager payOrderActionWithDict:dict];
    }
    
    

    JUlogFunction
    
}


#pragma mark 通知中心

-(void)payOrderSucceedAction:(NSNotification *)notifi{
     JUlogFunction
    
    [JUUmengStaticTool event:JUUmengStaticPaySuccess key:JUUmengStaticPaySuccess value:JUUmengStaticPaySuccess];
    
    self.view.hidden = YES;
    
    JUpurchaseController *purchaseVC = [[JUpurchaseController alloc]init];
    
    purchaseVC.restorePurchased = self.isPurchaseSucceed;

    [self.navigationController pushViewController:purchaseVC animated:NO];

    
}

#pragma mark 方法

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [JUUmengStaticTool event:JUUmengStaticOnlinePay key:JUUmengStaticOnlinePay value:JUUmengStaticPV];
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}



- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}




@end
