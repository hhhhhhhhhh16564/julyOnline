//
//  JURecommandController.m
//  algorithm
//
//  Created by pro on 17/9/23.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JURecommandController.h"
#import "JURefreshFooter.h"
#import "JURefeshHeader.h"
#import "JURecommandCell.h"
#import "JURecommendModel.h"
#import "JUTableViewSectionHeaderView.h"
#import "SDCycleScrollView.h"
#import "JUBannerModel.h"
#import "JUWebViewController.h"
#import "JULiveCourseDetailController.h"
#import "JURefeshHeader.h"
#import "JULiveDetailController.h"
static NSString *const recommandCell = @"recommmanCell";
static NSString *const tableViewSectionHeaderView = @"tableViewSectionHeaderView";

@interface JURecommandController ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate>
@property(nonatomic, strong) UITableView *mainTableView;


@property(nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property(nonatomic, strong) NSMutableArray *imagesURLStringsArray;

@property(nonatomic, strong) UIView *headView;



@property(nonatomic, strong) UIView *vipView;

@property(nonatomic, strong) UIImageView *vipImv;
@end

@implementation JURecommandController

-(NSMutableArray *)imagesURLStringsArray{
    if (!_imagesURLStringsArray) {
        _imagesURLStringsArray = [NSMutableArray array];
    }
    
    return _imagesURLStringsArray;
}
-(UIView *)vipView{
    
    if (!_vipView) {
        _vipView = [[UIView alloc]init];
        _vipView.backgroundColor = [UIColor whiteColor];
        _vipView.frame = CGRectMake(0, 0, Kwidth, Kwidth*0.31+15+20);
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLoginAction)];
        [_vipView addGestureRecognizer:tapGesture];
        
        self.vipImv = [[UIImageView alloc]init];
        self.vipImv.userInteractionEnabled = YES;
        [_vipView addSubview:self.vipImv];
        
        [self.vipImv mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(0);
            make.top.mas_equalTo(15);
            make.bottom.mas_equalTo(-20);
            
        }];
       [self.vipImv sd_setImageWithURL:[NSURL URLWithString:self.vip_img] placeholderImage:[UIImage imageNamed:@"bigloading"]];
        

    }

    
    
    return _vipView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configureSubViews];

}


-(UIView *)headView{
    
    if (!_headView) {
        _headView = [[UIView alloc]init];
        _headView.backgroundColor = [UIColor whiteColor];
        _headView.frame = CGRectMake(0, 0, Kwidth, Kwidth*0.5+20);
        
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, Kwidth, Kwidth*0.5) delegate:self placeholderImage:[UIImage imageNamed:@"bigloading"]];
        //    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        cycleScrollView.pageControlDotSize = CGSizeMake(6, 6);
        cycleScrollView.currentPageDotColor = Kcolor16rgb(@"ffffff", 1);
        cycleScrollView.pageDotColor = Kcolor16rgb(@"ffffff", 0.5);
        cycleScrollView.autoScrollTimeInterval = 6;
        cycleScrollView.imageURLStringsGroup = self.imagesURLStringsArray;
        self.cycleScrollView = cycleScrollView;
        [_headView addSubview:cycleScrollView];
        
    }
    
    return _headView;
    
}



