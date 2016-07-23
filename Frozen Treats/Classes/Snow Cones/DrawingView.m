//
//  DrawingView.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 6/17/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "DrawingView.h"

@implementation DrawingView

- (id)initWithFrame:(CGRect)frame andFlavor:(int)flavorx
{
    self = [super initWithFrame:frame];
    if (self)
    {
        flavor = flavorx;
    }
    return self;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if(imageRef)
    {
        // Restore the screen that was previously saved
        CGContextTranslateCTM(context, 0, rect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        CGContextDrawImage(context, rect, imageRef);
        CGImageRelease(imageRef);
        
        CGContextTranslateCTM(context, 0, rect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
    }
    
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Particle%d.png", flavor]];
    [image drawAtPoint:lastPoint];
    
    imageRef = CGBitmapContextCreateImage(context);
}

- (void)changeFlavor:(int)flavorx
{
    flavor = flavorx;
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    lastPoint.x = touchPoint.x - 25;
    lastPoint.y = touchPoint.y - 25;
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    lastPoint.x = touchPoint.x - 25;
    lastPoint.y = touchPoint.y - 25;
    [self setNeedsDisplay];
}

@end
