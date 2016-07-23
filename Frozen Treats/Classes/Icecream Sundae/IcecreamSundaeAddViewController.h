//
//  IcecreamSundaeAddViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/23/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IcecreamSundaeAddViewController : UIViewController
{
    IBOutlet UIView *bowlView;
    IBOutlet UIImageView *icecreamBefore;
    IBOutlet UIImageView *dragLabel;
    IBOutlet UIButton *nextButton;
    
    int flavor;
}

@property (nonatomic) int flavor;

- (IBAction)backClick:(id)sender;
- (IBAction)nextClick:(id)sender;

@end
