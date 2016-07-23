//
//  MenuViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/13/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController
{
    IBOutlet UIScrollView *scroll;
    IBOutlet UIImageView *backgroundImgView;
    IBOutlet UIButton *soundButton;
    IBOutlet UIImageView *unlockSparkle;
}

- (IBAction)albumClick:(id)sender;
- (IBAction)soundClick:(id)sender;
- (IBAction)storeClick:(id)sender;
- (IBAction)moreClick:(id)sender;
- (IBAction)restoreClick:(id)sender;
- (IBAction)PrivacyPolicy:(id)sender;

@end
