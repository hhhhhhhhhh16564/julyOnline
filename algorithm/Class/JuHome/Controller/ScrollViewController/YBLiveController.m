//
//  YBLiveController.m
//  algorithm
//
//  Created by 周磊 on 16/9/14.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "YBLiveController.h"
#import "YBTitleView.h"
#import "YBTitleButton.h"
#import "JULiveCourseMoreController.h"

#import "JULiveModel.h"

#import "JUMoreCategoryModel.h"

#import "UIButton+Extension.h"
#import "JUMenuView.h"
#import "JUBannerModel.h"
#import "JURecommendModel.h"
#import "JURecommandController.h"
@interface YBLiveController ()<UIScrollViewDelegate>

@property(nonatomic, strong) YBTitleView *titleView;

@property(nonatomic, strong) UIScrollView *MainScrollView;

@property(nonatomic, strong) NSMutableArray *liveCoursesArray;
@property(nonatomic, strong) NSMutableArray *moreCategoryArray;
@property(nonatomic, strong) JUMenuView  *menuView;

@property(nonatomic, strong) UILabel *titleLabel;

@property(nonatomic, strong) UIButton *arrowButton;

@property(nonatomic, strong) UIView *blackCoverView;

@property (nonatomic,assign) NSInteger lastIndex;

@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) NSInteger lastPage;

@property(nonatomic, strong) NSMutableArray *bannerArray;


@property(nonatomic, strong) NSString *vip_img;

@end

@implementation YBLiveController


-(NSInteger)currentPage{
    NSUInteger index = self.MainScrollView.contentOffset.x/self.MainScrollView.width_extension;

    return index;
    
}

//
//
//-(UILabel *)titleLabel{
//    
//    if (!_titleLabel) {
//        _titleLabel = [[UILabel alloc]init];
//        _titleLabel.text = @"   所有分类";
//        _titleLabel.font = UIptfont(14);
//        //    titleLabel.backgroundColor = HCanvasColor(1);
//        _titleLabel.backgroundColor = [UIColor whiteColor];
//    }
//    
//    return _titleLabel;
//}

-(NSMutableArray *)liveCoursesArray{
    
    if (!_liveCoursesArray) {
        _liveCoursesArray = [NSMutableArray array];
    }
    
    return _liveCoursesArray;
}


-(NSMutableArray *)moreCategoryArray{
    
    if (!_moreCategoryArray) {
        _moreCategoryArray = [NSMutableArray array];
    }
    
    return _moreCategoryArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([JuuserInfo.showstring isEqualToString:@"0"]) {
        return;
    }
    
    //上一个加载页面的下标，初始化为-1(防止默认为0的影响)
    self.lastIndex = -1;
    
    self.navigationItem.title = @"直播课程";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupTopViews];
    
    
    [self makeDate];
    
}

-(void)setupSubViews{
    
    
    [self setupChildViewControllers];
    
    [self setupMainScrollView];
    
    [self addchildViews];
    
    [self setCoverView];
    
}


-(void)setupTopViews{
    
    
    YBTitleView  *titleView = [[YBTitleView alloc]init];
    titleView.showsVerticalScrollIndicator = NO;
    titleView.showsHorizontalScrollIndicator = NO;
    titleView.backgroundColor = self.navigationController.navigationBar.backgroundColor;
    titleView.frame = CGRectMake(0, 20, Kwidth- 50, 44);


    self.titleLabel.frame = titleView.frame;

    self.titleLabel.hidden = YES;

    titleView.titleArray = @[@""];

    titleView.buttonSpacing = 20;
    __weak typeof(self) weakSelf = self;
    
    titleView.Blcok = ^(YBTitleButton *button){
        NSInteger index = button.tag - 100;
        
        // 让UIScrollView滚动到对应位置
        CGPoint offset = weakSelf.MainScrollView.contentOffset;
        offset.x = index * weakSelf.MainScrollView.width_extension;
        [weakSelf.MainScrollView setContentOffset:offset animated:YES];

        [weakSelf.menuView MenubuttonClicked:index];
    };
    
//    [titleView titliButtonClicked:0];
    [self.view addSubview:titleView];
    self.titleView = titleView;
    
    [self.view addSubview:self.titleLabel];

    
    UIButton *button = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"zhibo@xiala@normal"] selectedImage:[UIImage imageNamed:@"zhibo@xiala@pre"] button:nil];
    
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:(UIControlEventTouchUpInside)];

    
//    button.backgroundColor = [UIColor whiteColor];
    button.frame = CGRectMake(titleView.right_extension, titleView.y_extension, Kwidth-titleView.width_extension, titleView.height_extension);
    
    [self.view addSubview:button];
    
    self.arrowButton = button;
    [self buttonClicked:button];
    

    JUMenuView *menuView = [[JUMenuView alloc]init];
    menuView.frame = CGRectMake(0, titleView.bottom_extension, Kwidth, 10);
    menuView.backgroundColor = [UIColor whiteColor];
    menuView.hidden = YES;
    self.menuView = menuView;
    
    __weak JUMenuView *weakmunuView = menuView;
    
    menuView.buttonBlcok = ^(YBTitleButton *button){
        
        NSInteger index = button.tag - 100;
        
        // 让UIScrollView滚动到对应位置
        CGPoint offset = weakSelf.MainScrollView.contentOffset;
        offset.x = index * weakSelf.MainScrollView.width_extension;
        [weakSelf.MainScrollView setContentOffset:offset animated:YES];
        

        if (weakmunuView.clickType == 1) {
            
            [JUUmengStaticTool event:JUUmengStaticAllLiveCourse key:JUUmengParamFilter value:@"TagClick"];
        }
        
        if (weakmunuView.isClicked) {
            
            [weakSelf buttonClicked:weakSelf.arrowButton];
  
        }
        
        [weakSelf.titleView titliButtonClicked:index];
        
        
    };
    
    
