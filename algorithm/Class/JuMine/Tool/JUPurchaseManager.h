//
//  JUPurchaseManager.h
//  algorithm
//
//  Created by 周磊 on 17/5/25.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

typedef NS_ENUM(NSInteger, JUPaymentTransactionState) {
    JUPaymentTransactionStateNotKnow,
    JUPaymentTransactionStatePurchasing,
    JUPaymentTransactionStatePurchased,
    JUPaymentTransactionStateFailed,
    JUPaymentTransactionStateRestored,
    JUPaymentTransactionStateDeferred
};

typedef void (^ callBlock)(JUPaymentTransactionState transactionState, NSMutableArray *array);

@interface JUPurchaseManager : NSObject
+(instancetype)shareManager;

@property(nonatomic, strong, readonly) NSArray<SKProduct *> *productsArray;

-(void)startRequestWithArray:(NSArray *)goodsIDArray;

-(void)buyProduct:(SKProduct *)product;

//恢复购买
//-(void)restoreCompletedTransactions;
//恢复购买
-(void)restoreCompletedTransactionsSuccess:(dispatch_block_t)successBlcok failure:(dispatch_block_t)failureBlock;




@property(nonatomic, copy) callBlock callblock;

@property(nonatomic, copy) globalBlock requestSucceedBlock;



@end
