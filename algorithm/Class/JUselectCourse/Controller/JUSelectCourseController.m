//
//  JUSelectCourseController.m
//  algorithm
//
//  Created by yanbo on 17/9/21.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUSelectCourseController.h"

@interface JUSelectCourseController ()

@end

@implementation JUSelectCourseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    NSLog(@"ddddddddddddddddddddd");
 
    
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
