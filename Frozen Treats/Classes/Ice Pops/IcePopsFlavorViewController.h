//
//  IcePopsFlavorViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/27/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface IcePopsFlavorViewController : UIViewController //<UIAccelerometerDelegate>
{
    IBOutlet UIScrollView *scroll;
    IBOutlet UIView *decorationsView;
    IBOutlet UIButton *nextButton;
    IBOutlet UIImageView *packet;
    IBOutlet UIButton *flavorsButton;
    IBOutlet UIImageView *tiltToPourLabel;
    IBOutlet UIImageView *powderPour;
    IBOutlet UIImageView *powder;
    
    double currentX;
    double currentRotation;
    BOOL pouring;
    int sugar;
    CALayer *textureMask;
    NSTimer *timer;
    NSTimer *timerPour;
    int flavor;
    int mold;
    int stick;
    
    CMMotionManager *motionManager;
    NSOperationQueue *queue;
}

@property (nonatomic) int mold;
@property (nonatomic) int stick;

- (IBAction)backClick:(id)sender;
- (IBAction)nextClick:(id)sender;
- (IBAction)decorationsClick:(id)sender;

@end
