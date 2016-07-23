//
//  IcePopsFirstViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/27/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IcePopsFirstViewController : UIViewController
{
    IBOutlet UIScrollView *scroll;
    IBOutlet UIImageView *slideLabel;
    int mold;
}

- (IBAction)backClick:(id)sender;
- (IBAction)nextClick:(id)sender;

@end
