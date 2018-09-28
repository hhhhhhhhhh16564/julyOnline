//
//  JUCommentsController.m
//  algorithm
//
//  Created by 周磊 on 16/11/25.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUCommentsController.h"

#import "JULessonModel.h"
#import "JURefeshHeader.h"
#import "JURefreshFooter.h"

#import "JUCommentModel.h"
#import "JUCommentsCell.h"
#import "JUReplayController.h"
#import "AppDelegate.h"
#import "JULoginViewController.h"
#import "JUMediaPlayerTool.h"
#import "JUCoverView.h"

static  NSString  * const commentCell = @"commentCell";

@interface JUCommentsController ()

@property(nonatomic, strong) YBNetManager *manager;
@property (nonatomic,assign) NSInteger pageIndex;

@property(nonatomic, strong) NSMutableArray<JUCommentModel *> *commentArray;

@property(nonatomic, strong) UIButton *headView;


//用来记录是否展开
@property (nonatomic,strong) NSMutableDictionary *recoderDict;

@property(nonatomic, strong) JUCoverView *coverView;


//测试属性
@property(nonatomic, strong) NSString *path;
@property(nonatomic, strong) NSDictionary *dict;

@end

@implementation JUCommentsController

-(NSMutableDictionary *)recoderDict{
    if (!_recoderDict) {
        
        _recoderDict = [NSMutableDictionary dictionary];
    }
    
    return _recoderDict;
    
}

-(JUCoverView *)coverView{
    
    if (!_coverView) {
        _coverView = [[JUCoverView alloc]init];
        
        
        _coverView.frame = CGRectMake(0, 0, Kwidth, Kheight-64-Kwidth*2/3-40.5-39);
        _coverView.imageName = @"emty_comment";
        _coverView.labelOneString = @"暂无评论  你是第一个哦~";
//        _coverView.textColor = Kcolor16rgb(@"999999", 1);
        _coverView.imageViewTop = 40;
         _coverView.hidden = YES;
        [self.tableView addSubview:_coverView];
        
    }
    
    return _coverView;
    
}


-(NSMutableArray <JUCommentModel *> *)commentArray{
    
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    
    return _commentArray;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
 

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(repLySucceedNotification:) name:JURepLySucceedNotification object:nil];
   
    [self setupViews];

    
}




- (YBNetManager *)manager
{
    if (!_manager) {
        _manager = [[YBNetManager alloc]init];
    }
    return _manager;
}


-(void)setupViews{
    
    [self setHeadView];
    [self setupTableview];
    [self setRefresh];
    
    [self coverView];


    
}

-(void)setHeadView{

    UIButton *headViwe = [UIButton buttonWithType:(UIButtonTypeCustom)];
    headViwe.frame = CGRectMake(0, -44, Kwidth, 44);
    headViwe.backgroundColor = [UIColor whiteColor];
   [headViwe addTarget:self action:@selector(buttonClicked:) forControlEvents:(UIControlEventTouchUpInside)];

    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"我来评论";
    label.textColor = Kcolor16rgb(@"#999999", 1);
    label.font = UIptfont(11);
    label.backgroundColor = Kcolor16rgb(@"#EDEDED", 1);
    label.layer.cornerRadius = 3;
    label.frame = CGRectMake(30, 5, Kwidth-60, 34);
    [headViwe addSubview:label];
    self.headView = headViwe;
}

-(void)buttonClicked:(UIButton *)button{
    [JUUmengStaticTool event:JUUmengStaticPlayerDetail key:JUUmengParamComment value:@"Comment"];

    if (!JuuserInfo.isLogin) {
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        JUBaseNavigationController *navc  = delegate.window.rootViewController.childViewControllers[0];
        
        
        [navc pushViewController:[[JULoginViewController alloc]init] animated:NO];
        
        return;
        
    }
    
    
    JUReplayController *replyVC = [[JUReplayController alloc]init];

    replyVC.lessonModel = self.lessonModel;

    JUBaseNavigationController *navc = [[JUBaseNavigationController alloc]initWithRootViewController:replyVC];
    
    [self.navigationController presentViewController:navc animated:NO completion:nil];
    
    

    
    
    JUlogFunction
    
}



