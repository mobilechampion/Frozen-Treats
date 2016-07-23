//
//  SnowConesDecorateViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/31/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnowConesDecorateViewController : UIViewController
{
    IBOutlet UIScrollView *scroll;
    IBOutlet UIView *decorationsView;
    IBOutlet UIImageView *coneImgView;
    IBOutlet UIImageView *shapeImgView;
    IBOutlet UIImageView *flavorImgView;
    
    int cone;
    int shape;
    int flavor;
    
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
    
    UIImage *awsomeImage;
}

@property (nonatomic) int cone;
@property (nonatomic) int shape;
@property (nonatomic) int flavor;
@property (nonatomic, retain) UIImage *awsomeImage;

- (IBAction)backClick:(id)sender;
- (IBAction)nextClick:(id)sender;
- (IBAction)decorationsClick:(id)sender;
- (IBAction)undoClick:(id)sender;
- (IBAction)drawOnsClick:(id)sender;
- (IBAction)extrasClick:(id)sender;

@end
