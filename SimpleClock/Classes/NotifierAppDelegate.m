//
//  NotifierAppDelegate.m
//  Notifier
//
//  Created by Brandon Trebitowski on 7/29/10.
//  Copyright RightSprite 2010. All rights reserved.
//

#import "NotifierAppDelegate.h"
#import "NSString+Additions.h"

@implementation NotifierAppDelegate
@synthesize window;
@synthesize timer, navigationController;
@synthesize alarmingClock;
@synthesize isTemp;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    application.applicationIconBadgeNumber = 0;//应用程序右上角的数字消失     
    
    
    addNObserver(@selector(turnToClock), @"turnToClock");
    addNObserver(@selector(turnToTimer), @"turnToTimer");
    
    if (initDB) {
        DebugLog(@"建库、建表");
        NSString *table_ClockListSql=@"create table if not exists ClockList(clockid integer primary key autoincrement, clockName text, soundRowid integer, soundName text, repeat text, alarmTime text, isUsed char(1))";
        NSString *table_SoundListSql=@"create table if not exists SoundList(soundid integer primary key autoincrement, soundName text, description text, fileName text, fileUrl text, imageName text, isSystem char(1))";
        [DataBaseAccess Update:table_ClockListSql];//建库、建表
        [DataBaseAccess Update:table_SoundListSql];//建库、建表
    }else{//拷贝数据库文件
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"Notifier" ofType:@"sqlite"];
        NSString *desPath= [NSString stringWithFormat:@"%@/Notifier.sqlite",DOCUMENT];
        NSFileManager *fileManaget = [NSFileManager defaultManager];
        if (![fileManaget fileExistsAtPath:desPath]) {
            DebugLog(@"拷贝数据库文件...");
            DebugLog(@"sourcePath=%@", sourcePath);
            DebugLog(@"desPath=%@", desPath);
            
            [fileManaget copyItemAtPath:sourcePath toPath:desPath error:nil];
        }else{
            DebugLog(@"数据库已经存在，不需要拷贝！");
        }
    }
    isTemp = NO;
    isEnterForeground = NO;    
    
    [window addSubview:timer.view];
    [window makeKeyAndVisible];

    return YES;
}
//转到闹钟管理界面
-(void) turnToClock{
    [UIView beginAnimations:@"flipping view" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseIn];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView: window cache: YES];
    [UIView commitAnimations];
    [window addSubview:navigationController.view];
}
//回到时间界面
-(void) turnToTimer{
    [UIView beginAnimations:@"flipping view" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseIn];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView: window cache: YES];
    [UIView commitAnimations];
    [window addSubview:timer.view];
}

