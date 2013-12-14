//
//  EditRepeat.m
//  Notifier
//
//  Created by yshch on 12-2-16.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "EditRepeat.h"
#import "SoundTableCell.h"
#import "NSString+Additions.h"
#define cellTag 100

@implementation EditRepeat

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.tag=cellTag + indexPath.row;
    
    if (indexPath.row==0) {
        cell.textLabel.text=@"星期日";
    }else if(indexPath.row==1){
        cell.textLabel.text=@"星期一";
    }else if(indexPath.row==2){
        cell.textLabel.text=@"星期二";
    }else if(indexPath.row==3){
        cell.textLabel.text=@"星期三";
    }else if(indexPath.row==4){
        cell.textLabel.text=@"星期四";
    }else if(indexPath.row==5){
        cell.textLabel.text=@"星期五";
    }else{
        cell.textLabel.text=@"星期六";
    }
    
    if ([[APPSESSION.currentClock.repeat substringWithRange:NSMakeRange(indexPath.row, 1)] isContainsString:@"T"]) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];// don't keep the table selection
    
    UITableViewCell *cell = (UITableViewCell *) [self.view viewWithTag:cellTag + indexPath.row];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        APPSESSION.currentClock.repeat=[APPSESSION.currentClock.repeat stringByReplacingCharactersInRange:NSMakeRange(indexPath.row, 1) withString:@"T"];
    }else{
        cell.accessoryType=UITableViewCellAccessoryNone;
        APPSESSION.currentClock.repeat=[APPSESSION.currentClock.repeat stringByReplacingCharactersInRange:NSMakeRange(indexPath.row, 1) withString:@"F"];
    }
}

#pragma mark - View lifecycle
- (void)viewDidLoad{
    self.navigationItem.title=@"重复时间";
    [super viewDidLoad];
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
@end
