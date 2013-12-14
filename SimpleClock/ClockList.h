//
//  ClockList.h
//  Notifier
//
//  Created by yshch on 12-2-14.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClockList : NSObject

@property (nonatomic, assign) NSNumber * clockid;
@property (nonatomic, retain) NSString * clockName;
@property (nonatomic, assign) NSNumber * soundRowid;
@property (nonatomic, retain) NSString * soundName;
@property (nonatomic, retain) NSString * repeat;
@property (nonatomic, retain) NSString * alarmTime;
@property (nonatomic, retain) NSString * isUsed;

@end
