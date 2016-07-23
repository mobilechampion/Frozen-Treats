//
//  IcecreamSandDecorateViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/21/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IcecreamSandDecorateViewController : UIViewController
{
    IBOutlet UIScrollView *scroll;
    IBOutlet UIView *decorationsView;
    IBOutlet UIImageView *icecreamImgView;
    IBOutlet UIImageView *decoration;
    IBOutlet UIImageView *topBiscuit;
    
    int icecream;
    int deco;
    NSMutableArray *changes;
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

@property (nonatomic) int icecream;

- (IBAction)backClick:(id)sender;
- (IBAction)nextClick:(id)sender;
- (IBAction)decorationsClick:(id)sender;
- (IBAction)undoClick:(id)sender;
- (IBAction)drawOnsClick:(id)sender;
- (IBAction)extrasClick:(id)sender;

@end
