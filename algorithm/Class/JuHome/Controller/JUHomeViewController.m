//
//  JUHomeViewController.m
//  algorithm
//
//  Created by pro on 16/6/27.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUHomeViewController.h"
#import "JUHomeFlowLayout.h"
#import "JUBannerModel.h"
#import "JUCategoryModel.h"
#import "JUColHeaderReuseView.h"
#import "JUCoursesModel.h"
#import "JUCollectionViewCell.h"
#import "SDCycleScrollView.h"
#import "JUMoreViewController.h"
#import "JUCourseDetailViewController.h"
#import "JULiveCoursesCell.h"
#import "JULiveCourseDetailController.h"
#import "JUDateTool.h"
#import "JUVedioCourseMoreController.h"
#import "JUDateBase.h"
#import "JUCourseLaseRecorderDatabase.h"
#import "JULessonRecordDatabase.h"

#import "JUCouponController.h"
//直播课程
#import "JULiveModel.h"
//视频课程
#import "JUVideoModel.h"
//#import "YBViewController.h"
#import "YBLiveController.h"
#import "YBVideoController.h"
#import "JUWebViewController.h"
#import "JURefeshHeader.h"
#import "UIScrollView+Extension.h"
#import "JUPurchaseManager.h"


static NSString * HeaderId = @"collectionViewHeaderId";

static NSString * JUHomeCollectionCell = @"homeCell";

static NSString *livecoursesCell = @"livecoursesCell";
static NSString *cachesPath = @"multiplePlayDeletePreviousVideoKey";



static NSString *deleteLessonAndCourseDataPath = @"deleteLessonAndCourseDataPath";

@interface JUHomeViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, JUColHeaderReuseViewDelegate, SDCycleScrollViewDelegate>

@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong)UICollectionView *homeCollectionView;


@property(nonatomic, strong) NSMutableArray *bannerArray;
@property(nonatomic, strong) NSMutableArray *categoryArray;
@property(nonatomic, strong) NSMutableArray *imagesURLStringsArray;


//App2.0

@property(nonatomic, strong) NSMutableArray *liveArray;

@property(nonatomic, strong) NSMutableArray *videoArray;





@property(nonatomic, strong)UIView *headview;

@property(nonatomic, strong) SDCycleScrollView *cycleScrollView;

@end

@implementation JUHomeViewController

-(NSMutableArray *)bannerArray{
    
    if (_bannerArray == nil) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}

-(NSMutableArray *)categoryArray{
    
    if (_categoryArray == nil) {
        _categoryArray = [NSMutableArray array];
    }
    
    return _categoryArray;
    
}


//App2.0
-(NSMutableArray *)imagesURLStringsArray{
    
    if (_imagesURLStringsArray == nil) {
        _imagesURLStringsArray = [NSMutableArray array];
    }
    
    return _imagesURLStringsArray;
    
}


-(NSMutableArray *)liveArray{
    
    if (_liveArray == nil) {
        _liveArray = [NSMutableArray array];
    }
    return _liveArray;
}


-(NSMutableArray *)videoArray{
    
    if (_videoArray == nil) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"七月在线";

    [self setUpViews];

    //数据源
    [MBProgressHUD showMessage:@"正在加载中" toView: self.view];

//    JULog(@"%@", JuuserInfo.showstring);
    
    
    //因为有登录，当自动登录时，留0.5秒时间给自动登录，登录成功后会返回一下数据如accesstoken等，带着这些东西去请求数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
                   dispatch_get_global_queue(0, 0), ^{
                       
                       [self makeDate];
                       
                   });
    
}
#pragma mark 视图布局
-(void)setUpViews{
    
    
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor redColor];
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
    __weak typeof(self) weakSelf = self;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view).with.insets(UIEdgeInsetsMake(64, 0, 49, 0));
        
    }];
    
    //这一句必须要加，要先刷新界面
    [self.view layoutIfNeeded];

  
    CGFloat Kspacing = 15;
    JUHomeFlowLayout *flowyout = [[JUHomeFlowLayout alloc]init];
//    flowyout.itemSize = CGSizeMake(kItemWith, kItemHeitht+33.5);
    flowyout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowyout.minimumInteritemSpacing = Kspacing;
    flowyout.minimumLineSpacing = 0;
    flowyout.sectionInset = UIEdgeInsetsMake(0, Kspacing, 20, Kspacing);
    
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.contentView.bounds collectionViewLayout:flowyout];
    
    collectionView.contentInset = UIEdgeInsetsMake(Kwidth*0.5+20, 0, 0, 0);
     collectionView.delegate = self;
     collectionView.dataSource = self;
