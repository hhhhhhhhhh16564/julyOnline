//
//  JUMineLoginStateController.m
//  algorithm
//
//  Created by pro on 16/7/11.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUMineLoginStateController.h"
#import "JUCourseRecoderController.h"
#import "JUCourseViewCell.h"
#import "JUpurchaseController.h"
#import "JUAboutCompanyController.h"
#import "JUShoppingCarController.h"
#import "JUMyCouponViewController.h"

#import "JUShoppingCarOrderController.h"

static NSString * juCourseViewCell = @"mineCourseViewCell";

@interface JUMineLoginStateController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UIImageView *userIcon;


@property(nonatomic, strong) UITableView *tableView;





@property(nonatomic, strong) UILabel *lastStudyLab;
@property(nonatomic, strong) UILabel *thisWeekStudyLab;




@property(nonatomic, strong) JUUser *user;

@end

@implementation JUMineLoginStateController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self p_setupViews];
    
}

#pragma mark 视图布局
//设置子控件
-(void)p_setupViews{

    UIView *contentView = [[UIView alloc]init];
    contentView.frame = CGRectMake(0, 64, Kwidth, Kheight-49-64);
    [self.view addSubview:contentView];
    self.contentView = contentView;
    contentView.backgroundColor = HCanvasColor(1);
    
    
    
    
//    UIView *topView = [[UIView alloc]init];
//    topView.frame = CGRectMake(0, 0 ,self.view.width_extension, 270);
//    
//    
//    self.topView = topView;
//    topView.backgroundColor = Kcolor16rgb(@"#18b4ed", 1);
//    
//    //图像
//    UIImageView *userIcon = [[UIImageView alloc]init];
//    userIcon.image = [UIImage imageNamed:@"personal_head_sign"];
//    userIcon.layer.cornerRadius = 40;
//    userIcon.layer.masksToBounds = YES;
//    [topView addSubview:userIcon];
//    userIcon.layer.masksToBounds = YES;
//    self.userIcon = userIcon;
//    
//    [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.size.mas_equalTo(CGSizeMake(80, 80));
//        make.top.equalTo(topView).with.offset(60);
//        make.centerX.equalTo(topView);
//        
//    }];
//    
//    
//    //分割线
//    UIView *seperatorLinveView = [[UIView alloc]init];
//    seperatorLinveView.backgroundColor = [UIColor whiteColor];
//    [self.topView addSubview:seperatorLinveView];
//    
//    [seperatorLinveView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.mas_equalTo(userIcon.mas_bottom).offset(40);
//        make.size.mas_equalTo(CGSizeMake(1, 36));
//        make.centerX.equalTo(topView.mas_centerX);
//        
//        
//        
//    }];
//    
//    
//    
//    UILabel *lastStudyLab = [[UILabel alloc]init];
//    [self.topView addSubview:lastStudyLab];
//    [lastStudyLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(seperatorLinveView);
//        make.right.equalTo(seperatorLinveView.mas_left).with.offset(-25);
//        make.width.mas_equalTo(70);
//        make.height.mas_equalTo(40);
//        
//    }];
//    
//    lastStudyLab.textColor = [UIColor whiteColor];
//    lastStudyLab.font = UIptfont(16);
//    lastStudyLab.textAlignment = NSTextAlignmentCenter;
//    lastStudyLab.text = @"上次学习2分钟前";
//    lastStudyLab.numberOfLines = 0;
//    self.lastStudyLab = lastStudyLab;
//    
//    
//    UILabel *thisWeekStudyLab = [[UILabel alloc]init];
//    [self.topView addSubview:thisWeekStudyLab];
//    
//    [thisWeekStudyLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(seperatorLinveView);
//        make.left.equalTo(seperatorLinveView.mas_right).with.offset(25);
//        make.width.mas_equalTo(70);
//        make.height.mas_equalTo(40);
//    }];
//    
//    
//    thisWeekStudyLab.textColor = [UIColor whiteColor];
//    thisWeekStudyLab.font = UIptfont(16);
//    thisWeekStudyLab.textAlignment = NSTextAlignmentCenter;
//    thisWeekStudyLab.text = @"本周已学0次课";
//    
//    thisWeekStudyLab.numberOfLines = 0;
//    
//    self.thisWeekStudyLab = thisWeekStudyLab;
    


    //底部Viwe 是一个tableView
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = HCanvasColor(1);
    [self.contentView addSubview:self.tableView];
    [self.tableView  mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
        
    }];
    [self.tableView registerClass:[JUCourseViewCell class] forCellReuseIdentifier:juCourseViewCell];
    
    
    
//    self.tableView.tableHeaderView = topView;
//    self.tableView.tableFooterView = [self setupFootView];

  }

