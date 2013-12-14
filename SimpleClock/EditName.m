//
//  EditName.m
//  Notifier
//
//  Created by yshch on 12-2-11.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "EditName.h"
#import "singleton.h"

@implementation EditName
@synthesize textFieldName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - UITextField delegate

-(void) textFieldDidEndEditing:(UITextField *)textField{
    APPSESSION.currentClock.clockName=textField.text;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 自定义方法 
- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer {//点击界面退出键盘
	[textFieldName resignFirstResponder];
}

#pragma mark - View lifecycle
- (void)viewDidLoad{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bkg.png"]];
    
    UITapGestureRecognizer *recognizer;
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
    [recognizer release];
     
    //设置nav bar
    self.navigationItem.title=@"闹钟名称";
    textFieldName.text=APPSESSION.currentClock.clockName;
    [super viewDidLoad];
}

- (void)viewDidUnload{
    [self setTextFieldName:nil];
    [super viewDidUnload];
}
- (void)viewWillDisappear:(BOOL)animated{
    [textFieldName resignFirstResponder];
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)dealloc {
    [textFieldName release];
    [super dealloc];
}
- (IBAction)nameValueChanged:(id)sender {
    APPSESSION.currentClock.clockName = textFieldName.text;
}
@end
