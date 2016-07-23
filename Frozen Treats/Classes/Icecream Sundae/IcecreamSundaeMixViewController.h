//
//  IcecreamSundaeMixViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/23/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IcecreamSundaeMixViewController : UIViewController
{
    IBOutlet UIButton *nextButton;
    IBOutlet UIImageView *flavorPowder;
    IBOutlet UIImageView *topPart;
    IBOutlet UIImageView *shakeLabel;
    IBOutlet UIImageView *mixContent;
    IBOutlet UIButton *mixButton;
    IBOutlet UIView *blenderView;
    
    int flavor;
    BOOL shakeStopped;
}

@property (nonatomic) int flavor;

- (IBAction)backClick:(id)sender;
- (IBAction)nextClick:(id)sender;
- (IBAction)startMix:(id)sender;

@end
