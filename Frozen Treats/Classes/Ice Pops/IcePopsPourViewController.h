//
//  IcePopsPourViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/27/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface IcePopsPourViewController : UIViewController //<UIAccelerometerDelegate>
{
    IBOutlet UIButton *nextButton;
    IBOutlet UIView *packet;
    IBOutlet UIImageView *powderPour;
    IBOutlet UIImageView *powder;
    IBOutlet UIImageView *flavoredImgView;
    IBOutlet UIImageView *moldImgView;
    IBOutlet UIImageView *tiltToPourLabel;
    
    UIView *flavorView;

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

@property (nonatomic) int flavor;
@property (nonatomic) int mold;
@property (nonatomic) int stick;

- (IBAction)backClick:(id)sender;
- (IBAction)nextClick:(id)sender;

@end
