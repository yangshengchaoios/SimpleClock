//
//  EditTime.m
//  Notifier
//
//  Created by yshch on 12-2-11.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "EditTime.h"
#import "singleton.h"

@implementation EditTime
@synthesize timePicker;
@synthesize labelAlarmTime;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - picker 数据源方法
//选取器如果有多个滚轮，就返回滚轮的数量，我们这里有两个，就返回2
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2;
}
//返回给定的组件有多少行数据，我们有2个组件，所以用if操作。后期tableview也是类似的操作方法
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return 24;
    }
	else{
        return 60;
    }
}

#pragma mark - picker 委托方法
//官方的意思是，指定组件中的指定数据，我理解的就是目前选中的是哪一行。
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%02d",row];
}
//当选取器的行发生改变的时候调用这个方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSInteger hour=[pickerView selectedRowInComponent:0];
    NSInteger minute=[pickerView selectedRowInComponent:1];
    labelAlarmTime.text=[NSString stringWithFormat:@"%02d:%02d",hour,minute];
    APPSESSION.currentClock.alarmTime = labelAlarmTime.text;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 50;
}

#pragma mark - 自定义方法
- (IBAction)btnSaveAction:(id)sender {//保存修改信息
    [self.navigationController popViewControllerAnimated:YES];//退回到上一级
}
#pragma mark - View lifecycle
- (void)viewDidLoad
{
    //设置nav bar
    self.navigationItem.title=@"编辑时间";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bkg.png"]];
    
//    UIBarButtonItem *btnSave = [[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(btnSaveAction:)] autorelease];
//    self.navigationItem.rightBarButtonItem = btnSave;
    
    [super viewDidLoad];
    
    labelAlarmTime.text = APPSESSION.currentClock.alarmTime;
    [timePicker selectRow:[[APPSESSION.currentClock.alarmTime substringWithRange:NSMakeRange(0, 2)] intValue] inComponent:0 animated:NO];
    [timePicker selectRow:[[APPSESSION.currentClock.alarmTime substringWithRange:NSMakeRange(3, 2)] intValue] inComponent:1 animated:NO];
}
- (void)viewDidUnload{
    [self setTimePicker:nil];
    [self setLabelAlarmTime:nil];
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)dealloc {
    [timePicker release];
    [labelAlarmTime release];
    [super dealloc];
}
@end
