//
//  BXHCalendarDayView.m
//  BXHCalendar
//
//  Created by 步晓虎 on 2017/10/18.
//  Copyright © 2017年 步晓虎. All rights reserved.
//

#import "BXHCalendarDayView.h"
#import "BXHCalendarSupport.h"
#import "NSDate+BXHCategory.h"
#import "BXHCalendarManager.h"


#define DATEVIEW_H  30

@interface BXHCalendarDaySelectView : CAShapeLayer

@property (nonatomic, strong) UIColor *selectColor;

@property (nonatomic, assign) BOOL fill;

@end

@implementation BXHCalendarDaySelectView

- (instancetype)init
{
    if (self = [super init])
    {
        self.fill = YES;
        self.backgroundColor = HQRGBAColor(249, 228, 195, 1.0).CGColor;
        self.selectColor = Calendar_DayView_SelectColor;
    }
    return self;
}

- (void)reloadPath
{
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:self.bounds.size.height / 2-2 startAngle:(0.0*M_PI) endAngle:2.0f*M_PI clockwise:true];
    self.path = path.CGPath;
    if (self.fill)
    {
        self.fillColor = self.selectColor.CGColor;
    }
    else
    {
        self.fillColor = [UIColor clearColor].CGColor;
    }
    self.strokeColor = self.selectColor.CGColor;
    self.lineWidth = 1;
    self.lineCap = kCALineCapRound;
    self.strokeStart = 0;
    self.strokeEnd = 1;
}



@end

@interface BXHCalendarDayView ()

@property (nonatomic, strong) BXHCalendarDaySelectView *selectView;

@property (nonatomic, strong) BXHCalendarDaySelectView *currentDateView;

@property (nonatomic, strong) BXHCalendarDaySelectView *pointView;

@end

@implementation BXHCalendarDayView

- (instancetype)init
{
    if (self = [super init])
    {
        [self addSubview:self.contentView];
        [self.contentView.layer addSublayer:self.currentDateView];
        [self.contentView.layer addSublayer:self.selectView];
        [self.contentView.layer addSublayer:self.pointView];
        [self.contentView addSubview:self.textLabel];
        
    }
    return self;
}

- (void)layoutSubviews
{
    self.contentView.frame = self.bounds;
    
    CGFloat backViewWidth = self.contentView.bounds.size.height;
    
    self.currentDateView.frame = CGRectMake((self.contentView.bounds.size.width - backViewWidth) / 2  , 0, backViewWidth, 30);
    self.selectView.frame = self.currentDateView.frame;
    self.textLabel.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, 30);
    self.pointView.frame = CGRectMake(self.contentView.bounds.size.width / 2 - 2, CGRectGetMaxY(self.textLabel.frame), 4, 4);
    [self.currentDateView reloadPath];
    [self.selectView reloadPath];
    [self.pointView reloadPath];
    [super layoutSubviews];
}

#pragma mark - get / set
- (void)setSelected:(BOOL)selected
{
    if (self.selectView.hidden == !selected) return;
    [super setSelected:selected];
    self.selectView.hidden = !selected;
    if (selected)
    {
        if ([BXHCalendarManager defaultManager].selectDayView != self)
        {
            [BXHCalendarManager defaultManager].selectDayView.selected = NO;
            [BXHCalendarManager defaultManager].selectDayView = self;
        }
        [BXHCalendarManager defaultManager].selectDate = self.date;
    }
}

- (void)setHaveEvent:(BOOL)haveEvent
{
    if (_haveEvent == haveEvent) return;
    _haveEvent = haveEvent;
    self.pointView.hidden = !_haveEvent;
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    self.currentDateView.hidden = !date.isToday;
    self.textLabel.text = [_date bxh_stringWithFormate:@"dd"];
    self.textLabel.backgroundColor = UIColor.clearColor;
    if (self.month == _date.month || [BXHCalendarManager defaultManager].displayType == BXHCalendarDisplayWeekType)
    {
        self.textLabel.textColor = Calendar_DayView_TextColor;
    }
    else
    {
        self.textLabel.textColor = Calendar_DayView_NOMonthTextColor;
    }
}

- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor =  HQRGBAColor(249, 228, 195, 1.0);

    }
    return _contentView;
}

- (BXHCalendarDaySelectView *)currentDateView
{
    if (!_currentDateView)
    {
        _currentDateView = [[BXHCalendarDaySelectView alloc] init];
        _currentDateView.hidden = YES;
        _currentDateView.fill = NO;
    }
    return _currentDateView;
}

- (BXHCalendarDaySelectView *)selectView
{
    if (!_selectView)
    {
        _selectView = [[BXHCalendarDaySelectView alloc] init];
        _selectView.hidden = YES;
    }
    return _selectView;
}

- (BXHCalendarDaySelectView *)pointView
{
    if (!_pointView)
    {
        _pointView = [[BXHCalendarDaySelectView alloc] init];
        _pointView.selectColor = Calendar_DayView_PointColor;
        _pointView.hidden = YES;
    }
    return _pointView;
}

- (UILabel *)textLabel
{
    if (!_textLabel)
    {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = Calendar_DayView_TextFont;
        _textLabel.adjustsFontSizeToFitWidth = YES;
        _textLabel.text = @"1111";
    }
    return _textLabel;
}

@end
