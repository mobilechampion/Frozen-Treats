//
//  IcecreamConeChooseDipViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/15/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IcecreamConeChooseDipViewController : UIViewController
{
    IBOutlet UIScrollView *scroll;
    IBOutlet UIImageView *dipConeLabel;
    IBOutlet UIImageView *chooseFlavorLabel;
    IBOutlet UIView *icecreamView;
    IBOutlet UIButton *nextButton;
    
    IBOutlet UIImageView *coneImgView;
    IBOutlet UIImageView *dipImgView;
    IBOutlet UIImageView *icecream1;
    IBOutlet UIImageView *icecream2;
    IBOutlet UIImageView *icecream3;
    IBOutlet UIImageView *icecream4;

    NSTimer *startColoring;
    int dip;
    int flavor1;
    int flavor2;
    int cone;
}

@property (nonatomic) int flavor1;
@property (nonatomic) int flavor2;
@property (nonatomic) int cone;

- (IBAction)backClick:(id)sender;
- (IBAction)nextClick:(id)sender;

@end
