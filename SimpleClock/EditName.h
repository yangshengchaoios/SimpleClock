//
//  EditName.h
//  Notifier
//
//  Created by yshch on 12-2-11.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditName : UIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate>
@property (retain, nonatomic) IBOutlet UITextField *textFieldName;
- (IBAction)nameValueChanged:(id)sender;

@end
