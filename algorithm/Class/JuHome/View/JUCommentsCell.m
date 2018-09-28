//
//  JUCommentsCell.m
//  algorithm
//
//  Created by 周磊 on 16/11/25.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUCommentsCell.h"
#import "JUReplyCell.h"

#import "JULoginViewController.h"

#import "AppDelegate.h"
#import "JUBaseNavigationController.h"


static NSString *const replyCell = @"replyCell";

@interface JUCommentsCell ()<UITableViewDelegate, UITableViewDataSource>

{
    
    CGFloat _tableViewHeight;
}

@property(nonatomic, strong) UIImageView *avatarImv;

@property(nonatomic, strong) UILabel *nameLabel;

@property(nonatomic, strong) UILabel *contentLabel;

@property(nonatomic, strong) UILabel *add_timeLabel;

@property(nonatomic, strong) UIButton *fav_numButton;

//@property(nonatomic, strong) UILabel  *replayLabel;

@property(nonatomic, strong) UIImageView *replyImv;

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) UILabel *countLabel;

@property(nonatomic, strong) UIView *seeMoreView;

@property(nonatomic, strong) UIView *footView;

@property(nonatomic, strong) UIButton *replyButton;

@property(nonatomic, strong) YBNetManager *manager;

@end


@implementation JUCommentsCell

-(UIView *)seeMoreView{
    
    if (!_seeMoreView) {
        
        _seeMoreView = [[UIView alloc]init];
        _seeMoreView.frame = CGRectMake(0, 0, Kwidth, 30);
        
        
//        _seeMoreView.backgroundColor = [UIColor redColor];
        
        UIButton *seeMoreButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [seeMoreButton setTitle:@"查看更多>>" forState:(UIControlStateNormal)];
        
        UIColor *color = Kcolor16rgb(@"0099FF", 1);
        
        [seeMoreButton setTitleColor:color forState:(UIControlStateNormal)];
        [seeMoreButton.titleLabel setFont: UIptfont(10)];

       [seeMoreButton addTarget:self action:@selector(seeMorebuttonClicked:) forControlEvents:(UIControlEventTouchUpInside)];

       
        seeMoreButton.frame = CGRectMake(0, 7.5, 55, 15);
        

        
        [_seeMoreView addSubview:seeMoreButton];
        
        
    }
    
    
    return _seeMoreView;
  
}

-(UIView *)footView{
    
    if (_commentModel.tableViewIsOpend == YES) {
        
        return nil;
    }
    
    
    
    if (_commentModel.sortArray.count <= 2) {
        
        return nil;
    }
    
    
    return self.seeMoreView;
    
}


- (YBNetManager *)manager
{
    if (!_manager) {
        _manager = [[YBNetManager alloc]init];
    }
    return _manager;
}



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
//        self.backgroundColor = RandomColor;
        [self p_setupViews];
        
        
    }
    return self;
    
    
    
    
}

