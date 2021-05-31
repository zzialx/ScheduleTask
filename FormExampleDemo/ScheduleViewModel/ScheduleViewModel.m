//
//  ScheduleViewModel.m
//  FormExampleDemo
//
//  Created by mwj on 2020/12/28.
//  Copyright © 2020 lx. All rights reserved.
//

#import "ScheduleViewModel.h"
#import <UIKit/UIKit.h>
@interface ScheduleViewModel ()

@end


@implementation ScheduleViewModel


- (void)getScheduleDataSourceShowWeekend:(BOOL)showWeekend complete:(complete)complete fail:(fail)fail{
    NSMutableArray * scheduleList = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 8; i < 40; i ++) {
        if (showWeekend) {
            for (int j = 0; j < 8; j++) {
                ScheduleItemModel * model = [[ScheduleItemModel alloc]init];
                model.horizontalAxis = j;
                model.verticalAxis = i;
                if (j==0) {
                    NSString * time = [NSString stringWithFormat:@"%d:00",8];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"HH:mm"];
                    NSDate *timeDate = [dateFormatter dateFromString:time];
                    NSTimeInterval millisecond = [timeDate timeIntervalSince1970] * 1000;
                    millisecond = millisecond + 30 * 60 * 1000 * (i - 8);
                    NSString * showtime =  [dateFormatter stringFromDate:[[NSDate alloc]initWithTimeIntervalSince1970:millisecond/1000.0]];
                    model.name = showtime;
                    if (j==1||j==7) {
                        model.isWeekDay = YES;
                    }
                }else{
                    model.name = [NSString stringWithFormat:@""];
                }
                [scheduleList addObject:model];
            }
        }else{
            for (int j = 0; j < 6; j++) {
                ScheduleItemModel * model = [[ScheduleItemModel alloc]init];
                model.horizontalAxis = j;
                model.verticalAxis = i;
                if (j==0) {
                    NSString * time = [NSString stringWithFormat:@"%d:00",8];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"HH:mm"];
                    NSDate *timeDate = [dateFormatter dateFromString:time];
                    NSTimeInterval millisecond = [timeDate timeIntervalSince1970] * 1000;
                    millisecond = millisecond + 30 * 60 * 1000 * (i - 8);
                    NSString * showtime =  [dateFormatter stringFromDate:[[NSDate alloc]initWithTimeIntervalSince1970:millisecond/1000.0]];
                    model.name = showtime;
                    model.isWeekDay = NO;
                }else{
                    model.name = [NSString stringWithFormat:@""];
                }
                [scheduleList addObject:model];
            }
        }
        
    }
    if (scheduleList.count>0) {
        if (complete) complete(scheduleList);
    }else{
        if (fail)fail();
    }
}

- (void)getAllMeetAndHospitalListComplete:(successScheduleList)complete fail:(fail)fail{
    NSMutableArray * section_one_arrary =[NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i<2; i++) {
        ScheduleItemModel * model = [[ScheduleItemModel alloc]init];
        model.name = [NSString stringWithFormat:@"培训%d",i];
        [section_one_arrary addObject:model];
        model.taskType = TaskType_NeiBu;
        
    }
    
    NSMutableArray * section_three_array = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<15; i++) {
        ScheduleItemModel * model = [[ScheduleItemModel alloc]init];
        model.name = [NSString stringWithFormat:@"北京市口腔医院北京市口腔医院北京市%d",i];
        [section_three_array addObject:model];
        model.taskType = TaskType_VistiMeeting;
    }
    
    NSMutableArray * section_two_array = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<5; i++) {
        ScheduleItemModel * model = [[ScheduleItemModel alloc]init];
        model.name = [NSString stringWithFormat:@"全国会%d",i];
        [section_two_array addObject:model];
        model.taskType = TaskType_Area;
    }
    
    if (section_two_array.count>0) {
        if (complete) complete(section_one_arrary,section_two_array,section_three_array);
    }else{
        if (fail)fail();
    }
    
}

