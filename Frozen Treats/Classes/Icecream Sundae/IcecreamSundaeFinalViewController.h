//
//  IcecreamSundaeFinalViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/24/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>

@interface IcecreamSundaeFinalViewController : UIViewController <MFMailComposeViewControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate>
{
    IBOutlet UIImageView *backgroundImgView;
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *shareButton;
    IBOutlet UIButton *homeButton;
    IBOutlet UIButton *eatAgainButton;
    IBOutlet UIView *bitesView;
    IBOutlet UIImageView *decorations;
    
    IBOutlet UIImageView *dishImgView;
    IBOutlet UIImageView *scoop1;
    IBOutlet UIImageView *scoop2;
    IBOutlet UIImageView *scoop3;
    IBOutlet UIImageView *scoop4;
    IBOutlet UIImageView *scoop5;

    int flavor;
    int dish;
    NSMutableArray *drizzles;
    
    UIImage *decorationsImage;
    UIImage *imageWithBackground;
    BOOL saved;
    BOOL fromFridge;
    BOOL firstTime;
    BOOL popClosed;
}

@property (nonatomic, retain) UIImage *decorationsImage;
@property (nonatomic, retain) NSMutableArray *drizzles;
@property (nonatomic) BOOL fromFridge;
@property (nonatomic) int flavor;
@property (nonatomic) int dish;

- (IBAction)backClick:(id)sender;
- (IBAction)homeClick:(id)sender;
- (IBAction)shareClick:(id)sender;
- (IBAction)saveClick:(id)sender;
- (IBAction)eatAgain:(id)sender;

@end
