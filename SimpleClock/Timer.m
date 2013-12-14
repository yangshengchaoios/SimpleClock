//
//  Timer.m
//  Notifier
//
//  Created by yshch on 12-2-11.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "Timer.h"
#import "NSString+Additions.h"
#import "NotifierAppDelegate.h"

@interface Timer(Private)
-(void) getCurrentTime;
@end

@implementation Timer
@synthesize currentTime;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//弹出设置窗口
- (IBAction)btnConfig:(id)sender {
    postN(@"turnToClock");
}
-(void) getCurrentTime{
    currentTime.text = [APPSESSION NSDateToNSString:[NSDate date] Format:@"HH:mm:ss"];
    [self performSelector:@selector(getCurrentTime) withObject:nil afterDelay:0.2f];//循环调用
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    currentTime.font = [UIFont fontWithName:@"DB LCD Temp" size:55.0f];
    [self getCurrentTime];    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setCurrentTime:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [currentTime release];
    [super dealloc];
}

@end