-(void)configureSubViews{
    
    JULog(@"%@", self.view.logframe);
    
    UIView *mainContentView = [[UIView alloc]init];
    mainContentView.frame = CGRectMake(0, 0, Kwidth, Kheight-64-49);
    [self.view addSubview:mainContentView];
    
    
    
    CGRect tableViewFrame =  mainContentView.bounds;
    self.mainTableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
    self.mainTableView.backgroundColor = HCanvasColor(1);
    self.mainTableView.tableHeaderView = self.headView;
    self.mainTableView.mj_header = [JURefeshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    
    [mainContentView addSubview:self.mainTableView];
    
    
    
    
    [self.mainTableView registerClass:[JURecommandCell class] forCellReuseIdentifier:recommandCell];
    
    [self.mainTableView registerClass:[JUTableViewSectionHeaderView class] forHeaderFooterViewReuseIdentifier:tableViewSectionHeaderView];
    

    
    
 
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JURecommandCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:recommandCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JURecommendModel *recommendModel = self.mainDataArray[indexPath.section];
   
//    JULog(@"%zd", recommendModel.course.count);
    cell.liveModel = recommendModel.course[indexPath.row];
    
    return cell;
//    return nil;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.mainDataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    return 3;
    JURecommendModel *recommendModel = self.mainDataArray[section];
    
    
    return recommendModel.course.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    
    JUTableViewSectionHeaderView *tableHeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:tableViewSectionHeaderView];
    tableHeadView.backgroundColor = [UIColor redColor];
    JURecommendModel *recommendModel = self.mainDataArray[section];

    tableHeadView.titleLabel.text = recommendModel.title;
    
    return tableHeadView;
    
 
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return self.vipView;
    }
    
    
    UIView *view = [[UIView alloc]init];
    
    view.backgroundColor = [UIColor whiteColor];
    return view;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return Kwidth*0.31+15+20;
    }
    
    
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 15+Kwidth*0.4*0.72;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JURecommendModel *recommendModel = self.mainDataArray[indexPath.section];
    
    //    JULog(@"%zd", recommendModel.course.count);
    JULiveModel * liveModel = recommendModel.course[indexPath.row];
    
//    JULiveCourseDetailController *liveVC = [[JULiveCourseDetailController alloc]init];
//    liveVC.course_id = liveModel.course_id;
//    [self.navigationController pushViewController:liveVC animated:NO];
    
    
    
        JULiveDetailController *liveVC = [[JULiveDetailController alloc]init];
        liveVC.course_id = liveModel.course_id;
        [self.navigationController pushViewController:liveVC animated:NO];

}
-(void)setMainDataArray:(NSMutableArray *)mainDataArray{
    _mainDataArray = mainDataArray;
    
    [self.mainTableView reloadData];
    
}


-(void)setBannerArray:(NSMutableArray *)bannerArray{
    _bannerArray = bannerArray;

    [self.imagesURLStringsArray removeAllObjects];
    
    [_bannerArray enumerateObjectsUsingBlock:^(JUBannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *imagURLString = [obj.img stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [self.imagesURLStringsArray addObject:imagURLString];
        
    }];
    
     self.cycleScrollView.imageURLStringsGroup = self.imagesURLStringsArray;
}

-(void)setVip_img:(NSString *)vip_img{
    _vip_img = vip_img;
    [self.vipImv sd_setImageWithURL:[NSURL URLWithString:self.vip_img] placeholderImage:[UIImage imageNamed:@"bigloading"]];
}
#pragma mark 响应方法
#pragma mark 响应方法
//点击轮播图图片
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    //  JUWebViewController  以后也可能跳转html5页面
    
    
    [JUUmengStaticTool event:JUUmengStaticHomePage key:JUUmengParamBannerClick intValue:index];
    
    if (![JuuserInfo.showstring isEqualToString:@"1"]) return;
    
    
    JUBannerModel *bannerModel = self.bannerArray[index];
    
    if ([bannerModel.jump_url hasPrefix:@"http"]) {
 
        JULog(@"%@", bannerModel.jump_url);
        JUWebViewController *webVC = [[JUWebViewController alloc]init];
        webVC.jump_url = bannerModel.jump_url;
        //        webVC.navigationItem.title = @"七月在线年会员VIP";
        [self.navigationController pushViewController:webVC animated:NO];
        return;
        
    }
    
    
    
    JULiveDetailController *liveCourse = [[JULiveDetailController alloc]init];
    liveCourse.course_id = bannerModel.jump_url;
    [self.navigationController pushViewController:liveCourse animated:NO];
    
    
}

-(void)tapLoginAction{
    
//    JULiveCourseDetailController *detailVC = [[JULiveCourseDetailController alloc]init];
    
    
    JULiveDetailController *detailVC = [[JULiveDetailController alloc]init];

    detailVC.course_id = @"70";
    detailVC.course_name = @"VIP";
    
    [self.navigationController pushViewController:detailVC animated:NO];

}

-(void)loadNewTopics{
    
    [self.mainTableView reloadData];
    self.cycleScrollView.imageURLStringsGroup = self.imagesURLStringsArray;

    [self.mainTableView.mj_header endRefreshing];
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
