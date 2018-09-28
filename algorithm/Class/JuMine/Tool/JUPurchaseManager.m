//
//  JUPurchaseManager.m
//  algorithm
//
//  Created by 周磊 on 17/5/25.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUPurchaseManager.h"

@interface JUPurchaseManager ()<UIAlertViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    
    NSArray * _productIdArray;
    
    dispatch_block_t restoreSuccess;
    dispatch_block_t restoreFailure;
}

@property(nonatomic, strong) NSArray<SKProduct *> *productsArray;

@end

@implementation JUPurchaseManager

+(instancetype)shareManager{
    static dispatch_once_t onceToken;
    static JUPurchaseManager *purchaseManager = nil;
    dispatch_once(&onceToken, ^{
        
        purchaseManager = [[JUPurchaseManager alloc]init];
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:purchaseManager];

    });
    return purchaseManager;
}

-(void)startRequestWithArray:(NSArray *)goodsIDArray{
    
    if (!goodsIDArray) {
        goodsIDArray = @[@"com.july.edu.algorithm_46", @"com.july.edu.algorithm_47", @"com.july.edu.algorithm_56"];
    }
    
    if ([goodsIDArray count]) {
        _productIdArray = goodsIDArray;
    }
    
    NSSet *productIdSet = [NSSet setWithArray:_productIdArray];
    SKProductsRequest *request = [[SKProductsRequest alloc]initWithProductIdentifiers:productIdSet];
    request.delegate = self;
    [request start];
    
    
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    self.productsArray = response.products;
    JULog(@"内购请求得到回应------->>>>>> 商品的个数: %zd: success", self.productsArray.count);

    if (self.requestSucceedBlock) {
        self.requestSucceedBlock(response.products);
    }
}

-(void)buyProduct:(SKProduct *)product{
    //1. 创建票据
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    //2. 将票据加到交易队列中
    [[SKPaymentQueue defaultQueue]addPayment:payment];
}
//-(void)restoreCompletedTransactions{
//    
//    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
//    
//}


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    
    JUPaymentTransactionState transactionState = JUPaymentTransactionStateNotKnow;
    //    SKPaymentTransactionStatePurchasing,  正在购买
    //    SKPaymentTransactionStatePurchased,   已经购买(购买成功)
    //    SKPaymentTransactionStateFailed,      购买失败
    //    SKPaymentTransactionStateRestored,    恢复购买
    //    SKPaymentTransactionStateDeferred     未决定
    

    NSMutableArray *array = [NSMutableArray array];
    for (SKPaymentTransaction *transation in transactions) {
        [MBProgressHUD hideHUD];

        switch (transation.transactionState) {
                
            case SKPaymentTransactionStatePurchasing:{
                
                transactionState = JUPaymentTransactionStatePurchasing;
                
                JULog(@"用户正在购买");
                break;
            }
            case SKPaymentTransactionStatePurchased:{
                JULog(@"购买成功，将对应的商品展示给用户");
                transactionState = JUPaymentTransactionStatePurchased;

                [MBProgressHUD showSuccess:@"购买成功"];

                [queue finishTransaction:transation];
                
                
                break;
            }
            case SKPaymentTransactionStateFailed:{
                
                transactionState = JUPaymentTransactionStateFailed;
                [MBProgressHUD showError:@"购买失败"];
                
                [queue finishTransaction:transation];
                
                JULog(@"购买失败");
                break;
            }
            case SKPaymentTransactionStateRestored:{
                
                
                transactionState = JUPaymentTransactionStateRestored;
                
                NSArray *tempArray = [transation.payment.productIdentifier componentsSeparatedByString:@"_"];
                [array addObject:tempArray[1]];
                
                
                
                [MBProgressHUD showSuccess:@"恢复购买成功"];

                JULog(@"恢复购买,将对应的商品给用户");
                [queue finishTransaction:transation];
                break;
            }
                
            case SKPaymentTransactionStateDeferred:{
                
                transactionState = JUPaymentTransactionStateDeferred;

                JULog(@"未决定");
                break;
            }
                
            default:
                break;
        }
        
    }
    
    if ([array count]) {
        JULog(@"%@", array);
        
        // 将已经购买的商品ID, 本地化
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"appPurchaseGoodsID"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
    
    
    if (self.callblock) {
        self.callblock(transactionState, array);
    }
    
}


-(void)restoreCompletedTransactionsSuccess:(dispatch_block_t)successBlcok failure:(dispatch_block_t)failureBlock{
    
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];

    restoreSuccess = successBlcok;
    restoreFailure = failureBlock;
    
    
}



- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error  {
    
    if (restoreFailure) {
        restoreFailure();

    }
    
    


    JULog(@"恢复购买失败————————————————》》》》");
    
}

// Sent when all transactions from the user's purchase history have successfully been added back to the queue.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    
    if (restoreSuccess) {
        restoreSuccess();

    }
    
    
//    [MBProgressHUD hideHUD];
//    [MBProgressHUD showSuccess:@"恢复购买成功"];

    JULog(@"恢复购买成功————————————————》》》》");

    
}






- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

@end
