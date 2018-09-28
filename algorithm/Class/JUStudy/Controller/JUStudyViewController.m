//
//  JUStudyViewController.m
//  algorithm
//
//  Created by yanbo on 17/9/12.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUStudyViewController.h"
#import "TYSlidePageScrollView.h"
#import "TYTitlePageTabBar.h"
#import "JUStudyingViewController.h"
#import "TableViewController.h"
#import "JUAnnulationView.h"
#import "JUFreeCourseController.h"
#import "JUShoppingCarController.h"
#import "JULoginViewController.h"
#import "JURegisteredViewController.h"
#import "JULiveCourseDetailController.h"
#import "JULiveDetailController.h"

@interface JUStudyViewController ()<TYSlidePageScrollViewDataSource, TYSlidePageScrollViewDelegate>

@property(nonatomic, strong) YBNetManager *manager;
@property (nonatomic, weak) TYSlidePageScrollView *slidePageScrollView;

@property(nonatomic, strong) TYTitlePageTabBar *titlePageTabBar;

@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIView *scrollView;

@property(nonatomic, strong) UIView *headView;
@property (nonatomic,assign) CGFloat headViewHeight;
@property(nonatomic, strong) UIView *statueView;



//登录状态View
@property(nonatomic, strong) UIView *loginStateView;
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *uidLabel;
@property(nonatomic, strong) UIButton *VIPButton;






//未登录状态View
@property (nonatomic,strong) UIView *unLoginStateView;


@property(nonatomic, assign) NSUInteger lastPage;

@property(nonatomic, assign) NSUInteger curretnPage;

@property(nonatomic, strong) JUUser *user;
@end

@implementation JUStudyViewController



- (YBNetManager *)manager
{
    if (!_manager) {
        _manager = [[YBNetManager alloc]init];
    }
    return _manager;
}


-(CGFloat)headViewHeight{
 
    return JuuserInfo.isLogin ? 130 : 150;
}


-(UIView *)loginStateView{
    
    if (!_loginStateView) {
        _loginStateView = [[UIView alloc]init];
        self.iconImageView = [[UIImageView alloc]init];
        //self.iconImageView.backgroundColor = [UIColor redColor];
        self.iconImageView.image = [UIImage imageNamed:@"personal_head_sign"];
        self.iconImageView.layer.cornerRadius = 40;
        self.iconImageView.layer.masksToBounds = YES;
        [_loginStateView addSubview:self.iconImageView];

        [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.bottom.mas_equalTo(-15);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.font = UIptfont(18);
        [_loginStateView addSubview:self.nameLabel];
        self.nameLabel.text = @"";
        
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(30);
            make.top.equalTo(self.iconImageView);
            make.height.mas_equalTo(18);
        }];
        
        
        

        self.uidLabel = [[UILabel alloc]init];
        self.uidLabel.textColor = [UIColor whiteColor];
        self.uidLabel.font = UIptfont(13);
        [_loginStateView addSubview:self.uidLabel];
        self.uidLabel.text = @"";
        
        [self.uidLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(30);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(11);
            make.height.mas_equalTo(13);
        }];

        
        self.VIPButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.VIPButton setImage:[UIImage imageNamed:@"VIP_unnor"] forState:(UIControlStateNormal)];
        [self.VIPButton setImage:[UIImage imageNamed:@"VIP"] forState:(UIControlStateSelected)];
       
        [self.VIPButton addTarget:self action:@selector(VIPAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_loginStateView addSubview:self.VIPButton];
        
        
        [self.VIPButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.uidLabel.mas_left).offset(-5);
            make.top.equalTo(self.uidLabel.mas_bottom).offset(8);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
 
    }
    _loginStateView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.headViewHeight);

    return _loginStateView;
}

-(UIView *)unLoginStateView{
    
    if (!_unLoginStateView) {
        _unLoginStateView = [[UIView alloc]init];
        JUAnnulationView *annulationView = [[JUAnnulationView alloc]init];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLoginAction)];
        [annulationView addGestureRecognizer:tapGesture];
        annulationView.backgroundColor = Kcolor16rgb(@"f7f9fc", 1);
        annulationView.layer.cornerRadius = 40;
        annulationView.layer.masksToBounds = YES;
        [_unLoginStateView addSubview:annulationView];
        [annulationView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(35);
            make.size.mas_equalTo(CGSizeMake(80, 80));
            make.centerX.equalTo(_unLoginStateView);
        }];
        
        
        //注册按钮方法
        UIButton *registeredButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [registeredButton addTarget:self action:@selector(registeredButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        
        [registeredButton setTitle:@"没有账号， 去注册 >" forState:(UIControlStateNormal)];
        [registeredButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_unLoginStateView addSubview:registeredButton];
        [registeredButton.titleLabel setFont:UIptfont(13)];
        
        [registeredButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(annulationView.mas_bottom).offset(10);
            make.centerX.equalTo(_unLoginStateView);
            make.height.mas_equalTo(13);
        }];
  
    }
    _unLoginStateView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.headViewHeight);

    return _unLoginStateView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addNotifi];
    
    [self setup_subViews];
    [self loginStateDidChanged:nil];

}


