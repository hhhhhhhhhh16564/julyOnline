//
//  JUBaseRefreshController.h
//  algorithm
//
//  Created by 周磊 on 17/4/11.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUBaseViewController.h"
#import "JURefeshHeader.h"
#import "JURefreshFooter.h"

@interface JUBaseRefreshController : JUBaseViewController
@property(nonatomic, strong) UITableView *mainTableView;

@property(nonatomic, strong) NSMutableArray *mainDataArray;

-(void)loadNewTopics;
-(void)loadMoreTopics;
@end