- (void)startClock:(ClockList *) alarmClock {   
    for (int i=0; i <= (isTemp ? 0 : 7); i++) {//删除所有与该闹钟相关的通知
        NSString *notifID=[NSString stringWithFormat:@"%d_%d",[alarmClock.clockid intValue],i];
        [self shutdownClock:notifID]; 
    }
    
    if ([alarmClock.isUsed isEqualToString:@"0"]) {
        return;//假如闹钟不启用，则返回
    }
     
    NSString *strNowDate = [APPSESSION NSDateToNSString:[NSDate date] Format:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [APPSESSION NSStringToNSDate:strNowDate Format:@"yyyy-MM-dd HH:mm:ss"];//当前时间
    
    NSString *strClockDate = [NSString stringWithFormat:@"%@ %@:00",[APPSESSION NSDateToNSString:[NSDate date] Format:@"yyyy-MM-dd"],alarmClock.alarmTime];
    NSDate *fireDate = [APPSESSION NSStringToNSDate:strClockDate Format:@"yyyy-MM-dd HH:mm:ss"];//当前闹钟触发的时间
    
    NSDateComponents *nsdc = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSEraCalendarUnit | 
    NSYearCalendarUnit | 
    NSMonthCalendarUnit | 
    NSDayCalendarUnit | 
    NSHourCalendarUnit | 
    NSMinuteCalendarUnit | 
    NSSecondCalendarUnit | 
    NSWeekCalendarUnit | 
    NSWeekdayCalendarUnit | 
    NSWeekdayOrdinalCalendarUnit | 
    NSQuarterCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    nsdc = [calendar components:unitFlags fromDate: fireDate];
    
	//查找对应的铃声url地址
    SoundList *tempMusic = ClockMusic(alarmClock);
    NSString *musicPath = tempMusic.fileName;
    if ([tempMusic.isSystem isEqualToString:@"0"]) {
        musicPath = tempMusic.fileUrl;
    }
    
    if ([alarmClock.repeat isContainsString:@"T"]) {//表示有重复
        DebugLog(@"有重复：%@", alarmClock.repeat);
        for (int i=0; i<7; i++) {
            NSString *temp = [alarmClock.repeat substringWithRange:NSMakeRange(i,1)];
            if ([temp isEqualToString:@"F"]) {
                continue;
            }            
            UILocalNotification *notif = [[UILocalNotification alloc] init];
            NSDictionary *infoDict =[NSDictionary dictionaryWithObjectsAndKeys:
                                     num([alarmClock.clockid intValue]),@"clockid",
                                     alarmClock.clockName,@"clockName",
                                     alarmClock.alarmTime,@"alarmTime",
                                     alarmClock.repeat,@"repeat",
                                     alarmClock.isUsed,@"isUsed",
                                     num([alarmClock.soundRowid intValue]),@"soundRowid",
                                     tempMusic.imageName,@"imageName",
                                     tempMusic.soundName,@"musicName",
                                     musicPath,@"musicPath",
                                     [NSString stringWithFormat:@"%d_%d",[alarmClock.clockid intValue],(i+1)],@"notifID",
                                     nil];
            
            int weekday = nsdc.weekday;//星期
            int tempDay = i + 1 - weekday;
            if (tempDay == 0 && [nowDate compare:fireDate] > 0) { //当有重复的时候，且今天时间已经过去，则把通知放到下周的今天触发
                tempDay = -1;
            }
            int days = (tempDay >= 0 ? tempDay : tempDay + 7);//向后延迟的天数
            NSDate *repeatFireDate = [[calendar dateFromComponents:nsdc] dateByAddingTimeInterval:3600 * 24 * days];
            
            notif.fireDate = repeatFireDate;
            notif.timeZone = [NSTimeZone defaultTimeZone];
            notif.alertBody = alarmClock.clockName;
            DebugLog(@"alertLaunchImage=%@,musicPath=%@",tempMusic.imageName,musicPath);
            notif.alertLaunchImage = tempMusic.imageName;
            notif.soundName = musicPath;
            notif.repeatInterval = NSWeekCalendarUnit; //每周重复一次
            notif.applicationIconBadgeNumber = 0;//设置右上角的数字
            notif.userInfo = infoDict;
            [[UIApplication sharedApplication] scheduleLocalNotification:notif];
            DebugLog(@"send notification:%@", notif);
            [notif release];
        }
    }else{//没有重复
        DebugLog(@"没有重复：%@", alarmClock.repeat);
        
        NSDate *noRepeatFireDate = nil;
        if ([nowDate compare:fireDate] > 0) {//假如在保存的时候，发现时间已经过去了，则把通知时间调后一天
            noRepeatFireDate = [[calendar dateFromComponents:nsdc] dateByAddingTimeInterval:3600 * 24 * 1];//延迟一天
        }else{
            noRepeatFireDate = [[calendar dateFromComponents:nsdc] dateByAddingTimeInterval:3600 * 24 * 0];
        }
        
        UILocalNotification *notif = [[UILocalNotification alloc] init];
        NSDictionary *infoDict =[NSDictionary dictionaryWithObjectsAndKeys:
                                 num([alarmClock.clockid intValue]),@"clockid",
                                 alarmClock.clockName,@"clockName",
                                 alarmClock.alarmTime,@"alarmTime",
                                 alarmClock.repeat,@"repeat",
                                 alarmClock.isUsed,@"isUsed",
                                 num([alarmClock.soundRowid intValue]),@"soundRowid",
                                 tempMusic.imageName,@"imageName",
                                 tempMusic.soundName,@"musicName",
                                 musicPath,@"musicPath",
                                 [NSString stringWithFormat:@"%d_0",[alarmClock.clockid intValue]],@"notifID",
                                 nil];
        
        notif.fireDate = noRepeatFireDate;
        notif.timeZone = [NSTimeZone defaultTimeZone];
        notif.alertBody = alarmClock.clockName;
        notif.alertLaunchImage = tempMusic.imageName;
        notif.soundName = musicPath;
        notif.applicationIconBadgeNumber = 0;//设置右上角的数字
        notif.userInfo = infoDict;
        [[UIApplication sharedApplication] scheduleLocalNotification:notif];
        DebugLog(@"send notification:%@", notif);
        [notif release];
    }
}

- (void)shutdownClock:(NSString *) notifID {
	NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
	for(UILocalNotification *notif in localNotifications) {
		if ([notifID isEqualToString:(NSString *)[[notif userInfo] objectForKey:@"notifID"]]) {
            DebugLog(@"shutdown notification:%@", notif);
			[[UIApplication sharedApplication] cancelLocalNotification:notif];
		}
	}
}

- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
    NSLog(@"didReceiveLocalNotification");
    DebugLog(@"receive notification:%@", notif);
    if (alarmingClock == nil) {
        alarmingClock = [ClockList new];
    }
    alarmingClock.clockid = (NSNumber *)[[notif userInfo] objectForKey:@"clockid"];
    alarmingClock.clockName = (NSString *)[[notif userInfo] objectForKey:@"clockName"];
    alarmingClock.alarmTime = (NSString *)[[notif userInfo] objectForKey:@"alarmTime"];
    alarmingClock.repeat = (NSString *)[[notif userInfo] objectForKey:@"repeat"];
    alarmingClock.isUsed = (NSString *)[[notif userInfo] objectForKey:@"isUsed"];
    alarmingClock.soundRowid = (NSNumber *)[[notif userInfo] objectForKey:@"soundRowid"];
    
    if (!isEnterForeground) {
        //播放铃声
        SoundList *tempSound = (SoundList *)ClockMusic(alarmingClock);
        NSString *musicPath=[NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath],tempSound.fileName];
        if ([tempSound.isSystem isEqualToString:@"0"]) {
            musicPath = tempSound.fileUrl;
        }	
        [APPSESSION playMusic:musicPath];
        
        //确定是否取消
        UIAlertView* alert =[[ UIAlertView alloc] initWithTitle:(NSString *)[[notif userInfo] objectForKey:@"clockName"]
                                                        message:[NSString stringWithFormat:@"到点了！ %@", (NSString *)[[notif userInfo] objectForKey:@"alarmTime"]]
                                                       delegate:self 
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:@"延迟10分钟",nil];
        UIImageView *imgv=[[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 60, 50)];
        imgv.image = [UIImage imageNamed:(NSString *)[[notif userInfo] objectForKey:@"imageName"]];
        [alert addSubview:imgv];
        [imgv release];
        [alert show];
        [alert release];
    }
    isEnterForeground=NO;
    
    if (![alarmingClock.repeat isContainsString:@"T"]) { //如果该通知不需要重复的话，就注销掉
        [self shutdownClock:[NSString stringWithFormat:@"%d_0",[alarmingClock.clockid intValue]]];
        [DataBaseAccess Update:[NSString stringWithFormat: @"update ClockList set isUsed='0' where clockid=%d", [alarmingClock.clockid intValue]]];
    }
    app.applicationIconBadgeNumber = 0;//应用程序右上角的数字消失
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    DebugLog(@"clockName=%@,alarmTime=%@", alarmingClock.clockName,alarmingClock.alarmTime);
    if (buttonIndex==alertView.cancelButtonIndex) {
        DebugLog(@"Close");
        isTemp = NO;
    }else{
        DebugLog(@"Snooze 10 minutes");
        isTemp = YES;
        NSString *h = [alarmingClock.alarmTime substringWithRange:NSMakeRange(0, 2)];
        NSString *m = [alarmingClock.alarmTime substringWithRange:NSMakeRange(3, 2)];
        int nm = ([m intValue] + 10) % 60;//新的minute
        int nh = ([h intValue] + ([m intValue] > nm ? 1 : 0)) % 24;//新的hour
        DebugLog(@"新的时间%@", [NSString stringWithFormat:@"%02d:%02d",nh, nm]);
        alarmingClock.alarmTime = [NSString stringWithFormat:@"%02d:%02d",nh, nm];
        alarmingClock.repeat = @"FFFFFFF";//临时通知的话，关闭重复标志
        [self startClock:alarmingClock];
    }
    [APPSESSION stopMusic];//关闭铃声
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"applicationWillResignActive");
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"applicationDidEnterBackground");
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"applicationWillEnterForeground");
    isEnterForeground = YES;
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"applicationDidBecomeActive");
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"applicationWillTerminate");
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    NSLog(@"applicationDidReceiveMemoryWarning");
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    removeNObserver(@"turnToClock");
    removeNObserver(@"turnToTimer");
    
    [window release];
    [timer release];
    [navigationController release];
    [alarmingClock release];
    [super dealloc];
}


@end
