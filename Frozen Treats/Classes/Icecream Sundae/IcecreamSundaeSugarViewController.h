//
//  IcecreamSundaeSugarViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/23/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface IcecreamSundaeSugarViewController : UIViewController //<UIAccelerometerDelegate>
{
    IBOutlet UIButton *nextButton;
    IBOutlet UIImageView *packet;
    IBOutlet UIImageView *powderPour;
    IBOutlet UIImageView *powder;
    IBOutlet UIImageView *flavorPowder;
    IBOutlet UIImageView *tiltToPourLabel;
    
    double currentX;
    double currentRotation;
    BOOL pouring;
    int sugar;
    CALayer *textureMask;
    NSTimer *timer;
    NSTimer *timerPour;
    int flavor;
    
    CMMotionManager *motionManager;
    NSOperationQueue *queue;
}

@property (nonatomic) int flavor;

- (IBAction)backClick:(id)sender;
- (IBAction)nextClick:(id)sender;

@end
