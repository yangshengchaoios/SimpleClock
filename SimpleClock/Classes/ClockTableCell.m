//
//  ClockTableCell.m
//  Notifier
//
//  Created by yshch on 12-2-16.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "ClockTableCell.h"

@implementation ClockTableCell
@synthesize labelTimeAndName;
@synthesize labelSoundName;
@synthesize labelClockIsUsed;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        labelTimeAndName=[[UILabel alloc] initWithFrame:CGRectOffset(CGRectFromString(@"{{20, 11}, {230, 26}}"), 0, 0)];
        [labelTimeAndName setFont:[UIFont boldSystemFontOfSize:22.0f]];
        [labelTimeAndName setTextColor:[UIColor blackColor]];
        [labelTimeAndName setBackgroundColor:[UIColor clearColor]];
        [self addSubview:labelTimeAndName];
        
        labelSoundName=[[UILabel alloc] initWithFrame:CGRectOffset(CGRectFromString(@"{{20, 43}, {230, 21}}"), 0, 0)];
        [labelSoundName setFont:[UIFont boldSystemFontOfSize:18.0f]];
        [labelSoundName setTextColor:[UIColor darkGrayColor]];
        [labelSoundName setBackgroundColor:[UIColor clearColor]];
        [self addSubview:labelSoundName];
        
        labelClockIsUsed=[[UILabel alloc] initWithFrame:CGRectOffset(CGRectFromString(@"{{258, 24}, {42, 21}}"), 0, 0)];
        [labelClockIsUsed setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [labelClockIsUsed setTextColor:[UIColor grayColor]];
        [labelClockIsUsed setBackgroundColor:[UIColor clearColor]];
        [self addSubview:labelClockIsUsed];
    }
    return self;
}

-(void) setData:(ClockList *)oneClock{
    labelTimeAndName.text = [NSString stringWithFormat:@"%@ %@", oneClock.alarmTime, oneClock.clockName];
    labelSoundName.text=oneClock.soundName;
    
    if ([oneClock.isUsed isEqualToString:@"1"]) {
        labelClockIsUsed.text=@"开";
         [labelClockIsUsed setTextColor:[UIColor blackColor]];
    }else{
        labelClockIsUsed.text=@"关";
         [labelClockIsUsed setTextColor:[UIColor grayColor]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
    [labelTimeAndName release];
    [labelSoundName release];
    [labelClockIsUsed release];
    [super dealloc];
}
@end