-(void)p_setupViews{
    
    UIImageView *avatarImv = [[UIImageView alloc]init];
    avatarImv.layer.cornerRadius = 16.5;
    avatarImv.layer.masksToBounds = YES;
    [self.contentView addSubview:avatarImv];
    self.avatarImv = avatarImv;
    
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.textColor = Kcolor16rgb(@"#868686", 1);
    nameLabel.font = UIptfont(12);
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;

    
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.textColor = Kcolor16rgb(@"#666666", 1);
    contentLabel.numberOfLines = 0;
    contentLabel.font = UIptfont(11);
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    
    
    
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.scrollEnabled = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[JUReplyCell class] forCellReuseIdentifier:replyCell];
    tableView.backgroundColor = Kcolor16rgb(@"F1F1F1", 1);
    
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    
    
    
    
    UILabel *add_timeLabel = [[UILabel alloc]init];
    add_timeLabel.textColor = Kcolor16rgb(@"999999", 1);
    add_timeLabel.font = UIptfont(9);
    [self.contentView addSubview:add_timeLabel];
    self.add_timeLabel = add_timeLabel;
    
   UIColor *blueColor = Kcolor16rgb(@"#0099FF", 1)
    
    UIButton *fav_numButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [fav_numButton setImage:[UIImage imageNamed:@"pinglun@zan@normal"] forState:(UIControlStateNormal)];
    [fav_numButton setImage:[UIImage imageNamed:@"pinglun@zan@pre"] forState:(UIControlStateSelected)];

    [fav_numButton setTitleColor:blueColor forState:(UIControlStateNormal)];
    [fav_numButton.titleLabel setFont:UIptfont(9)];
    [fav_numButton buttonSpaceImageWithTitle:5];
    
    
    [fav_numButton addTarget:self action:@selector(fav_numButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.contentView addSubview:fav_numButton];
    self.fav_numButton = fav_numButton;
    
    
//    UILabel *replayLabel = [[UILabel alloc]init];
//
//    replayLabel.text = @"回复";
//    replayLabel.font = UIptfont(9);
//    replayLabel.textColor = [UIColor grayColor];
//    [self.contentView addSubview:replayLabel];
//    self.replayLabel = replayLabel;
    
    UIImageView *replyImv = [[UIImageView alloc]init];
    replyImv.image = [UIImage imageNamed:@"pinglun@copy@normal"];
    
    [self.contentView addSubview:replyImv];
    
    self.replyImv = replyImv;
    
    
    
    
    UILabel *countLabel = [[UILabel alloc]init];
    countLabel.text = @"0";
    countLabel.font = UIptfont(9);
    countLabel.textColor = blueColor;
    [self.contentView addSubview:countLabel];
    self.countLabel = countLabel;
    
    


    UIButton *replyButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    
    [replyButton addTarget:self action:@selector(replybuttonClicked:) forControlEvents:(UIControlEventTouchUpInside)];

    
    [self.contentView addSubview:replyButton];
    self.replyButton = replyButton;


    UIView *seperatorLineView = [[UIView alloc]init];
    seperatorLineView.backgroundColor = Kcolor16rgb(@"DDDDDD", 1);
    
    [self.contentView addSubview:seperatorLineView];
    self.seperatorLineView = seperatorLineView;
    
    
    
}


-(void)layoutSubviews{
    [super layoutSubviews];

    [self.avatarImv mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(33, 33));
        
    }];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.avatarImv.mas_right).offset(11);
        make.centerY.equalTo(self.avatarImv.mas_centerY);
        make.height.mas_equalTo(12);
        
        make.width.mas_equalTo(150);
        
    }];



    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
 
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(6);
        make.right.mas_equalTo(-30);
    
    }];
    
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(59);
        make.right.mas_equalTo(-15);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(_tableViewHeight);
        
    }];
    
    
    
    CGFloat bootmspacing = 15;
    
    if (_tableViewHeight == 0) {
        
        bootmspacing = 10;
        
    }
    
    
    [self.add_timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(59);
        make.top.equalTo(self.tableView.mas_bottom).offset(bootmspacing);
        make.height.mas_equalTo(9);
        
    }];
    


    [self.countLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-64);
       make.centerY.equalTo(self.add_timeLabel);

        
    }];
    
//    [self.replayLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//     
//        make.right.equalTo(self.countLabel.mas_left).mas_equalTo(-5);
//        make.top.equalTo(self.add_timeLabel);
//        
//    }];
//    
    
    [self.replyImv mas_remakeConstraints:^(MASConstraintMaker *make) {
       
         make.right.equalTo(self.countLabel.mas_left).mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(12, 12));
        
        make.centerY.equalTo(self.add_timeLabel);
        
        
    }];
    
    
    
//    [self.fav_numButton setBackgroundColor:[UIColor redColor]];
    
    [self.fav_numButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.replyImv.mas_left).offset(-5);
        
        make.centerY.equalTo(self.add_timeLabel);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(32.5);
        
        
    }];
    
    
    
    [self.replyButton mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.mas_offset(0);
        make.right.equalTo(self.countLabel.mas_right).offset(10);
        
        make.size.mas_equalTo(CGSizeMake(40, 30));
        
    }];
    
    
    
//    
//    self.nameLabel.backgroundColor = [UIColor yellowColor];
//    self.contentLabel.backgroundColor = [UIColor greenColor];
//    self.avatarImv.backgroundColor =[UIColor redColor];
//    self.add_timeLabel
//    self.replyButton.backgroundColor = [UIColor greenColor];
    
    
    
//    [self.contentView colorForSubviews];
    
    [self.seperatorLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
        
        
    }];
    
}