- (void)getAllTaskListCurrentShowStartDate:(NSString*)startDate endDate:(NSString*)endDate Complete:(complete)complete fail:(fail)fail{
    NSLog(@"获取开始日期：%@-----结束日期：%@",startDate,endDate);
    NSMutableArray * taskList = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 4; i < 6; i++) {
        ScheduleItemModel * model = [[ScheduleItemModel alloc]init];
        model.name = @"内部会";
        model.starttime = @"12:00";
        model.endtime = @"14:00";
//        NSLog(@"计算时长=====%ld",(long)[self getTimeLengthWithStartTime:model.starttime endTime:model.endtime]);
        model.timeLength =  [self getTimeLengthWithStartTime:model.starttime endTime:model.endtime];
        model.taskType = TaskType_NeiBu;
        model.hostDate = [NSString stringWithFormat: @"2021-05-2%d",i];
        model.isWeekDay = [self isSelectDateWeekDay:[self weekdayStringWithDate:model.hostDate]];
    
        //计算出来时间段的索引
        
//        if ([startDate isEqualToString:@"2021-05-23"]&&[endDate isEqualToString:@"2021-05-29"]) {
            //周末要显示的索引计算,横向索引
            NSInteger startLongitudinalIndex = [self getShowTaskDateLongitudinalIndexWithTaskDate:model.hostDate startDate:startDate showWeekend:YES];
            //要显示的索引计算,纵向索引
            NSInteger startTransverseIndex = [self getShowTaskDateTransverseIndexStartTime:model.starttime showWeekend:YES];
            
            NSLog(@"横向索引====%ld",(long)startLongitudinalIndex);
            
            NSLog(@"纵向索引====%ld",(long)startTransverseIndex/8);
        if (startLongitudinalIndex>0&&startTransverseIndex>0) {
            
            NSInteger item = startLongitudinalIndex + startTransverseIndex;
            
            model.indexPath = [NSIndexPath indexPathForItem:item inSection:0];
            
            [taskList addObject:model];
        }
            
            
//        }
//        if ([startDate isEqualToString:@"2021-05-24"]&&[endDate isEqualToString:@"2021-05-28"]) {
//            //周末不显示的索引计算
//            NSInteger startLongitudinalIndex = [self getShowTaskDateLongitudinalIndexWithTaskDate:model.hostDate startDate:@"2021-05-24" showWeekend:YES];
//            //要显示的索引计算,纵向索引
//            NSInteger satrtTransverseIndex = [self getShowTaskDateTransverseIndexStartTime:model.starttime showWeekend:NO];
//
//            NSLog(@"横向索引====%ld",(long)startLongitudinalIndex);
//
//            NSLog(@"纵向索引====%ld",(long)satrtTransverseIndex/6);
//
//            NSInteger item = startLongitudinalIndex + satrtTransverseIndex;
//
//            model.indexPath = [NSIndexPath indexPathForItem:item inSection:0];
//        }
        
        
    }
    if (taskList.count>0) {
        if (complete) complete(taskList);
    }else{
        if (fail)fail();
    }
    
}

