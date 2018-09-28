//
//  JUDownloadListController.m
//  algorithm
//
//  Created by pro on 16/7/13.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUDownloadListController.h"
#import "JUDownListCell.h"
#import "JULessonModel.h"
#import "JUButton.h"
#import "JULoginViewController.h"
#import "JUReplayController.h"

static NSString *judownListViewCell = @"judownListViewCell";


@interface JUDownloadListController ()<JUDownListCellDelegate>

@property(nonatomic, strong) UIView *footView;
@property(nonatomic, strong) JUButton *downloadButton;


@property(nonatomic, assign) CGFloat foot_Y;

//下载用的数组
@property(nonatomic, strong) NSMutableArray *downloadArray;

@end

@implementation JUDownloadListController
-(NSMutableArray *)CourselessonArray
{
    
    if (_CourselessonArray == nil) {
        
        _CourselessonArray = [NSMutableArray array];
    }
    
    return _CourselessonArray;
    
}

-(NSMutableArray *)downloadArray{
    if (_downloadArray == nil) {
        _downloadArray = [NSMutableArray array];
    }
    
    
    return _downloadArray;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downloadTaskDidFinishDownloadingNotification:) name:JuDownloadTaskDidFinishDownloadingNotification object:nil];
    

    
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);

    //去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[JUDownListCell class] forCellReuseIdentifier:judownListViewCell];
    
  _foot_Y = Kheight-64-Kwidth*2/3-40.5-49;
    
}

#pragma mark 视图布局
-(void)setupViews{
    
 
    
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = HCanvasColor(1);
    footView.frame = CGRectMake(0, Kheight-64-Kwidth*2/3-40.5-49, Kwidth, 49);
    [self.tableView addSubview:footView];
    self.footView = footView;
    
    //选择全部和下载两个Button
   
    JUButton *selectedButton = [JUButton buttonWithType:(UIButtonTypeCustom)];
    [selectedButton setTitle:@"选择全部" forState:(UIControlStateNormal)];
    [selectedButton setTitle:@"取消全部" forState:(UIControlStateSelected)];
    [selectedButton.titleLabel setFont:UIptfont(14)];
    
    [selectedButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [selectedButton addTarget:self action:@selector(selectALLAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [footView addSubview:selectedButton];
    
    JUButton *downLoadButton = [JUButton buttonWithType:(UIButtonTypeCustom)];
    [downLoadButton setTitle:@"下载" forState:(UIControlStateNormal)];
    [downLoadButton setTitleColor:Hcgray(1) forState:(UIControlStateNormal)];
    [downLoadButton.titleLabel setFont:UIptfont(14)];

     downLoadButton.enabled = YES;
     [downLoadButton addTarget:self action:@selector(downLoadAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [footView addSubview:downLoadButton];
    self.downloadButton = downLoadButton;
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = HSpecialSeperatorline(1);
    [footView addSubview:lineView];
    
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.mas_equalTo(CGSizeMake(0.5, 20));
        make.centerY.mas_equalTo(footView.mas_top).offset(footView.height_extension/2);
        make.centerX.mas_equalTo(footView.mas_left).offset(Kwidth/2);
        
        
    }];
    
    
    [selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.top.and.bottom.mas_equalTo(0);
        make.width.mas_equalTo(Kwidth/2);
        
    }];
    
    [downLoadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.and.right.and.bottom.mas_equalTo(0);
        make.width.mas_equalTo(Kwidth/2);
        
        
    }];
    
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = HSpecialSeperatorline(1);
    [footView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        
        
    }];
    
    
       
    
}

#pragma mark tableviewDelegate代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JUDownListCell *cell =  [tableView dequeueReusableCellWithIdentifier:judownListViewCell forIndexPath:indexPath];
    //设置选中时没有背景色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JULessonModel *model = self.CourselessonArray[indexPath.row];
    
    cell.lessonModel = model;
    NSString *nametext = [NSString stringWithFormat:@"%ld.  %@",(long)indexPath.row+1,model.name];
    
    cell.nameLab.text = nametext;
    cell.delegate = self;
    
    return cell;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.CourselessonArray.count;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 69;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    JUlogFunction
    
  
    JUReplayController *replayVC = [[JUReplayController alloc]init];
    [self.navigationController pushViewController:replayVC animated:NO];
    

}