//    collectionView.backgroundColor = Kcolor16rgb(@"f4f4f4", 1);
    collectionView.backgroundColor = [UIColor whiteColor];
     collectionView.bounces = YES;
      collectionView.alwaysBounceVertical = YES;
    
    [self.contentView addSubview:collectionView];
    self.homeCollectionView = collectionView;
    

    //轮播图view
    UIView *headView = [[UIView alloc]init];
    headView.frame = CGRectMake(0, -Kwidth*0.5-20, Kwidth, Kwidth*0.5);
    [collectionView addSubview:headView];
    self.headview = headView;
    
    [self p_setupCycleScrollView];
    
    [self.homeCollectionView registerClass:[JUCollectionViewCell class] forCellWithReuseIdentifier:JUHomeCollectionCell];
    
    [self.homeCollectionView registerClass:[JUColHeaderReuseView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderId];
    [self.homeCollectionView registerClass:[JULiveCoursesCell class] forCellWithReuseIdentifier:livecoursesCell];
    self.homeCollectionView.mj_header = [JURefeshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.homeCollectionView.mj_header.ignoredScrollViewContentInsetTop = self.homeCollectionView.yb_insetT;
}

-(void)p_setupCycleScrollView{
    
//    UIScrollView *demoContainerView = [[UIScrollView alloc] initWithFrame:self.headview.bounds];
//    demoContainerView.contentSize = self.headview.frame.size;
//    [self.headview addSubview:demoContainerView];

    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.headview.bounds delegate:self placeholderImage:[UIImage imageNamed:@"bigloading"]];
//    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    cycleScrollView.pageControlDotSize = CGSizeMake(6, 6);
    cycleScrollView.currentPageDotColor = Kcolor16rgb(@"ffffff", 1);
    cycleScrollView.pageDotColor = Kcolor16rgb(@"ffffff", 0.5);
    cycleScrollView.autoScrollTimeInterval = 6;
    self.cycleScrollView = cycleScrollView;
    [self.headview addSubview:cycleScrollView];
    
}



#pragma mark 其它方法

-(void)loadNewData{
    [self makeDate];
}


-(void)makeDate{
    
    YBNetManager *mannger = [[YBNetManager alloc]init];
    
    __weak typeof(self) weakSelf = self;
    [mannger GET:home2URL parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
        
    } success:^(NSURLSessionDataTask *task,id responobject) {
        [self.homeCollectionView.mj_header endRefreshing];
        
        
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        
        if (responobject) {
            NSDictionary *dict = responobject[@"data"];
      //直接打印出两个Model的属性
//            [NSObject createPropertyCodeWithDict:[dict[@"live"] firstObject]];
//            [NSObject createPropertyCodeWithDict:[dict[@"video"] firstObject]];

            if (dict) {
                self.bannerArray = [JUBannerModel mj_objectArrayWithKeyValuesArray:dict[@"banner"]];
                [self.imagesURLStringsArray removeAllObjects];
                
                [self.bannerArray enumerateObjectsUsingBlock:^(JUBannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *imagURLString = [obj.img stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    [self.imagesURLStringsArray addObject:imagURLString];
                    
                }];
                
                if ([JuuserInfo.showstring isEqualToString:@"0"]) {
                    
                    NSString *string = [self.imagesURLStringsArray lastObject];
                    
                    [self.imagesURLStringsArray replaceObjectAtIndex:0 withObject:string];
                    
                }
                
                
                //
//                NSMutableArray *ddddd = dict[@"live"];
//                [ddddd writeToFile:@"/Users/julyonline/Desktop/plist/11.plist" atomically:YES];
                
                
                

                
                self.liveArray = [JULiveModel mj_objectArrayWithKeyValuesArray:dict[@"live"]];
                self.videoArray = [JUVideoModel mj_objectArrayWithKeyValuesArray:dict[@"video"]];
                
                if ([JuuserInfo.showstring isEqualToString:@"0"]) {

                    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"11" ofType:@"plist"];
                    NSArray *array = [[NSArray alloc]initWithContentsOfFile:bundlePath];
                    self.liveArray = [JULiveModel mj_objectArrayWithKeyValuesArray:array];
                    
                    [self.liveArray removeObjectAtIndex:0];
                }
                


                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    weakSelf.cycleScrollView.imageURLStringsGroup = self.imagesURLStringsArray;
                    [weakSelf.homeCollectionView reloadData];

                });
                
                
                
                
            }
            
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.homeCollectionView.mj_header endRefreshing];

        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        if (error) {
            JULog(@"%@", error);
        }
        
        
    }];
    
}

