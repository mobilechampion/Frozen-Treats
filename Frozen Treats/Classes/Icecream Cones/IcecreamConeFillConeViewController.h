//
//  IcecreamConeFillConeViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/14/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IcecreamConeFillConeViewController : UIViewController
{
    IBOutlet UIScrollView *scroll;
    IBOutlet UIImageView *flavorImgView1;
    IBOutlet UIImageView *flavorImgView2;
    IBOutlet UIImageView *coneImgView;
    IBOutlet UIView *machineView;
    IBOutlet UIImageView *pickConeLabel;
    IBOutlet UIButton *nextButton;
    IBOutlet UIImageView *pullLeverLabel;
    IBOutlet UIImageView *handleImgView;
    IBOutlet UIImageView *pouringIcecream1;
    IBOutlet UIImageView *pouringIcecream2;
    
    IBOutlet UIImageView *icecream1;
    IBOutlet UIImageView *icecream2;
    IBOutlet UIImageView *icecream3;
    IBOutlet UIImageView *icecream4;

    BOOL touchingHandle;
    int flavor1;
    int flavor2;
    int cone;
    
    float maxHandle;
    float minHandle;
    NSTimer *icecreamPourTimer;
}

@property (nonatomic) int flavor1;
@property (nonatomic) int flavor2;

- (IBAction)backClick:(id)sender;
- (IBAction)nextClick:(id)sender;

@end
