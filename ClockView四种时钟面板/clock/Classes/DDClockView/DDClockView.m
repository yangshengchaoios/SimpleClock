//
//  ColckView.m
//  Clock
//
//  Created by dxl on 12-12-30.
//
//

#import "DDClockView.h"

#import "DDDialView.h"

#import "DDNeedleView.h"

@interface DDClockView(){
    
    NSTimer *_timer;
    
    NSDateComponents *_comps;
}

-(void)startTimer;

-(void)endTimer;

-(void)doIt;

@end

@implementation DDClockView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor =[UIColor clearColor];
        
        _viewOfDial =[[[DDDialView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        [self addSubview:_viewOfDial];
        
        //时钟
        _viewOfHourNeedle =[[[DDNeedleHourView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        [self addSubview:_viewOfHourNeedle];
        
        
        //分钟
        _viewOfMinuteNeedle =[[[DDNeedleMinuteView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        [self addSubview:_viewOfMinuteNeedle];
        
        //秒钟
        _viewOfSecondNeedle =[[[DDNeedleSecondView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        [self addSubview:_viewOfSecondNeedle];
        
        [self doIt];
        
        [self startTimer];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


-(void)startTimer{

    _timer =[NSTimer scheduledTimerWithTimeInterval:1.0f
                                             target:self
                                           selector:@selector(doIt)
                                           userInfo:nil
                                            repeats:YES];
}

-(void)endTimer{

}

-(void)doIt{
    
    /*
    float section =30.0f;
    
    float currentAngle =[_viewOfHourNeedle angle];

    currentAngle +=section;
    
    [_viewOfHourNeedle setAngle:currentAngle];
     */
    
    NSDate *currentDate =[NSDate date];
    
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	unsigned int unitFlags = NSSecondCalendarUnit |NSMinuteCalendarUnit | NSHourCalendarUnit;
	NSDateComponents *comps = [gregorian components:unitFlags fromDate:currentDate];
    [gregorian release];
    
	int seconds = [comps second];
    int minute =[comps minute];
    int hour =[comps hour];
    
    float angleOfSecond =seconds * 6.0f;
    
    float angleOfMinute =(minute +seconds/60.0f ) *6.0f;
    
    float angleOfHour = (hour%12)*30.0f + ((minute +seconds/60.0f )/60.0f)*30.0f;
    
    [_viewOfSecondNeedle setAngle:angleOfSecond];
    
    [_viewOfMinuteNeedle setAngle:angleOfMinute];
    
    [_viewOfHourNeedle setAngle:angleOfHour];
}

@end
