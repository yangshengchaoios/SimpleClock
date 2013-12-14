//
//  SoundSwitch.m
//  Notifier
//
//  Created by shengchao yang on 12-2-25.
//  Copyright (c) 2012年 foxhis. All rights reserved.
//

#import "SoundSwitch.h"
#import "SoundTableView.h"
#import "RecordTableView.h"

@implementation SoundSwitch

SoundTableView *stv;
RecordTableView *rtv;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)segmentAction:(id)sender{
	UISegmentedControl *sgc = (UISegmentedControl *)sender;
	NSLog(@"Segment clicked: %d", sgc.selectedSegmentIndex);
    if (sgc.selectedSegmentIndex == 1) {
        postN(@"ChooseView");
    }else{
        postN(@"RecordView");
    }
}

//转到闹钟管理界面
-(void) ChooseView{
    [APPSESSION initAllSounds:1];
    [self.view addSubview:stv.view];
}
//转到闹钟管理界面
-(void) RecordView{
    [APPSESSION initAllSounds:2];
    [self.view addSubview:rtv.view];
}
-(void) MoveToDetail{
    PUSHNEXTVIEWCONTROLLER(@"SoundDetail");
}
#pragma mark - View lifecycle
- (void)viewDidLoad{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bkg.png"]];
	NSArray *segmentTextContent = [NSArray arrayWithObjects:@"Choose",@"Record",nil];
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	segmentedControl.selectedSegmentIndex = 0;
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.frame = CGRectMake(0, 0, 300, 30);
	[segmentedControl addTarget:self 
                         action:@selector(segmentAction:) 
               forControlEvents:UIControlEventValueChanged];
    
	self.navigationItem.titleView = segmentedControl;
    addNObserver(@selector(ChooseView), @"ChooseView");
    addNObserver(@selector(RecordView), @"RecordView");
    addNObserver(@selector(MoveToDetail), @"MoveToDetail");
    stv=[[SoundTableView alloc] initWithNibName:@"SoundTableView" bundle:nil] ;
    rtv=[[RecordTableView alloc] initWithNibName:@"RecordTableView" bundle:nil] ;
    
    if ([APPSESSION.currentSound.isSystem isEqualToString:@"1"]) {
        postN(@"ChooseView");
    }else{
        postN(@"RecordView");
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidUnload{
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    removeNObserver(@"ChooseView");
    removeNObserver(@"RecordView");
    removeNObserver(@"MoveToDetail");
    [stv release];
    stv = nil;
    [rtv release];
    rtv = nil;
    [super dealloc];
}
@end
