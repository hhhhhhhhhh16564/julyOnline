//
//  JUDateTool.h
//  七月算法_iPad
//
//  Created by 周磊 on 16/5/31.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SaveDatatool  [JUDateTool sharceInstance]
//存贮数据的工具类,每次请求的数据后就保存在这里，方便在别的页面用
@interface JUDateTool : NSObject

//bannerModel
@property(nonatomic, strong) NSMutableArray *bannerModelArray;

//categoryModel
@property(nonatomic, strong) NSMutableArray *categoryModelArray;

//保存课程的词典 key为coures_ID ,value为课程的数组
@property(nonatomic, strong) NSMutableDictionary *lessonArrayDict;

+(instancetype)sharceInstance;

//保存到沙盒
-(void)savetocaches;

//从沙盒里加载数据
-(void)loadFromCaches;

@end
