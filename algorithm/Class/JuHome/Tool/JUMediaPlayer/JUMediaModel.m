//
//  JUMediaModel.m
//  algorithm
//
//  Created by 周磊 on 17/2/23.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUMediaModel.h"

@implementation JUMediaModel

-(NSTimeInterval)beginTime{
    if (_beginTime < 0) {
        _beginTime = 0;
    }
    return _beginTime;
}
-(BOOL)isM3u8File{
    
    return [[self.VideoURL description] containsString:@"m3u8"] || [[self.VideoURL description] containsString:@"M3U8"];
    
}



@end