//    [self buttonDidSelected:0];
 
}

//设置黑色遮盖view

-(void)setCoverView{
    
    UIView *blackCoverView = [[UIView alloc]init];
    blackCoverView.backgroundColor = [UIColor blackColor];
    blackCoverView.alpha = 0.12;
    blackCoverView.frame = CGRectMake(0, 64, Kwidth, Kheight-64);
    blackCoverView.hidden = YES;
    [self.view addSubview:blackCoverView];
    [self.view insertSubview:blackCoverView aboveSubview:self.MainScrollView];
    
    self.blackCoverView = blackCoverView;
    

    
}




-(void)setupChildViewControllers{
    
    //    JULiveCourseMoreController *liveCourseMoreVC = [[JULiveCourseMoreController alloc]init];
    //    [self addChildViewController:liveCourseMoreVC];
    //
    for (int i = 0; i < self.titleView.titleArray.count; i++) {
        if (i == 0) {
            JURecommandController *commandVC = [[JURecommandController alloc]init];
            [self addChildViewController:commandVC];
            
        }else{
            JULiveCourseMoreController *VC = [[JULiveCourseMoreController alloc]init];
            [self addChildViewController:VC];
 
        }
        
        
        
    }
    
}


-(void)setupMainScrollView{
    
    
    UIScrollView *MainScrollView = [[UIScrollView alloc]init];
    MainScrollView.frame = CGRectMake(0, 64, Kwidth, Kheight-64-49);
    MainScrollView.backgroundColor = HCanvasColor(1);
    MainScrollView.pagingEnabled = YES;
    MainScrollView.showsVerticalScrollIndicator = NO;
    MainScrollView.showsHorizontalScrollIndicator = NO;
    MainScrollView.delegate = self;
    MainScrollView.contentSize = CGSizeMake(self.childViewControllers.count*MainScrollView.width_extension, 0);
//    MainScrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    [self.view addSubview:MainScrollView];
    
    self.MainScrollView = MainScrollView;
    [self.view sendSubviewToBack:MainScrollView];
    
    [self.view addSubview:self.menuView];
    
}


-(void)addchildViews{
    
    //子控制器的索引
    
    NSUInteger index = self.MainScrollView.contentOffset.x/self.MainScrollView.width_extension;
    
    if (self.lastIndex != index) {
        self.lastIndex = index;
        JUMoreCategoryModel *model = self.moreCategoryArray[index];
        
        [JUUmengStaticTool event:JUUmengStaticAllLiveCourse key:JUUmengParamCourseView value:model.category_id];
        
    }
    
    UIViewController *childVC = nil;
    
    if (index == 0) {
        JURecommandController *commandVC = self.childViewControllers[index];
       // [commandVC view];
        
        
        commandVC.mainDataArray = self.liveCoursesArray;
        commandVC.bannerArray = self.bannerArray;
        commandVC.vip_img = self.vip_img;
        childVC = commandVC;
        if ([childVC isViewLoaded]) {
            return;
        }
        
    }else{
        //取出子控制器
        JULiveCourseMoreController *liveVC = self.childViewControllers[index];
        childVC = liveVC;
        if ([childVC isViewLoaded]) {
            return;
        }
        liveVC.CategoryModel = self.moreCategoryArray[index];
    }

    childVC.view.frame = self.MainScrollView.bounds;
    childVC.view.height_extension = Kheight-64-49;
    childVC.view.y_extension = 0;
    childVC.view.backgroundColor = [UIColor whiteColor];
    [self.MainScrollView addSubview:childVC.view];

    

}



