//
//  DataBaseAccess.h
//  Notifier
//
//  Created by yshch on 12-2-13.
//  Copyright (c) 2012年 . All rights reserved.
//
#import <Foundation/Foundation.h>
@interface DataBaseAccess : NSObject
+(NSMutableArray *) SelectClock:(NSString *)sql;
+(NSMutableArray *) SelectSound:(NSString *)sql;
+(void) Update:(NSString *)sql;
@end
