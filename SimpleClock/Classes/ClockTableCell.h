//
//  ClockTableCell.h
//  Notifier
//
//  Created by yshch on 12-2-16.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockList.h"
#import "singleton.h"

@interface ClockTableCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *labelTimeAndName;
@property (retain, nonatomic) IBOutlet UILabel *labelSoundName;
@property (retain, nonatomic) IBOutlet UILabel *labelClockIsUsed;

-(void) setData:(ClockList *)oneClock;
@end
