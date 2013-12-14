//
//  EditTime.h
//  Notifier
//
//  Created by yshch on 12-2-11.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditTime : UIViewController<UIPickerViewDelegate> 
@property (retain, nonatomic) IBOutlet UIPickerView *timePicker;
@property (retain, nonatomic) IBOutlet UILabel *labelAlarmTime;
@end
