//
//  LeftTaskView.m
//  FormExampleDemo
//
//  Created by mwj on 2020/12/30.
//  Copyright © 2020 lx. All rights reserved.
//

#import "TaskView.h"
#import "ScheduleListCollectionViewCell.h"

#define ITEM_HEIGHT   40
#define LEFT_ITEM_WIDTH   80

static NSString *const cellID = @"cellID";

@interface TaskView ()<UICollectionViewDelegate,UICollectionViewDataSource,ScheduleListCollectionViewCellDelegate>

@property(nonatomic,strong)UICollectionView * collectionView;

@property(nonatomic,assign)TaskViewType viewType;

@property(nonatomic,strong)UIView *snapView;

@end


@implementation TaskView

- (instancetype)initWithFrame:(CGRect)frame withTaskList:(NSArray*)taskList viewType:(TaskViewType)type{
    self = [super initWithFrame:frame];
    if (self) {
        self.viewType = type;
        self.taskArray = taskList;
        [self creatLeftCollectionViewUI];
    }
    return self;
}
- (void)setTaskArray:(NSArray *)taskArray{
    _taskArray = taskArray;
    [self.collectionView reloadData];
}
- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ScheduleListCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.delegate = self;
    [cell showTitle:self.taskArray[indexPath.row] indexPath:indexPath];
    cell.layer.borderWidth = 2.0;
    cell.layer.borderColor = UIColor.orangeColor.CGColor;
    cell.layer.cornerRadius = 5.0;
    cell.clipsToBounds = YES;
    cell.isCanLongPress = YES;
    return cell;
}
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.taskArray count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.viewType==TaskViewTypeLeft?CGSizeMake(LEFT_ITEM_WIDTH, ITEM_HEIGHT):CGSizeMake((self.frame.size.width-30)/4, ITEM_HEIGHT);
}
- (void)creatLeftCollectionViewUI{
    [self collectionView];
}
- (UICollectionView*)collectionView{
    if (_collectionView==nil) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing  = 10.0;
        layout.minimumInteritemSpacing = 10.0;
        layout.sectionInset  = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [self addSubview:_collectionView];
        _collectionView.backgroundColor = UIColor.whiteColor;
        [_collectionView registerClass:[ScheduleListCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    }
    return _collectionView;
}

- (void)longPressDragCellEnd:(UILongPressGestureRecognizer*)recognizer itemModel:(ScheduleItemModel*)model{
    if (self.longPressDragCellEnd) {
        self.longPressDragCellEnd(recognizer,model);
    }
}

@end
