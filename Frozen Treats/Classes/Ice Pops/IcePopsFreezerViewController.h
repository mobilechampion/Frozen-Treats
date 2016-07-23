//
//  IcePopsFreezerViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/28/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IcePopsFreezerViewController : UIViewController
{
    IBOutlet UIView *moldView;
    IBOutlet UIImageView *moldImgView;
    IBOutlet UIImageView *stickImgView;
    IBOutlet UIButton *nextButton;
    IBOutlet UIImageView *dragLabel;
    
    int mold;
    int flavor;
    int stick;
}

@property (nonatomic) int flavor;
@property (nonatomic) int mold;
@property (nonatomic) int stick;

- (IBAction)backClick:(id)sender;
- (IBAction)nextClick:(id)sender;

@end