-(void)setCommentModel:(JUCommentModel *)commentModel{
    
    _commentModel = commentModel;

    
        [self.avatarImv sd_setImageWithURL:[NSURL URLWithString:commentModel.avatar] placeholderImage:[UIImage imageNamed:@"personal_head_sign"]];
        

    
    self.nameLabel.text = commentModel.name;
    
//    self.nameLabel.text = [NSString stringWithFormat:@"%@-%.0f",commentModel.name,commentModel.CommentHeight];
    
    self.contentLabel.text = commentModel.content;
    

    
    if ([commentModel.status isEqualToString:@"1"]) {
        
        self.fav_numButton.selected = YES;
    }else{
        
        self.fav_numButton.selected = NO;
    }
    
    [self.fav_numButton setTitle:commentModel.fav_num forState:(UIControlStateNormal)];
    
    
    self.countLabel.text = [NSString stringWithFormat:@"%zd",commentModel.sortArray.count];
    
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[commentModel.add_time doubleValue]];
    self.add_timeLabel.text = [self createdate:date];
    
    self.tableView.tableFooterView = self.footView;
    
    _tableViewHeight = commentModel.tableViewHeight;
    
    [self.tableView reloadData];


}


-(NSString *)createdate:(NSDate *)createDate{
    NSDate *nowDate = [NSDate date];
    NSTimeInterval timeinterval = [nowDate timeIntervalSinceDate:createDate];
    if (timeinterval < 60) {
        return @"刚刚";
    }else if (timeinterval < 60*60){
        
        return [NSString stringWithFormat:@"%.0lf分钟前",timeinterval/60];
        
    }else if (timeinterval < 60*60*24){
        
        return [NSString stringWithFormat:@"%.0lf小时前",timeinterval/(60*60)];
        
        
    }else {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];

        [formatter setDateFormat:@"yyyy年MM月dd日"];
      
        NSString *dateString = [formatter stringFromDate:createDate];
        
        
        return dateString;
        
    
    }
    
    
    return @"";
        

    
}



#pragma mark 点击按钮

//更多
-(void)seeMorebuttonClicked:(UIButton *)button{
    
    
    if (self.seeMoreblock) {
        
        self.seeMoreblock(_commentModel.index);
    }
    
    
}

//回复


-(void)replybuttonClicked:(UIButton *)button{
    [JUUmengStaticTool event:JUUmengStaticPlayerDetail key:JUUmengParamComment value:@"Reply"];

    BOOL isLogin = [self loginAction];
    
    if (!isLogin) {
        return;
    }
    
    
    
    if (self.replyCommentBlock) {
        
        self.replyCommentBlock(_commentModel);
    }
    
}

//回复

//点赞，取消点赞

-(void)fav_numButtonClicked:(UIButton *)button{
    [JUUmengStaticTool event:JUUmengStaticPlayerDetail key:JUUmengParamComment value:@"Like"];

  BOOL isLogin = [self loginAction];
    
    if (!isLogin) {
        return;
    }
    
    NSInteger favCount = [self.commentModel.fav_num integerValue];
    
    if (button.selected) {
        
        favCount -= 1;
    }else{
        
        favCount += 1;
    }
    
    self.commentModel.fav_num = [NSString stringWithFormat:@"%zd",favCount];
    
    [button setTitle:self.commentModel.fav_num forState:(UIControlStateNormal)];
    
    button.selected = !button.selected;
    
    
    

    
    

    //先取消先前的请求
    [self.manager canceAllrequest];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",favourRUL,self.commentModel.ID];
    [self.manager GET:urlString parameters:nil headdict:JuuserInfo.headDit progress:^(NSProgress *progress) {
        
        
    } success:^(NSURLSessionDataTask *task, id responobject) {
        
        if ([[responobject[@"errno"] description] isEqualToString:@"0"]) {
            
            JULog(@"请求成功");
        }
        
 
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        JULog(@"%@", error);
        
    }];
    
  
    
}
//登录

-(BOOL)loginAction{
    if (!JuuserInfo.isLogin) {
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        JUBaseNavigationController *navc  = delegate.window.rootViewController.childViewControllers[0];
        
        
        [navc pushViewController:[[JULoginViewController alloc]init] animated:NO];
        
        return NO;
        
    }
    
    return YES;
    
}



#pragma mark tableView delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    JUReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:replyCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.commentModel = self.commentModel.sortArray[indexPath.row];
    
 
    
    

        

    
    return cell;
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.commentModel.sortArray[indexPath.row] replyHeight];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.commentModel.sortArray.count > 2 && self.commentModel.tableViewIsOpend == NO) {
        
        return 2;
    }
    
    
    
    
    return self.commentModel.sortArray.count;
}






@end
