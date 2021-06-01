//
//  ViewController.m
//  FormExampleDemo
//
//  Created by mwj on 2020/12/22.
//  Copyright © 2020 lx. All rights reserved.
//

#import "ViewController.h"
#import "PageHorizontalCollectionViewCell.h"
#import "ScheduleItemModel.h"
#import "ScheduleView.h"
#import <Toast.h>
#import <Masonry.h>
#import "BXHCalendarView.h"
#import "NSDate+BXHCalendar.h"
#import "NSDate+BXHCategory.h"
#import "ScheduleViewModel.h"
#import "HspTaskSceduleView.h"
#import "ScheduleListCollectionViewCell.h"
#import "ScheduleItemModel.h"
#import "TaskInfoView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define WSWeakSelf(type)     __weak __typeof__(type) weakSelf = self;
#define WSStrongSelf(type)  __strong __typeof(type) type = weak##type;

#define ITEM_HEIGHT  550/11
#define ITEM_WIDTH   (SCREEN_WIDTH-7)/9
#define ITEM_WIDTH5  (SCREEN_WIDTH-5)/7

static NSString *const cellID = @"cellID_pageHorizon";



@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,PageHorizontalCollectionViewCellDelegate,BXHCalendarViewDataSource,BXHCalendarViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)BXHCalendarView * calenderView;///<日历

@property(nonatomic,strong)UICollectionView * collectionView;///<横向滑动的表格

@property(nonatomic,strong)NSMutableArray * dataArray;///<表格的数据

@property(nonatomic,strong)NSMutableArray * scheduleDataArray;///<日程安排的view

@property(nonatomic,assign)NSInteger timeLength;///<时长

@property(nonatomic,assign)NSInteger verticalAxisLength;///<时长

@property(nonatomic,strong)ScheduleViewModel * viemModel;///<数据源处理

@property(nonatomic,strong)HspTaskSceduleView * scedyleView;

@property(nonatomic,strong)UIButton * fullScreenBtn;///<全屏按钮

@property(nonatomic,strong)UIButton * weekendBtn;///<全屏按钮

@property(nonatomic,strong)NSMutableArray * hasAddDataArray;///<已经添加的日程数据

@property(nonatomic,assign)CGFloat offsetY;

@property(nonatomic,strong)TaskInfoView * detialInfoView;///<DM角色显示的view


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = UIColor.whiteColor;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.scheduleDataArray = [NSMutableArray arrayWithCapacity:0];
    self.hasAddDataArray = [NSMutableArray arrayWithCapacity:0];
    self.timeLength = 1;
    self.verticalAxisLength = 23;
    self.offsetY = 0.0;
    [self viemModel];
    [self scedyleView];
    [self setCalenderviewUI];
    [self collectionView];
    [self fullScreenBtn];
    [self weekendBtn];
    [self getDataListShowWeekend:YES];
    [self getHasAddedTaskList];
    
}
#pragma mark------选择不同的周的数据-----
- (void)updateSelectWeekData{
    for (ScheduleView * taskView in self.scheduleDataArray) {
        [taskView removeFromSuperview];
    }
    [self.scheduleDataArray removeAllObjects];
    [self getHasAddedTaskList];
}
///显示日程view
- (void)addTaskViewWithIndexPathItemModel:(ScheduleItemModel*)itemModel{
    PageHorizontalCollectionViewCell * cell  = (PageHorizontalCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:itemModel.indexPath];
    if (cell!=nil) {
        __block ScheduleView * taskView = [[ScheduleView alloc]initWithFrame:CGRectMake(cell.frame.origin.x,cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height * itemModel.timeLength) userType:UserType_DM];
        [self.collectionView addSubview:taskView];
        BOOL isCover = [self chargeDifferentView:taskView];
        if (isCover) {
            NSLog(@"存在覆盖的view");
            taskView = nil;
            return;;
            }
        taskView.itemModel = itemModel;
        taskView.indexPath = itemModel.indexPath;
        taskView.isShowWeekendAdd = self.viemModel.showWeekend;
//        taskView.isLastTime = model.verticalAxis==self.verticalAxisLength?YES:NO;
//        [self.collectionView addSubview:taskView];
//        [cell.contentView addSubview:taskView];
//        [cell.contentView bringSubviewToFront:taskView];
        [self.scheduleDataArray addObject:taskView];
        NSLog(@"collectionView上任务位置===%@",taskView);
        NSLog(@"上传完成之后需要存储数据库");
        WSWeakSelf(self);
        [taskView setTaskAction:^(TaskActionType type) {
                            
        }];
        [taskView setLongpressShowDetial:^{
            [weakSelf showDetialInfoView:taskView];
        }];
    }
}
- (void)showDetialInfoView:(ScheduleView*)taskView{
    self.detialInfoView = [[TaskInfoView alloc]initWithFrame:CGRectZero];
    [self.collectionView addSubview:self.detialInfoView];
    [self.detialInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(taskView.mas_right).offset(2);
        make.top.equalTo(taskView);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(260);
    }];
    self.detialInfoView.layer.cornerRadius = 8.0;
    self.detialInfoView.clipsToBounds = YES;
}

