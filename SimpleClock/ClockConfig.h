//
//  ClockConfig.h
//  Notifier
//
//  Created by yshch on 12-2-11.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClockConfig : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
@property (retain, nonatomic) IBOutlet UITableViewCell *cellSwitch;
@property (retain, nonatomic) IBOutlet UITableViewCell *cellTime;
@property (retain, nonatomic) IBOutlet UITableViewCell *cellName;
@property (retain, nonatomic) IBOutlet UITableViewCell *cellSound;
@property (retain, nonatomic) IBOutlet UITableViewCell *cellRepeat;
@property (retain, nonatomic) IBOutlet UITableViewCell *cellDelete;

@property (retain, nonatomic) IBOutlet UILabel *cellTimeDetail;
@property (retain, nonatomic) IBOutlet UILabel *cellNameDetail;
@property (retain, nonatomic) IBOutlet UILabel *cellSoundDetail;
@property (retain, nonatomic) IBOutlet UILabel *cellRepeatDetail;

@property (retain, nonatomic) IBOutlet UISwitch *cellSwitchButton;

- (IBAction)saveClock:(id)sender;
- (IBAction)cellSwitchButtonClicked:(id)sender;
@end
