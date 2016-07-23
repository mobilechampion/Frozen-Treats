//
//  IcecreamSundaeDecorationViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/23/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IcecreamSundaeDecorationViewController : UIViewController
{
    IBOutlet UIScrollView *scroll;
    IBOutlet UIView *decorationsView;
    IBOutlet UIImageView *dishImgView;

    IBOutlet UIImageView *scoop1;
    IBOutlet UIImageView *scoop2;
    IBOutlet UIImageView *scoop3;
    IBOutlet UIImageView *scoop4;
    IBOutlet UIImageView *scoop5;
    IBOutlet UIButton *backButton;
    
    int dish;
    int flavor;
//    NSMutableArray *changes;
//    NSMutableArray *drizzles;
    NSMutableArray *extrasArray;
    int lastDecoration;
    
    IBOutlet UIView *bigView;
    
    UIImageView *drawOn;
    UIImage *currentDrawingImage;
    BOOL movingStopped;
    int lastTag;
    int lastTouchedExtra;
    BOOL touchedExtra;
    CGPoint lastTouchedPoint;
}

@property (nonatomic) int dish;
@property (nonatomic) int flavor;

- (IBAction)backClick:(id)sender;
- (IBAction)nextClick:(id)sender;
- (IBAction)decorationsClick:(id)sender;
- (IBAction)undoClick:(id)sender;
- (IBAction)drawOnsClick:(id)sender;
- (IBAction)extrasClick:(id)sender;

@end
