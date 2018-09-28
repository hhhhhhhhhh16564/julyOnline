//
//  JUTeacherListViewController.h
//  七月算法_iPad
//
//  Created by pro on 16/6/2.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUBaseTableViewController.h"

@interface JUTeacherListViewController : JUBaseTableViewController
@property(nonatomic, strong) NSMutableArray *teacherListArray;

-(void)setHeadViewWithSimpleDescription:(NSString *)simpleDescription;

@end
