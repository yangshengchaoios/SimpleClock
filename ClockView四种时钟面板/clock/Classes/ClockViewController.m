//
//  ClockViewController.m
//  clock
//
//  Created by Enriquez Guillermo on 7/2/11.
//  Copyright 2011 Nacho4d. All rights reserved.
//  See the file License.txt for copying permission.
//

#import "ClockViewController.h"


@implementation ClockViewController

@synthesize clockView1, clockView2, clockView3,clockView4;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
	[clockView1 release];
	[clockView2 release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	//Original clock images was taken from:
	// http://www.comparestoreprices.co.uk/wall-clocks/bliss-roman-aluminium-clock.asp
	// It can be found in Images folder: bliss-roman-aluminium-clock.jpg
		
	//ClockView with some images
//	clockView1 = [[ClockView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
//	[clockView1 setClockBackgroundImage:[UIImage imageNamed:@"clock-background.png"].CGImage];
//	[clockView1 setHourHandImage:[UIImage imageNamed:@"clock-hour-background.png"].CGImage];
//	[clockView1 setMinHandImage:[UIImage imageNamed:@"clock-min-background.png"].CGImage];
//	[clockView1 setSecHandImage:[UIImage imageNamed:@"clock-sec-background.png"].CGImage];
//	clockView1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//	[self.view addSubview:clockView1];
	
	//ClockView with default style
//	clockView2 = [[ClockView alloc] initWithFrame:CGRectMake(15, 20, 300, 300)];
//	clockView2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//	[self.view addSubview:clockView2];
    
//    clockView3 =[[DDClockView alloc] initWithFrame:CGRectMake(60, 150, 300, 300)];
//    clockView3.center =self.view.center;
//    [self.view addSubview:clockView3];
    
    clockView4 =[[MTIBulbView alloc] initWithFrame:CGRectMake(60, 150, 280, 50)];
    clockView4.backgroundColor=[UIColor blackColor];
    clockView4.center =self.view.center;
    [self.view addSubview:clockView4];
}

- (void)viewWillAppear:(BOOL)animated
{
	//start the clock at current time
	[clockView1 start];
	[clockView2 start];
    [clockView4 start];
}

- (void)viewWillDisappear:(BOOL)animated
{
	//stop the clock
	[clockView1 stop];
	[clockView2 stop];
    [clockView4 stop];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	self.clockView1 = nil;
	self.clockView2 = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
