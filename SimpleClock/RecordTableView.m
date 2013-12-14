//
//  RecordTableView.m
//  Notifier
//
//  Created by shengchao yang on 12-2-25.
//  Copyright (c) 2012年 foxhis. All rights reserved.
//

#import "RecordTableView.h"
#define buttonPlayTagStart 110

@interface RecordTableView (private)
- (void)initSoundRecorder;
- (void)stopSoundRecorder;
@end


@implementation RecordTableView
@synthesize labelRecordSta;
@synthesize soundRecorder;
@synthesize buttonRecord;
@synthesize fileUrl,fileName;

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
    
    //弹出编辑界面
    APPSESSION.currentSound = (SoundList *)[APPSESSION.allSounds objectAtIndex:indexPath.row];
    PUSHNEXTVIEWCONTROLLER(@"SoundDetail");
}

#pragma mark - 初始化录音对象函数
- (void)initSoundRecorder{
    if (soundRecorder) {
        if (soundRecorder.isRecording) {
            [soundRecorder stop];
        }
		[soundRecorder release];
	}   
    buttonRecord.tag=buttonPlayTagStart;//设置录音tag
    
    //(document目录的路径)
    self.fileName =[NSString stringWithFormat:@"%@",[APPSESSION NSDateToNSString:[NSDate date] Format:@"MMddyyyy-HHmmssSSS"]];//yyyyMMddHHmmssSSS
    self.fileUrl = [NSString stringWithFormat:@"%@/%@.caf",DOCUMENT, self.fileName];
    NSURL *destinationURL = [NSURL fileURLWithPath: self.fileUrl];//录音文件存放的地址
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];    
    
    //以下是设置录音的参数
    //1 ID号    
    [recordSettings setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];    
    float sampleRate =  24;//[pcmSettingsViewController.sampleRateField.text floatValue];    
    //2 采样率    
    [recordSettings setObject:[NSNumber numberWithFloat:sampleRate] forKey: AVSampleRateKey];    
    //3 通道的数目    
    [recordSettings setObject:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];        
    //4 采样位数  默认 16    
    [recordSettings setObject:[NSNumber numberWithInt:20] forKey:AVLinearPCMBitDepthKey];    
    //    //5    
    //    BOOL isabc=YES;
    //    [recordSettings setObject:[NSNumber numberWithBool:isabc forKey:AVLinearPCMIsBigEndianKey];    
    //    //6 采样信号是整数还是浮点数    
    //    [recordSettings setObject:[NSNumber numberWithBool:isabc forKey:AVLinearPCMIsFloatKey];
    
    soundRecorder = [[AVAudioRecorder alloc] initWithURL:destinationURL settings:recordSettings error:nil];    
    [recordSettings release];
    [soundRecorder prepareToRecord];
}
-(void)stopSoundRecorder{
    if (soundRecorder && soundRecorder.isRecording) {
        [soundRecorder stop];
	}
}
- (IBAction)recordMusicAction:(id)sender {
    DebugLog(@"in method record music...");
    if(buttonRecord.tag == buttonPlayTagStart + 0){//录音
        DebugLog(@"开始录音...");
        [self initSoundRecorder];
        
        [soundRecorder record];
        [buttonRecord setImage:[UIImage imageNamed:@"end.png"] forState:UIControlStateNormal];
        labelRecordSta.text = @"recording";
        buttonRecord.tag = buttonPlayTagStart + 1;
    }else{
        DebugLog(@"停止录音...");
        [self stopSoundRecorder];
        
        //插入数据库
        NSString *insertSql=[NSString stringWithFormat:@"insert into SoundList(soundName,description,fileName,fileUrl,imageName,isSystem) values('%@','%@','%@','%@','%@','0')",
                             self.fileName,
                             @"",
                             [NSString stringWithFormat:@"%@.caf",self.fileName],
                             self.fileUrl,                     
                             @"default_img.png"];
        [DataBaseAccess Update:insertSql];
        
        labelRecordSta.text = @"start record";
        [buttonRecord setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        buttonRecord.tag = buttonPlayTagStart;
        [APPSESSION initAllSounds:2];
        [(UITableView *)[self.view viewWithTag:100] reloadData];
    }
    DebugLog(@"end in method record music");
}

#pragma mark - View lifecycle
- (void)viewDidLoad{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bkg.png"]];    
    self.navigationItem.title = @"Recording";
    buttonRecord.tag = buttonPlayTagStart;//设置录音tag
    labelRecordSta.text = @"start record";
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    DebugLog(@"record table view will appear");
    [APPSESSION initAllSounds:2];
    [(UITableView *)[self.view viewWithTag:100] reloadData];
}
- (void)viewWillDisappear:(BOOL)animated{
    DebugLog(@"in method viewWillDisappear");
    [self stopSoundRecorder];
    [super viewWillDisappear:YES];
}
- (void)viewDidUnload {
    [self setSoundRecorder:nil];
    [self setButtonRecord:nil];
    [self setFileUrl:nil];
    [self setFileName:nil];
    [self setLabelRecordSta:nil];
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}
- (void)dealloc {
    [soundRecorder release];
    [buttonRecord release];
    [fileUrl release];
    [fileName release];
    [labelRecordSta release];
    [super dealloc];
}


#pragma mark - 网上下载的录音源码 学习

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
AVAudioRecorder *recorder;
NSString *recorderFilePath;
- (void) startRecording
{
    UIBarButtonItem *stopButton = [[UIBarButtonItem alloc] initWithTitle:@"Stop" style:UIBarButtonItemStyleBordered  target:self action:@selector(stopRecording)];
    self.navigationItem.rightBarButtonItem = stopButton;
    [stopButton release];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    if(err){
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
    }
    [audioSession setActive:YES error:&err];
    err = nil;
    if(err){
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
    }
    
    //设置录音参数
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey]; 
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    [recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    // Create a new dated file
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString *caldate = [now description];
    recorderFilePath = [[NSString stringWithFormat:@"%@/%@.caf", DOCUMENTS_FOLDER, caldate] retain];
    NSURL *url = [NSURL fileURLWithPath:recorderFilePath];
    err = nil;
    recorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
    if(!recorder){
        NSLog(@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
                                   message: [err localizedDescription]
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    //prepare to record
    [recorder setDelegate:self];
    [recorder prepareToRecord];
    recorder.meteringEnabled = YES;
    
    BOOL audioHWAvailable = audioSession.inputIsAvailable;
    if (! audioHWAvailable) {
        UIAlertView *cantRecordAlert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
                                   message: @"Audio input hardware not available"
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [cantRecordAlert show];
        [cantRecordAlert release]; 
        return;
    }    
    // start recording
    [recorder recordForDuration:(NSTimeInterval) 10];
}

- (void) stopRecording{    
    [recorder stop];
    NSURL *url = [NSURL fileURLWithPath: recorderFilePath];
    NSError *err = nil;
    NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
    if(!audioData)
        NSLog(@"audio data: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
//    [editedObject setValue:[NSData dataWithContentsOfURL:url] forKey:editedFieldKey];       
    //[recorder deleteRecording];    
    NSFileManager *fm = [NSFileManager defaultManager];
    err = nil;
    [fm removeItemAtPath:[url path] error:&err];
    if(err)
        NSLog(@"File Manager: %@ %d %@", [err domain], [err code], [[err userInfo] description]);

    UIBarButtonItem *startButton = [[UIBarButtonItem alloc] initWithTitle:@"Record" style:UIBarButtonItemStyleBordered  target:self action:@selector(startRecording)];
    self.navigationItem.rightBarButtonItem = startButton;
    [startButton release];
}
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
    NSLog (@"audioRecorderDidFinishRecording:successfully:");
    // your actions here
}
@end
