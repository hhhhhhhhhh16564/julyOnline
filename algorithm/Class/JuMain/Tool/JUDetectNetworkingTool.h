//
//  JUDetectNetworkingTool.h
//  七月算法_iPad
//
//  Created by pro on 16/5/29.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#define networkingType [JUDetectNetworkingTool shareMannger].networkType
typedef enum {
   
    ReachableViaWiFi,//wife
    ReachableViaWWAN,//自带网络
    NotReachable,//没有网络
    Unknown,//未知网络    
}NetworkingType;


//检测网络的工具类
@interface JUDetectNetworkingTool : NSObject

+(instancetype )shareMannger;

@property(nonatomic, assign)NetworkingType networkType;

-(void)detectNetwok;

@end
