//
//  WipeAwayView.h
//  WipeAway
//
//  Created by Craig on 12/6/10.
//

#import <UIKit/UIKit.h>

@interface WipeAwayView : UIView
{
	CGPoint		location;
	CGImageRef	imageRef;
	UIImage		*eraser;
	BOOL		wipingInProgress;
	UIColor		*maskColor;
	CGFloat		eraseSpeed;
    
    int shapeSnowCone;
}

- (id)initWithFrame:(CGRect)frame andShape:(int)shape;
- (void)newMaskWithColor:(UIColor *)color eraseSpeed:(CGFloat)speed;

@end
