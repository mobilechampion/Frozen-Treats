//
//  SnowConesFirstViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/30/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BubblesGlassEffect.h"
#import <CoreMotion/CoreMotion.h>

@interface SnowConesFirstViewController : UIViewController //<UIAccelerometerDelegate>
{
    IBOutlet UIButton *nextButton;
    IBOutlet UIView *packet;
    IBOutlet UIImageView *powder;
    IBOutlet UIButton *machineButton;
    IBOutlet UIImageView *pressButtonLabel;
    IBOutlet BubblesGlassEffect *bubbles;

    double currentX;
    double currentRotation;
    BOOL pouring;
    int sugar;
    CALayer *textureMask;
    NSTimer *timer;
    NSTimer *timerPour;
    NSTimer *timerIce;
    
    int cubesNr;
    BOOL cubesPouring;
    NSMutableArray *cubes;
    CAEmitterLayer *emitter;
    
    CMMotionManager *motionManager;
    NSOperationQueue *queue;
}

- (IBAction)backClick:(id)sender;
- (IBAction)nextClick:(id)sender;
- (IBAction)startMachine:(id)sender;

@end
