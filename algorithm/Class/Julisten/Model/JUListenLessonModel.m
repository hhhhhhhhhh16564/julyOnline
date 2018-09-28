//
//  JUListenLessonModel.m
//  algorithm
//
//  Created by 周磊 on 16/12/1.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUListenLessonModel.h"

@implementation JUListenLessonModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    
    
    return @{
           
             @"ID" : @"id"
           
            };

}





-(NSString *)teacher{
    
    NSArray *array = @[@"寒小阳", @"龙心尘", @"李伟", @"邓毅", @"梁云志", @"魏璇", @"梅晨航", @"吴彦东", @"李克林", @"杨凤", @"王亚琴", @"孙斐瑾", @"邹博"];
    int index = arc4random() % 13;
    
    
    
    
    if (!_teacher) {
        
        _teacher = array[index];
    }
    return _teacher;
}


-(CGFloat)totalTime{
    
    if (_totalTime == 0) {
        
        NSArray *array = [_duration componentsSeparatedByString:@":"];
        
        if (array.count == 2) {
            
            _totalTime = [array[0] intValue]*60+[array[1] intValue];
            
        }else{
            
            _totalTime = [array[0] integerValue] * 3600 + [array[1] intValue]*60+[array[2] intValue];
            
        }
        
        
        
        
    }
    
    return _totalTime;
    
}





@end
