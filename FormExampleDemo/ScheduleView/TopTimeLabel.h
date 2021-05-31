//
//  TopTimeLabel.h
//  FormExampleDemo
//
//  Created by mwj on 2021/5/26.
//  Copyright © 2021 lx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
 VerticalAlignmentTop = 0, // default
 VerticalAlignmentMiddle,
 VerticalAlignmentBottom,
}VerticalAlignment;

NS_ASSUME_NONNULL_BEGIN

@interface TopTimeLabel : UILabel

@property (nonatomic) VerticalAlignment verticalAlignment;

@end

NS_ASSUME_NONNULL_END
