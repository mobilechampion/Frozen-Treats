//
//  IcecreamConeDecorateViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/15/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IcecreamConeDecorateViewController : UIViewController
{
    IBOutlet UIScrollView *scroll;
    IBOutlet UIView *decorationsView;
    IBOutlet UIImageView *decoration1;
    IBOutlet UIImageView *decoration2;

    IBOutlet UIImageView *coneImgView;
    IBOutlet UIImageView *dipImgView;
    IBOutlet UIImageView *icecream1;
    IBOutlet UIImageView *icecream2;
    IBOutlet UIImageView *icecream3;
    IBOutlet UIImageView *icecream4;
    
    NSMutableArray *extrasArray;
    NSMutableArray *changes;
    int dip;
    int flavor1;
    int flavor2;
    int cone;
    int deco1;
    int deco2;
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

@property (nonatomic) int flavor1;
@property (nonatomic) int flavor2;
@property (nonatomic) int cone;
@property (nonatomic) int dip;

- (IBAction)backClick:(id)sender;
- (IBAction)nextClick:(id)sender;
- (IBAction)decorationsClick:(id)sender;
- (IBAction)undoClick:(id)sender;
- (IBAction)drawOnsClick:(id)sender;
- (IBAction)extrasClick:(id)sender;

@end
