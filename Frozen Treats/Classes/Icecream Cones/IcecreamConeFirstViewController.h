//
//  IcecreamConeFirstViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/13/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface IcecreamConeFirstViewController : UIViewController
{
    IBOutlet UIImageView *chooseFlavorLabel;
    IBOutlet UIButton *nextButton;
    IBOutlet UIImageView *bottleFlavor;
    IBOutlet UIImageView *pouringFlavor;
    IBOutlet UIImageView *flavorImgView;
    IBOutlet UIImageView *tiltToPourLabel;
    
    IBOutlet UIButton *bottle1;
    IBOutlet UIButton *bottle2;
    IBOutlet UIButton *bottle3;
    IBOutlet UIButton *bottle4;
    IBOutlet UIButton *bottle5;
    
    int flavor;
    CALayer *maskLayer;
    float currentX;
    float currentRotation;
    NSTimer *timer;
    NSTimer *timerPour;
    BOOL pouring;
    
    CMMotionManager *motionManager;
    NSOperationQueue *queue;
}

- (IBAction)backClick:(id)sender;
- (IBAction)flavorSelected:(UIButton*)sender;
- (IBAction)nextClick:(id)sender;

@end
