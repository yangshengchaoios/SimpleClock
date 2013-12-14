//
//  SoundTableView.m
//  Notifier
//
//  Created by yshch on 12-2-11.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "SoundTableView.h"
#import "singleton.h"
#import "SoundTableCell.h"
#import "DataBaseAccess.h"

@implementation SoundTableView

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
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [APPSESSION.allSounds count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"SoundTableCell";
    SoundTableCell *cell = (SoundTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SoundTableCell" owner:self options:nil]lastObject];
    }
    SoundList *tempSound=(SoundList *)[APPSESSION.allSounds objectAtIndex:indexPath.row];
    [cell setData:tempSound]; 
	return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];// don't keep the table selection   
    SoundList *tempSound=(SoundList *)[APPSESSION.allSounds objectAtIndex:indexPath.row];
    //修改与ClockList的关联关系
    NSString *updateSql1=[NSString stringWithFormat: @"update ClockList set soundRowid=%d,soundName='%@' where clockid=%d",
                          [tempSound.soundid intValue],
                          tempSound.soundName,
                          [APPSESSION.currentClock.clockid intValue]];
    [DataBaseAccess Update:updateSql1];
    APPSESSION.currentClock.soundRowid = tempSound.soundid;
    APPSESSION.currentClock.soundName = tempSound.soundName;
    [tableView reloadData];
    
    //播放铃声(系统自带的铃声)
    NSString *musicPath=[NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath],tempSound.fileName];
    [APPSESSION playMusic:musicPath];
}
-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    DebugLog(@"点击了编辑");
    //弹出编辑界面
    APPSESSION.currentSound=(SoundList *)[APPSESSION.allSounds objectAtIndex:indexPath.row];
    PUSHNEXTVIEWCONTROLLER(@"SoundDetail");
}
-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
} 
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"edit";
}
- (IBAction)recordAction:(id)sender{
	PUSHNEXTVIEWCONTROLLER(@"RecordTableView");
}

#pragma mark - View lifecycle
- (void)viewDidLoad{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bkg.png"]];
//    UIBarButtonItem *btnTemp = [[[UIBarButtonItem alloc] initWithTitle:@"Record" style:UIBarButtonItemStyleBordered target:self action:@selector(recordAction:)] autorelease];
//    self.navigationItem.rightBarButtonItem = btnTemp;
    
    self.navigationItem.title=@"选择铃声";
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated{
    DebugLog(@"sound table view will appear");
    [APPSESSION initAllSounds:1];
    [(UITableView *)[self.view viewWithTag:100] reloadData];
}
- (void)viewWillDisappear:(BOOL)animated{
    DebugLog(@"in method viewWillDisappear");
    [APPSESSION stopMusic];
    [super viewWillDisappear:YES];
}
- (void)viewDidUnload{
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)dealloc {
    [super dealloc];
}
@end
