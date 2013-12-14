//
//  NotifierAppDelegate.h
//  Notifier
//
//  Created by Brandon Trebitowski on 7/29/10.
//  Copyright RightSprite 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseAccess.h"
#import "Timer.h"
#import "singleton.h"

@class Timer;

@interface NotifierAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    Timer *timer;
    UINavigationController *navigationController;
    BOOL isEnterForeground;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (retain, nonatomic) IBOutlet Timer *timer;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic,retain) ClockList *alarmingClock;
@property (nonatomic,assign) BOOL isTemp;

- (NSString *)applicationDocumentsDirectory;
- (void)startClock:(ClockList *) alarmingClock;
- (void)shutdownClock:(NSString *) alarmClock;
@end

