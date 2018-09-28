//
//  JUBaseTableViewController.m
//  七月算法_iPad
//
//  Created by 周磊 on 16/6/1.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUBaseTableViewController.h"

@implementation JUBaseTableViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
  [self p_setupViews];
    
}

-(void)p_setupViews{
    
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *str = NSStringFromClass([self class]);
    
//    [MobClick beginLogPageView:str];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSString *str = NSStringFromClass([self class]);
    
//    [MobClick endLogPageView:str];
}

-(NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexpath{

    return @"删除";
    
}
@end
