//
//  DrawingView.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 6/17/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawingView : UIView
{
    CGImageRef imageRef;
    int flavor;
    CGPoint lastPoint;
}

- (id)initWithFrame:(CGRect)frame andFlavor:(int)flavorx;
- (void)changeFlavor:(int)flavorx;

@end
