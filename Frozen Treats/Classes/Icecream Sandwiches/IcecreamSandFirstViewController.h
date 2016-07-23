//
//  IcecreamSandFirstViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/20/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IcecreamSandFirstViewController : UIViewController
{
    IBOutlet UIView *spoonView;
    IBOutlet UIImageView *addIngredientsLabel;
    IBOutlet UIImageView *cocoImgView;
    IBOutlet UIImageView *eggImgView;
    IBOutlet UIImageView *flourImgView;
    
    IBOutlet UIImageView *oilBowlImgView;
    IBOutlet UIImageView *cocoBowlImgView;
    IBOutlet UIImageView *eggBowlImgView;
    IBOutlet UIImageView *flourBowlImgView;
    IBOutlet UIButton *nextButton;
    
    IBOutlet UIImageView *mixIngrediendsLabel;
    IBOutlet UIImageView *woodSpoon;
    IBOutlet UIImageView *doughImgView;
    
    BOOL coco;
    BOOL egg;
    BOOL flour;
    BOOL oil;
    BOOL mixing;
    NSTimer *mixingSound;
}

- (IBAction)backClick:(id)sender;
- (IBAction)nextClick:(id)sender;

@end
