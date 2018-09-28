//
//  JUAboutCompanyController.m
//  algorithm
//
//  Created by 周磊 on 17/1/18.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUAboutCompanyController.h"

@interface JUAboutCompanyController ()

@property(nonatomic, strong) UIImageView *backImv;


@end

@implementation JUAboutCompanyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup_subViews];
    
    self.navigationItem.title = @"关于";
    
}

-(void)setup_subViews{
    
    UIImageView *backImv = [[UIImageView alloc]init];
    backImv.frame = CGRectMake(0, 64, Kwidth, Kheight-64);
    UIImage *sourceImage = [UIImage imageNamed:@"guanyu@bj"];
    backImv.image = sourceImage;
    [self.view addSubview:backImv];
     self.backImv = backImv;
    
    
    
    UIImageView *iconImv = [[UIImageView alloc]init];
    iconImv.frame = CGRectMake(0, 80, 84, 84);
    iconImv.image = [UIImage imageNamed:@"LOGO@gaunyu"];
    [self.backImv addSubview:iconImv];
    [iconImv X_centerInSuperView];
    
    
    
    UILabel *introducelabel = [[UILabel alloc]init];
    [self.backImv addSubview:introducelabel];
    [self labelDescribe:introducelabel];
    introducelabel.font = UIptfont(18);
    introducelabel.y_extension = iconImv.bottom_extension+28;
    introducelabel.height_extension = 18;
     introducelabel.text = @"国内领先的人工智能教育平台";
    
    
    
    
    
    
    UILabel *urlLable = [[UILabel alloc]init];
    [self.backImv addSubview:urlLable];
    [self labelDescribe:urlLable];
    urlLable.text = @"官网:http://www.julyedu.com";
    urlLable.y_extension = introducelabel.bottom_extension+9;
    
    
    
    UILabel *commpanyLable = [[UILabel alloc]init];
    [self.backImv addSubview:commpanyLable];
    [self labelDescribe:commpanyLable];
     commpanyLable.text = @"北京七月在线科技有限公司";
     commpanyLable.bottom_extension = Kheight-64-69;
    

    
    UILabel *versionLabel = [[UILabel alloc]init];
    [self.backImv addSubview:versionLabel];
    [self labelDescribe:versionLabel];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    versionLabel.text = [NSString stringWithFormat:@"V%@",appVersion];
    versionLabel.bottom_extension = commpanyLable.y_extension-8;
}


-(void)labelDescribe:(UILabel *)label{
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = UIptfont(14);

    label.frame = CGRectMake(0, 0, Kwidth, 15);
    [label X_centerInSuperView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}























@end
