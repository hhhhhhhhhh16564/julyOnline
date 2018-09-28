//
//  JUDownloadViewController.m
//  algorithm
//
//  Created by pro on 16/6/27.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUDownloadViewController.h"
#import "JUDownloadingViewController.h"
#import "JUDownloadedViewController.h"
#import "ButtonView.h"

@interface JUDownloadViewController ()
{
    NSUInteger _index;
    
}

@property(nonatomic, strong) UITableViewController *showViewController;
@property(nonatomic, strong) UIView *contentView;


@end

@implementation JUDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setChildrenControllers];
    [self p_setupSubViews];
    [self p_setupTitle];
    
}



-(void)setChildrenControllers{
       
    JUDownloadedViewController *downloadedVC = [[JUDownloadedViewController alloc]init];
    [self addChildViewController:downloadedVC];
    

    JUDownloadingViewController *downloadingVC = [[JUDownloadingViewController alloc]init];
    [self addChildViewController:downloadingVC];
    
    
}



-(void)p_setupTitle{
    
    UIView *titleView = [[UIView alloc]init];
    titleView.frame = CGRectMake(0, 0, 196, 26);
    self.navigationItem.titleView = titleView;

    NSArray *array = @[@"已下载", @"下载中"];
    ButtonView *buttonView = [[ButtonView alloc]initWithTitleArray:array];
    buttonView.selectedTitleColor = Hmblue(1);
    buttonView.normalTitleColor = Hmblack(1);
    buttonView.fontsize = 16;
    buttonView.lineColor = Hmblue(1);
    buttonView.button_Width = 50;
    buttonView.frame = titleView.bounds;
    [titleView addSubview:buttonView];
    
    __weak typeof(self) weakSelf = self;
   
    buttonView.indexBlock = ^(NSInteger index){
        
        [weakSelf.showViewController.view removeFromSuperview];
        
        UITableViewController *showVC = weakSelf.childViewControllers[index];
        weakSelf.showViewController = showVC;
        showVC.view.frame = self.contentView.bounds;
        [self.contentView addSubview:weakSelf.showViewController.view];
        
        _index = index;
        
        
    };
    
    [buttonView setButtonClicked:_index];
    
}

-(void)p_setupSubViews{
    
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor redColor];
    contentView.frame = CGRectMake(0, 64, Kwidth, Kheight-64-49);
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
    
//    [self.view layoutSubviews];
    
    
}





-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];


    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
