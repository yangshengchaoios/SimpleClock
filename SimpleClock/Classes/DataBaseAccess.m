//
//  DataBaseAccess.m
//  Notifier
//
//  Created by yshch on 12-2-13.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "DataBaseAccess.h"
#import "FMDatabase.h"
#import "ClockList.h"
#import "SoundList.h"
#import "singleton.h"

@implementation DataBaseAccess
+(NSMutableArray *) SelectClock:(NSString *)sql{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath=[paths objectAtIndex:0];
    NSString *path=[docsPath stringByAppendingPathComponent:@"Notifier.sqlite"];
    FMDatabase *db =[FMDatabase databaseWithPath:path];
    if (![db open]) {
        DebugLog(@"could not open db");
        return nil;
    }
    
    FMResultSet *rs=[db executeQuery:sql];
    NSMutableArray *result=[NSMutableArray new];
    while ([rs next]) {
        ClockList *tmpClock=[ClockList new];
        [tmpClock setClockid:num([rs intForColumn:@"clockid"])];
        [tmpClock setClockName:[rs stringForColumn:@"clockName"]];
        [tmpClock setSoundRowid:num([rs intForColumn:@"soundRowid"])];
        [tmpClock setSoundName:[rs stringForColumn:@"soundName"]];
        [tmpClock setRepeat:[rs stringForColumn:@"repeat"]];
        [tmpClock setAlarmTime:[rs stringForColumn:@"alarmTime"]];
        [tmpClock setIsUsed:[rs stringForColumn:@"isUsed"]];
        [result addObject:tmpClock];
    }
    [rs close];
    [db close];    
    return result;
}
+(NSMutableArray *) SelectSound:(NSString *)sql{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath=[paths objectAtIndex:0];
    NSString *path=[docsPath stringByAppendingPathComponent:@"Notifier.sqlite"];
    FMDatabase *db =[FMDatabase databaseWithPath:path];
    if (![db open]) {
        DebugLog(@"could not open db");
        return nil;
    }
    
    FMResultSet *rs=[db executeQuery:sql];
    NSMutableArray *result=[NSMutableArray new];
    while ([rs next]) {
        SoundList *tmpSound=[SoundList new];
        [tmpSound setSoundid:num([rs intForColumn:@"soundid"])];
        [tmpSound setSoundName:[rs stringForColumn:@"soundName"]];
        [tmpSound setDescription:[rs stringForColumn:@"description"]];
        [tmpSound setFileName:[rs stringForColumn:@"fileName"]];
        [tmpSound setFileUrl:[rs stringForColumn:@"fileUrl"]];
        [tmpSound setImageName:[rs stringForColumn:@"imageName"]];
        [tmpSound setIsSystem:[rs stringForColumn:@"isSystem"]];
        [result addObject:tmpSound];
    }
    [rs close];
    [db close];    
    return result;
}
+(void) Update:(NSString *)sql{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath=[paths objectAtIndex:0];
    NSString *path=[docsPath stringByAppendingPathComponent:@"Notifier.sqlite"];
    FMDatabase *db =[FMDatabase databaseWithPath:path];
    if (![db open]) {
        DebugLog(@"could not open db");
        return;
    }
    [db executeUpdate:sql];
    [db close]; 
}
@end
