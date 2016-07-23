//
//  IcePopsStirViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/27/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IcePopsStirViewController : UIViewController
{
    IBOutlet UIButton *nextButton;
    IBOutlet UIImageView *stick;
    IBOutlet UIImageView *flavoredImgView;
    IBOutlet UIImageView *powder;
    IBOutlet UIImageView *stirLabel;
    
    CGPoint touchOffset;
    BOOL touchingStick;
    
    int flavor;
    int mold;
    int stickx;
}

@property (nonatomic) int flavor;
@property (nonatomic) int mold;
@property (nonatomic) int stickx;

- (IBAction)backClick:(id)sender;
- (IBAction)nextClick:(id)sender;

@end
