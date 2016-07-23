//
//  IcePopsFinalViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/29/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>

@interface IcePopsFinalViewController : UIViewController <MFMailComposeViewControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate>
{
    IBOutlet UIImageView *backgroundImgView;
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *shareButton;
    IBOutlet UIButton *homeButton;
    IBOutlet UIButton *eatAgainButton;
    IBOutlet UIView *bitesView;
    IBOutlet UIImageView *decorations;
    IBOutlet UIImageView *moldImgView;
    IBOutlet UIImageView *stickImgView;
    
    int mold;
    int flavor;
    int stick;
    UIImage *decorationsImage;
    
    UIImage *imageWithBackground;
    BOOL saved;
    BOOL fromFridge;
    BOOL firstTime;
    BOOL popClosed;
}

@property (nonatomic, retain) UIImage *decorationsImage;
@property (nonatomic) BOOL fromFridge;
@property (nonatomic) int mold;
@property (nonatomic) int stick;
@property (nonatomic) int flavor;

- (IBAction)backClick:(id)sender;
- (IBAction)homeClick:(id)sender;
- (IBAction)shareClick:(id)sender;
- (IBAction)saveClick:(id)sender;
- (IBAction)eatAgain:(id)sender;

@end
