//
//  TaskInfoCell.h
//  FormExampleDemo
//
//  Created by mwj on 2021/6/1.
//  Copyright © 2021 lx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *departmentNameLab;

@property (weak, nonatomic) IBOutlet UILabel *departmentLab;

@property (weak, nonatomic) IBOutlet UILabel *doctorLab;

@property (weak, nonatomic) IBOutlet UILabel *doctorNameLab;

@end

NS_ASSUME_NONNULL_END
