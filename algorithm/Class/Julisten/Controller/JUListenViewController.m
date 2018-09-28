//
//  JUListenViewController.m
//  algorithm
//
//  Created by 周磊 on 16/11/30.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUListenViewController.h"
#import "JUListenCell.h"
#import "NSObject+Property.h"
#import "JUListenCourseModel.h"
#import "JUListenLessonController.h"


static NSString * const listCell =  @"listCell";

@interface JUListenViewController ()

@property(nonatomic, strong) NSMutableArray<JUListenCourseModel*> *listenArray;




@end

@implementation JUListenViewController
-(NSMutableArray<JUListenCourseModel*> *)listenArray{
    
    if (!_listenArray) {
        _listenArray = [NSMutableArray array];
    }
    
    return _listenArray;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    
    [self makeData];
    
}


-(void)setupViews{
    
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_register_background"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[JUListenCell class] forCellReuseIdentifier:listCell];
    

    
}

-(void)makeData{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"1111" ofType:@"plist"];
    NSArray *array = [[NSArray alloc]initWithContentsOfFile:path];

    self.listenArray = [JUListenCourseModel mj_objectArrayWithKeyValuesArray:array];

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    JUListenCell *cell = [tableView dequeueReusableCellWithIdentifier:listCell forIndexPath:indexPath];
    cell.courseModel = self.listenArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.listenArray.count;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    JUListenLessonController *listenVC = [[JUListenLessonController alloc]init];

    listenVC.dataArray = self.listenArray[indexPath.row].lessons;
    [self.navigationController pushViewController:listenVC animated:NO];
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    

    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"login_register_background"]imageWithRenderingMode:UIImageRenderingModeAutomatic] forBarMetrics:UIBarMetricsDefault];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    dict[NSFontAttributeName] = UIptfont(34*KMultiplier);
    [self.navigationController.navigationBar setTitleTextAttributes:dict];

    
}

- (void)dealloc
{
    
    JUlogFunction
    
    
    
    
}


@end
