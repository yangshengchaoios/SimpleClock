//
//  RecordTableView.h
//  Notifier
//
//  Created by shengchao yang on 12-2-25.
//  Copyright (c) 2012年 foxhis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "singleton.h"
#import "DataBaseAccess.h"
#import "SoundTableCell.h"
#import "AVFoundation/AVFoundation.h"
#import "AudioToolbox/AudioToolbox.h"


@interface RecordTableView : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,AVAudioPlayerDelegate>

@property (nonatomic,retain) AVAudioRecorder *soundRecorder;
@property (retain, nonatomic) IBOutlet UIButton *buttonRecord;
@property (nonatomic,retain) NSString *fileUrl;
@property (nonatomic,retain) NSString *fileName;
@property (retain, nonatomic) IBOutlet UILabel *labelRecordSta;

- (IBAction)recordMusicAction:(id)sender;
@end
