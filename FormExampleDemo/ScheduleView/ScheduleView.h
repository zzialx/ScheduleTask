//
//  ScheduleView.h
//  FormExampleDemo
//
//  Created by mwj on 2020/12/24.
//  Copyright © 2020 lx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleItemModel.h"

typedef enum : NSUInteger {
    TaskActionDel_Type,
    TaskActionExecute_Type,
    TaskActionEdit_Type,
    TaskActionDoctor_Type,
    TaskActionMeeting_Type
} TaskActionType;


typedef enum : NSUInteger {
    UserType_MR,
    UserType_DM,
} UserType;

NS_ASSUME_NONNULL_BEGIN

@class ScheduleView;

typedef void(^endDragAndDrop)(ScheduleView * taskView,NSInteger dragLength);

typedef void(^taskAction)(TaskActionType type);

typedef void(^longpressShowDetial)(void);

@interface ScheduleView : UIView

@property(nonatomic,strong)ScheduleItemModel * itemModel;

@property(nonatomic,assign)BOOL isLastTime;///<最后一个时间段，不允许拖拽

@property(nonatomic,assign)BOOL isCanDrag;///<DM角色不支持拖拽  MR角色允许拖拽底部按钮

@property(nonatomic,strong)NSIndexPath * indexPath;///<索引位置

@property(nonatomic,assign)BOOL isShowWeekendAdd;///<是否是显示周末添加的

@property(nonatomic,copy)endDragAndDrop endDragAndDrop;

@property(nonatomic,copy)taskAction taskAction;///<任务执行事件

@property(nonatomic,copy)longpressShowDetial longpressShowDetial;///<DM角色长按


- (instancetype)initWithFrame:(CGRect)frame userType:(UserType)userType;

@end

NS_ASSUME_NONNULL_END
