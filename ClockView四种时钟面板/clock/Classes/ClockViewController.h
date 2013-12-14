//
//  ClockViewController.h
//  clock
//
//  Created by Enriquez Guillermo on 7/2/11.
//  Copyright 2011 Nacho4d. All rights reserved.
//  See the file License.txt for copying permission.
//

#import <UIKit/UIKit.h>
#import "ClockView.h"
#import "DDClockView.h"
#import "MTIBulbView.h"

@interface ClockViewController : UIViewController 
{
}

@property (nonatomic, retain) ClockView *clockView1;
@property (nonatomic, retain) ClockView *clockView2;
@property (nonatomic, retain) DDClockView *clockView3;
@property (nonatomic, retain) MTIBulbView *clockView4;
@end