//
//  JUCategoryModel.h
//  七月算法_iPad
//
//  Created by 周磊 on 16/5/31.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUModel.h"
#import "JUCoursesModel.h"

@interface JUCategoryModel : JUModel

@property(nonatomic, strong) NSString *cat_id;
@property(nonatomic, strong) NSString *cat_name;
@property(nonatomic, strong) NSArray<JUCoursesModel *> *courses;



@end
