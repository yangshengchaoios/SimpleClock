//
//  singleton.m
//  Notifier
//
//  Created by yshch on 12-2-13.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "singleton.h"
#import "DataBaseAccess.h"

@implementation singleton

@synthesize currentClock,currentSound;
@synthesize allClocks,allSounds;
@synthesize currentClockIndex,isAddClock,isAddSound;
@synthesize musicPlayer;

+(singleton *)sharedSingleton {
	static singleton *sharedSingleton;
	@synchronized(self)
	{
		if (!sharedSingleton) {
			if (!sharedSingleton)
				sharedSingleton=[[singleton alloc] init];
		}
		return sharedSingleton;
	}
}

-(void) initAllClock{
    if (allClocks != nil && [allClocks count]>0) {
        [allClocks removeAllObjects];
    }
    allClocks=[DataBaseAccess SelectClock:@"select * from ClockList order by alarmTime asc"];
}

-(void) initAllSounds:(int) flag{
    if (allSounds != nil && [allSounds count]>0) {
        [allSounds removeAllObjects];
    }
    if (flag == 1) {
        allSounds=[DataBaseAccess SelectSound:@"select * from SoundList where isSystem='1' order by soundid asc"];
    }else if(flag == 2){
        allSounds=[DataBaseAccess SelectSound:@"select * from SoundList where isSystem='0' order by soundid asc"];
    }else{
        allSounds=[DataBaseAccess SelectSound:@"select * from SoundList order by soundid asc"];
    }
}

//NSDate->NSString
-(NSString *) NSDateToNSString:(NSDate *)date Format:(NSString *) format{    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: format];
    if (date == nil) {
        date = [NSDate date];
    }
    NSString *dateString = [formatter stringFromDate:date];
    [formatter release];
    return dateString;
}

//NSString->NSDate
-(NSDate *) NSStringToNSDate:(NSString *)string Format:(NSString *) format{    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: format];
    NSDate *date = [formatter dateFromString :string];
    [formatter release];
    return date;
}

// 返回程序安装后Ipad设备的沙盒目录
- (NSString *)documentPath{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}
// 返回程序打包中的资源目录
- (NSString *)nativeDocumentPath{
	return [[self boundlePath] stringByAppendingPathComponent:@"/"];
}
// 返回程序打包的资源包
- (NSString *)boundlePath {
	return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"NotifierResource.bundle"];
}

- (void)playMusic:(NSString *) musicPath{
	if (musicPlayer) {
        if (musicPlayer.isPlaying) {
            [musicPlayer stop];
        }
		[musicPlayer release];
        musicPlayer = nil;
	}    
	musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:musicPath] error:nil];
	musicPlayer.numberOfLoops = 0;
	musicPlayer.volume = 1;
    musicPlayer.delegate = self;
    musicPlayer.meteringEnabled = YES;
	[musicPlayer prepareToPlay];
    [musicPlayer play];
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {//铃声播放完成后，自动调用的委托方法
	[self stopMusic];
}
- (void)stopMusic{
    if (musicPlayer && musicPlayer.isPlaying) {
        DebugLog(@"stopping playmusic");
        [musicPlayer stop];
	}
}

-(SoundList *) getClockMusic:(ClockList *)oneClock{
    SoundList *oneSound=nil;
    NSMutableArray *tempSoundArray = [DataBaseAccess SelectSound:[NSString stringWithFormat:@"select * from SoundList where soundid=%d",[oneClock.soundRowid intValue]]];
    if ([tempSoundArray count] > 0) {
        oneSound = (SoundList *)[tempSoundArray lastObject];
    }
    return oneSound;
}

-(id) init
{
	self = [super init];
	if (self) {
        allClocks=[[NSMutableArray alloc] init];
        allSounds=[[NSMutableArray alloc] init];
//        musicPlayer=[[AVAudioPlayer alloc] init];
	}
	return self;
}
//=========================================================== 
// dealloc
//=========================================================== 
- (void)dealloc{
    [musicPlayer release];
    musicPlayer = nil;
    
    [currentClock release];
    currentClock=nil;
    [currentSound release];
    currentSound = nil;
    
    [allClocks release];
    allClocks = nil;
    
    [allSounds release];
    allSounds = nil;
	
    [super dealloc];
}
@end