#pragma mark-----------------------ACTION-----------------------
- (void)showFullScreenAction{
    NSLog(@"显示全屏");
}
- (void)showWeekendAction{
    self.viemModel.showWeekend = !self.viemModel.showWeekend;
    if (self.viemModel.showWeekend) {
        _collectionView.frame  = CGRectMake(0, CGRectGetMaxY(self.calenderView.frame), SCREEN_WIDTH-ITEM_WIDTH, _collectionView.frame.size.height);
        [self.calenderView showWeekend:YES];
        [self getDataListShowWeekend:YES];
    }else{
        _collectionView.frame  = CGRectMake(0, CGRectGetMaxY(self.calenderView.frame), SCREEN_WIDTH-ITEM_WIDTH5, _collectionView.frame.size.height);
        [self.calenderView showWeekend:NO];
        [self getDataListShowWeekend:NO];
        
        
    }
}
#pragma mark-----------------------日期代理方法-----------------------
- (void)calendarView:(BXHCalendarView *)calendarView willShowMonthView:(BXHCalendarMonthView *)monthView
{
    self.title = [NSString stringWithFormat:@"%@",[monthView.beaginDate bxh_stringWithFormate:@"yyyy-MM-dd"]];
    NSLog(@"开始日期====%@",[NSString stringWithFormat:@"%@",[monthView.beaginDate bxh_stringWithFormate:@"yyyy-MM-dd"]]);
    self.viemModel.currentStartDate = [NSString stringWithFormat:@"%@",[monthView.beaginDate bxh_stringWithFormate:@"yyyy-MM-dd"]];
    self.viemModel.currentEndDate = [self.viemModel computeDateWithDays:6 startDate:self.viemModel.currentStartDate];
    [self updateSelectWeekData];
}

- (void)calendarView:(BXHCalendarView *)calendarView dayViewHaveEvent:(BXHCalendarDayView *)dayView
{
    dayView.haveEvent = dayView.date.day % 3 == 0;
}

- (void)calendarView:(BXHCalendarView *)calendarView didSelectDayView:(BXHCalendarDayView *)dayView
{
    
    NSLog(@"select %@",[dayView.date bxh_stringWithFormate:@"yyyy-MM-dd"]);
}
#pragma mark-----------------------UICollectionViewDelegate-----------------------

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PageHorizontalCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.delegate = self;
    [cell showTitle:self.dataArray[indexPath.row] indexPath:indexPath];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.viemModel.showWeekend?CGSizeMake(ITEM_WIDTH,ITEM_HEIGHT):CGSizeMake(ITEM_WIDTH5, ITEM_HEIGHT);
}

- (void)longPressCellModel:(ScheduleItemModel*)model cellFrame:(CGRect)cellFrame{
    NSLog(@"纵轴索引====%ld",model.verticalAxis);
    NSLog(@"时长===%ld",self.timeLength);
    NSLog(@"表格高度====%ld",self.verticalAxisLength);
    //判断纵轴坐标+时长是否超过表格的长度
    if (model.verticalAxis > self.verticalAxisLength) {
        NSLog(@"超过纵轴长度");
        return;
    }
}


#pragma mark-----------------------模拟数据源-----------------------
- (void)getDataListShowWeekend:(BOOL)showWeekend{
    WSWeakSelf(self);
    [self.viemModel getScheduleDataSourceShowWeekend:showWeekend complete:^(NSArray<ScheduleItemModel *> * _Nonnull dataSource) {
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.dataArray addObjectsFromArray:dataSource];
        [weakSelf.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView layoutIfNeeded];
        [weakSelf updateTaskViewFrame];
        } fail:^{
            
        }];
}
- (void)getHasAddedTaskList{
    WSWeakSelf(self);
    //开始时间 结束时间
    [self.viemModel getAllTaskListCurrentShowStartDate:self.viemModel.currentStartDate endDate:self.viemModel.currentEndDate Complete:^(NSArray<ScheduleItemModel *> * _Nonnull dataSource) {
            for (int i = 0; i < dataSource.count; i++) {
                ScheduleItemModel * item = dataSource[i];
                [weakSelf addTaskViewWithIndexPathItemModel:item];
            
            }
        } fail:^{
            
        }];
}
#pragma mark-----------------------UI--------------------

