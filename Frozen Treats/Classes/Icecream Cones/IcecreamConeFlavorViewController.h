//
//  IcecreamConeFlavorViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/14/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface IcecreamConeFlavorViewController : UIViewController //<UIAccelerometerDelegate>
{
    IBOutlet UIImageView *chooseFlavorLabel;
    IBOutlet UIButton *nextButton;
    IBOutlet UIImageView *bottleFlavor;
    IBOutlet UIImageView *pouringFlavor;
    IBOutlet UIImageView *flavorImgView1;
    IBOutlet UIImageView *flavorImgView2;
    IBOutlet UIImageView *tiltToPourLabel;
    
    IBOutlet UIButton *bottle1;
    IBOutlet UIButton *bottle2;
    IBOutlet UIButton *bottle3;
    IBOutlet UIButton *bottle4;
    IBOutlet UIButton *bottle5;
    
    int flavor1;
    int flavor2;
    CALayer *maskLayer;
    float currentX;
    float currentRotation;
    NSTimer *timer;
    NSTimer *timerPour;
    BOOL pouring;
    
    CMMotionManager *motionManager;
    NSOperationQueue *queue;
}

@property (nonatomic) int flavor1;

- (IBAction)backClick:(id)sender;
- (IBAction)flavorSelected:(UIButton*)sender;
- (IBAction)nextClick:(id)sender;

@end