-(void)setupTableview{
    

    
//    [self.tableView addSubview:self.headView];
    
    
    [self.tableView setContentInset:UIEdgeInsetsMake(39, 0, 0, 0)];
    
    [self.tableView addSubview:self.headView];

    
    [self.tableView registerClass:[JUCommentsCell class] forCellReuseIdentifier:commentCell];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
}

#pragma make tableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    JUCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCell forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    JUCommentModel *commentModel = self.commentArray[indexPath.row];
    

    [self setTableViewIsOpend:commentModel];


    
    __weak typeof(self) weakSelf = self;
    cell.seeMoreblock = ^(NSInteger index){
        
     JUCommentModel *commentModel = weakSelf.commentArray[index];
     commentModel.tableViewIsOpend = YES;
        
        NSString *ID = commentModel.ID;
        
        //记录这个查看更多已经打开
        
        [weakSelf.recoderDict setObject:@"1" forKey:ID];
 

        
//        JULog(@"%@ %@", commentModel.ID, recoderString);

        
        [weakSelf refreshVisableCellS];
        
    };
    
    
    
    cell.replyCommentBlock = ^(JUCommentModel *commentModel){
        
        
        JUReplayController *replyVC = [[JUReplayController alloc]init];
        replyVC.commentModel = commentModel;
        
        JUBaseNavigationController *navc = [[JUBaseNavigationController alloc]initWithRootViewController:replyVC];
        
        [weakSelf.navigationController presentViewController:navc animated:NO completion:nil];
        
        
        
        
    };
    
    
    
    
    cell.seperatorLineView.hidden = (indexPath.row==self.commentArray.count-1);
    cell.commentModel = commentModel;
    

    return cell;
    
}


//刷新可见区域

-(void)refreshVisableCellS{
    
    
    NSArray<NSIndexPath *> *indexPathsArray = self.tableView.indexPathsForVisibleRows;
    
    [self.tableView reloadRowsAtIndexPaths:indexPathsArray withRowAnimation:(UITableViewRowAnimationNone)];
    
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    JUCommentModel *commentModel = self.commentArray[indexPath.row];

    return commentModel.CommentHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.commentArray.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    
    
    self.headView.y_extension = scrollView.contentOffset.y;
    
    
}

