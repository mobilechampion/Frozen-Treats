//
//  IcecreamSandFlavorViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/21/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IcecreamSandFlavorViewController : UIViewController
{
    IBOutlet UIScrollView *scroll;
    IBOutlet UIButton *nextButton;
    IBOutlet UIImageView *icecreamImgView;
    
    int icecream;
}

- (IBAction)backClick:(id)sender;
- (IBAction)nextClick:(id)sender;

@end
