//
//  IcecreamConeFinalViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/15/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>

@interface IcecreamConeFinalViewController : UIViewController <MFMailComposeViewControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate>
{
    IBOutlet UIImageView *backgroundImgView;
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *shareButton;
    IBOutlet UIButton *homeButton;
    IBOutlet UIButton *eatAgainButton;
    IBOutlet UIImageView *decorations;

    IBOutlet UIImageView *decoration1;
    IBOutlet UIImageView *decoration2;
    
    IBOutlet UIImageView *coneImgView;
    IBOutlet UIImageView *dipImgView;
    IBOutlet UIImageView *icecream1;
    IBOutlet UIImageView *icecream2;
    IBOutlet UIImageView *icecream3;
    IBOutlet UIImageView *icecream4;
    
    IBOutlet UIView *bitesView;

    int dip;
    int flavor1;
    int flavor2;
    int cone;
    int deco1;
    int deco2;
    
    UIImage *decorationsImage;
    UIImage *imageWithBackground;
    BOOL saved;
    BOOL fromFridge;
    BOOL firstTime;
    BOOL popClosed;
}

@property (nonatomic, retain) UIImage *decorationsImage;
@property (nonatomic) BOOL fromFridge;
@property (nonatomic) int flavor1;
@property (nonatomic) int flavor2;
@property (nonatomic) int cone;
@property (nonatomic) int dip;
@property (nonatomic) int deco1;
@property (nonatomic) int deco2;

- (IBAction)backClick:(id)sender;
- (IBAction)homeClick:(id)sender;
- (IBAction)shareClick:(id)sender;
- (IBAction)saveClick:(id)sender;
- (IBAction)eatAgain:(id)sender;

@end
