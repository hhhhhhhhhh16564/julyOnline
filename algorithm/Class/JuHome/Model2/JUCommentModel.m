//
//  JUCommentModel.m
//  algorithm
//
//  Created by 周磊 on 16/11/25.
//  Copyright © 2016年 Julyonline. All rights reserved.
//

#import "JUCommentModel.h"

@implementation JUCommentModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
        
        @"ID" : @"id"
        
        
            };
    
    
}

+(NSDictionary *)mj_objectClassInArray{
    
    
    return @{
             
             @"reply" : @"JUCommentModel"
             
            };
}


-(NSString *)replyjoinContent{
    
    
    return [NSString stringWithFormat:@"%@回复%@: %@", self.name, self.replyToName,self.content];
    
    
}


-(NSString *)name{
    
    if (![_name length]) {
        
        _name = @"匿名用户";
    }
    
    return _name;
}


-(NSString *)replyToName{
    
    if (![_replyToName length]) {
        
        _replyToName = @"匿名用户";
    }
    
    return _replyToName;
    
}




-(NSMutableAttributedString *)artibutedString{
    
    NSMutableAttributedString *arrtibuedstring = [[NSMutableAttributedString alloc]initWithString:self.replyjoinContent];
    
    
    
    UIColor *color = Kcolor16rgb(@"0099FF", 1);
    
    UIColor *grayColor = Kcolor16rgb(@"#999999", 1);

    
    NSString *userString = [NSString stringWithFormat:@"%@", self.name];
    
    NSRange nameRange = [userString rangeOfString:userString];
    
    NSString *replyToName = self.replyToName;
    
    NSRange toNameSearchRange = NSMakeRange(nameRange.length, [self.replyjoinContent length]-nameRange.length);

    NSRange toNameRange = [self.replyjoinContent rangeOfString:replyToName options:0 range:toNameSearchRange];
    

    
    [arrtibuedstring addAttribute:NSForegroundColorAttributeName value:grayColor range:NSMakeRange(0, [arrtibuedstring length])];
    
    //用户名
    [arrtibuedstring setAttributes:@{NSForegroundColorAttributeName : color} range:nameRange];
    
    //回复名
    [arrtibuedstring setAttributes:@{NSForegroundColorAttributeName : color} range:toNameRange];

    
    
    //设置行高 行间距
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    
//    paragraphStyle.minimumLineHeight = 21;
//    paragraphStyle.maximumLineHeight = 21;
//    
//    NSRange range = NSMakeRange(0, [arrtibuedstring length]);
//    
//    [arrtibuedstring addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    
    
    
    
    return arrtibuedstring;
    
}



-(NSMutableArray *)sortArray{

    
    _sortArray = [NSMutableArray array];
    
    
    [self getAllCommentModelInComment:self];

    
    return _sortArray;
}


-(void)getAllCommentModelInComment:(JUCommentModel *)commentModel{
    
    
    if ([commentModel.reply count]) {
        
        [commentModel.reply enumerateObjectsUsingBlock:^(JUCommentModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            obj.replyToName = commentModel.name;
            
            [_sortArray addObject:obj];
            
            [self getAllCommentModelInComment:obj];
            
        }];
        

    }

    
}





-(void)setTableViewIsOpend:(BOOL)tableViewIsOpend{
    
    _tableViewIsOpend = tableViewIsOpend;
    
    //清空tableView的高度，重新计算
    
    if (self.sortArray.count > 2) {
        self.tableViewHeight = 0;
        
    }

}

-(CGFloat)replyHeight{
    
    if (_replyHeight) return _replyHeight;
    
    _replyHeight = 0;
    // 内容高度
//   CGSize size = [self.replyjoinContent sizeWithFont:UIptfont(10) maxW:Kwidth-59-15-49-5];
    
    //顶部
    _replyHeight += 6;
    //
    
    CGRect rect = [self.artibutedString boundingRectWithSize:CGSizeMake(Kwidth-59-15-49-5, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    _replyHeight += rect.size.height;
    
    
    // 底部距离
    _replyHeight += 6;
    
    
    return _replyHeight;
    
}

 

-(CGFloat)tableViewHeight{
    
    //显示的个数为2个
    
  
    
    
    if (![self.sortArray count]) return 0;
    

    
    
    _tableViewHeight = 0;
    


      NSUInteger showCount = 2;

    if (self.sortArray.count <= showCount) {
        
        [self.sortArray enumerateObjectsUsingBlock:^(JUCommentModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            _tableViewHeight += obj.replyHeight;

        }];


    }else{
        
        
        if (_tableViewIsOpend == YES) {
            
            [self.sortArray enumerateObjectsUsingBlock:^(JUCommentModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                _tableViewHeight += obj.replyHeight;
                
            }];
            
        }else{
            
            [self.sortArray enumerateObjectsUsingBlock:^(JUCommentModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                _tableViewHeight += obj.replyHeight;
                
                if (idx == showCount-1) {
                    
                    *stop = YES;
                }
                
                
            }];

            
            
            //计算查看更多和底部的高度
            
            _tableViewHeight += 30;
            
            
        }
        
    }
    
    return _tableViewHeight;
    
}




-(CGFloat)CommentHeight{
    //顶部间距
    _CommentHeight = 5;
    
    //nameLabel底部
    _CommentHeight = _CommentHeight+16.5+6;
    
    
    
    
    //contentLabel底部
    CGSize size = [self.content sizeWithFont:UIptfont(11) maxW:Kwidth-89];
    
    _CommentHeight = _CommentHeight+size.height+5;
    
    
    //tableview顶部
    _CommentHeight += 5;
    
    //时间label的顶部 = tableview的高度 + 间距
    
    CGFloat tablviewHeight = self.tableViewHeight;
    
    
    if (tablviewHeight) {
        
        _CommentHeight = _CommentHeight + tablviewHeight+15;

        
    }else{
        _CommentHeight = _CommentHeight + tablviewHeight+10;

        
    }
    
    
    
    
    //时间label底部
    
    _CommentHeight = _CommentHeight+9;
    
    
    //cell的高度
    _CommentHeight += 10;
    
    
    return _CommentHeight;
    
    
    
    
}









@end
