//
//  IcePopsStickViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 6/10/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IcePopsStickViewController : UIViewController
{
    IBOutlet UIScrollView *scroll;
    IBOutlet UIImageView *slideLabel;
    int mold;
    int stick;
}

@property (nonatomic) int mold;

- (IBAction)backClick:(id)sender;
- (IBAction)nextClick:(id)sender;

@end
