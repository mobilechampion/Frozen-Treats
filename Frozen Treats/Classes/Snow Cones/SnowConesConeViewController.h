//
//  SnowConesConeViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/30/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnowConesConeViewController : UIViewController
{
    IBOutlet UIScrollView *scroll;
    IBOutlet UIImageView *chooseLabel;
    int cone;
}

- (IBAction)backClick:(id)sender;
- (IBAction)nextClick:(id)sender;

@end