//footView

//-(UIView *)setupFootView{
//    
//    UIView *footView = [[UIView alloc]init];
//    footView.frame = CGRectMake(0, 0, self.view.width_extension, 70);
//    footView.backgroundColor = HCanvasColor(1);
//    //退出按钮
//    UIButton *logoutButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [logoutButton addTarget:self action:@selector(logoutAction:) forControlEvents:(UIControlEventTouchUpInside)];
//    
//    logoutButton.layer.cornerRadius = 4;
//    logoutButton.layer.borderColor = (Hcgray(1)).CGColor;
//    logoutButton.layer.borderWidth = 1;
//    //    logoutButton.titleLabel.textColor = Hcgray(1);
//    [logoutButton setTitleColor:Hcgray(1) forState:(UIControlStateNormal)];
//    [logoutButton setTitle:@"退出登录" forState:(UIControlStateNormal)];
//    logoutButton.titleLabel.font = UIptfont(15);
//    [logoutButton setBackgroundColor:[UIColor whiteColor]];
//    [footView addSubview:logoutButton];
//    
//    [logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(200, 40));
//        make.centerX.equalTo(footView);
//        make.centerY.equalTo(footView.mas_bottom).with.offset(-35);
//    }];
//  
//    return footView;
//    
//}

#pragma mark 响应方法

#pragma mark 其它方法

-(void)makePersonalData{

    NSString *iconurl = JuuserInfo.loginDate[@"iconurl"];
    
    if ([iconurl length]) {
        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:iconurl] placeholderImage:[UIImage imageNamed:@"personal_head_sign"]];
        
        
    }
  
    
    YBNetManager *mannager = [[YBNetManager alloc]init];
    
    
    __weak typeof(self) weakSelf = self;
    [mannager POST:getUserInfomation parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
        
        
    } success:^(NSURLSessionDataTask *task, NSDictionary * responobject) {
        
//        JULog(@"登录返回数据:  %@", responobject);
        
        if (![responobject count]) {
                    JULog(@"登录返回数据*******  :  %@", responobject);

            return ;
        }
        
        
        NSDictionary *dict = responobject[@"data"];
        if (dict) {
            
            
            JUUser *user = [JUUser mj_objectWithKeyValues:dict];
            weakSelf.user = user;
            
            weakSelf.thisWeekStudyLab.text = [NSString stringWithFormat:@"本周已学%@次课", user.w_lear_num];
            if ([user.avatar_file length] && ![iconurl length]) {
                //                [weakSelf.userIcon sd_setImageWithURL:[NSURL URLWithString:user.avatar_file]];
                
                [weakSelf.userIcon sd_setImageWithURL:[NSURL URLWithString:user.avatar_file] placeholderImage:[UIImage imageNamed:@"personal_head_sign"]];
                
                
                
                
            }
            
            
            //username 就是nickname
//            weakSelf.nicknameLab.text = user.user_name;
            if ([user.last_learn_time length]) {
                NSString *str=user.last_learn_time;
                NSTimeInterval time=[str doubleValue];
                NSDate *createDate=[NSDate dateWithTimeIntervalSince1970:time];
                
                weakSelf.lastStudyLab.text = [NSString stringWithFormat:@"上次学习%@", [weakSelf createdate:createDate]];
            }
            
            if ([user.last_learn_time isEqualToString:@"0"]) {
                weakSelf.lastStudyLab.text = [NSString stringWithFormat:@"上次学习0分钟前"];
                
            }
            
            
            
            
        }
        
        
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
    
    
    
    
    
}

-(NSString *)createdate:(NSDate *)createDate{
    
    NSDate *nowDate = [NSDate date];
    NSTimeInterval timeinterval = [nowDate timeIntervalSinceDate:createDate];
    if (timeinterval < 60) {
        return @"1分钟前";
    }else if (timeinterval < 60*60){
        
        return [NSString stringWithFormat:@"%.0lf分钟前",timeinterval/60];
        
    }else if (timeinterval < 60*60*24){
        
        return [NSString stringWithFormat:@"%.0lf小时前",timeinterval/(60*60)];
        
        
    }else if (timeinterval < 60*60*24*30){
        
        return [NSString stringWithFormat:@"%.0lf天前",timeinterval/(60*60*24)];
        
    }else if (timeinterval < 60*60*24*30*12){
        
        return [NSString stringWithFormat:@"%.0lf个月前",timeinterval/(60*60*24*30)];
        
    }else {
        
        return [NSString stringWithFormat:@"%.0lf年前",timeinterval/(60*60*24*30*12)];
        
    }
    
    return @"";
    
}


