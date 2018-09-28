//
//  JUCompendiumController.m
//  algorithm
//
//  Created by yanbo on 17/10/20.
//  Copyright © 2017年 Julyonline. All rights reserved.
//

#import "JUCompendiumController.h"
#import "JUCompendiumStageCell.h"
#import "JUCompendiumTitleCell.h"
#import "JUCompendiumContentCell.h"
#import "NSArray+Extension.h"
#import "JUCourseDetailViewController.h"
static NSString * const compendiumStageCell = @"compendiumStageCell";
static NSString * const compendiumTitleCell = @"compendiumTitleCell";
static NSString * const compendiumContentCell = @"compendiumContentCell";



@interface JUCompendiumController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) NSMutableArray *mainDataArray;

@property(nonatomic, strong) NSString *first_video_ID;

@end

@implementation JUCompendiumController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setup_subViews];
    
//    self.view.backgroundColor = [UIColor redColor];
//    self.mainTableView.backgroundColor = [UIColor blueColor];
    
}

-(void)setup_subViews{
    
    UIView *conentView = [[UIView alloc]init];
    conentView.frame = self.view.bounds;
    [self.view addSubview:conentView];
    self.contentView = conentView;
    
    UITableView *mainTableView = [[UITableView alloc]init];
    mainTableView.frame = self.contentView.bounds;
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:mainTableView];
    self.mainTableView = mainTableView;
    
    [self.mainTableView registerClass:[JUCompendiumStageCell class] forCellReuseIdentifier:compendiumStageCell];
    [self.mainTableView registerClass:[JUCompendiumTitleCell class] forCellReuseIdentifier:compendiumTitleCell];
    [self.mainTableView registerClass:[JUCompendiumContentCell class] forCellReuseIdentifier:compendiumContentCell];

    
    
//
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#(nonnull NSString *)#> forIndexPath:indexPath];
    
    
}


-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    

    self.contentView.frame = self.view.bounds;
    self.mainTableView.frame = self.contentView.bounds;
    
}





-(void)setSourceArray:(NSArray *)sourceArray{
    
    self.mainDataArray = [NSMutableArray array];
    self.first_video_ID = nil;
    NSMutableArray *dataArray = [sourceArray mutableArrayDeeoCopy];
    
    
    for (int i = 0; i < dataArray.count; i++) {
        
        NSMutableDictionary *dict1 = dataArray[i];
        
        
        NSString *stageValue = dict1[@"stage_name"];
        
        if (!stageValue) {
            stageValue = @"";
        }

        //如果stageVAlue没有值，就不需要添加
        if ([stageValue length]) {
            
            stageValue = [NSString stringWithFormat:@"  %@",stageValue];
            JUCompentDiumModel *compentdiuModel = [[JUCompentDiumModel alloc]init];
            compentdiuModel.content = stageValue;
            compentdiuModel.type = compentDiumModelTypeStage;
            compentdiuModel.contentHeigth = 32;
            [self.mainDataArray addObject:compentdiuModel];
        }
        
        NSMutableArray *lessonArray = dict1[@"lesson"];

        for (int i = 0; i < lessonArray.count; i++) {
            
            NSMutableDictionary *dict2 = lessonArray[i];
            
            
//            第9课 增强学习与Deep Q Network 绿色的文字
            NSString *nameValue = dict2[@"name"];
            if (!nameValue) {
                nameValue = @"";
            }

            
            nameValue = [NSString stringWithFormat:@"%@", nameValue];
                         // 12+10+12
            CGFloat MaxWidth = Kwidth-34;
            
            
            //如果videoID是不是0的话，要显示播放按钮， 显示播放按钮，文字的宽度要减少35
            if (![[dict2[@"video_id"] description] isEqualToString:@"0"]) {

                MaxWidth -= 35;
            }
            
            
            
            CGFloat contentHeight = [nameValue sizeWithFont:UIptfont(13) maxW:MaxWidth].height;
            
            if (contentHeight < 33) {
                contentHeight = 33;
            }
            
            JUCompentDiumModel *compentdiuModel = [[JUCompentDiumModel alloc]init];
            compentdiuModel.content = nameValue;
            compentdiuModel.type = compentDiumModelTypeTitle;
            compentdiuModel.video_id = [dict2[@"video_id"] description];
            
            if (!self.first_video_ID) {
                self.first_video_ID = compentdiuModel.video_id;
            }
            
        
            compentdiuModel.contentHeigth = contentHeight;
            compentdiuModel.MaxWidth = MaxWidth;
            

            [self.mainDataArray addObject:compentdiuModel];

            NSMutableArray *pointArray = dict2[@"point"];
            for (int i = 0; i < pointArray.count; i++) {
               
                NSMutableDictionary *dict3 = pointArray[i];
                
                NSString *nameValue  = dict3[@"name"];
                if (!nameValue) {
                    nameValue = @"";
                }
                nameValue = [NSString stringWithFormat:@":%@",nameValue];
                
                NSString *type = [dict3[@"type"] description];
                
                JUCompentDiumModel *compentdiuModel = [[JUCompentDiumModel alloc]init];

                
                //拼接实战项目                     //拼接知识点i

                if ([type isEqualToString:@"1"]) {
                    nameValue = [NSString stringWithFormat:@"知识点%d  %@",i+1, nameValue];
                }else {
                 compentdiuModel.redContent = @"实战项目  ";
                }
                
                compentdiuModel.content = nameValue;
                compentdiuModel.type = compentDiumModelTypeContent;
                compentdiuModel.contentHeigth = 22;

                [self.mainDataArray addObject:compentdiuModel];

            }
            
        }
        
    }
 
        
        
        
    [self.mainTableView reloadData];
    
//    JULog(@"%zd", self.mainDataArray.count);
    
    
}


