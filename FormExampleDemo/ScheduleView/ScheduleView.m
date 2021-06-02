//
//  ScheduleView.m
//  FormExampleDemo
//
//  Created by mwj on 2020/12/24.
//  Copyright © 2020 lx. All rights reserved.
//

#import "ScheduleView.h"
#import <Masonry.h>
#import <objc/runtime.h>

#define ITEM_HEIGHT  550/11

#define BTN_H  30

#define BTN_PAD  5

#define __object_block_return(block, object) \
if(block) { \
block(object); \
} \

@interface ScheduleView ()


@property(nonatomic,strong)UIButton * bottomLine;

@property(nonatomic,assign)CGFloat lastHeight;///<记录手指离开时self的高度

@property(nonatomic,strong)UIPanGestureRecognizer *panGR;///<长按手势

@property(nonatomic,strong)UIView * contentView;

@property(nonatomic,strong)UILongPressGestureRecognizer *longGesture;///<长按执行删除

@property(nonatomic,strong)UIButton * delBtn;///<删除任务按钮

@property(nonatomic,strong)UIButton * executeBTn;///<执行任务按钮

@property(nonatomic,strong)UIButton * editBtn;///<编辑任务按钮

@property(nonatomic,strong)UIButton * meetBtn;///<会议按钮

@property(nonatomic,assign)UserType logingUserType;///<登录用户的角色

@property(nonatomic,assign)BOOL isOutBorderDraging;///<是否越界

@end


@implementation ScheduleView

- (instancetype)initWithFrame:(CGRect)frame userType:(UserType)userType{
    self = [super initWithFrame:frame];
    if (self) {
        _logingUserType = userType;
        
        self.lastHeight = frame.size.height;
        
        self.isOutBorderDraging = NO;
        
        [self setSubUI];
    }
    return self;
}
- (void)setSubUI{
    [self contentView];
    
    [self bottomLine];
    
    [self delBtn];
    
    [self executeBTn];

    [self editBtn];

    [self meetBtn];
    
    [self updateSubViewsFrame];
    //长按拖动
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGRAct:)];
    [self.bottomLine addGestureRecognizer:panGR];
    self.panGR = panGR;
}

- (void)setIsShowWeekendAdd:(BOOL)isShowWeekendAdd{
    _isShowWeekendAdd = isShowWeekendAdd;
}

- (void)setItemModel:(ScheduleItemModel *)itemModel{
    _itemModel = itemModel;
}
- (void)setIsLastTime:(BOOL)isLastTime{
    _isLastTime = isLastTime;
    if (isLastTime) {
        [self.bottomLine removeGestureRecognizer:self.panGR];
    }else{
        [self.bottomLine addGestureRecognizer:self.panGR];
    }
}
- (void)setIsCanDrag:(BOOL)isCanDrag{
    _isCanDrag = isCanDrag;
    if (_isCanDrag) {
        self.bottomLine.userInteractionEnabled = NO;
    }
}
#pragma mark--------------USER ACTION------------
- (void)delTaskAction{
    NSLog(@"删除任务");
    __object_block_return(self.taskAction,TaskActionDel_Type);
}
- (void)executeTaskAction{
    NSLog(@"执行任务");
    __object_block_return(self.taskAction,TaskActionExecute_Type);
}
- (void)editTaskAction{
    if (self.itemModel.taskType == TaskType_Area) {
        NSLog(@"编辑任务");
        __object_block_return(self.taskAction,TaskActionEdit_Type);
    }if (self.itemModel.taskType == TaskType_VistiMeeting) {
        NSLog(@"医生任务");
        __object_block_return(self.taskAction,TaskActionDoctor_Type);
    }
}
- (void)meetTaskAction{
    NSLog(@"会议任务");
    __object_block_return(self.taskAction,TaskActionMeeting_Type);
}
- (void)panGRAct: (UIPanGestureRecognizer *)rec{
    CGPoint point = [rec translationInView:self];
    NSLog(@"长按拉动%f,%f",point.x,point.y);
    CGFloat scrollY = point.y;
    if (scrollY>0) {
        NSLog(@"向下拉=====%f========%ld",floor(scrollY/50),self.itemModel.verticalAxis);
        CGFloat scrollIndex = floor (scrollY/50);
        if (scrollIndex + self.itemModel.verticalAxis >23) {
            NSLog(@"滑动出格了，不再监听拖动状态");
            self.isOutBorderDraging = YES;
            return;
        }
    }
    switch (rec.state) {
            case UIGestureRecognizerStateChanged:
            NSLog(@"拖动时");
            if (self.isOutBorderDraging) {
                NSLog(@"越界了，不再允许滑动");
                return;
            }
            if (scrollY>0) {
                //向下拉
                NSLog(@"向下拉=====%f",floor(scrollY/50));
                //向下取整
                [UIView animateWithDuration:1 animations:^{
                                    
                                } completion:^(BOOL finished) {
                                    CGFloat scrollH = floor (scrollY/50)*ITEM_HEIGHT;
                                   
                                    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,scrollH + self.lastHeight);
                                }];
               
            }else{
                //向上拉
                NSLog(@"向上拉=======%f",fabs(scrollY)/50);
                NSLog(@"向上取值=======%f",ceilf(fabs(scrollY)/50));
                if ((self.lastHeight- (floor(fabs(scrollY)/50))*ITEM_HEIGHT)==0 ) {
                    [UIView animateWithDuration:1 animations:^{
                                    
                                    } completion:^(BOOL finished) {
                                        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,ITEM_HEIGHT);
                                        [self removeFromSuperview];
                                    }];
                }else{
                    [UIView animateWithDuration:1 animations:^{
                                    
                                    } completion:^(BOOL finished) {
                                        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,self.lastHeight- (floor(fabs(scrollY)/50))*ITEM_HEIGHT);
                                    }];
                }
                
               
                }
            break;
            case UIGestureRecognizerStateEnded:
            self.lastHeight = self.frame.size.height;
            NSLog(@"拖动结束====%f",self.lastHeight);
            NSLog(@"长按日历任务拖动结束frame===%@",self);
            break;
            case UIGestureRecognizerStateCancelled:
            NSLog(@"拖动取消");
            break;
            default:
            break;
    }
}
- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan: {
            NSLog(@"长按显示执行、删除按钮");
            if (self.logingUserType == UserType_MR) {
                
                [self updateTaskViewLongpressState:self.itemModel.taskType];
                
                [self.bottomLine setHidden:YES];
            }if (self.logingUserType == UserType_DM) {
                if (self.itemModel.taskType != TaskType_NeiBu) {
                    if (self.longpressShowDetial) {
                        self.longpressShowDetial();
                    }
                }else{
                    NSLog(@"内部会不支持长按");
                }
                
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
            break;

        default:
            break;
    }
}
- (void)updateTaskViewLongpressState:(TaskType)taskType{
    switch (taskType) {
        case TaskType_NeiBu:
            [self.delBtn setHidden:NO];
            break;
        case TaskType_Area:
            [self.delBtn setHidden:NO];
            [self.executeBTn setHidden:NO];
            [self.editBtn setHidden:NO];
            break;
        case TaskType_VistiMeeting:
            [self.delBtn setHidden:NO];
            [self.executeBTn setHidden:NO];
            [self.editBtn setHidden:NO];
            [self.meetBtn setHidden:NO];
            [self.editBtn setBackgroundColor:UIColor.purpleColor];
            break;
        default:
            break;
    }
}
#pragma mark --------UI-------
- (UILongPressGestureRecognizer *)longGesture {
    if (!_longGesture) {
        _longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
        _longGesture.minimumPressDuration = 0.5;
    }
    return _longGesture;
}

