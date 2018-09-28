//
//  JUPayManager.m
//  algorithm
//
//  Created by pro on 16/9/14.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUPayManager.h"
#import "AppDelegate.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
@implementation JUPayManager

+(void)payOrderActionWithDict:(NSMutableDictionary *)dict{
    
   
    
    if ([dict[@"type"] isEqualToString:@"1"]) {//微信
        
        [self WeiXinPayWithDict:dict];
        
    }else if ([dict[@"type"] isEqualToString:@"2"]){
        
        [self AliPayWithDict:dict];
        
    }else{
        
        
    }
    
}


+(void)AliPayWithDict:(NSDictionary *)dict{
    
    
    
    YBNetManager *manager = [[YBNetManager alloc]init];
    
    [manager POST:payOrderURL parameters:dict headdict:JuuserInfo.headDit constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } progress:^(NSProgress * _Nonnull Progress) {
        
        
    } success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        
        if (!responseObject[@"data"][@"str"])return ;
        
        NSString *orderString =responseObject[@"data"][@"str"];
        
        [[AlipaySDK defaultService]payOrder:orderString fromScheme:AliPayAPPID callback:^(NSDictionary *resultDic) {
            
            JULog(@"支付回调呵呵哈哈哈 resultDic : %@", resultDic);
            
        }];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        JULog(@"%@", error);
        
    }];
    
}

+(void)WeiXinPayWithDict:(NSDictionary *)dict{
    //友盟bug
    
    JuuserInfo.weixinPayAction = YES;
    
    YBNetManager *manager = [[YBNetManager alloc]init];

    
    [manager POST:payOrderURL parameters:dict headdict:JuuserInfo.headDit constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } progress:^(NSProgress * _Nonnull Progress) {
        
        
    } success:^(NSURLSessionDataTask *task, NSDictionary  *responseObject) {
        
        NSDictionary *dict = responseObject[@"data"][@"wx"];
        
        if (!dict) return ;
        
        JULogDictonary(dict)
        
        PayReq *req = [[PayReq alloc] init];
        
        req.partnerId = [dict objectForKey:@"partnerid"];
        
        req.prepayId = [dict objectForKey:@"prepayid"];
        
        req.package = [dict objectForKey:@"package"];
        
        req.nonceStr = [dict objectForKey:@"noncestr"];
        
        req.timeStamp = [[dict objectForKey:@"timestamp"] intValue];
        
        req.sign = [dict objectForKey:@"sign"];
        
        
        //调起微信支付
        if ([WXApi sendReq:req]) {
            
            JULog(@"吊起成功");
        }
 
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
    
    
    
}



-(void)hhh{
//    YBNetManager *manager = [[YBNetManager alloc]init];
//    
//    
//    [manager POST:@"http://api.julyedu.com/pay/createOrder" parameters:nil
//     
//         headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
//             
//         } success:^(NSURLSessionDataTask *task, NSDictionary * dict) {
//             
//             NSLog(@"发送请求成功");
//             
//             
//             
//             
//             //              data = {
//             //              prepay_id = wx20160905161552740eefa9790986691537,
//             //              mch_id = 1378328902,
//             //              result_code = SUCCESS,
//             //              nonce_str = AWjoFV83Y1VUuovU,
//             //              sign = 8EA28911BB54C93D74466CEBE5850CCF,
//             //              trade_type = APP,
//             //              timestamp = 1473063352,
//             //              appid = wx5dd973a1ed4c1b27,
//             //              return_msg = OK,
//             //              return_code = SUCCESS
//             //              }
//             //
//             
//             NSLog(@"%@", dict);
//             
//             
//             
//             
//             PayReq *req = [[PayReq alloc] init];
//             
//             NSMutableDictionary *response = dict[@"data"];
//             
//             req.partnerId = @"1378328902";
//             
//             req.prepayId = [response objectForKey:@"prepayid"];
//             
//             req.package = @"Sign=WXPay";
//             
//             req.nonceStr = [response objectForKey:@"noncestr"];
//             
//             req.timeStamp = [[response objectForKey:@"timestamp"] intValue];
//             
//             req.sign = [response objectForKey:@"sign"];
//             
//             //             UInt64   recordTime = [[NSDate date] timeIntervalSince1970];
//             
//             
//             JULog(@"partnerId :%@ \n prepayId  :%@ \n package :%@ \n nonceStr :%@ \n sign  :%@ \n timeStamp  :%d \n ", req.partnerId, req.prepayId, req.package, req.nonceStr, req.sign, (unsigned int)req.timeStamp);
//             
//             
//             //调起微信支付
//             if ([WXApi sendReq:req]) {
//                 NSLog(@"吊起成功");
//             }
//             
//             
//             
//         } failure:^(NSURLSessionDataTask *task, NSError *error) {
//             
//             
//             
//             NSLog(@"发送请求失败");
//             
//             
//         }];
//    

    
    
}






































@end
