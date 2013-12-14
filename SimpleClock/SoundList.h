//
//  SoundList.h
//  Notifier
//
//  Created by yshch on 12-2-15.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundList : NSObject
@property (nonatomic, assign) NSNumber * soundid;
@property (nonatomic, retain) NSString * soundName;
@property (nonatomic, retain) NSString * description;
@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) NSString * fileUrl;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSString * isSystem;
@end
