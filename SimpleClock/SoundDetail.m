//
//  SoundDetail.m
//  Notifier
//
//  Created by yshch on 12-2-16.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "SoundDetail.h"
#define buttonPlayTagStart 100


@interface SoundDetail (private)
- (void)initMusicPlayer;
- (void)stopMusicPlayer;
- (void)updateProcessSlider;
@end

@implementation SoundDetail
@synthesize textFieldSoundName;
@synthesize textViewSoundDes;
@synthesize imageSound;
@synthesize buttonPlay;
@synthesize buttonDelete;
@synthesize musicPlayer;
@synthesize processSlider;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
	buttonPlay.tag = buttonPlayTagStart;//设置播放tag
	[buttonPlay setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
//	[self initMusicPlayer];
	[timer invalidate];
}

#pragma mark - UITextField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - 初始化播放对象函数
- (void)initMusicPlayer{
	if (musicPlayer) {
        if (musicPlayer.isPlaying) {
            [musicPlayer stop];
        }
		[musicPlayer release];
        musicPlayer = nil;
	}    
    
    buttonPlay.tag=buttonPlayTagStart;//设置播放tag
    processSlider.value = 0.0;
    
    NSString *musicPath=[NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath],APPSESSION.currentSound.fileName];
    if ([APPSESSION.currentSound.isSystem isEqualToString:@"0"]) {
        musicPath = APPSESSION.currentSound.fileUrl;
    }	
//	AVAudioSession* audioSession = [AVAudioSession sharedInstance];
//	[audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
//	[audioSession setActive:YES error:nil];
    
	musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:musicPath] error:nil];
	musicPlayer.delegate = self;
	musicPlayer.numberOfLoops = 0;
	musicPlayer.volume = 1;
    musicPlayer.meteringEnabled = YES;
	[musicPlayer prepareToPlay];
}
- (void)stopMusicPlayer{
    if (musicPlayer && musicPlayer.isPlaying) {
        [musicPlayer stop];
	}
}
#pragma mark - 自定义方法(几个按钮)
- (IBAction)btnSavedAction:(id)sender {//保存修改信息     
    NSString *updateSql=[NSString stringWithFormat: @"update SoundList set soundName='%@',description='%@' where soundid=%d",
                         textFieldSoundName.text,
                         textViewSoundDes.text,     
                         [APPSESSION.currentSound.soundid intValue]];
    [DataBaseAccess Update:updateSql];
    [self.navigationController popViewControllerAnimated:YES];//退回到上一级
}

- (IBAction)playMusicAction:(id)sender {//播放 按钮
    DebugLog(@"in method playMusic...");
    if (buttonPlay.tag == buttonPlayTagStart + 0) {//播放
        DebugLog(@"点击播放...");
        [self initMusicPlayer];
		[musicPlayer play];
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateProcessSlider) userInfo:nil repeats:YES];
        [buttonPlay setImage:[UIImage imageNamed:@"end.png"] forState:UIControlStateNormal];
		buttonPlay.tag = buttonPlayTagStart + 1;
	}else if(buttonPlay.tag == buttonPlayTagStart + 1){//暂停
        DebugLog(@"点击暂停...");
		[musicPlayer pause];
        [timer invalidate];
        [buttonPlay setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
		buttonPlay.tag = buttonPlayTagStart;
	}
    DebugLog(@"end in method playMusic");
}

#pragma mark - 几个委托方法
- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer {//点击view任意位置时，退出键盘
	[textFieldSoundName resignFirstResponder];
    [textViewSoundDes resignFirstResponder];
}
- (void)updateProcessSlider{//播放进度更新(自动)
	[self.musicPlayer updateMeters];
    if (musicPlayer.duration > 0) {
        processSlider.value = musicPlayer.currentTime / musicPlayer.duration;
    }
}
- (IBAction)processSliderChanged:(UISlider *)sender{//手动修改播放进度
	if (musicPlayer) {
		musicPlayer.currentTime = processSlider.value * musicPlayer.duration;
	}
}
- (IBAction)deleteMusicAction:(id)sender {//删除music
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"Are you sure want to delete?" 
                                                           delegate:self 
                                                  cancelButtonTitle:@"Cancel" 
                                             destructiveButtonTitle:@"Confirm" 
                                                  otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
    [actionSheet release];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex!=actionSheet.cancelButtonIndex){
        //删除音频文件
        if ([[NSFileManager defaultManager] fileExistsAtPath:APPSESSION.currentSound.fileUrl]) {
            DebugLog(@"删除沙盒目录下的闹铃文件...");
            [[NSFileManager defaultManager] removeItemAtPath:APPSESSION.currentSound.fileUrl error:nil];
        }
        //删除数据表里的信息
        NSString *deleteSql=[NSString stringWithFormat:@"delete from SoundList where soundid=%d",[APPSESSION.currentSound.soundid intValue]];
        [DataBaseAccess Update:deleteSql];
        
        [self.navigationController popViewControllerAnimated:YES];//退回到上一级
    }
}

#pragma mark - View lifecycle
- (void)viewDidLoad{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bkg.png"]];//view的背景图片
    self.navigationItem.title=@"Edit Music";
    
    //toolbar初始化
    UIBarButtonItem *btnSave = [[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(btnSavedAction:)] autorelease];
    self.navigationItem.rightBarButtonItem = btnSave;
    
    //显示 或 隐藏删除按钮
    if ([APPSESSION.currentSound.isSystem isEqualToString:@"1"]) {
        [buttonDelete setHidden:YES];
    }else{
        [buttonDelete setHidden:NO];
    }
    
    //添加手势
    UITapGestureRecognizer *recognizer;
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
    [recognizer release];
    
    //数据初始化
//    [self initMusicPlayer];//初始化播放器
    buttonPlay.tag=buttonPlayTagStart;//设置播放tag
    processSlider.value = 0.0;
    textFieldSoundName.text=APPSESSION.currentSound.soundName;
    textViewSoundDes.text=APPSESSION.currentSound.description;
    imageSound.image=[UIImage imageNamed:APPSESSION.currentSound.imageName];
    
    [super viewDidLoad];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)viewWillDisappear:(BOOL)animated{//(返回上一界面之前)暂停播放器
    if (musicPlayer) {
        [musicPlayer stop];
//        if (musicPlayer.isPlaying) {
//            [musicPlayer stop];
//        }
//		[musicPlayer release];
//        musicPlayer = nil;
	}
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload{
    [self setMusicPlayer:nil];
    [self setTextFieldSoundName:nil];
    [self setTextViewSoundDes:nil];
    [self setImageSound:nil];
    [self setButtonPlay:nil];
    [self setProcessSlider:nil];
    [self setButtonDelete:nil];
    [super viewDidUnload];
}
- (void)dealloc {
    [timer release];
    [musicPlayer release];
    [textFieldSoundName release];
    [textViewSoundDes release];
    [imageSound release];
    [buttonPlay release];
    [processSlider release];
    [buttonDelete release];
    [super dealloc];
}
@end
