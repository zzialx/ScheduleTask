//
//  BXHWeekendView.h
//  BXHCalendar
//
//  Created by 步晓虎 on 2017/10/19.
//  Copyright © 2017年 步晓虎. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXHWeekendView : UIView

- (instancetype)initWithItemWidth:(CGFloat)itemWidth showWeekend:(BOOL)showWeekend;

/// 显示周末按钮
/// @param showWeekend yes 代表显示
/// @param itemWidth 宽度
- (void)updateShowWeekend:(BOOL)showWeekend withTemWidth:(CGFloat)itemWidth;

@end
