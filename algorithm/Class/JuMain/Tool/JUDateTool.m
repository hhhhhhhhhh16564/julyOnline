//
//  JUDateTool.m
//  七月算法_iPad
//
//  Created by 周磊 on 16/5/31.
//  Copyright © 2016年 zhl. All rights reserved.
//

#import "JUDateTool.h"
#define KcategoryModelArray @"categoryModelArray"
#define KbannerModelArray @"bannerModelArray"
#define courseDict @"lessonArrayDict"
@interface JUDateTool ()
@property(nonatomic, strong) NSString *cachespath;

@end

@implementation JUDateTool

+(instancetype)sharceInstance{
    
    static dispatch_once_t onceToken;
    static JUDateTool *datatool = nil;
    dispatch_once(&onceToken, ^{
        
        datatool = [[JUDateTool alloc]init];
        
       
    });
    
    return datatool;
    
}

-(NSString *)cachespath{
    
    NSString *caches = NSSearchPathForDirectoriesInDomains(algorithmDowonloadMediaCachPath, NSUserDomainMask, YES)[0];
    
    //随便拼接一个东西
    NSString *cachespath = [caches stringByAppendingPathComponent:@"mydatatool23472"];
    
    
    return cachespath;
    
}



-(void)savetocaches{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.categoryModelArray) {
        dic[KcategoryModelArray] = self.categoryModelArray;
 
    }
    
    if (self.bannerModelArray) {
        dic[KbannerModelArray] = self.bannerModelArray;

    }
    
    if (self.lessonArrayDict) {
        dic[courseDict] = self.lessonArrayDict;
    }
    

    [NSKeyedArchiver archiveRootObject:dic toFile:self.cachespath];
    
}

-(void)loadFromCaches{
    

    
        
        NSMutableDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithFile:self.cachespath];
        
        if (dic) {
            
            self.categoryModelArray = dic[KcategoryModelArray];
            self.bannerModelArray = dic[KbannerModelArray];
            self.lessonArrayDict = dic[courseDict];
           
        }
 
}

-(NSMutableArray *)categoryModelArray{
    
    if (_categoryModelArray == nil) {
        _categoryModelArray = [NSMutableArray array];
    }
    
    return _categoryModelArray;
}


-(NSMutableDictionary *)lessonArrayDict{
    
    if (_lessonArrayDict == nil) {
        _lessonArrayDict = [NSMutableDictionary dictionary];
    }
    
    return _lessonArrayDict;
}

-(NSMutableArray *)bannerModelArray {
    
    if (_bannerModelArray  == nil) {
        _bannerModelArray = [NSMutableArray array];
    }
    
    return _bannerModelArray ;
}



@end
