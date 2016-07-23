//
//  IcecreamSandOvenViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/21/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <math.h>
#import "PSAnalogClockView.h"

@interface IcecreamSandOvenViewController : UIViewController
{
    IBOutlet UIView *sheetView;
    IBOutlet UIButton *nextButton;
    IBOutlet UIImageView *dragCookieLabel;
    IBOutlet UIImageView *dragCookieOutLabel;
    IBOutlet UIImageView *bakingLabel;
    
    IBOutlet UIImageView *sand1;
    IBOutlet UIImageView *sand2;
    IBOutlet UIImageView *sand3;
    IBOutlet UIImageView *sand4;
    IBOutlet UIImageView *sand5;
    IBOutlet UIImageView *sand6;
    
    PSAnalogClockView *analogClock2;
    BOOL baked;
}

- (IBAction)backClick:(id)sender;
- (IBAction)nextClick:(id)sender;

@end