-(void)addNotifi{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateDidChanged:) name:JULoginStatueDidChanged object:nil];


}

-(void)setup_subViews{
    [self addContentView];
    [self addSlidePageScrollView];
    [self addHeaderView];
    [self addTabPageMenu];
    [self addchildren];
    
}

-(void)reloadData{
    [self setup_subviewsFrame];
    [self.slidePageScrollView reloadData];

}


-(void)setup_subviewsFrame{
    
    self.headView.frame = CGRectMake(0, 0, CGRectGetWidth(self.slidePageScrollView.frame), self.headViewHeight);
    self.titlePageTabBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.slidePageScrollView.frame), 44);
    self.statueView.frame = CGRectMake(0, self.headViewHeight-20, CGRectGetWidth(self.slidePageScrollView.frame), 20);

}
-(void)addContentView{
    
    UIView *contentView = [[UIView alloc]init];
    contentView.frame = self.view.bounds;
    [self.view addSubview:contentView];
    self.contentView = contentView;
}

-(void)addSlidePageScrollView{
    
    TYSlidePageScrollView *slidePageScrollView = [[TYSlidePageScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-49)];
    slidePageScrollView.pageTabBarIsStopOnTop = YES;
    slidePageScrollView.pageTabBarStopOnTopHeight = 20;
    slidePageScrollView.dataSource = self;
    slidePageScrollView.delegate = self;
    [self.contentView addSubview:slidePageScrollView];
    self.slidePageScrollView = slidePageScrollView;

}


-(void)addHeaderView{
    
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = Kcolor16rgb(@"18b4ed", 1);
    self.slidePageScrollView.headerView = headView;
    self.headView = headView;

    
    
    [self.headView addSubview:self.loginStateView];
    [self.headView addSubview:self.unLoginStateView];
    
    
    
    UIView *statueView = [[UIView alloc]init];
    statueView.backgroundColor = Kcolor16rgb(@"f7f9fc", 1);
    statueView.hidden = YES;
    [headView addSubview:statueView];
    self.statueView = statueView;
    
}


-(void)addTabPageMenu{
//    @property (nonatomic, strong) UIFont *textFont;
//    @property (nonatomic, strong) UIFont *selectedTextFont;
//    
//    @property (nonatomic, strong) UIColor *textColor;
//    @property (nonatomic, strong) UIColor *selectedTextColor;
    NSArray *titleArray = @[@"在学课程", @"免费课程", @"购物车"];
    
    TYTitlePageTabBar *titlePageTaBar = [[TYTitlePageTabBar alloc]init];
    titlePageTaBar.backgroundColor = Kcolor16rgb(@"#f7f9fc", 1);
    titlePageTaBar.textFont = UIptfont(15);
    titlePageTaBar.textColor = Kcolor16rgb(@"#202426", 1);
    titlePageTaBar.selectedTextColor = Kcolor16rgb(@"#0099ff", 1);
    titlePageTaBar.horIndicatorColor = titlePageTaBar.selectedTextColor;
    titlePageTaBar.titleArray = titleArray;
    self.slidePageScrollView.pageTabBar = titlePageTaBar;
    self.titlePageTabBar = titlePageTaBar;
    
    
}

-(void)addchildren{
    
    JUStudyingViewController *vc = [[JUStudyingViewController alloc]init];
    JUFreeCourseController *freeVC = [[JUFreeCourseController alloc]init];
    TableViewController *tableViewVC11 = [[TableViewController alloc]init];
    // don't forget addChildViewController
    [self addChildViewController:vc];
    [self addChildViewController:freeVC];
    [self addChildViewController:tableViewVC11];
    
//    [self.view addSubview:vc.view];
//    [self.view addSubview:freeVC.view];
//    [self.view addSubview:tableViewVC11.view];
    
    
}

#pragma mark代理方法
- (void)slidePageScrollView:(TYSlidePageScrollView *)slidePageScrollView verticalScrollViewDidScroll:(UIScrollView *)pageScrollView{
    
    if (pageScrollView.contentOffset.y >= -64) {
        self.statueView.hidden = NO;
    }else{
        self.statueView.hidden = YES;
    }
    
    
    
}

- (void)slidePageScrollView:(TYSlidePageScrollView *)slidePageScrollView horizenScrollToPageIndex:(NSInteger)index{
    
    self.curretnPage = index;
    
    if (index == 2) {

        JUShoppingCarController *shoppingCar = [[JUShoppingCarController alloc]init];
        shoppingCar.ID = @"study";
        [self.navigationController pushViewController:shoppingCar animated:NO];
        

        
    }else{

        self.lastPage = index;
    }
    
    
}




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
 

    [self resetPage];
    [self makeData];

    
}

