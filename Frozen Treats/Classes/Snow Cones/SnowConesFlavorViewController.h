//
//  SnowConesFlavorViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/31/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingView.h"

@interface SnowConesFlavorViewController : UIViewController <UIAccelerometerDelegate>
{
    IBOutlet UIImageView *chooseFlavorLabel;
    IBOutlet UIButton *nextButton;
    IBOutlet UIImageView *bottleFlavor;
    IBOutlet UIImageView *pouringFlavor;
    IBOutlet UIImageView *flavorImgView;
    IBOutlet UIImageView *coneImgView;
    IBOutlet UIImageView *shapeImgView;
    IBOutlet UIImageView *tapDrawLabel;
    
    DrawingView *drawingView;
    
    IBOutlet UIButton *bottle1;
    IBOutlet UIButton *bottle2;
    IBOutlet UIButton *bottle3;
    IBOutlet UIButton *bottle4;
    IBOutlet UIButton *bottle5;

    int flavor;
    float currentX;
    float currentRotation;
    NSTimer *timer;
    NSTimer *timerPour;
    BOOL pouring;
    
    int shape;
    int cone;
}

@property (nonatomic) int shape;
@property (nonatomic) int cone;

- (IBAction)backClick:(id)sender;
- (IBAction)flavorSelected:(UIButton*)sender;
- (IBAction)nextClick:(id)sender;
- (IBAction)undoClick:(id)sender;

@end
