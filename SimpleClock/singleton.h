//
//  singleton.h
//  Notifier
//
//  Created by yshch on 12-2-13.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVFoundation/AVFoundation.h"
#import "AudioToolbox/AudioToolbox.h"
#import "ClockList.h"
#import "SoundList.h"
@class ClockList;

@interface singleton : NSObject<AVAudioPlayerDelegate>{
    NSInteger currentClockIndex;    //当前闹钟对象在数组中的下标
    ClockList *currentClock;        //当前编辑的闹钟对象
    SoundList *currentSound;        //当前操作的声音对象
    BOOL isAddClock;                //是添加还是编辑闹钟
    BOOL isAddSound;                //是否添加声音
    NSMutableArray *allClocks;      //所有闹钟对象数组  
    NSMutableArray *allSounds;      //所有声音文件数组
}
+(singleton *) sharedSingleton;
@property (nonatomic,retain) AVAudioPlayer *musicPlayer;

@property (nonatomic,assign) NSInteger currentClockIndex;
@property (nonatomic,retain) ClockList *currentClock;
@property (nonatomic,retain) SoundList *currentSound;
@property (nonatomic,assign) BOOL isAddClock;
@property (nonatomic,assign) BOOL isAddSound;
@property (nonatomic,retain) NSMutableArray *allClocks;
@property (nonatomic,retain) NSMutableArray *allSounds;

-(void) initAllClock;
-(void) initAllSounds:(int) flag;
-(NSString *) NSDateToNSString:(NSDate *)date Format:(NSString *) format;
-(NSDate *) NSStringToNSDate:(NSString *)string Format:(NSString *) format;
- (void)playMusic:(NSString *) musicfile;
- (void)stopMusic;

- (NSString *)documentPath;
- (NSString *)nativeDocumentPath;
- (NSString *)boundlePath;

-(SoundList *) getClockMusic:(ClockList *)clock;
@end
