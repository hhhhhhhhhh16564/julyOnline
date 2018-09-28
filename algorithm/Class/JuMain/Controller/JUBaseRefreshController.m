//
//  JUBaseRefreshController.m
//  algorithm
//
//  Created by 周磊 on 17/4/11.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUBaseRefreshController.h"

@interface JUBaseRefreshController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation JUBaseRefreshController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configureSubViews];
    
 
}

-(void)configureSubViews{
    self.view.backgroundColor = [UIColor blueColor];
    
    UIView *mainContentView = [[UIView alloc]init];
    mainContentView.frame = CGRectMake(0, 0, Kwidth, Kheight);
    [self.view addSubview:mainContentView];
    
    
    mainContentView.backgroundColor = [UIColor redColor];
    
    CGRect tableViewFrame =  CGRectMake(0, 64, Kwidth, Kheight-64);
    self.mainTableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.backgroundColor = HCanvasColor(1);
    [mainContentView addSubview:self.mainTableView];
    
    self.mainTableView.backgroundColor = [UIColor yellowColor];
    
    self.mainTableView.mj_header = [JURefeshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    
    self.mainTableView.mj_footer = [JURefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

-(void)loadNewTopics{}
-(void)loadMoreTopics{}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}


@end
