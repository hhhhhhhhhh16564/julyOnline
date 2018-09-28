//
//  JUTeacherListViewController.m
//  七月算法_iPad
//
//  Created by pro on 16/6/2.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUTeacherListViewController.h"
#import "JUTeacherListCell.h"

#import "JUTeacherModel.h"

static NSString *teacherListCell = @"teacherListCell";
@interface JUTeacherListViewController ()


@end

@implementation JUTeacherListViewController

-(NSMutableArray *)teacherListArray
{
    if (_teacherListArray == nil) {
        _teacherListArray = [NSMutableArray array];
    }
    
    return _teacherListArray;
    
}

-(void)viewDidLoad{
    
    [super viewDidLoad];

    //去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.tableView registerClass:[JUTeacherListCell class] forCellReuseIdentifier:teacherListCell];
    
    
//    
//    UIView *view = [[UIView alloc]init];
//    view.frame = CGRectMake(0, 0, self.view.width, 44);
//    UILabel *lab = [[UILabel alloc]init];
//    lab.frame = CGRectMake(30*KMultiplier,13.5 , self.view.width/2, 17);
//    lab.text = @"讲师简介";
//    lab.textColor = Hmblack(1);
//    [view addSubview:lab];
//    
//    
//    
//    self.tableView.tableHeaderView = view;
//    

}

-(void)setHeadViewWithSimpleDescription:(NSString *)simpleDescription{
    CGFloat height = [simpleDescription sizeWithFont:UIptfont(16) maxW:(Kwidth-24)].height;
    
    
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = HCanvasColor(1);
    headView.frame = CGRectMake(0, 0, Kwidth, height+34);
    
    self.tableView.tableHeaderView = headView;
    
    
    UIView *labelView = [[UIView alloc]init];
    labelView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:labelView];
    
   
    [labelView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.mas_equalTo(0);
        make.height.mas_equalTo(height+24);
    }];
    
    
    UILabel *label = [[UILabel alloc]init];
    label.font = UIptfont(16);
    label.textColor = Hmblack(1);
    label.text = simpleDescription;
    [labelView addSubview:label];
    
    [label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(labelView).with.insets(UIEdgeInsetsMake(12, 12, 12, 12));
        
    }];
    
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JUTeacherListCell *cell = [tableView dequeueReusableCellWithIdentifier:teacherListCell forIndexPath:indexPath];
    JUTeacherModel *model = self.teacherListArray[indexPath.row];
    
    cell.teacherModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.teacherListArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  

    JUTeacherModel *model = self.teacherListArray[indexPath.row];
    

    return [JUTeacherListCell calculateHeightwithString:model];
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [JUUmengStaticTool event:JUUmengStaticPlayerDetail key:JUUmengParamAbstract value:JUUmengStaticPV];

    
    
}



@end
