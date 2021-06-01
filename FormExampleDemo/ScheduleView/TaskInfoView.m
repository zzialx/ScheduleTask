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

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

static NSString * infocell = @"TaskInfoCell";

static NSString * meetingcell = @"PlanMeetingCell";


@interface TaskInfoView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UILabel * visitLab;///<拜访项

@property(nonatomic,strong)UILabel * meetLab;///<会议项

@property(nonatomic,strong)UITableView * tableView;

@end

@implementation TaskInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:242.0/255 green:195.0/255 blue:121.0/255 alpha:1.0];
        
        [self setSubViewUI];
    }
    return  self;
}

- (void)setSubViewUI{
    [self tableView];
}

- (UITableView*)tableView{
    if (_tableView==nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
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

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel * nameLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,SCREEN_WIDTH-20 , 20)];
    [self addSubview:nameLab];
    nameLab.text = section==0?@"计划拜访:":@"计划会议:";
    nameLab.textAlignment = NSTextAlignmentLeft;
    nameLab.font = [UIFont systemFontOfSize:16];
    [nameLab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    return nameLab;
}
- (UILabel*)visitLab{
    if (_visitLab==nil) {
        _visitLab = [[UILabel alloc]initWithFrame:CGRectZero];
        [self addSubview:_visitLab];
        [_visitLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(20);
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.height.mas_equalTo(20);
        }];
        _visitLab.text = @"计划拜访:";
        _visitLab.textAlignment = NSTextAlignmentLeft;
        _visitLab.font = [UIFont systemFontOfSize:16];
    }
    return _visitLab;
}

@end
