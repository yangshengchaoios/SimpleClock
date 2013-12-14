//
//  ClockList.m
//  Notifier
//
//  Created by yshch on 12-2-14.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "ClockList.h"

@implementation ClockList

@synthesize clockid;
@synthesize clockName;
@synthesize soundRowid;
@synthesize soundName;
@synthesize repeat;
@synthesize isUsed;
@synthesize alarmTime;

//=========================================================== 
// - (id)init
//
//=========================================================== 
- (id)init
{
    self = [super init];
    if (self) {
        clockid = num(1);
        clockName = @"新闹钟名称";
        soundRowid = num(1);
        soundName = @"默认铃声";
        repeat = @"FFFFFFF";
        isUsed = @"1";
        alarmTime = @"";
    }
    return self;
}


//=========================================================== 
// dealloc
//=========================================================== 
- (void)dealloc
{
    [clockid release];
    clockid = nil;
    [soundRowid release];
    soundRowid = nil;
    [soundName release];
    soundName = nil;
    [clockName release];
    clockName = nil;
    [repeat release];
    repeat = nil;
    [isUsed release];
    isUsed = nil;
    [alarmTime release];
    alarmTime = nil;
    
    [super dealloc];
}

@end
