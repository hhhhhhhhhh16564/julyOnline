//
//  JUTabBarController.m
//  algorithm
//
//  Created by pro on 16/6/27.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUTabBarController.h"
#import "JUTabBar.h"

#import "JUHomeViewController.h"
#import "JUDownloadViewController.h"
#import "JUMineViewController.h"
#import "JUListenViewController.h"
#import "JUStudyViewController.h"
#import "JUSelectCourseController.h"
#import "YBLiveController.h"
#import "NSDate+Extension.h"


static NSString * const tabBarjuddingString = @"1102275343_2300";
@interface JUTabBarController ()

@end
@implementation JUTabBarController

-(void)loadFromUserdefaults{
    
    //下个接口应改为 registeredAgreementiphone2
    NSURL *url = [NSURL URLWithString:registeredAgreementiphone2];
    
    JuuserInfo.showstring = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    // 这一个版本的key
    NSString *thisVersion = @"thisVerstion_ipad_homeVC";
    
    // 这一个版本的号的值
    NSString *appVersionValue = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    if ([JuuserInfo.showstring isEqualToString:@"1"]) {
        [[NSUserDefaults standardUserDefaults]setObject:appVersionValue forKey:thisVersion];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSString *thisVersionValue = [[NSUserDefaults standardUserDefaults]objectForKey:thisVersion];
    if ([thisVersionValue isEqualToString:appVersionValue]) {
        
        JuuserInfo.showstring = @"1";
        
    }
    
    
    
    
    NSTimeInterval timeInterVal = [self afterDay:6 year:2017 mounth:11 day:7];
    
    if ([NSDate date].timeIntervalSince1970 > timeInterVal) {
        
        JuuserInfo.showstring = @"1";
    }
    
    JuuserInfo.showstring = @"1";

}

-(NSTimeInterval )afterDay:(NSUInteger)afterDay year:(NSUInteger)year mounth:(NSUInteger)mounth day:(NSUInteger)day{
    

    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = [NSString stringWithFormat:@"yyyy-MM-dd"];
    NSString *dateString = [NSString stringWithFormat:@"%04zd-%02zd-%02zd",(unsigned long)year, mounth, day];
    
    
    NSDate *date = [formatter dateFromString:dateString];

    NSDate *resultdate = [date dateByAddingDays:afterDay];
    
   
//    NSLog(@"%@----------- %@", resultdate, date);
 
    
    return resultdate.timeIntervalSince1970;
    
}





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:tabBarjuddingString];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self loadFromUserdefaults];
//    JuuserInfo.showstring = @"1";
    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
        //首页
        JUHomeViewController *homeVC = [[JUHomeViewController alloc]init];
        [self addChildVc:homeVC title:@"首页" image:@"tab1_normal"selectedImage:@"tab1_selected"];
        
    }
 
    if ([JuuserInfo.showstring isEqualToString:@"1"]) {
        
        JUStudyViewController *studyVC = [[JUStudyViewController alloc]init];
        
        
        [self addChildVc:studyVC title:@"学习" image:@"xuexi_nor" selectedImage:@"xuexi_pre"];
        
        
        

        
        // 选课
        
        YBLiveController *selectCourse = [[YBLiveController alloc]init];
        [self addChildVc:selectCourse title:@"选课" image:@"xuanke_normal" selectedImage:@"xuanke_pre"];
        
    }
    
    

    

    
    //下载
    JUDownloadViewController *downVC = [[JUDownloadViewController alloc]init];
    [self addChildVc:downVC title:@"下载" image:@"tab2_normal" selectedImage:@"tab2_selected"];
    
//    
    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
        //听一听
        JUListenViewController *listenVc = [[JUListenViewController alloc]init];
        [self addChildVc:listenVc title:@"听一听" image:@"Listen_Normal" selectedImage:@"Listen_selected"];
        
    }
 
    //我的
    JUMineViewController *mineVC = [[JUMineViewController alloc]init];
    [self addChildVc:mineVC title:@"我" image:@"tab3_normal" selectedImage:@"tab3_selected"];

    // 2.更换系统自带的tabbar
    
    JUTabBar *tabBar = [[JUTabBar alloc] init];
    tabBar.itemCount = self.childViewControllers.count;
    [self setValue:tabBar forKeyPath:@"tabBar"];
    /*
     [self setValue:tabBar forKeyPath:@"tabBar"];相当于self.tabBar = tabBar;
     [self setValue:tabBar forKeyPath:@"tabBar"];这行代码过后，tabBar的delegate就是HWTabBarViewController
     说明，不用再设置tabBar.delegate = self;
     */
    
    /*
     1.如果tabBar设置完delegate后，再执行下面代码修改delegate，就会报错
     tabBar.delegate = self;
     
     2.如果再次修改tabBar的delegate属性，就会报下面的错误
     错误信息：Changing the delegate of a tab bar managed by a tab bar controller is not allowed.
     错误意思：不允许修改TabBar的delegate属性(这个TabBar是被TabBarViewController所管理的)
     */
 
}

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
   childVc.title = title; // 同时设置tabbar和navigationBar的文字
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    if (iOS7) {
        childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    }
    
    // 设置文字的样式
//    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
//    
//    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = Hmblue(1);
//    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    JUBaseNavigationController *nav = [[JUBaseNavigationController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:nav];
    

//    childVc.navigationItem.title = title;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
