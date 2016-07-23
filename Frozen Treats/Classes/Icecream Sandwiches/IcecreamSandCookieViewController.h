//
//  IcecreamSandCookieViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/20/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IcecreamSandCookieViewController : UIViewController
{
    IBOutlet UIButton *nextButton;
    IBOutlet UIView *spoonView;
    IBOutlet UIImageView *spoonCookie;
    IBOutlet UIImageView *cookie1;
    IBOutlet UIImageView *cookie2;
    IBOutlet UIImageView *cookie3;
    IBOutlet UIImageView *cookie4;
    IBOutlet UIImageView *cookie5;
    IBOutlet UIImageView *cookie6;
    IBOutlet UIImageView *dragLabel;
    
    int cookies;
}

- (IBAction)backClick:(id)sender;
- (IBAction)nextClick:(id)sender;

@end
