//
//  NSString+Additions.h
//  XRmenu
//
//  Created by yangxh on 11-11-23.
//  Copyright 2011年 . All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (NSString_Additions)

// 编码
- (NSString *) base64StringEncode;
+ (NSString *) base64StringFromData:(NSData *)data length:(int)length;

// 解码
- (NSString *) base64StringDecode;
+ (NSData *) base64DataFromString:(NSString *)string;

// 过滤UUID的-
- (NSString *) fileName;
//+ (NSString *) base64DataFromString:(NSString *)string;

+ (NSString*) stringWithUUID;

//UTF8编码和解码
- (NSString *)UTF8EncodedString;
- (NSString *)UTF8DecodedString;

- (BOOL)isContainsString:(NSString *)searchKey;
@end
