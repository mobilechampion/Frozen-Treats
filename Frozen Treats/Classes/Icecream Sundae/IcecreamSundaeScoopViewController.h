//
//  IcecreamSundaeScoopViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/23/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IcecreamSundaeScoopViewController : UIViewController
{
    IBOutlet UIImageView *dishImgView;
    IBOutlet UIView *scoopView;
    IBOutlet UIImageView *scoopSpoon;
    IBOutlet UIButton *nextButton;
    IBOutlet UIImageView *scoopLabel;
    IBOutlet UIImageView *icecreamBowl;
    
    IBOutlet UIImageView *scoop1;
    IBOutlet UIImageView *scoop2;
    IBOutlet UIImageView *scoop3;
    IBOutlet UIImageView *scoop4;
    IBOutlet UIImageView *scoop5;
    
    int scoops;
    int nrScoops;
    int dish;
    int flavor;
}

@property (nonatomic) int dish;
@property (nonatomic) int flavor;

- (IBAction)backClick:(id)sender;
- (IBAction)nextClick:(id)sender;

@end
