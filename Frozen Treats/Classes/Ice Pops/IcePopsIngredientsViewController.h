//
//  IcePopsIngredientsViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/28/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IcePopsIngredientsViewController : UIViewController
{
    IBOutlet UIImageView *moldImgView;
    IBOutlet UIImageView *stickImgView;
    IBOutlet UIButton *nextButton;
    IBOutlet UIScrollView *scroll;
    IBOutlet UIView *decorationsView;
    IBOutlet UIButton *backButton;
    IBOutlet UIView *bigView;
    
    UIImageView *drawOn;
    UIImage *currentDrawingImage;
    BOOL movingStopped;
    int lastTag;
    int lastTouchedExtra;
    BOOL touchedExtra;
    CGPoint lastTouchedPoint;
    
    int mold;
    int flavor;
    int stick;
    int lastDecoration;
    NSMutableArray *extrasArray;
}

@property (nonatomic) int flavor;
@property (nonatomic) int mold;
@property (nonatomic) int stick;

- (IBAction)backClick:(id)sender;
- (IBAction)nextClick:(id)sender;
- (IBAction)undoClick:(id)sender;
- (IBAction)decorationsClick:(id)sender;
- (IBAction)drawOnsClick:(id)sender;
- (IBAction)extrasClick:(id)sender;

@end
