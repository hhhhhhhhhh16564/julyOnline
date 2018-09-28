//
//  YBViewController.m
//  algorithm
//
//  Created by 周磊 on 16/9/6.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "YBVideoController.h"
#import "YBTitleView.h"
#import "YBTitleButton.h"
#import "JUVedioCourseMoreController.h"
#import "JUVideoModel.h"
#import "JUMoreCategoryModel.h"
#import "UIButton+Extension.h"
#import "JUMenuView.h"


@interface YBVideoController ()<UIScrollViewDelegate>

@property(nonatomic, strong) NSMutableArray *videoCourseArray;
@property(nonatomic, strong) NSMutableArray *moreCategoryArray;

@property(nonatomic, strong) YBTitleView *titleView;

@property(nonatomic, strong) UIScrollView *MainScrollView;

@property(nonatomic, strong) JUMenuView  *menuView;

@property(nonatomic, strong) UILabel *titleLabel;

@property(nonatomic, strong) UIButton *arrowButton;

@property (nonatomic,assign) NSInteger lastIndex;

@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) NSInteger lastPage;


@end

@implementation YBVideoController


-(NSInteger)currentPage{
    NSUInteger index = self.MainScrollView.contentOffset.x/self.MainScrollView.width_extension;
    
    return index;
    
}


-(NSMutableArray *)videoCourseArray{
    
    if (!_videoCourseArray) {
        _videoCourseArray = [NSMutableArray array];
    }
    
    return _videoCourseArray;
}


-(NSMutableArray *)moreCategoryArray{
    
    if (!_moreCategoryArray) {
        _moreCategoryArray = [NSMutableArray array];
    }
    
    return _moreCategoryArray;
}



-(UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"   所有分类";
        _titleLabel.font = UIptfont(14);

        //    titleLabel.backgroundColor = HCanvasColor(1);
        _titleLabel.backgroundColor = [UIColor whiteColor];
    }
    
    return _titleLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.lastIndex = -1;

    self.navigationItem.title = @"视频";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupTopViews];
    
    
    [self makeDate];
    
}

-(void)setupSubViews{
    
    
    [self setupChildViewControllers];
    
    [self setupMainScrollView];
    
    [self addchildViews];
    
}


-(void)setupTopViews{
    
    
    YBTitleView  *titleView = [[YBTitleView alloc]init];
    titleView.showsVerticalScrollIndicator = NO;
    titleView.showsHorizontalScrollIndicator = NO;
    titleView.backgroundColor = [UIColor whiteColor];
    titleView.frame = CGRectMake(0, 64, Kwidth- 50, 40);
    
    
    self.titleLabel.frame = titleView.frame;
    
    
    titleView.titleArray = @[@"算法"];
    
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
    
    
    button.backgroundColor = [UIColor whiteColor];
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
            
            [JUUmengStaticTool event:JUUmengStaticAllVideo key:JUUmengParamFilter value:@"TagClick"];
        }
        
        
        if (weakmunuView.isClicked) {
            
            [weakSelf buttonClicked:weakSelf.arrowButton];
            
        }
        
        [weakSelf.titleView titliButtonClicked:index];
        
        
    };
    
    
    //    [self buttonDidSelected:0];
    
}


-(void)setupChildViewControllers{
    
    //    JULiveCourseMoreController *liveCourseMoreVC = [[JULiveCourseMoreController alloc]init];
    //    [self addChildViewController:liveCourseMoreVC];
    //
    for (int i = 0; i < self.titleView.titleArray.count; i++) {
        
        JUVedioCourseMoreController *VC = [[JUVedioCourseMoreController alloc]init];
        
        [self addChildViewController:VC];
        
    }
    
}