-(BOOL)isWached{
    
    if (self.first_video_ID && [self.first_video_ID isEqualToString:@"0"]) {
        
        return NO;
        
    }
    
    
    return YES;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    JUCompentDiumModel *diumModel = self.mainDataArray[indexPath.row];
    
    if (diumModel.type == compentDiumModelTypeStage) {
        JUCompendiumStageCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:compendiumStageCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.CompentDiumModel = diumModel;
        
        return cell;
        
    }else if (diumModel.type == compentDiumModelTypeTitle){
        
        JUCompendiumTitleCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:compendiumTitleCell forIndexPath:indexPath];
        
        if ([self.liveModel.is_baoming integerValue]) {
            
            cell.imv.hidden = NO;
            
        }else{
            cell.imv.hidden = YES;
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.CompentDiumModel = diumModel;

        return cell;

    }else if (diumModel.type == compentDiumModelTypeContent){
        
        JUCompendiumContentCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:compendiumContentCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.CompentDiumModel = diumModel;

        return cell;

    }
    
    return nil;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JUCompentDiumModel *diumModel = self.mainDataArray[indexPath.row];
    
    
    if (diumModel.type == compentDiumModelTypeTitle) {
        
        return diumModel.contentHeigth+12;
    }

    return diumModel.contentHeigth;
    
 
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    

    return self.mainDataArray.count;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JUCompentDiumModel *diumModel = self.mainDataArray[indexPath.row];

    if (diumModel.type == compentDiumModelTypeTitle && ![diumModel.video_id isEqualToString:@"0"]) {
        
//        JULog(@"可以播放");
//     
//        JUCourseDetailViewController *detailVC = [[JUCourseDetailViewController alloc]init];
//         detailVC.isAutoPlay = YES;
//        JULessonModel *lessonModel = [[JULessonModel alloc]init];
//        lessonModel.course_id = self.liveModel.course_id;
//        
//        lessonModel.ID = diumModel.video_id;
//        
//        
//        detailVC.lessonModel = lessonModel;
//        
//        detailVC.course_id = self.liveModel.course_id;;
//        
//        JULog(@"%@ ", diumModel.video_id);
//        
//        
//        [self.navigationController pushViewController:detailVC animated:NO];
        
        if ([self.delegate respondsToSelector:@selector(CompendiumController:DidClickPlayButton:)]) {
            
            [self.delegate CompendiumController:self DidClickPlayButton:diumModel];
            
        }
        
        
        
    }
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
