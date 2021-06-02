//
//  ScheduleViewModel.h
//  FormExampleDemo
//
//  Created by mwj on 2020/12/28.
//  Copyright © 2020 lx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScheduleItemModel.h"

NS_ASSUME_NONNULL_BEGIN

//日程vm

typedef void(^complete)(NSArray <ScheduleItemModel*> * dataSource);

typedef void(^successScheduleList)(NSArray <ScheduleItemModel*> * meetTypeList,NSArray <ScheduleItemModel*> * meetAreaList,NSArray <ScheduleItemModel*> * hpList);

typedef void(^fail)(void);

@interface ScheduleViewModel : NSObject

@property(nonatomic,assign)BOOL showWeekend;///<是否显示周末

@property(nonatomic,copy)NSString * currentStartDate;///<选择的开始日期

@property(nonatomic,copy)NSString * currentEndDate;///<选择的结束日期


/**
 获取日程静态展现数据源

 @param complete 完成
 @param fail 失败
 */
- (void)getScheduleDataSourceShowWeekend:(BOOL)showWeekend complete:(complete)complete fail:(fail)fail;



/// 获取日程首页数据
/// @param complete 完成
/// @param fail 失败
- (void)getAllMeetAndHospitalListComplete:(successScheduleList)complete fail:(fail)fail;


/// 获取日程动态数据
/// @param complete 完成
/// @param fail 失败
- (void)getAllTaskListCurrentShowStartDate:(NSString*)startDate endDate:(NSString*)endDate Complete:(complete)complete fail:(fail)fail;


/// 判断这一天是不是周末
/// @param date 日期
- (BOOL)isSelectDateWeekDay:(NSString*)date;


/// 日期转化为周几
/// @param date 日期
- (NSString *)weekdayStringWithDate:(NSString *)date;


/// 获取几天以后的数据
/// @param days 天数
/// @param startDate 开始日期
- (NSString *)computeDateWithDays:(NSInteger)days startDate:(NSString*)startDate;


/// 比较日期 0; //今天之前 1;//今天之后  2;//今天
/// @param dateStr 选择日期
+ (NSInteger)timeCompare:(NSString*)dateStr;




@end

NS_ASSUME_NONNULL_END