- (HspTaskSceduleView*)scedyleView{
    if (_scedyleView==nil) {
        _scedyleView = [[HspTaskSceduleView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 150)];
        [self.view addSubview:_scedyleView];
        WSWeakSelf(self);
        [_scedyleView setLongPressEnd:^(UILongPressGestureRecognizer * _Nonnull recognizer,ScheduleItemModel * model) {
            UIWindow* window = [UIApplication sharedApplication].keyWindow;
            CGFloat x = [recognizer locationOfTouch:0 inView:window].x;
            CGFloat y = [recognizer locationOfTouch:0 inView:window].y;
            NSLog(@"结束时位置===%f========%f",x,y);
            CGPoint location = [recognizer locationInView:weakSelf.collectionView];
            NSIndexPath * indexPath = [weakSelf.collectionView indexPathForItemAtPoint:location];
            if (indexPath.row%8==0) {
                NSLog(@"第一竖排不能放拖拽的view");
                return;
            }
            ScheduleItemModel * item = weakSelf.dataArray[indexPath.row];
            item.taskType = model.taskType;
            item.indexPath = indexPath;
            item.timeLength = weakSelf.timeLength;
            //判断选择的任务存放的日期是否是周末
            if (weakSelf.viemModel.showWeekend) {
                item.isWeekDay = item.horizontalAxis==1||item.horizontalAxis ==7?YES:NO;
                item.hostDate = @"";
            }else{
                item.hostDate = @"";
            }
            
            [weakSelf addTaskViewWithIndexPathItemModel:item];
        }];
    }
    return _scedyleView;
}


///判断拖拽的view是否覆盖
- (BOOL)chargeDifferentView:(ScheduleView*)testView{
    BOOL isCover = NO;
    for (ScheduleView * taskView in self.scheduleDataArray) {
        NSInteger diff = CGRectIntersectsRect(testView.frame, taskView.frame);
        if (diff==1) {
            isCover = YES;
            break;
        }
    }
    return isCover;
}

- (UIButton*)fullScreenBtn{
    if (_fullScreenBtn==nil) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_fullScreenBtn];
        [_fullScreenBtn addTarget:self action:@selector(showFullScreenAction) forControlEvents:UIControlEventTouchUpInside];
        [_fullScreenBtn setBackgroundColor:UIColor.orangeColor];
        [_fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-40);
            make.top.equalTo(self.view).offset(20);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(60);
        }];
    }
    return _fullScreenBtn;
}
- (UIButton*)weekendBtn{
    if (_weekendBtn==nil) {
        _weekendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_weekendBtn];
        [_weekendBtn addTarget:self action:@selector(showWeekendAction) forControlEvents:UIControlEventTouchUpInside];
        [_weekendBtn setBackgroundColor:UIColor.blueColor];
        [_weekendBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_weekendBtn setTitle:@"显示周末" forState:UIControlStateNormal];
        [_weekendBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -_weekendBtn.titleLabel.bounds.size.width)];
        //默认周末是显示的
        _weekendBtn.selected = YES;
        [_weekendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.fullScreenBtn.mas_left).offset(-40);
            make.top.equalTo(self.view).offset(20);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(80);
        }];
    }
    return _weekendBtn;
}

- (ScheduleViewModel*)viemModel{
    if (_viemModel==nil) {
        _viemModel = [[ScheduleViewModel alloc]init];
        _viemModel.showWeekend = YES;
    }
    return _viemModel;
}
#pragma mark-----------------------日历-----------------------
- (void)setCalenderviewUI{
    self.calenderView = [[BXHCalendarView alloc] initWithFrame:CGRectMake(0, 220, self.view.bounds.size.width, 60)];
    [self.view addSubview:self.calenderView];
    self.calenderView.dataSource = self;
    self.calenderView.delegate = self;
    self.calenderView.isShowWeekend = YES;
    [self.calenderView goToToday];

}

