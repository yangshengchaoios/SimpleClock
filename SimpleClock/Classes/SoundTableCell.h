//
//  SoundTableCell.h
//  Notifier
//
//  Created by yshch on 12-2-16.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundList.h"
#import "singleton.h"

@interface SoundTableCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *labelSoundName;
@property (retain, nonatomic) IBOutlet UIImageView *imageSound;

-(void) setData:(SoundList *)oneSound;
@end
