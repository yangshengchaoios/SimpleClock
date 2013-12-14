//
//  Timer.h
//  Notifier
//
//  Created by yshch on 12-2-11.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseAccess.h"
#import "singleton.h"
#import "ClockList.h"
#import "SoundList.h"

@interface Timer : UIViewController
- (IBAction)btnConfig:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *currentTime;
@end
