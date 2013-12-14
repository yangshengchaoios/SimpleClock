//
//  SoundTableCell.m
//  Notifier
//
//  Created by yshch on 12-2-16.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "SoundTableCell.h"

@implementation SoundTableCell
@synthesize labelSoundName;
@synthesize imageSound;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setData:(SoundList *)oneSound{
    labelSoundName.text=oneSound.soundName;
    imageSound.image=[UIImage imageNamed:oneSound.imageName];
    
    if ([oneSound.soundid intValue] == [APPSESSION.currentClock.soundRowid intValue]) {
        self.accessoryType=UITableViewCellAccessoryCheckmark;
    }else{
        self.accessoryType=UITableViewCellAccessoryNone;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
    [labelSoundName release];
    [imageSound release];
    [super dealloc];
}
@end