//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
#pragma mark  其它方法

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
   self.footView.y_extension = _foot_Y+scrollView.contentOffset.y;
    
}

-(void)hookedButtonDidClicked:(JUDownListCell *)listCell{
    
    [self.downloadArray removeAllObjects];
    [self.CourselessonArray enumerateObjectsUsingBlock:^(JULessonModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.lessonstate == JUSeleted) {
            
            [self.downloadArray addObject:obj];
            
        }
        
    }];
    
    [self setDownLoadButtonTitle];
    
}

//设置下载button的字体
-(void)setDownLoadButtonTitle{
    if (self.downloadArray.count) {
        NSString *str = [NSString stringWithFormat:@"下载(%ld)", (long)self.downloadArray.count];
        [self.downloadButton setTitle:str forState:(UIControlStateNormal)];
        [self.downloadButton setTitleColor:Hmgreen(1) forState:(UIControlStateNormal)];
        self.downloadButton.enabled = YES;
        
        
    }else{
        
        [self.downloadButton setTitle:@"下载" forState:(UIControlStateNormal)];
        [self.downloadButton setTitleColor:Hcgray(1) forState:(UIControlStateNormal)];
        self.downloadButton.enabled = NO;
  
    }
    
    
}


#pragma mark 响应方法
-(void)selectALLAction:(JUButton *)sender{
    
    sender.selected = !sender.selected;
    
    [self.downloadArray removeAllObjects];
    
    //移除所有的元素
    
    [self.CourselessonArray enumerateObjectsUsingBlock:^(JULessonModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if (sender.selected) {
            if (obj.lessonstate != JUCompleted) {
                
                obj.lessonstate = JUSeleted;
                
                [self.downloadArray addObject:obj];
            }
            
            
        }else{
            
            if (obj.lessonstate != JUCompleted) {
                
                obj.lessonstate = JUUnSelected;
                
            }

        }
    }];
    
    [self.tableView reloadData];
    [self setDownLoadButtonTitle];


    
}

-(void)downLoadAction:(JUButton *)sender{
    
    if (!self.downloadArray.count) {
        return;
    }
    
    //如果没有网路，返回
    
    if (JuuserInfo.isLogin == NO) {
        
        
        JULoginViewController *loginVC = [[JULoginViewController alloc]init];
        
        [self.navigationController pushViewController:loginVC animated:NO];
        
        return;
        
    }
    
    
    
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;

    
    if (networkingType == NotReachable) {
        
        GMToast *toast = [[GMToast alloc]initWithView:keywindow  text:@"请检查你的网络" duration:1.5];
        [toast show];
        
        return;
    }
    

    

    
    if (networkingType == ReachableViaWWAN) {
        
        GMToast *toast = [[GMToast alloc]initWithView:keywindow  text:@"你正在用手机流量下载" duration:1.5];
        [toast show];
        
    }
    
    
    GMToast *toast = [[GMToast alloc]initWithView:keywindow  text:@"添加视频到下载列表成功" duration:1.5];
    [toast show];

    

    //全部下载要先查看下载状态，如果状态是JUDownloadStateNone,就下载
    [self.downloadArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JULessonModel *lessonModel = obj;
        if (lessonModel.downloadInfo.downloadstatus == JUDownloadStateNone) {

            
            [[JUDownloadManager shredManager] downloadWithUrlString:lessonModel.play_url toPath:lessonModel.destinationPath process:^(float progress, NSString *sizeString, NSString *speedString) {
                
                
            } completion:^{
                
                
            } failure:^(NSError *error) {
                
                
            } lessonModel:lessonModel];
            
            
            
            
        };
        
    }];
    
    //加入下载列表之后, 该表字体
    [self.downloadButton setTitle:@"下载" forState:(UIControlStateNormal)];
    [self.downloadButton setTitleColor:Hcgray(1) forState:(UIControlStateNormal)];
    self.downloadButton.enabled = NO;
}


#pragma mark 通知代理方法

-(void)downloadTaskDidFinishDownloadingNotification:(NSNotification *)notifi{
    //给状态改变一点时间
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       
                       [self.tableView reloadData];

                   });
    
    
}




#pragma mark 系统方法
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    

}




#pragma mark 系统方法
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