#pragma mark tableViewDelegate的代理方法

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
    UIView *view = [[UIView alloc]init];
    
    view.backgroundColor = HCanvasColor(1);
    
    
    return view;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.0001;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 2) {
        
        return 0.0001;
    }
    
    
    return 10;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        
        return 2;
        
        
    }else if (section == 1){
        
        if ([JuuserInfo.showstring isEqualToString:@"0"]) {
            
            return 0;
        }

        return 3;
        
        
    }else if(section == 2){
        
        return 1;
        
    }else{
        
        return 0;
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
    
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JUCourseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:juCourseViewCell forIndexPath:indexPath];
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (indexPath.section == 0) {
        
        
        if (indexPath.row == 0) {
            
            cell.cellView.leftView.image = [UIImage imageNamed:@"my_study_icon"];
            cell.cellView.centerLabel.text = @"学习记录";
            
            cell.lineView.hidden = NO;
            
        }else if (indexPath.row == 1){
            
            
            cell.cellView.leftView.image = [UIImage imageNamed:@"my_class_icon"];
            cell.cellView.centerLabel.text = @"已购课程";
            
            cell.lineView.hidden = YES;

        }
        
        
    }else if (indexPath.section == 1){
        
        
        if (indexPath.row == 0) {
            cell.lineView.hidden = NO;

            cell.cellView.leftView.image = [UIImage imageNamed:@"shop"];
            cell.cellView.centerLabel.text = @"购物车";
            
            
            
        }else if (indexPath.row == 1){
            cell.lineView.hidden = NO;

            cell.cellView.leftView.image = [UIImage imageNamed:@"my_order_icon"];
            cell.cellView.centerLabel.text = @"我的订单";
            
            
        }else if(indexPath.row == 2){
            cell.lineView.hidden = YES;

            
            cell.cellView.leftView.image = [UIImage imageNamed:@"youhuiquan@icon"];
            cell.cellView.centerLabel.text = @"优惠券";
            
        }
        

        
    }else if (indexPath.section == 2){
        
        
        
        if (indexPath.row == 0) {
            cell.lineView.hidden = YES;

            cell.cellView.leftView.image = [UIImage imageNamed:@"guanyu@icon"];
            cell.cellView.centerLabel.text = @"关于七月在线";
            
        }
        
        
    }
    
    
    cell.cellView.rightView.image = [UIImage imageNamed:@"arrow_icon"];
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self umengLoginStateStatic:indexPath];
    
    
    UIViewController *VC = nil;

    if (indexPath.section == 0) {
        
        
        if (indexPath.row == 0) {
            // 学习记录
            
            JUCourseRecoderController *recoderVC = [[JUCourseRecoderController alloc]init];
            VC = recoderVC;

 
        }else if (indexPath.row == 1){
            
            //已购课程
            JUpurchaseController *purchaseVc = [[JUpurchaseController alloc]init];
            VC = purchaseVc;
         
            
        }
        
        
    }else if (indexPath.section == 1){
        
        
        if (indexPath.row == 0) {
            //购物车
            JUShoppingCarController *shoppingVC = [[JUShoppingCarController alloc]init];
            VC = shoppingVC;

        }else if (indexPath.row == 1){
            // 我的订单
            
            
            
            JUShoppingCarOrderController *myOrderVC = [[JUShoppingCarOrderController alloc]init];
            
            VC = myOrderVC;

    
        }else if(indexPath.row == 2){
            JUMyCouponViewController *myCouponVC = [[JUMyCouponViewController alloc]init];
            VC = myCouponVC;
            
        }
        
        
        
    }else if (indexPath.section == 2){
        
        
        //关于七月在线
        if (indexPath.row == 0) {
            
            JUAboutCompanyController *aboutCompanyVC = [[JUAboutCompanyController alloc]init];
            
            VC = aboutCompanyVC;
    
        }
    }
    
    if (VC) {
        [self.navigationController pushViewController:VC animated:NO];
    }
    
    
}


-(void)umengLoginStateStatic:(NSIndexPath *)indexPath{
    NSString *Value = @"";
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            Value = @"LearningRecord";
            
        }else if (indexPath.row == 1){
            
            Value = @"Course";
            
        }
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            Value = @"ShoppingCart";
            
        }else if (indexPath.row == 1){
            Value = @"Order";
            
        }else if(indexPath.row == 2){
            
            Value = @"Coupon";
            
        }
    }else if (indexPath.section == 2){
        
        if (indexPath.row == 0) {
            Value = @"About";
            
        }
        
        
    }
    
    [JUUmengStaticTool event:JUUmengStaticMine key:JUUmengParamMineLogin value:Value];
    
}



#pragma mark系统方法
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self.navigationController setNavigationBarHidden:YES];
    [self makePersonalData];
    
}



-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
    

}



@end