#pragma mark-----------------------底部时刻表格-----------------------
- (UICollectionView*)collectionView{
    if (_collectionView==nil) {
        // 使用系统自带的流布局（继承自UICollectionViewLayout）
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // cell间的间距
        layout.minimumLineSpacing  = 0.5;
        layout.minimumInteritemSpacing = 0.5;
        //第一个cell和最后一个cell居中显示（这里我的Demo里忘记改了我用的是160，最后微调数据cell的大小是180）
//        CGFloat margin = (ScreenW - 180) * 0.5;
        layout.sectionInset  = UIEdgeInsetsMake(0, 0, 0, 0);
        // 使用UICollectionView必须设置UICollectionViewLayout属性
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self.view addSubview:_collectionView];
        _collectionView.frame  = CGRectMake(0, CGRectGetMaxY(self.calenderView.frame), SCREEN_WIDTH-ITEM_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(self.calenderView.frame)-20);

//        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.calenderView.mas_bottom).with.offset(30);
//            make.left.equalTo(self.view);
//            make.width.mas_equalTo(SCREEN_WIDTH-(SCREEN_WIDTH-7)/9);
//            make.bottom.equalTo(self.view).offset(-20);
//        }];
        _collectionView.backgroundColor = [UIColor lightGrayColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
//        [_collectionView setShowsHorizontalScrollIndicator:NO];
//        [self.view addSubview:_collectionView];
        // 实现注册cell，其中PageHorizontalCollectionViewCell是我自定义的cell，继承自UICollectionViewCell
        [_collectionView registerClass:[PageHorizontalCollectionViewCell class] forCellWithReuseIdentifier:cellID];
        _collectionView.layer.borderColor = UIColor.lightGrayColor.CGColor;
        _collectionView.layer.borderWidth = 0.5;
        
    }
    return _collectionView;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    self.offsetY = scrollView.contentOffset.y;
    //滚动结束移除弹框 ,移除DM角色
    if (self.detialInfoView) {
        [self.detialInfoView removeFromSuperview];
        self.detialInfoView = nil;
    }
}

/// ** setContentOffset改变会调用scrollViewDidEndScrollingAnimation代理方法 **

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    [self updateTaskViewFrame];
    
}
- (void)updateTaskViewFrame{
    if (self.viemModel.showWeekend) {
        [UIView animateWithDuration:0.5 animations:^{
                            
                    } completion:^(BOOL finished) {
                        for (ScheduleView * taskView in self.scheduleDataArray) {
                            if (!taskView.itemModel.isWeekDay) {
                                //判断是不是显示周末的时候添加的
                                if(taskView.isShowWeekendAdd){
                                    //使用初始化的
                                    NSInteger item = taskView.indexPath.item;
                                    NSIndexPath * updateIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
                                    PageHorizontalCollectionViewCell * cell  = (PageHorizontalCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:updateIndexPath];
                                    if (cell) {
                                        CGRect frame = CGRectMake(cell.frame.origin.x, taskView.frame.origin.y,ITEM_WIDTH, taskView.frame.size.height);
                                        taskView.frame = frame;
                                        NSLog(@"周末显示的frame=====%@",taskView);
                                    }else{
                                        NSLog(@"不在可视区域内，无法找到cell====%ld",(long)item);
//                                            self.needOpenCellIndexPath = updateIndexPath;
                                      
                                    }
                                }else{
                                    NSInteger item = taskView.indexPath.item;
                                    //item转化，索引值转化
                                    item = item + (long)(item/6 +1) * 2  +  1;
                                    NSIndexPath * updateIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
                                    PageHorizontalCollectionViewCell * cell  = (PageHorizontalCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:updateIndexPath];
                                    if (cell) {
                                        CGRect frame = CGRectMake(cell.frame.origin.x, taskView.frame.origin.y,ITEM_WIDTH, taskView.frame.size.height);
                                        taskView.frame = frame;

                                    }else{
                                        NSLog(@"不在可视区域内，无法找到cell");
                                       
                                    }
                                }
                            }else{
                                taskView.hidden = NO;
                            }
                        }
                    }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
                        
                    } completion:^(BOOL finished) {
                        for (ScheduleView * taskView in self.scheduleDataArray) {
                            if (!taskView.itemModel.isWeekDay) {
                                //只需要处理非周末的日程
                                if(taskView.isShowWeekendAdd){
                                    NSInteger item = taskView.indexPath.item;
                                    //item转化，索引值转化
                                    item = item - (long)item/8 * 2  -  1;
                                    NSIndexPath * updateIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
                                    PageHorizontalCollectionViewCell * cell  = (PageHorizontalCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:updateIndexPath];
                                    if (cell) {
                                        CGRect frame = CGRectMake(cell.frame.origin.x, taskView.frame.origin.y,ITEM_WIDTH5, taskView.frame.size.height);
                                        taskView.frame = frame;
                                        NSLog(@"非周末显示的frame=====%@",taskView);

                                    }else{
                                        NSLog(@"不在可视区域内，无法找到cell===%ld",(long)item);
//                                            self.needOpenCellIndexPath = updateIndexPath;
                                       

                                    }
                                }else{
                                    NSInteger item = taskView.indexPath.item;
                                    NSIndexPath * updateIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
                                    PageHorizontalCollectionViewCell * cell  = (PageHorizontalCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:updateIndexPath];
                                    if (cell) {
                                        CGRect frame = CGRectMake(cell.frame.origin.x, taskView.frame.origin.y,ITEM_WIDTH5, taskView.frame.size.height);
                                        taskView.frame = frame;
                                    }else{
                                        NSLog(@"不在可视区域内，无法找到cell");
                                       
                                    }
                                }
                            }else{
                                taskView.hidden = YES;
                            }
                        }
                    }];
        }
}
@end