/// 获取任务的横向索引
- (NSInteger)getShowTaskDateLongitudinalIndexWithTaskDate:(NSString*)taskDate startDate:(NSString*)startDate showWeekend:(BOOL)showWeekend{
    
    NSInteger longitudinalIndex = 0;
    
    NSMutableArray * showWeekendDateList = [NSMutableArray arrayWithCapacity:8];
    
    [showWeekendDateList addObject:@""];
    
    NSMutableArray * noShowWeekendDateList = [NSMutableArray arrayWithCapacity:6];
    
    [noShowWeekendDateList addObject:@""];
    
    if (showWeekend) {
        
        for (int i = 0; i < 7; i++) {
            
            [showWeekendDateList addObject:[self computeDateWithDays:i startDate:startDate]];
            
        }
        if ([showWeekendDateList containsObject:taskDate]) {
            
            longitudinalIndex = [showWeekendDateList indexOfObject:taskDate];
            
        }else{
            
            longitudinalIndex = -1;
        }
        
        
    }else{
        
        for (int i = 1; i < 5; i++) {
            
            [noShowWeekendDateList addObject:[self computeDateWithDays:i startDate:startDate]];
            
        }
        
        if ([showWeekendDateList containsObject:taskDate]) {
            
            longitudinalIndex = [showWeekendDateList indexOfObject:taskDate];
            
        }else{
            
            longitudinalIndex = -1;
        }
        
    }
    
    return  longitudinalIndex;
}
/// 获取任务的纵向索引
- (NSInteger)getShowTaskDateTransverseIndexStartTime:(NSString*)startTime showWeekend:(BOOL)showWeekend{
    
    NSInteger transverseIndex = 0;
    NSMutableArray * scheduleList = [NSMutableArray arrayWithCapacity:0];
    
    NSString * showtime = @"";
    for (int i = 8; i < 40; i ++) {
        if (showWeekend) {
            for (int j = 0; j < 8; j++) {
                if (j==0) {
                    NSString * time = [NSString stringWithFormat:@"%d:00",8];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"HH:mm"];
                    NSDate *timeDate = [dateFormatter dateFromString:time];
                    NSTimeInterval millisecond = [timeDate timeIntervalSince1970] * 1000;
                    millisecond = millisecond + 30 * 60 * 1000 * (i - 8);
                    showtime =  [dateFormatter stringFromDate:[[NSDate alloc]initWithTimeIntervalSince1970:millisecond/1000.0]];
                } else {
                    
                    showtime = [NSString stringWithFormat:@""];
                    
                }
                [scheduleList addObject:showtime];
            }
        }else{
            for (int j = 0; j < 6; j++) {
                if (j==0) {
                    NSString * time = [NSString stringWithFormat:@"%d:00",8];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"HH:mm"];
                    NSDate *timeDate = [dateFormatter dateFromString:time];
                    NSTimeInterval millisecond = [timeDate timeIntervalSince1970] * 1000;
                    millisecond = millisecond + 30 * 60 * 1000 * (i - 8);
                    showtime =  [dateFormatter stringFromDate:[[NSDate alloc]initWithTimeIntervalSince1970:millisecond/1000.0]];
                }else{
                    showtime = [NSString stringWithFormat:@""];
                }
                [scheduleList addObject:showtime];
            }
        }
    }
    
    transverseIndex = [scheduleList indexOfObject:startTime];
    
    return  transverseIndex;
}

- (NSString *)computeDateWithDays:(NSInteger)days startDate:(NSString*)startDate
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *myDate = [dateFormatter dateFromString:startDate];
    
    NSDate *newDate = [myDate dateByAddingTimeInterval:60 * 60 * 24 * days];
    
    return [dateFormatter stringFromDate:newDate];
}

- (NSString *)weekdayStringWithDate:(NSString *)date {
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *myDate = [dateFormatter dateFromString:date];
    
    //获取星期几
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:myDate];
    
    NSInteger weekday = [componets weekday];//1代表星期日，2代表星期一，后面依次
    
    NSArray *weekArray = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    
    NSString *weekStr = weekArray[weekday-1];
    
    return weekStr;
}

- (BOOL)isSelectDateWeekDay:(NSString*)date{
    BOOL isWeekDay = NO;
    
    if ([date isEqualToString:@"星期日"]||[date isEqualToString:@"星期六"]) {
        
        isWeekDay = YES;
    }
    return isWeekDay;
}

- (NSInteger)getTimeLengthWithStartTime:(NSString*)startTime endTime:(NSString*)endTime{
    NSInteger timelength = 1;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSTimeInterval starttime_millisecond = [[dateFormatter dateFromString:startTime] timeIntervalSince1970] * 1000;
    
    NSTimeInterval endtime_millisecond = [[dateFormatter dateFromString:endTime] timeIntervalSince1970] * 1000;
    
    timelength = (endtime_millisecond - starttime_millisecond)/30/60/1000;
    
    return timelength;
}

@end
