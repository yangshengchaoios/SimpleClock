//
//  ClockTableView.m
//  Notifier
//
//  Created by yshch on 12-2-11.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "ClockTableView.h"
#import "ClockList.h"
#import "ClockTableCell.h"

@implementation ClockTableView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([APPSESSION.allClocks count]==0) {//当没有闹钟的时候，显示添加闹钟cell
        return 1;
    }else{
        return [APPSESSION.allClocks count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *kCellIdentifier = @"cellID";
	ClockTableCell *cell = [[[ClockTableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellIdentifier] autorelease];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	if ([APPSESSION.allClocks count] > 0)	{
        ClockList *oneClock=(ClockList *)[APPSESSION.allClocks objectAtIndex:indexPath.row];
        [cell setData:oneClock];
    }else{//当没有闹钟的时候，显示添加闹钟cell
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:23.0f]];
        cell.textLabel.text=@"没有闹钟";
        
        [cell.detailTextLabel setTextColor:[UIColor grayColor]];
        cell.detailTextLabel.text=@"添加";
    }
	return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];// don't keep the table selection
    if ([APPSESSION.allClocks count] > 0) {
        APPSESSION.isAddClock=NO;//设置修改闹钟标志
        APPSESSION.currentClock = (ClockList *)[APPSESSION.allClocks objectAtIndex:indexPath.row];
        PUSHNEXTVIEWCONTROLLER(@"ClockConfig");
    }else{
        [self performSelector:@selector(addClock:) withObject:nil];
    }
}

#pragma mark - 自定义方法
- (IBAction)addClock:(id)sender {//新增闹钟
    APPSESSION.isAddClock=YES;//设置添加闹钟
    APPSESSION.currentClock=[ClockList new];//设置当前操作的闹钟为新的对象
    APPSESSION.currentClock.alarmTime = CURRENTTIME([NSDate date]);
    PUSHNEXTVIEWCONTROLLER(@"ClockConfig");
}
- (IBAction)finished:(id)sender {//转到时间显示主界面
    postN(@"turnToTimer");
}

#pragma mark - View lifecycle
- (void)viewDidLoad{
    //设置nav bar 标题
    self.navigationItem.title=@"闹钟列表";
    //设置nav bar左边按钮
    UIBarButtonItem *btnAdd = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addClock:)] autorelease];
    self.navigationItem.leftBarButtonItem = btnAdd;
    //设置nav bar右边按钮
    UIBarButtonItem *btnFinish =[[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finished:)] autorelease];
	self.navigationItem.rightBarButtonItem = btnFinish;
    
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated{//重画view时调用
    [APPSESSION initAllClock];
    [(UITableView *)[self.view viewWithTag:100] reloadData];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)viewDidUnload{
    [super viewDidUnload];
}
- (void)dealloc {
    [super dealloc];
}
@end