#pragma mark 响应方法
//点击轮播图图片
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
//  JUWebViewController  以后也可能跳转html5页面
    

    [JUUmengStaticTool event:JUUmengStaticHomePage key:JUUmengParamBannerClick intValue:index];
    
    if (![JuuserInfo.showstring isEqualToString:@"1"]) return;
  
    
    JUBannerModel *bannerModel = self.bannerArray[index];
    
    if ([bannerModel.jump_url hasPrefix:@"http"]) {
    
        JUWebViewController *webVC = [[JUWebViewController alloc]init];
        webVC.jump_url = bannerModel.jump_url;
//        webVC.navigationItem.title = @"七月在线年会员VIP";
        [self.navigationController pushViewController:webVC animated:NO];
        
        return;
       
    }

    JULiveCourseDetailController *liveCourse = [[JULiveCourseDetailController alloc]init];
    liveCourse.course_id = bannerModel.jump_url;
    [self.navigationController pushViewController:liveCourse animated:NO];
    
}

//更多按钮点击
-(void)morebuttonDidClicked:(JUColHeaderReuseView *)reuseView{
    
    
    if ([reuseView.titleLabel.text isEqualToString:@"直播课程"]) {
        
        [JUUmengStaticTool event:JUUmengStaticHomePage key:JUUmengParamLiveClick value:@"more"];
        
        YBLiveController *ybVC = [[YBLiveController alloc]init];
        [self.navigationController pushViewController:ybVC animated:NO];
        
    }else{
        [JUUmengStaticTool event:JUUmengStaticHomePage key:JUUmengParamVideoClick value:@"more"];
        
        YBVideoController *vedioVC = [[YBVideoController alloc]init];
        [self.navigationController pushViewController:vedioVC animated:NO];

    }
}


-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView scollViewDirection:(SDCycleScrollViewScrollDirection)direction toCurrentPage:(NSInteger)currentPage{
 
    
    [JUUmengStaticTool event:JUUmengStaticHomePage key:JUUmengParamBannerView intValue:currentPage];
    
    if (direction == SDCycleScrollViewScrollLeft) {
        [JUUmengStaticTool event:JUUmengStaticHomePage key:JUUmengParamBannerSlide value:@"left"];
        
    }else{
        
        [JUUmengStaticTool event:JUUmengStaticHomePage key:JUUmengParamBannerSlide value:@"right"];
        
    }
}

#pragma mark 代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (section==0) {
        
        return self.liveArray.count;
        
    }else if(section==1){
        
        return self.videoArray.count;
        
    }
    
    return 0;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        
        JULiveCoursesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:livecoursesCell forIndexPath:indexPath];
        cell.lineView.hidden = YES;
        cell.liveModel = self.liveArray[indexPath.row];
        
        return cell;
        
        
    }else{
        
    JUCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JUHomeCollectionCell forIndexPath:indexPath];
        
        cell.videoModel = self.videoArray[indexPath.row];


        return cell;

    }
    
       return nil;
}




-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        JUColHeaderReuseView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderId forIndexPath:indexPath];
        view.colHeadreuseViewDelegate = self;
        
        view.titleLabel.text = @"视频";
        view.moreBtn.hidden = NO;
        
        if (indexPath.section == 0) {
            view.titleLabel.text = @"直播课程";
            if ([JuuserInfo.showstring isEqualToString:@"0"]) {
                
                view.moreBtn.hidden = YES;

            }
            
            
        }

//        view.line.hidden = !(indexPath.section);
        
        //
        return view;
    }else return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section