-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    self.lastPage = self.currentPage;
    
}




-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    if (self.lastPage < self.currentPage) { //左边滑动
        
        [JUUmengStaticTool event:JUUmengStaticAllLiveCourse key:JUUmengParamSlide value:@"left"];

    }else{//右边滑动
        
        [JUUmengStaticTool event:JUUmengStaticAllLiveCourse key:JUUmengParamSlide value:@"right"];

    }
    
    
    
    //加载view
    [self addchildViews];
    
    NSInteger index = scrollView.contentOffset.x/self.MainScrollView.width_extension;
    
//    [self.titleView titliButtonClicked:index];
    
    [self buttonDidSelected:index];
    
}

/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 使用setContentOffset:animated:或者scrollRectVisible:animated:方法让scrollView产生滚动动画
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self addchildViews];
    
}



#pragma mrak 请求数据
-(void)makeDate{
    
    JULoadingView *loadingView = [JULoadingView shareInstance];
    loadingView.frame = CGRectMake(0, 0, Kwidth, Kheight-49);
    
    __weak typeof(self) weakSelf = self;
    loadingView.failureBlock = ^{
        
        [weakSelf makeDate];
        
    };
    
    [self.view addSubview:loadingView];
    [loadingView beginLoad];
    
    YBNetManager *manager = [[YBNetManager alloc]init];
    
    
    NSString *url = [NSString stringWithFormat:@"%@", V30recommendCourse];
    
    [manager GET:url parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
        
    } success:^(NSURLSessionDataTask *task, NSMutableDictionary *responobject) {
        
        [loadingView loadSuccess];
         
        [responobject writeToFile:@"/Users/pro/Desktop/资料/11.plist" atomically:YES];
        
        if (![[responobject[@"errno"] description] isEqualToString:@"0"])return ;
        
        NSDictionary *dict = responobject[@"data"];
        self.bannerArray = [JUBannerModel mj_objectArrayWithKeyValuesArray:dict[@"banner"]];
        self.moreCategoryArray = [JUMoreCategoryModel mj_objectArrayWithKeyValuesArray:dict[@"category"]];
        self.vip_img = dict[@"vip_img"];
        JUMoreCategoryModel *categoryModel = [[JUMoreCategoryModel alloc]init];
        categoryModel.category_id = @"0";
        categoryModel.name = @"推荐";
        [self.moreCategoryArray insertObject:categoryModel atIndex:0];

        self.liveCoursesArray = [JURecommendModel mj_objectArrayWithKeyValuesArray:dict[@"recommend"]];
        
        //请求到数据后刷新页面
        [self reloadDate];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    
        [loadingView loadFailure];
        
    }];
    
    
    
    
}

-(void)reloadDate{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        NSMutableArray *titleArray = [NSMutableArray array];
        
        [self.moreCategoryArray enumerateObjectsUsingBlock:^(JUMoreCategoryModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [titleArray addObject:obj.name];
            
        }];
        
        
        self.titleView.titleArray = titleArray;
        self.menuView.buttonArray = titleArray;
        
        [self buttonDidSelected:0];
        //        JULog(@"===============  %zd ============= ", self.titleView.titleArray.count);
        
        [self.titleView layoutIfNeeded];
        [self.menuView layoutIfNeeded];
        
        //请求到数据后加载子控件
        [self setupSubViews];
        
    });
    
}


#pragma mark 响应事件

-(void)buttonClicked:(UIButton *)button{
    
    button.selected = !button.selected;

    [UIView animateWithDuration:0.2 animations:^{
    
        //    self.titleLabel.hidden = button.selected;
        self.menuView.hidden =button.selected;

        
            self.blackCoverView.hidden =  self.menuView.hidden;
        
        
        
    }];
    
    if (button.selected) {//收拢的
        
        [JUUmengStaticTool event:JUUmengStaticAllLiveCourse key:JUUmengParamFilter value:@"Retraction"];
        
    }else{ //下拉的

        [JUUmengStaticTool event:JUUmengStaticAllLiveCourse key:JUUmengParamFilter value:@"Expand"];

        
    }
    
    
    
}

//三个点击事件绑定

-(void)buttonDidSelected:(NSUInteger)index{
    
    [self.menuView  MenubuttonClicked:index];
    [self.titleView titliButtonClicked:index];
    
    
}

-(void)SelectedIndex:(NSUInteger)index{
    
    CGPoint offset = self.MainScrollView.contentOffset;
    offset.x = index * self.MainScrollView.width_extension;
    [self.MainScrollView setContentOffset:offset animated:NO];

    
    [self buttonDidSelected:index];
    
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];

}





@end
