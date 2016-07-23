//
//  SnowConesFinalViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 6/3/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>

@interface SnowConesFinalViewController : UIViewController <MFMailComposeViewControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate>
{
    IBOutlet UIImageView *backgroundImgView;
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *shareButton;
    IBOutlet UIButton *homeButton;
    IBOutlet UIButton *eatAgainButton;
    IBOutlet UIView *bitesView;
    IBOutlet UIImageView *decorations;
    IBOutlet UIImageView *coneImgView;
    IBOutlet UIImageView *shapeImgView;
    IBOutlet UIImageView *flavorImgView;

    int cone;
    int shape;
    int flavor;
    
    UIImage *awsomeImage;
    UIImage *decorationsImage;
    UIImage *imageWithBackground;
    BOOL saved;
    BOOL fromFridge;
    BOOL firstTime;
    BOOL popClosed;
}

@property (nonatomic, retain) UIImage *awsomeImage;
@property (nonatomic, retain) UIImage *decorationsImage;
@property (nonatomic) BOOL fromFridge;
@property (nonatomic) int cone;
@property (nonatomic) int shape;
@property (nonatomic) int flavor;

@end
