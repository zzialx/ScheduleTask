//
//  HspTaskSceduleView.h
//  FormExampleDemo
//
//  Created by mwj on 2020/12/30.
//  Copyright © 2020 lx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleListCollectionViewCell.h"
#import "ScheduleItemModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^longPressEnd)(UILongPressGestureRecognizer * recognizer,ScheduleItemModel * model);

@interface HspTaskSceduleView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property(nonatomic,copy)longPressEnd longPressEnd;


@end

NS_ASSUME_NONNULL_END
