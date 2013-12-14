//
//  SoundDetail.h
//  Notifier
//
//  Created by yshch on 12-2-16.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "singleton.h"
#import "DataBaseAccess.h"
#import "AVFoundation/AVFoundation.h"
#import "AudioToolbox/AudioToolbox.h"

@interface SoundDetail : UIViewController<UIGestureRecognizerDelegate,UITextFieldDelegate,UIActionSheetDelegate,AVAudioPlayerDelegate>{
    NSTimer *timer;
}
@property (nonatomic,retain) AVAudioPlayer *musicPlayer;
@property (retain, nonatomic) IBOutlet UISlider *processSlider;

@property (retain, nonatomic) IBOutlet UITextField *textFieldSoundName;
@property (retain, nonatomic) IBOutlet UITextView *textViewSoundDes;
@property (retain, nonatomic) IBOutlet UIImageView *imageSound;

@property (retain, nonatomic) IBOutlet UIButton *buttonPlay;
@property (retain, nonatomic) IBOutlet UIButton *buttonDelete;

- (IBAction)processSliderChanged:(UISlider *)sender;
- (IBAction)playMusicAction:(id)sender;
- (IBAction)deleteMusicAction:(id)sender;
@end
