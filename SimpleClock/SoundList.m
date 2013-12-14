//
//  SoundList.m
//  Notifier
//
//  Created by yshch on 12-2-15.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "SoundList.h"

@implementation SoundList

@synthesize soundid;
@synthesize soundName;
@synthesize description;
@synthesize fileName,fileUrl;
@synthesize imageName;
@synthesize isSystem;

//=========================================================== 
// - (id)init
//
//=========================================================== 
- (id)init
{
    self = [super init];
    if (self) {
        soundid = num(-1);
        soundName = @"default music";
        description = @"";
        fileName = @"default_sound.caf";
        imageName = @"default_img.png";
        fileUrl=@"";
        isSystem=@"1";
    }
    return self;
}

//=========================================================== 
// dealloc
//=========================================================== 
- (void)dealloc{
    [isSystem release];
    isSystem = nil;
    [fileUrl release];
    fileUrl = nil;
    [soundid release];
    soundid = nil;
    [soundName release];
    soundName = nil;
    [description release];
    description = nil;
    [fileName release];
    fileName = nil;
    [imageName release];
    imageName = nil;
    [super dealloc];
}

@end
