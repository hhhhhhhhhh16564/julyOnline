//
//  JULoadingView.h
//  algorithm
//
//  Created by yanbo on 17/10/25.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LoadingState) {
    
    LoadingStateUnitiall,
    LoadingStateLoading,
    LoadingStateSuccess,
    LoadingStateFailure,
    LoadingStateLoadAgain // 点击了加载按钮，再一次开始加载
    
    
};




@interface JULoadingView : UIView


//// 加载动画延时的时间  //默认是0.5秒
//@property (nonatomic,assign) NSTimeInterval loadingTime;
//
//// 动画加载一段时间后，如果未响应，就显示加载失败，重新夹杂
//@property (nonatomic,assign) NSTimeInterval WaitingTime;

@property(nonatomic, copy) dispatch_block_t failureBlock;


-(void)beginLoad;
-(void)loadSuccess;
-(void)loadFailure;


+(instancetype)shareInstance;

@end