- (UIView*)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        [self addSubview:_contentView];
        _contentView.layer.cornerRadius = 3;
        _contentView.layer.masksToBounds  = YES;
        _contentView.userInteractionEnabled = YES;
        //添加长按手势
        [_contentView addGestureRecognizer:self.longGesture];
    }
    return _contentView;
}
- (UIButton*)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomLine setTitle:@"_____" forState:UIControlStateNormal];
        [_bottomLine setTitleColor:UIColor.orangeColor forState:UIControlStateNormal];
        [self addSubview:_bottomLine];
        _bottomLine.backgroundColor = UIColor.lightGrayColor;
        [self updateSubViewsFrame];
        //长按拖动
        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGRAct:)];
        [_bottomLine addGestureRecognizer:panGR];
        self.panGR = panGR;
    }
    return _bottomLine;;
}

- (UIButton *)delBtn{
    if (_delBtn==nil) {
        _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_delBtn];
        [_delBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_delBtn addTarget:self action:@selector(delTaskAction) forControlEvents:UIControlEventTouchUpInside];
        [_delBtn setBackgroundColor:UIColor.orangeColor];
        [_delBtn setHidden:YES];
    }
    return _delBtn;
}
- (UIButton *)executeBTn{
    if (_executeBTn==nil) {
        _executeBTn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_executeBTn];
        [_executeBTn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_executeBTn addTarget:self action:@selector(executeTaskAction) forControlEvents:UIControlEventTouchUpInside];
        [_executeBTn setBackgroundColor:UIColor.orangeColor];
        [_executeBTn setHidden:YES];

    }
    return _executeBTn;
}
- (UIButton *)editBtn{
    if (_editBtn==nil) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_editBtn];
        [_editBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(editTaskAction) forControlEvents:UIControlEventTouchUpInside];
        [_editBtn setBackgroundColor:UIColor.redColor];
        [_editBtn setHidden:YES];

    }
    return _editBtn;
}
- (UIButton *)meetBtn{
    if (_meetBtn==nil) {
        _meetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_meetBtn];
        [_meetBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_meetBtn addTarget:self action:@selector(meetTaskAction) forControlEvents:UIControlEventTouchUpInside];
        [_meetBtn setBackgroundColor:UIColor.blueColor];
        [_meetBtn setHidden:YES];

    }
    return _meetBtn;
}


- (void)updateSubViewsFrame{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(3, 3, 3, 3));
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).with.offset(0);
        make.height.mas_equalTo(30.0);
    }];
    
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).mas_offset(-4);
        make.top.equalTo(self.contentView).mas_offset(4);
        make.height.mas_equalTo(8);
        make.width.mas_equalTo(8);
    }];
    
    [self.executeBTn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).mas_offset(BTN_PAD);
        make.height.mas_equalTo(BTN_H);
        make.width.mas_equalTo(BTN_H);
    }];
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.executeBTn.mas_right).mas_offset(BTN_PAD);
        make.height.equalTo(self.executeBTn);
        make.width.equalTo(self.executeBTn);
    }];
    
    [self.meetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.editBtn.mas_right).mas_offset(BTN_PAD);
        make.height.equalTo(self.executeBTn);
        make.width.equalTo(self.executeBTn);
    }];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 2);
    CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
    CGContextSetRGBStrokeColor(ctx, 226.0/255, 75.0/255, 25.0/255, 1);
    CGContextAddRect(ctx, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    CGContextDrawPath(ctx, kCGPathFillStroke);
}
@end
