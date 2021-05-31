//
//  ScheduleListCollectionViewCell.m
//  FormExampleDemo
//
//  Created by mwj on 2020/12/30.
//  Copyright © 2020 lx. All rights reserved.
//

#import "ScheduleListCollectionViewCell.h"
#import "PageHorizontalCollectionViewCell.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width

#define ITEM_WIDTH   (ScreenW-7)/9
#define ITEM_WIDTH5  (ScreenW-5)/7

#define ITEM_HEIGHT  50


@interface ScheduleListCollectionViewCell()<UIGestureRecognizerDelegate>

@property(nonatomic,strong)UILabel * testLab;
/// 长按手势
@property (nonatomic, strong, nullable) UILongPressGestureRecognizer *longGesture;
/// 长按触发拖拽所需时间，默认是 0.5 秒。
@property (nonatomic, assign) NSTimeInterval minimumPressDuration;
/// 当前item所在的索引
@property (nonatomic, strong)NSIndexPath * currentIndexPath;
/// 当前cell对象
@property (nonatomic, strong)ScheduleItemModel * currentItemModel;

@property(nonatomic,strong)UIView *snapView;



@end

@implementation ScheduleListCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViews];
        _minimumPressDuration = 0.5;
        [self addGestureRecognizer:self.longGesture];
        _isCanLongPress = YES;
//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlelongGesture:)];
//        pan.delegate = self;
//        [self addGestureRecognizer:pan];
    }
    return self;
}
- (void)setIsCanLongPress:(BOOL)isCanLongPress{
    _isCanLongPress = isCanLongPress;
    if (!_isCanLongPress) {
        [self removeGestureRecognizer:self.longGesture];
    }
}
- (void)showTitle:(ScheduleItemModel*)model indexPath:(NSIndexPath*)indexPath{
    
    self.testLab.text = model.name;
    
    self.currentIndexPath = indexPath;
    
    self.currentItemModel = model;
    
}
- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan: {
            // 手势开始
            NSLog(@"医院选择的长按");
            [self snapView];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            NSLog(@"开始拖动截图");
            //设置截图视图位置
            [UIView animateWithDuration:1 animations:^{
                        } completion:^(BOOL finished) {
                            if (window) {
                                if (self.snapView) {
                                    if (longGesture.numberOfTouches>0) {
                                        self.snapView.frame = CGRectMake([longGesture locationOfTouch:0 inView:window].x , [longGesture locationOfTouch:0 inView:window].y, ITEM_WIDTH, ITEM_HEIGHT);

                                        self.snapView.center = CGPointMake([longGesture locationOfTouch:0 inView:window].x, [longGesture locationOfTouch:0 inView:window].y);
                                    }
                                }
                                
                            }
                           
                        }];
            
        }
            break;
        case  UIGestureRecognizerStateEnded:{
            NSLog(@"结束拖动，确定边界问题");
            if (_delegate&&[_delegate respondsToSelector:@selector(longPressDragCellEnd:itemModel:)]) {
                [self.delegate longPressDragCellEnd:longGesture itemModel:self.currentItemModel];
            }
            
            [UIView animateWithDuration:1 animations:^{
                            
                        } completion:^(BOOL finished) {
                            if (self->_snapView!=nil) {
                                [self->_snapView removeFromSuperview];
                                self->_snapView = nil;
                            }
                            
                        }];
        }
           
            break;

        default:
            break;
    }
}
- (UIView*)snapView{
    if (_snapView==nil) {
        _snapView = [self snapshotViewAfterScreenUpdates:YES];
        _snapView.center = self.center;
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:_snapView];
    }
    return _snapView;
}

//- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
//    switch (longGesture.state) {
//        case UIGestureRecognizerStateBegan: {
//            NSLog(@"长按显示执行、删除按钮");
//
//        }
//            break;
//        case UIGestureRecognizerStateChanged:
//            break;
//
//        default:
//            break;
//    }
//}
#pragma mark--------------------分割-----

- (void)setSubViews{
    self.testLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.contentView addSubview:self.testLab];
    self.testLab.backgroundColor = UIColor.whiteColor;
    self.testLab.textAlignment = NSTextAlignmentCenter;
    self.testLab.numberOfLines = 2;
    self.testLab.font = [UIFont systemFontOfSize:15.0];
}


- (UILongPressGestureRecognizer *)longGesture {
    if (!_longGesture) {
        _longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
        _longGesture.minimumPressDuration = _minimumPressDuration;
    }
    return _longGesture;
}
- (void)setMinimumPressDuration:(NSTimeInterval)minimumPressDuration {
    _minimumPressDuration = minimumPressDuration;
    self.longGesture.minimumPressDuration = minimumPressDuration;
}

@end
