//
//  ClockConfig.m
//  Notifier
//
//  Created by yshch on 12-2-11.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "ClockConfig.h"
#import "ClockList.h"
#import "DataBaseAccess.h"
#import "singleton.h"
#import "NSString+Additions.h"
#import "NotifierAppDelegate.h"
#import "SoundTableCell.h"
#import "SoundSwitch.h"

@implementation ClockConfig
@synthesize cellSwitch;
@synthesize cellDelete;
@synthesize cellTimeDetail;
@synthesize cellNameDetail;
@synthesize cellSoundDetail;
@synthesize cellRepeatDetail;
@synthesize cellSwitchButton;
@synthesize cellTime;
@synthesize cellName;
@synthesize cellSound;
@synthesize cellRepeat;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{    
    if (APPSESSION.isAddClock) {
        self.navigationItem.title=@"添加闹钟";
        return 2;
    }else{
        self.navigationItem.title=@"编辑闹钟";
        return 3;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 1;
    }else if(section == 1){
        return 4;
    }else{
        return 2;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0://返回闹钟的开关
            return cellSwitch;break;  
        case 1:
            switch (indexPath.row) {
                case 0:return cellTime;break;
                case 1:return cellName;break;
                case 2:return cellRepeat;break;
                case 3:return cellSound;break;
            } break;
        case 2:
            if (indexPath.row == 0) {
                return cellDelete;
            }else{ //显示该闹钟关联的铃声图片信息
                SoundTableCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SoundTableCell" owner:self options:nil]lastObject];
                if (APPSESSION.currentSound) {
                    [cell setData:APPSESSION.currentSound]; 
                }
                return cell;
            }
            break;          
        default: break;
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2 && indexPath.row == 1) {
        return 80;
    }else{
        return 44;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];// don't keep the table selection
    if (indexPath.section==1) {
        NSString *viewControllerName = @"";

        if (indexPath.row==0) {                     //编辑时间
            viewControllerName = @"EditTime";
        }else if(indexPath.row==1){                 //编辑闹钟名称
            viewControllerName = @"EditName";
        }else if(indexPath.row==2){                 //设置重复时间
            viewControllerName = @"EditRepeat";
        }else if(indexPath.row==3){                 //选择铃声
            viewControllerName = @"SoundTableView";
        }        
        PUSHNEXTVIEWCONTROLLER(viewControllerName);//进入下一层界面        
    }else if(indexPath.section==2 && indexPath.row == 0){ //删除闹钟
        UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"确定要删除闹钟?" 
                                                               delegate:self 
                                                      cancelButtonTitle:@"取消" 
                                                 destructiveButtonTitle:@"确定" 
                                                      otherButtonTitles:nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showInView:self.view];
        [actionSheet release];
    }else{}
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==actionSheet.cancelButtonIndex) {
        DebugLog(@"点击了取消按钮");
        return;
    }
    else{
        DebugLog(@"点击了确定按钮");
        [DataBaseAccess Update:[NSString stringWithFormat:@"delete from ClockList where clockid=%d",[APPSESSION.currentClock.clockid intValue]]];
        [self.navigationController popViewControllerAnimated:YES];//退回到上一级
    }
}

#pragma mark - 自定义方法
- (IBAction)saveClock:(id)sender {//保存修改
    if (APPSESSION.isAddClock) {//添加闹钟
        NSString *insertSql=[NSString stringWithFormat:@"insert into ClockList(clockName,soundRowid,soundName,repeat,alarmTime,isUsed) values('%@',%d,'%@','%@','%@','%d')",
                             APPSESSION.currentClock.clockName,                             
                             [APPSESSION.currentClock.soundRowid intValue],
                             APPSESSION.currentClock.soundName,  
                             APPSESSION.currentClock.repeat,                             
                             APPSESSION.currentClock.alarmTime,          
                             cellSwitchButton.on];
        [DataBaseAccess Update:insertSql];
    }else{//修改闹钟
        NSString *updateSql=[NSString stringWithFormat: @"update ClockList set clockName='%@',repeat='%@',alarmTime='%@',isUsed='%d' where clockid=%d",
                             APPSESSION.currentClock.clockName,
                             APPSESSION.currentClock.repeat,                
                             APPSESSION.currentClock.alarmTime, 
                             cellSwitchButton.on,
                             [APPSESSION.currentClock.clockid intValue]];
        [DataBaseAccess Update:updateSql];
    }
    
    APPSESSION.currentClock.isUsed = [NSString stringWithFormat:@"%d",cellSwitchButton.on];
    [(NotifierAppDelegate *)[[UIApplication sharedApplication] delegate] startClock:APPSESSION.currentClock];
    [self.navigationController popViewControllerAnimated:YES];//退回到上一级
}

- (IBAction)cellSwitchButtonClicked:(id)sender {
    APPSESSION.currentClock.isUsed = [NSString stringWithFormat:@"%d",cellSwitchButton.on];
}

#pragma mark - View lifecycle
- (void)viewDidLoad{    
    //设置nav bar
    UIBarButtonItem *btnSave =[[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveClock:)] autorelease];
	self.navigationItem.rightBarButtonItem = btnSave;
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated{
    DebugLog(@"soundName=%@", APPSESSION.currentClock.soundName);
    DebugLog(@"name=%@",APPSESSION.currentClock.clockName);
    APPSESSION.currentSound = ClockMusic(APPSESSION.currentClock);
    cellTimeDetail.text = APPSESSION.currentClock.alarmTime;
    cellNameDetail.text = APPSESSION.currentClock.clockName;
    cellSoundDetail.text = APPSESSION.currentClock.soundName;
    
    if([APPSESSION.currentClock.repeat isContainsString:@"T"]){
        cellRepeatDetail.text=@"重复";
    }else{
        cellRepeatDetail.text=@"无重复";
    }

    if ([APPSESSION.currentClock.isUsed isContainsString:@"1"]) {
        cellSwitchButton.on=YES;
    }else{
        cellSwitchButton.on=NO;
    }
    
    [(UITableView *)[self.view viewWithTag:100] reloadData];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)viewDidUnload{
    [self setCellSwitch:nil];
    [self setCellDelete:nil];
    [self setCellTime:nil];
    [self setCellName:nil];
    [self setCellSound:nil];
    [self setCellRepeat:nil];
    [self setCellTimeDetail:nil];
    [self setCellNameDetail:nil];
    [self setCellSoundDetail:nil];
    [self setCellRepeatDetail:nil];
    [self setCellSwitchButton:nil];
    [super viewDidUnload];
}
- (void)dealloc {
    [cellSwitch release];
    [cellDelete release];
    [cellTime release];
    [cellName release];
    [cellSound release];
    [cellRepeat release];
    [cellTimeDetail release];
    [cellNameDetail release];
    [cellSoundDetail release];
    [cellRepeatDetail release];
    [cellSwitchButton release];
    [super dealloc];
}
@end
