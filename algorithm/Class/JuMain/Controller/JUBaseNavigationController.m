//
//  JUBaseNavigationController.m
//  algorithm
//
//  Created by pro on 16/6/27.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUBaseNavigationController.h"

@interface JUBaseNavigationController ()

@end

@implementation JUBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    // Do any additional setup after loading the view.
    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    
    //设置导航栏的背景颜色
   self.navigationBar.barTintColor = HCanvasColor(1);

    //设置title的字体颜色和样式
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor blackColor];
    dict[NSFontAttributeName] = UIptfont(36*KMultiplier);
    [self.navigationBar setTitleTextAttributes:dict];
    
}

+ (void)initialize
{
    // 设置整个项目所有item的主题样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // 设置普通状态
    // key：NS****AttributeName
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:28*KMultiplier];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
 
}



/**
 *  重写这个方法目的：能够拦截所有push进来的控制器
 *
 *  @param viewController 即将push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        
        /* 设置导航栏上面的内容 */
        // 设置左边的返回按钮
                viewController.navigationItem.leftBarButtonItem =   [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"btn_black_back" highImage:nil];
        
        // 设置右边的更多按钮
        
        //        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(more) image:@"navigationbar_more" highImage:@"navigationbar_more_highlighted"];
    }
    
    [super pushViewController:viewController animated:animated];
}
- (void)back
{
    // 因为self本来就是一个导航控制器，self.navigationController这里是nil的
    [self popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)shouldAutorotate{
    return [self.visibleViewController shouldAutorotate];
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.visibleViewController supportedInterfaceOrientations];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
