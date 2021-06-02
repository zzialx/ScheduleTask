//
//  TaskInfoView.m
//  FormExampleDemo
//
//  Created by mwj on 2021/6/1.
//  Copyright © 2021 lx. All rights reserved.
//

#import "TaskInfoView.h"
#import "TaskInfoCell.h"
#import "PlanMeetingCell.h"
#import <Masonry.h>
#import "ScheduleViewModel.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

static NSString * infocell = @"TaskInfoCell";

static NSString * meetingcell = @"PlanMeetingCell";


@interface TaskInfoView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,assign)BOOL isShowVisitState;

@end

@implementation TaskInfoView

- (instancetype)initWithFrame:(CGRect)frame hostDate:(NSString*)hostDate{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:242.0/255 green:195.0/255 blue:121.0/255 alpha:1.0];
        
        [self uploaddataInfoWithHostDate:hostDate];
        
        [self setSubViewUI];
    }
    return  self;
}
- (void)uploaddataInfoWithHostDate:(NSString*)hostDateStr{
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];//东八区时间

    NSInteger compare =  [ScheduleViewModel timeCompare:hostDateStr];
    
    NSLog(@"=======%ld",(long)compare);
    
    if (compare==0) {
        self.isShowVisitState = YES;
    }else{
        self.isShowVisitState = NO;
    }
    
}
- (void)setSubViewUI{
    
    [self tableView];
    
}

- (UITableView*)tableView{
    if (_tableView==nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(10, 10, 10, 0));
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"TaskInfoCell" bundle:nil] forCellReuseIdentifier:infocell];
        [_tableView registerNib:[UINib nibWithNibName:@"PlanMeetingCell" bundle:nil] forCellReuseIdentifier:meetingcell];
        _tableView.backgroundColor =  [UIColor colorWithRed:242.0/255 green:195.0/255 blue:121.0/255 alpha:1.0];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell * cell ;
    if (indexPath.section==0) {
        TaskInfoCell * infoCell = [tableView dequeueReusableCellWithIdentifier:infocell];
        if (infoCell==nil) {
            infoCell = [[TaskInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:infocell];
        }
        if (indexPath.row==0) {
            infoCell.departmentNameLab.text = @"内科";
            infoCell.doctorNameLab.text = @"张三";
        }if (indexPath.row==1) {
            infoCell.departmentNameLab.text = @"外壳放射科";
            infoCell.doctorNameLab.text = @"古力娜扎";
        }if (indexPath.row==2) {
            infoCell.departmentNameLab.text = @"外壳放射科外壳放射科外壳放射科外壳放射科";
            infoCell.doctorNameLab.text = @"艾哈麦提*古力娜扎";
        }
        
        cell = infoCell;
    }if (indexPath.section==1){
        PlanMeetingCell * meetingCell = [tableView dequeueReusableCellWithIdentifier:meetingcell];
        if (meetingCell==nil) {
            meetingCell = [[PlanMeetingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:meetingcell];
        }
        cell = meetingCell;
    }
    cell.backgroundColor = [UIColor colorWithRed:242.0/255 green:195.0/255 blue:121.0/255 alpha:1.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel * nameLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,SCREEN_WIDTH-20 , 20)];
    [self addSubview:nameLab];
    nameLab.text = self.isShowVisitState?(section==0?@"实际拜访:":@"实际会议:"):(section==0?@"计划拜访:":@"计划会议:");
    nameLab.textAlignment = NSTextAlignmentLeft;
    nameLab.font = [UIFont systemFontOfSize:16];
    [nameLab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    return nameLab;
}

@end
