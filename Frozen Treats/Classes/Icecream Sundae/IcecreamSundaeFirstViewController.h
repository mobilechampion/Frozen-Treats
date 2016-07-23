//
//  IcecreamSundaeFirstViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/22/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface IcecreamSundaeFirstViewController : UIViewController //<UIAccelerometerDelegate>
{
    IBOutlet UIScrollView *scroll;
    IBOutlet UIView *decorationsView;
    IBOutlet UIButton *nextButton;
    IBOutlet UIImageView *packet;
    IBOutlet UIImageView *selectAFlavorLabel;
    IBOutlet UIButton *flavorsButton;
    IBOutlet UIImageView *tiltToPourLabel;
    IBOutlet UIImageView *powderPour;
    IBOutlet UIImageView *powder;
    
    double currentX;
    double currentRotation;
    BOOL pouring;
    int sugar;
    CGPoint touchOffset;
    BOOL touchingStick;
    CALayer *textureMask;
    NSTimer *timer;
    NSTimer *timerPour;
    int flavor;
    
    CMMotionManager *motionManager;
    NSOperationQueue *queue;
}

- (IBAction)backClick:(id)sender;
- (IBAction)nextClick:(id)sender;
- (IBAction)decorationsClick:(id)sender;

@end
