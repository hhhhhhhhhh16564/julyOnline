//
//  JURefeshHeader.m
//  algorithm
//
//  Created by 周磊 on 16/10/19.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JURefeshHeader.h"

@implementation JURefeshHeader
//初始化

-(void)prepare{
    
    [super prepare];
    self.automaticallyChangeAlpha = YES;
    
    self.lastUpdatedTimeLabel.hidden = YES;
    
    self.stateLabel.textColor = [UIColor orangeColor];
    [self setTitle:@"下拉刷新" forState:(MJRefreshStateIdle)];
    [self setTitle:@"赶紧松开吧" forState:MJRefreshStatePulling];
    [self setTitle:@"正在加载数据..." forState:MJRefreshStateRefreshing];


    
}





@end
