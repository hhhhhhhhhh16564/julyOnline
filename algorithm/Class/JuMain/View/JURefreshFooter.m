//
//  JURefreshFooter.m
//  algorithm
//
//  Created by 周磊 on 16/10/19.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JURefreshFooter.h"

@implementation JURefreshFooter

-(void)prepare{
    [super prepare];
    
//    [self endRefreshingWithNoMoreData];
//    self.automaticallyHidden = YES;
    [self setTitle:@"数据加载完毕" forState:(MJRefreshStateNoMoreData)];
    
    
}




@end
