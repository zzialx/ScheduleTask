//
//  PageHorizontalCollectionViewCell.m
//  FormExampleDemo
//
//  Created by mwj on 2020/12/22.
//  Copyright © 2020 lx. All rights reserved.
//

#import "PageHorizontalCollectionViewCell.h"
#import <Masonry.h>
#import "TopTimeLabel.h"

@interface PageHorizontalCollectionViewCell ()

@property(nonatomic,strong)TopTimeLabel * titleLab;
/// 长按手势
@property (nonatomic, strong, nullable) UILongPressGestureRecognizer *longGesture;
/// 长按触发拖拽所需时间，默认是 0.5 秒。
@property (nonatomic, assign) NSTimeInterval minimumPressDuration;
/// 当前item所在的索引
@property (nonatomic, strong)NSIndexPath * currentIndexPath;
/// 当前cell对象
@property (nonatomic, strong)ScheduleItemModel * currentItemModel;

@end


@implementation PageHorizontalCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self titleLab];
        [self setSubViewsFrame];
        _minimumPressDuration = 0.5;
//        [self addGestureRecognizer:self.longGesture];

    }
    return self;
}
- (void)showTitle:(ScheduleItemModel*)model indexPath:(NSIndexPath*)indexPath{
    
    self.titleLab.text = model.name;
    
    self.currentIndexPath = indexPath;
    
    self.currentItemModel = model;
    
}
- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan: {
            // 手势开始，不能禁止，禁止之后无法再长按
            NSLog(@"长按开始");
            if (_delegate&&[_delegate respondsToSelector:@selector(longPressCellModel:cellFrame:)]) {
                [self.delegate longPressCellModel:self.currentItemModel cellFrame:self.frame];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
            break;

        default:
            break;
    }
}
#pragma mark--------------------分割-----

- (void)setSubViewsFrame{
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0,0, 0, 0));
    }];
}
- (UILabel*)titleLab{
    if (_titleLab==nil) {
        _titleLab = [[TopTimeLabel alloc]init];
        [self.contentView addSubview:_titleLab];
        _titleLab.backgroundColor = UIColor.whiteColor;
        _titleLab.textAlignment = NSTextAlignmentCenter;
//        _titleLab.verticalAlignment = VerticalAlignmentTop;
    }
    return _titleLab;;
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
