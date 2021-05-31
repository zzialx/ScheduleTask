//
//  LeftTaskView.h
//  FormExampleDemo
//
//  Created by mwj on 2020/12/30.
//  Copyright © 2020 lx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleListCollectionViewCell.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TaskViewType)
{
    TaskViewTypeLeft,
    TaskViewTypeRight
};

typedef void(^longPressDragCellEnd)(UILongPressGestureRecognizer * recognizer,ScheduleItemModel * item);


@interface TaskView : UIView

- (instancetype)initWithFrame:(CGRect)frame withTaskList:(NSArray*)taskList viewType:(TaskViewType)type;


@property(nonatomic,copy)longPressDragCellEnd longPressDragCellEnd;

@property(nonatomic,strong)NSArray * taskArray;

@end

NS_ASSUME_NONNULL_END
