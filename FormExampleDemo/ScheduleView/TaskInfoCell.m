//
//  TaskInfoCell.m
//  FormExampleDemo
//
//  Created by mwj on 2021/6/1.
//  Copyright © 2021 lx. All rights reserved.
//

#import "TaskInfoCell.h"

@implementation TaskInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.departmentNameLab.preferredMaxLayoutWidth = 30;
//    self.doctorNameLab.preferredMaxLayoutWidth = 30;
    [self.departmentLab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    [self.doctorLab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
