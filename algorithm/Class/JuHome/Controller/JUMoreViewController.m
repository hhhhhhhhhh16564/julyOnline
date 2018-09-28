//
//  JUMoreViewController.m
//  algorithm
//
//  Created by pro on 16/7/11.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUMoreViewController.h"
#import "JUMoreViewCell.h"
#import "JUCoursesModel.h"
#import "JUCourseDetailViewController.h"

static NSString * JUmoreViewTableViewCell = @"JUmoreViewTableViewCell";
@interface JUMoreViewController ()
//更多的详细课程
@property(nonatomic, strong) NSMutableArray *moreCourseArray;
@end

@implementation JUMoreViewController
-(NSMutableArray *)moreCourseArray{
    
    if (_moreCourseArray == nil) {
        _moreCourseArray = [NSMutableArray array];
    }
    
    return _moreCourseArray;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    


    
    
}
#pragma mark 视图布局
-(void)p_setupViews{
    
    self.title = self.cat_name;
    
    
   
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerClass:[JUMoreViewCell class] forCellReuseIdentifier:JUmoreViewTableViewCell];
    
     [self makeupData];
    
}




#pragma makr 其它方法
-(void)makeupData{
    
    
    YBNetManager *mannger = [[YBNetManager alloc]init];
    
    __weak typeof(self) weakSelf = self;
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", moreURL,self.cat_id];
    
//    JULog(@"------%@", urlString);
    
    
    [mannger GET:urlString parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
        
    } success:^(NSURLSessionDataTask *task, id responobject) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
//              JULog(@"----------- %@", responobject);
        
        if (responobject) {
            NSDictionary *dict = responobject[@"data"];
            if (dict) {
                
                
                
                self.moreCourseArray = [JUCoursesModel mj_objectArrayWithKeyValuesArray:dict];
                
//                JULog(@"%@", self.moreCourseArray);
                
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                
                
                });
                
            }
            
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        if (error) {
            JULog(@"%@", error);
        }
        
        
    }];
    
}

#pragma mark 响应方法




#pragma mark tableviewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.moreCourseArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JUMoreViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:JUmoreViewTableViewCell forIndexPath:indexPath];
    JUCoursesModel *courseModel = self.moreCourseArray[indexPath.row];
    
    cell.courseModel = courseModel;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 115;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JUCoursesModel *model = self.moreCourseArray[indexPath.row];
    
    JUCourseDetailViewController *detailVC = [[JUCourseDetailViewController alloc]init];
    detailVC.course_id = model.course_id;
    detailVC.course_title = model.course_title;
    
    [self.navigationController pushViewController:detailVC animated:NO];

    
    
}



#pragma mark系统方法

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置导航栏的背景颜色
    

    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
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
