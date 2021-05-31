//
//  ItemModel.h
//  FormExampleDemo
//
//  Created by mwj on 2020/12/24.
//  Copyright © 2020 lx. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    TaskType_NeiBu,
    TaskType_Area,
    TaskType_VistiMeeting,
} TaskType;


NS_ASSUME_NONNULL_BEGIN

@interface ScheduleItemModel : NSObject

@property(nonatomic,assign)NSInteger horizontalAxis;///<横轴索引

@property(nonatomic,assign)NSInteger verticalAxis;///<纵向索引

@property(nonatomic,assign)NSInteger timeLength;///<时长

@property(nonatomic,assign)BOOL isWeekDay;///<是否是周末

@property(nonatomic,strong)NSString * name;///<日程名字

@property(nonatomic,strong)NSString * starttime;///<开始时间  8：30

@property(nonatomic,strong)NSString * endtime;///<结束时间  10：30

@property(nonatomic,strong)NSString * hostDate;///<日期  2021-05-26

@property(nonatomic,strong)NSIndexPath * indexPath;///<任务的索引

@property(nonatomic,assign)TaskType taskType;///<任务类型

@end

NS_ASSUME_NONNULL_END