-(void)resetPage{
 
        //第三方库有bug
    for (UIViewController *vc in self.childViewControllers) {
        if ([vc respondsToSelector:@selector(view_WillAppear:)]) {
            if ([vc isKindOfClass:[JUStudyingViewController class]]) {
                JUStudyingViewController *studyVC = (JUStudyingViewController *)vc;
                [studyVC view_WillAppear:NO];
            }
            
            if ([vc isKindOfClass:[JUFreeCourseController class]]) {
                JUFreeCourseController *freeVC = (JUFreeCourseController *)vc;
                [freeVC view_WillAppear:NO];
            }
            
            
        }
        
    }
    
    
   // JULog(@"%zd  %zd", self.lastPage, self.slidePageScrollView.curPageIndex);
    
    if (self.curretnPage == 2) {
        [self.slidePageScrollView scrollToPageIndex:self.lastPage nimated:NO];
    }
    
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    


    
}



-(void)loginStateDidChanged:(NSNotification *)notifi
{
    
    [self loginStateChanged:JuuserInfo.isLogin];
    
    if (JuuserInfo.isLogin) {
        
        [JUUmengStaticTool event:JUUmengStaticMine key:JUUmengParamMineLogin value:JUUmengStaticPV];
    }else{
        
        [JUUmengStaticTool event:JUUmengStaticMine key:JUUmengParamMineNotLogin value:JUUmengStaticPV];
        
    }
    
    
}

#pragma mark其它方法
//当登录状态发生改变时调用
-(void)loginStateChanged:(BOOL)isLogin{
    
 
    if (isLogin) {
        self.loginStateView.hidden = NO;
        self.unLoginStateView.hidden = YES;
        
        // 登陆后要重新请求数据
        [self resetPage];
        [self makeData];
        
    }else{
        
        self.loginStateView.hidden = YES;
        self.unLoginStateView.hidden = NO;

    }
    [self reloadData];
    
}







#pragma mark 代理方法

- (NSInteger)numberOfPageViewOnSlidePageScrollView
{
    return self.childViewControllers.count;
}


- (UIScrollView *)slidePageScrollView:(TYSlidePageScrollView *)slidePageScrollView pageVerticalScrollViewForIndex:(NSInteger)index
{
 
    if (index == 0) {
        JUStudyingViewController *studyingVc = self.childViewControllers[index];
        [studyingVc view];
        return studyingVc.mainTableView;
    }else if (index == 1){
        JUFreeCourseController *freeVC = self.childViewControllers[index];
        [freeVC view];
        return freeVC.mainCollectionView;
    }else{
        TableViewController *tableViewVC = self.childViewControllers[index];
        [tableViewVC view];
        return tableViewVC.tableView;
    }
    
    
    
}


-(UIView *)slidePageChildView:(TYSlidePageScrollView *)slidePageScrollView pageVerticalScrollViewForIndex:(NSInteger)index{
    
    return [self.childViewControllers[index] view];
}

#pragma mark 响应方法

-(void)registeredButtonAction:(UIButton *)button{
    
    JURegisteredViewController *registerVC = [[JURegisteredViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:NO];
    
}



-(void)tapLoginAction{
    
    JULoginViewController *loginvC = [[JULoginViewController alloc]init];
    [self.navigationController pushViewController:loginvC animated:NO];
    
}

-(void)VIPAction:(UIButton *)button{
    
//    JULiveCourseDetailController *detailVC = [[JULiveCourseDetailController alloc]init];
    JULiveDetailController *detailVC = [[JULiveDetailController alloc]init];
    detailVC.course_id = @"70";
    detailVC.course_name = @"VIP";
    
    [self.navigationController pushViewController:detailVC animated:NO];
    
    
    
}

#pragma mark 数据处理

-(void)makeData{
    
    if (networkingType == NotReachable) {
        return;
    }
    
    
    __weak typeof(self) weakSelf = self;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{

        [self.manager POST:V30getUserInfoMation parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
            
            
        } success:^(NSURLSessionDataTask *task, NSMutableDictionary * responobject) {
            
            
 
//            JULog(@"%@", responobject);
            
            if ([[responobject[@"errno"] description] isEqualToString:@"0"]){
                weakSelf.user = [JUUser mj_objectWithKeyValues:responobject[@"data"]];
                
                NSURL *url = [NSURL URLWithString:self.user.avatar_file];
                [weakSelf.iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"personal_head_sign"]];
                
                weakSelf.uidLabel.text = [NSString stringWithFormat:@"UID: %@", self.user.uid];
                
                if (weakSelf.user.is_vip) {
                    
                    weakSelf.VIPButton.selected = YES;
                }else{
                    weakSelf.VIPButton.selected = NO;
                }
                
                weakSelf.nameLabel.text = self.user.user_name;
 
            }
   
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //JULog(@"%@", error);
          

            
        }];
 
        
    });
    
    
    

    
    
    

    
    
}









@end
