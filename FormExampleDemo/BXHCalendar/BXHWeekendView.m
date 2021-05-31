//
//  BXHWeekendView.m
//  BXHCalendar
//
//  Created by 步晓虎 on 2017/10/19.
//  Copyright © 2017年 步晓虎. All rights reserved.
//

#import "BXHWeekendView.h"
#import "BXHCalendarSupport.h"

@implementation BXHWeekendView

- (instancetype)initWithItemWidth:(CGFloat)itemWidth showWeekend:(BOOL)showWeekend
{
    if (self = [super initWithFrame:CGRectMake(0, 0, itemWidth * 7, 30)])
    {
        NSArray *weekShow;
        if (showWeekend) {
            weekShow = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
        }else{
            weekShow = @[@"一",@"二",@"三",@"四",@"五"];
        }
        NSInteger count = showWeekend?7:5;
        for (int i = 0; i < count; i++)
        {
            [self creatWeekendLabelAtIndex:i andItemWidth:itemWidth andShowText:weekShow[i]];
        }
    }
    return self;
}
- (void)updateShowWeekend:(BOOL)showWeekend withTemWidth:(CGFloat)itemWidth{
    for (id subview in self.subviews) {
        [subview removeFromSuperview];
    }
    NSArray *weekShow;
    if (showWeekend) {
        weekShow = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    }else{
        weekShow = @[@"一",@"二",@"三",@"四",@"五"];
    }
    NSInteger count = showWeekend?7:5;
    for (int i = 0; i < count; i++)
    {
        [self creatWeekendLabelAtIndex:i andItemWidth:itemWidth andShowText:weekShow[i]];
    }
}

- (void)creatWeekendLabelAtIndex:(NSInteger)index andItemWidth:(CGFloat)itemWidth andShowText:(NSString *)text
{
    UILabel *weekendLabel = [[UILabel alloc] init];
    weekendLabel.textColor = Calendar_WeekendView_TextColor;
    weekendLabel.font = Calendar_WeekendView_TextFont;
    weekendLabel.frame = CGRectMake(index * itemWidth, 0, itemWidth, self.frame.size.height);
    weekendLabel.text = text;
    weekendLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:weekendLabel];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