-(void)setRefresh{
    

    self.tableView.mj_header = [JURefeshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    
    
    self.tableView.mj_footer = [JURefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
    
    
    
}

- (void)loadNewTopics
{
    
    [self.commentArray removeAllObjects];
    
    self.pageIndex = 1;
    
    [self.manager canceAllrequest];
    
    [self.tableView.mj_footer resetNoMoreData];
    
    
    __weak typeof(self) weakSelf = self;
    [self.manager GET:[self urlStringWithPage:self.pageIndex] parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
        
        
    } success:^(NSURLSessionDataTask *task, NSMutableDictionary * responobject) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        
        if (![[responobject[@"errno"] description] isEqualToString:@"0"]) return ;
        

        self.commentArray = [JUCommentModel mj_objectArrayWithKeyValuesArray:responobject[@"data"][@"comment"]];
        
        
        
        [self.commentArray enumerateObjectsUsingBlock:^(JUCommentModel * _Nonnull commentModel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            
            commentModel.index = idx;
            

            [weakSelf setTableViewIsOpend:commentModel];
            
    
            
            
        }];
    
        
        weakSelf.coverView.hidden = (weakSelf.commentArray.count);
        
        [weakSelf.tableView reloadData];
        
        if (weakSelf.commentArray.count <5) {
            
            weakSelf.tableView.mj_footer.hidden = YES;
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        
    }];
 
}


- (void)loadMoreTopics
{
    
    self.pageIndex++;
    
    [self.manager canceAllrequest];
    
    
    __weak typeof(self) weakSelf = self;
    
    [self.tableView.mj_footer resetNoMoreData];
    
    [self.manager GET:[self urlStringWithPage:self.pageIndex] parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
        
        
    } success:^(NSURLSessionDataTask *task, NSMutableDictionary * responobject) {
        
        
        
        if (![[responobject[@"errno"] description] isEqualToString:@"0"]) return ;
        
        
        
        NSArray<JUCommentModel *> *CommentModels = [JUCommentModel mj_objectArrayWithKeyValuesArray:responobject[@"data"][@"comment"]];
        
        
        
        weakSelf.tableView.mj_footer.automaticallyHidden = YES;
        
        if (!CommentModels.count) {
            
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
            //            weakSelf.tableView.mj_footer.hidden = YES;
            
            return;
        }
        
        [weakSelf.tableView.mj_footer endRefreshing];
        
        [weakSelf.commentArray addObjectsFromArray:CommentModels];
        
        [weakSelf.commentArray enumerateObjectsUsingBlock:^(JUCommentModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            obj.index = idx;
            
            
            [weakSelf setTableViewIsOpend:obj];
            
        }];
        
        
        
        [weakSelf.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
        [weakSelf.tableView.mj_footer endRefreshing];
        
    }];
    
    
    
    
}




-(void)makedata{
    
    
     __weak typeof(self) weakSelf = self;
    
    
    NSString *urlstring = [NSString stringWithFormat:@"%@/%@/1/%zd",GetCommentURL, self.lessonModel.ID, self.commentArray.count];
    
    
    [self.manager GET:urlstring parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, NSMutableDictionary * responobject) {
        

         weakSelf.commentArray = [JUCommentModel mj_objectArrayWithKeyValuesArray:responobject[@"data"][@"comment"]];
        
         [weakSelf.commentArray enumerateObjectsUsingBlock:^(JUCommentModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
             obj.index = idx;
             
             [weakSelf setTableViewIsOpend:obj];
             
         }];
        
        
        [weakSelf refreshVisableCellS];
        

        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        

        JULog(@"%@", error);
        
        
    }];

    

}

//设置MOdel

-(void)setTableViewIsOpend:(JUCommentModel *)commentModel{
    
    NSString *recoderString = [self.recoderDict valueForKey:commentModel.ID];
    
    if ([recoderString isEqualToString:@"1"]) {
        
        commentModel.tableViewIsOpend = YES;
        
    }
    
}




 
-(NSString *)urlStringWithPage:(NSUInteger)pageIndex{
    

    NSString *urlstring = [NSString stringWithFormat:@"%@/%@/%zd/5",GetCommentURL, self.lessonModel.ID, pageIndex];

    JULog(@"%@", urlstring);
    
    return urlstring;
}


#pragma mark
//接受到通知

-(void)repLySucceedNotification:(NSNotification *)notifi{
    
    JULog(@"%@", notifi.object);
    
    if ([notifi.object isEqualToString:@"回复"]) {//评论，
        
        //评论之后，内容要刷新
        
        // 要重新请求数据
        
        [self makedata];

        
    }else{  // 发表， 需要刷新
        
        //发表的内容应该显示在最开始
//        [self.tableView.mj_header beginRefreshing];
        
        
        
        [self loadNewTopics];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
        
    }
    
    
    
    
}




-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    
    
//    [self.tableView setContentOffset:self.point];
//    
//    
//    JULog(@"出现： %f %zd", self.point.y, self.commentArray.count);
//
    
    JULessonModel *lessonModel = [JUMediaPlayerTool shareInstance].mediaPlayer.lessonModel;
    
    if (![self.lessonModel.ID isEqualToString:lessonModel.ID] && lessonModel) {// 加载的是新的一个视频， 需要 重新加载数据
        self.lessonModel = lessonModel;

    }
    
}


-(void)setLessonModel:(JULessonModel *)lessonModel{
    
    _lessonModel = lessonModel;
    
    //(获得默认值, 开始请求数据)
    
    [self loadNewTopics];
    
    
    JULog(@"开始请求数据");
}




            
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    

    [JUUmengStaticTool event:JUUmengStaticPlayerDetail key:JUUmengParamComment value:JUUmengStaticPV];


}

            
            
            

@end
