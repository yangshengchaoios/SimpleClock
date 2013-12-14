//
//  ColckView.h
//  Clock
//
//  Created by dxl on 12-12-30.
//
//

#import <UIKit/UIKit.h>

@class DDDialView;
@class DDNeedleHourView;
@class DDNeedleMinuteView;
@class DDNeedleSecondView;

@interface DDClockView : UIView{

    DDDialView *_viewOfDial;
    
    DDNeedleHourView *_viewOfHourNeedle;
    
    DDNeedleMinuteView *_viewOfMinuteNeedle;
    
    DDNeedleSecondView *_viewOfSecondNeedle;
}

@end
