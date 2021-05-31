//
//  PageHorizontalCollectionViewCell.h
//  FormExampleDemo
//
//  Created by mwj on 2020/12/22.
//  Copyright © 2020 lx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleItemModel.h"

NS_ASSUME_NONNULL_BEGIN


@protocol PageHorizontalCollectionViewCellDelegate <NSObject>

@optional

- (void)longPressCellModel:(ScheduleItemModel*)model cellFrame:(CGRect)cellFrame;

@end







@interface PageHorizontalCollectionViewCell : UICollectionViewCell


@property(nonatomic,assign)id <PageHorizontalCollectionViewCellDelegate> delegate;

- (void)showTitle:(ScheduleItemModel*)model indexPath:(NSIndexPath*)indexPath;

@end

NS_ASSUME_NONNULL_END