-(void)setupMainScrollView{
    
    
    UIScrollView *MainScrollView = [[UIScrollView alloc]init];
    MainScrollView.frame = self.view.bounds;
    MainScrollView.backgroundColor = HCanvasColor(1);
    MainScrollView.pagingEnabled = YES;
    MainScrollView.showsVerticalScrollIndicator = NO;
    MainScrollView.showsHorizontalScrollIndicator = NO;
    MainScrollView.delegate = self;
    MainScrollView.contentSize = CGSizeMake(self.childViewControllers.count*MainScrollView.width_extension, 0);
    MainScrollView.contentInset = UIEdgeInsetsMake(114, 0, 0, 0);
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
        
        [JUUmengStaticTool event:JUUmengStaticAllVideo key:JUUmengParamCourseView value:model.cat_id];
        
    }
    
    
    //取出子控制器
    JUVedioCourseMoreController *childVc = self.childViewControllers[index];
    
    if ([childVc isViewLoaded]) {
        return;
    }
    
    childVc.view.frame = self.MainScrollView.bounds;
    childVc.view.height_extension = Kheight-114;
    childVc.view.y_extension = 0;
    childVc.view.backgroundColor = [UIColor whiteColor];
    
    childVc.CategoryModel = self.moreCategoryArray[index];
    
    [self.MainScrollView addSubview:childVc.view];
    
    
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    self.lastPage = self.currentPage;
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (self.lastPage < self.currentPage) { //左边滑动
        
        [JUUmengStaticTool event:JUUmengStaticAllVideo key:JUUmengParamSlide value:@"left"];
        
    }else{//右边滑动
        
        [JUUmengStaticTool event:JUUmengStaticAllVideo key:JUUmengParamSlide value:@"right"];
        
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
    
    
    YBNetManager *manager = [[YBNetManager alloc]init];
    
    
    NSString *url = [NSString stringWithFormat:@"%@/0/1/3", vedioCourseCatetoryURL2_1];
    
    [manager GET:url parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
        
    } success:^(NSURLSessionDataTask *task, NSMutableDictionary *responobject) {
        
        //        JULog(@"%@", responobject);
        
        if (![[responobject[@"errno"] description] isEqualToString:@"0"])return ;
        
        NSDictionary *dict = responobject[@"data"];
        
//        JULog(@"%@", dict);
        self.moreCategoryArray = [JUMoreCategoryModel mj_objectArrayWithKeyValuesArray:dict[@"category"]];
        
        JUMoreCategoryModel *categoryModel = [[JUMoreCategoryModel alloc]init];
        categoryModel.cat_id = @"0";
        categoryModel.cat_name = @"全部";
        [self.moreCategoryArray insertObject:categoryModel atIndex:0];
        
        
        
        
        
        self.videoCourseArray = [JUVideoModel mj_objectArrayWithKeyValuesArray:dict[@"video"]];
        
//                        [self.moreCategoryArray.firstObject logObjectExtension_YanBo];
//                        [self.videoCourseArray.firstObject logObjectExtension_YanBo];
        
        
        //请求到数据后刷新页面
        [self reloadDate];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
   
}


-(void)reloadDate{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        NSMutableArray *titleArray = [NSMutableArray array];
        
        [self.moreCategoryArray enumerateObjectsUsingBlock:^(JUMoreCategoryModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [titleArray addObject:obj.cat_name];
            
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
        
        self.titleLabel.hidden = button.selected;
        self.menuView.hidden = button.selected;
        
    }];
    
    if (button.selected) {//收拢的
        
        [JUUmengStaticTool event:JUUmengStaticAllVideo key:JUUmengParamFilter value:@"Retraction"];
        
    }else{ //下拉的
        
        [JUUmengStaticTool event:JUUmengStaticAllVideo key:JUUmengParamFilter value:@"Expand"];
        
        
    }
    
    
    
}



//三个点击事件绑定

-(void)buttonDidSelected:(NSUInteger)index{
    
    [self.menuView  MenubuttonClicked:index];
    [self.titleView titliButtonClicked:index];
    
    
}
@end