{
    
        return CGSizeMake(self.view.bounds.size.width, 40);

    
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    

    CGFloat kItemWith = (self.view.width_extension-15*3)/2;
    CGFloat kItemHeitht = kItemWith * 0.72;
    
    CGFloat livecoursesWidth = self.view.width_extension-15*2;
    CGFloat livecoursesHeight = self.view.width_extension*0.4*0.72;
    

    
    
    if (indexPath.section == 0) {
       
        return CGSizeMake(livecoursesWidth, livecoursesHeight+15);

    }else{
        
        return CGSizeMake(kItemWith, kItemHeitht+40);

        
    }
    
    return CGSizeZero;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    

    if (indexPath.section == 0) {
        
        [JUUmengStaticTool event:JUUmengStaticHomePage key:JUUmengParamLiveClick intValue:indexPath.row];
        
        JULiveCourseDetailController *detailVc = [[JULiveCourseDetailController alloc]init];
        JULiveModel *liveModel = self.liveArray[indexPath.row];
        detailVc.course_id = liveModel.course_id;
        detailVc.course_name = liveModel.course_name;
        
        [self.navigationController pushViewController:detailVc animated:NO];
        
        
    }else{
        
        [JUUmengStaticTool event:JUUmengStaticHomePage key:JUUmengParamVideoClick intValue:indexPath.row];
        
        JUCourseDetailViewController *detailVC = [[JUCourseDetailViewController alloc]init];
        JUVideoModel *videoModel = self.videoArray[indexPath.row];
        
        detailVC.course_id = videoModel.course_id;
        detailVC.course_title = videoModel.video_name;
        [self.navigationController pushViewController:detailVC animated:NO];
        
    }
    
 
}


#pragma mark系统方法

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置导航栏的背景颜色
  
    [self.navigationController.navigationBar setBarTintColor:Hmblue(1)];
  
    //设置title的字体颜色和样式
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    dict[NSFontAttributeName] = UIptfont(34*KMultiplier);
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        if ([JuuserInfo.showstring isEqualToString:@"1"]) return ;
        JUPurchaseManager *manager = [JUPurchaseManager shareManager];
        [manager startRequestWithArray:nil];

//        [manager restoreCompletedTransactionsSuccess:^{
//            
//            
//        } failure:^{
//            
//            
//        }];
        
    });
    
    [JUUmengStaticTool event:JUUmengStaticHomePage key:JUUmengStaticPV value:JUUmengStaticPV];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)),
                   dispatch_get_global_queue(0, 0), ^{
                       NSUserDefaults *userdefulat = [NSUserDefaults standardUserDefaults];
                       
                       NSString *storagePath = [userdefulat valueForKey:deleteLessonAndCourseDataPath];
                       
                       if (!storagePath) {
                           
                           [userdefulat setObject:@"LLLLLLLLL" forKey:deleteLessonAndCourseDataPath];
                           [userdefulat synchronize];
                           
                           NSFileManager *manager = [NSFileManager defaultManager];
                           //移除数据库和表
                           [manager removeItemAtPath:lessonRecordDatabase.dataBasePath error:nil];
                           [manager removeItemAtPath:courseLaseRecorder111.dataBasePath error:nil];
                           
                           //创建数据库表
                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                               
                               [lessonRecordDatabase createLessonRecordDatabase];
                               [courseLaseRecorder111 createLessonRecordDatabase];
                               
                           });
                       }
                       
                   });
    
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
                   dispatch_get_global_queue(0, 0), ^{
                        NSUserDefaults *userdefulat = [NSUserDefaults standardUserDefaults];
                       //                       之前视频加密，现在更换视频，删除之前的视频

                       NSString *storagePath = [userdefulat valueForKey:cachesPath];
                       
                       if (!storagePath) {
                           
                           [userdefulat setObject:@"hhhhhhhhhhh" forKey:cachesPath];
                           [userdefulat synchronize];
                           
                           NSFileManager *manager = [NSFileManager defaultManager];
                           //移除数据库和表
                           [manager removeItemAtPath:mydatabase.dataseBasePath error:nil];
                           mydatabase.downloadBaseQueue = nil;
                           [manager removeItemAtPath:lessonRecordDatabase.dataBasePath error:nil];
                           [manager removeItemAtPath:courseLaseRecorder111.dataBasePath error:nil];
                           //移除数据资源
                           NSString *cachesPath = NSSearchPathForDirectoriesInDomains(algorithmDowonloadMediaCachPath, NSUserDomainMask, YES)[0];
                           
                           NSString *suffixPath = [NSString stringWithFormat:@"downloadVedio"
                                                   ];
                           
                         NSString *videoRootPath  = [cachesPath stringByAppendingPathComponent:suffixPath];
                           
                           [manager removeItemAtPath:videoRootPath error:nil];
                           
                           
                           //创建数据库表
                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                               
                               [mydatabase createTableWithDownload];
                               [lessonRecordDatabase createLessonRecordDatabase];
                               [courseLaseRecorder111 createLessonRecordDatabase];

                           });
                       }
        
                   });
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
  [self.navigationController.navigationBar setBarTintColor:HCanvasColor(1)];
    //设置title的字体颜色和样式
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor blackColor];
    dict[NSFontAttributeName] = UIptfont(36*KMultiplier);
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
        
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
