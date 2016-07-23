//
//  IcecreamSandFinalViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/21/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>

@interface IcecreamSandFinalViewController : UIViewController <MFMailComposeViewControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate>
{
    IBOutlet UIImageView *backgroundImgView;
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *shareButton;
    IBOutlet UIButton *homeButton;
    IBOutlet UIButton *eatAgainButton;
    IBOutlet UIImageView *decorations;
    
    IBOutlet UIImageView *icecreamImgView;
    IBOutlet UIImageView *decoration;
    IBOutlet UIView *bitesView;
    
    int deco;
    int icecream;
    
    UIImage *decorationsImage;
    UIImage *imageWithBackground;
    BOOL saved;
    BOOL fromFridge;
    BOOL firstTime;
    BOOL popClosed;
}

@property (nonatomic, retain) UIImage *decorationsImage;
@property (nonatomic) BOOL fromFridge;
@property (nonatomic) int deco;
@property (nonatomic) int icecream;

- (IBAction)backClick:(id)sender;
- (IBAction)homeClick:(id)sender;
- (IBAction)shareClick:(id)sender;
- (IBAction)saveClick:(id)sender;
- (IBAction)eatAgain:(id)sender;

@end
