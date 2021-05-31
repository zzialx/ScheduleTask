//
//  ScheduleListCollectionViewCell.h
//  FormExampleDemo
//
//  Created by mwj on 2020/12/30.
//  Copyright © 2020 lx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleItemModel.h"
NS_ASSUME_NONNULL_BEGIN


@protocol ScheduleListCollectionViewCellDelegate <NSObject>


@optional

- (void)longPressDragCellEnd:(UILongPressGestureRecognizer*)recognizer itemModel:(ScheduleItemModel*)model;

@end





@interface ScheduleListCollectionViewCell : UICollectionViewCell

@property(nonatomic,assign)id <ScheduleListCollectionViewCellDelegate> delegate;

@property(nonatomic,assign)BOOL isCanLongPress;///<是否允许长按

- (void)showTitle:(ScheduleItemModel*)model indexPath:(NSIndexPath*)indexPath;


@end

NS_ASSUME_NONNULL_END
