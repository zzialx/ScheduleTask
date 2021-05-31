//
//  HspTaskSceduleView.m
//  FormExampleDemo
//
//  Created by mwj on 2020/12/30.
//  Copyright © 2020 lx. All rights reserved.
//

#import "HspTaskSceduleView.h"
#import "ScheduleItemModel.h"
#import "TaskView.h"
#import "ScheduleViewModel.h"

#define WSWeakSelf(type)     __weak __typeof__(type) weakSelf = self;
#define WSStrongSelf(type)  __strong __typeof(type) type = weak##type;

#define meettypekey  @"meetType"
#define meetareakey  @"meetarea"
#define meethpkey    @"meethp"

@interface HspTaskSceduleView ()

@property(nonatomic,strong)NSMutableDictionary * dataDic;///<数据源

@property(nonatomic,strong)TaskView * meetingView;///<会议类型view

@property(nonatomic,strong)TaskView * areaMeetView;///<会议区域view

@property(nonatomic,strong)TaskView * hospitalListView;///<医院列表view

@property(nonatomic,strong)UIView * line;

@property(nonatomic,strong)ScheduleViewModel * vm;

@end


@implementation HspTaskSceduleView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self getTaskList];
        [self meetingView];
        [self areaMeetView];
        [self line];
        [self hospitalListView];
    }
    return self;
}
- (UIView*)line{
    if (_line == nil) {
        _line = [[UIView alloc]initWithFrame:CGRectMake(195.5, 0, 1, self.frame.size.height)];
        _line.backgroundColor = UIColor.blackColor;
        [self addSubview:_line];
    }
    return _line;
}

- (TaskView*)meetingView{
    if (_meetingView==nil) {
        _meetingView = [[TaskView alloc]initWithFrame:CGRectMake(10, 0, 80, self.frame.size.height) withTaskList:self.dataDic[meettypekey] viewType:TaskViewTypeLeft];
        _meetingView.backgroundColor = UIColor.whiteColor;
        [self addSubview:_meetingView];
        WSWeakSelf(self);
        _meetingView.longPressDragCellEnd = ^(UILongPressGestureRecognizer * _Nonnull recognizer, ScheduleItemModel * _Nonnull item) {
            if (weakSelf.longPressEnd) {
                weakSelf.longPressEnd(recognizer, item);
            }
        };
    }
    return _meetingView;
}
- (TaskView*)areaMeetView{
    if (_areaMeetView==nil) {
        _areaMeetView = [[TaskView alloc]initWithFrame:CGRectMake(100, 0, 80, self.frame.size.height) withTaskList:self.dataDic[meetareakey] viewType:TaskViewTypeLeft];
        _areaMeetView.backgroundColor = UIColor.whiteColor;
        [self addSubview:_areaMeetView];
        WSWeakSelf(self);
        _areaMeetView.longPressDragCellEnd = ^(UILongPressGestureRecognizer * _Nonnull recognizer, ScheduleItemModel * _Nonnull item) {
            if (weakSelf.longPressEnd) {
                weakSelf.longPressEnd(recognizer, item);
            }
        };
    }
    return _areaMeetView;
}
- (TaskView*)hospitalListView{
    if (_hospitalListView==nil) {
        _hospitalListView = [[TaskView alloc]initWithFrame:CGRectMake(210, 0, self.frame.size.width-210-60, self.frame.size.height) withTaskList:self.dataDic[meethpkey] viewType:TaskViewTypeRight];
        [self addSubview:_hospitalListView];
        WSWeakSelf(self);
        _hospitalListView.longPressDragCellEnd = ^(UILongPressGestureRecognizer * _Nonnull recognizer, ScheduleItemModel * _Nonnull item) {
            if (weakSelf.longPressEnd) {
                weakSelf.longPressEnd(recognizer, item);
            }
        };
    }
    return _hospitalListView;
}

- (void)getTaskList{
    self.dataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    WSWeakSelf(self);
    [self.vm getAllMeetAndHospitalListComplete:^(NSArray<ScheduleItemModel *> * _Nonnull meetTypeList, NSArray<ScheduleItemModel *> * _Nonnull meetAreaList, NSArray<ScheduleItemModel *> * _Nonnull hpList) {
        [weakSelf.dataDic setObject:meetTypeList forKey:meettypekey];
        [weakSelf.dataDic setObject:hpList forKey:meetareakey];
        [weakSelf.dataDic setObject:meetTypeList forKey:meethpkey];
        weakSelf.meetingView.taskArray = meetTypeList;
        weakSelf.areaMeetView.taskArray = meetAreaList;
        weakSelf.hospitalListView.taskArray = hpList;
        } fail:^{
            
        }];

    
}
- (ScheduleViewModel*)vm{
    if (_vm==nil) {
        _vm = [[ScheduleViewModel alloc]init];
    }
    return _vm;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
