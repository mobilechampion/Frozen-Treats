//
//  SnowConesDropViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/30/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnowConesDropViewController : UIViewController
{
    IBOutlet UIButton *nextButton;
    IBOutlet UIImageView *coneImgView;
    IBOutlet UIView *scoopView;
    IBOutlet UIImageView *texture;
    IBOutlet UIImageView *scoopSpoon;
    IBOutlet UIImageView *scoopLabel;
    
    int cone;
    
    int sugar;
    CALayer *textureMask;
}

@property (nonatomic) int cone;

- (IBAction)backClick:(id)sender;
- (IBAction)nextClick:(id)sender;

@end
