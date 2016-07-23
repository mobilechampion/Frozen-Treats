//
//  WipeAwayView.m
//  WipeAway
//
//  Created by Craig on 12/6/10.
//
//  See http://craigcoded.com/2010/12/08/erase-top-uiview-to-reveal-content-underneath/ for full explanation
//

#import "WipeAwayView.h"

@implementation WipeAwayView

- (id)initWithFrame:(CGRect)frame andShape:(int)shape
{
    self = [super initWithFrame:frame];
    if(self)
    {
        shapeSnowCone = shape;
		wipingInProgress = NO;
		eraser = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"eraser" ofType:@"png"]];
		[self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)newMaskWithColor:(UIColor *)color eraseSpeed:(CGFloat)speed
{
	wipingInProgress = NO;
	eraseSpeed = speed;
	
	[color retain];
	[maskColor release];
	maskColor = color;
	
	[self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	wipingInProgress = YES;
    if([touches count] == 1)
    {
		UITouch *touch = [touches anyObject];
		location = [touch locationInView:self];
		location.x -= [eraser size].width/2;
		location.y -= [eraser size].width/2;
		[self setNeedsDisplay];
	}
}
	
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if([touches count] == 1)
    {
		UITouch *touch = [touches anyObject];
		location = [touch locationInView:self];
		location.x -= [eraser size].width/2;
		location.y -= [eraser size].width/2;
		[self setNeedsDisplay];
	}
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();

	if(wipingInProgress)
    {
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

		// Erase the background -- raise the alpha to clear more away with eash swipe
		[eraser drawAtPoint:location blendMode:kCGBlendModeDestinationOut alpha:eraseSpeed];
	}
    else
    {
        UIImage *imageFirst = [UIImage imageNamed:[NSString stringWithFormat:@"a%d.png", shapeSnowCone]];
        UIImage *image = [self imageWithImage:imageFirst scaledToSize:[self sizeForShape:shapeSnowCone]];
        
        CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
        //CGRect imageRect = CGRectMake(30, 224, 268, 232);
        
        CGContextTranslateCTM(context, 0, image.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        CGContextDrawImage(context, imageRect, image.CGImage);

        
//		// First time in, we start with a solid color
//		CGContextSetFillColorWithColor( context, maskColor.CGColor);
//		CGContextFillRect(context, rect);
	}

	// Save the screen to restore next time around
	imageRef = CGBitmapContextCreateImage(context);
	
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (CGSize)sizeForShape:(int)shape
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        switch(shape)
        {
            case 1:
                return CGSizeMake(536, 294);
                break;
                
            case 2:
                return CGSizeMake(592, 406);
                break;
                
            case 3:
                return CGSizeMake(578, 446);
                break;
                
            case 4:
                return CGSizeMake(478, 446);
                break;
                
            case 5:
                return CGSizeMake(548, 446);
                break;
                
            case 6:
                return CGSizeMake(536, 486);
                break;
                
            case 7:
                return CGSizeMake(620, 404);
                break;
                
            case 8:
                return CGSizeMake(474, 528);
                break;
                
            case 9:
                return CGSizeMake(590, 410);
                break;
                
            case 10:
                return CGSizeMake(590, 516);
                break;
                
            default:
                return CGSizeMake(0, 0);
                break;
        }
    }
    else
    {
        switch (shape)
        {
            case 1:
                return CGSizeMake(268, 147);
                break;
                
            case 2:
                return CGSizeMake(296, 203);
                break;
                
            case 3:
                return CGSizeMake(289, 223);
                break;
                
            case 4:
                return CGSizeMake(239, 223);
                break;
                
            case 5:
                return CGSizeMake(274, 223);
                break;
                
            case 6:
                return CGSizeMake(268, 243);
                break;
                
            case 7:
                return CGSizeMake(310, 202);
                break;
                
            case 8:
                return CGSizeMake(254, 283);
                break;
                
            case 9:
                return CGSizeMake(295, 205);
                break;
                
            case 10:
                return CGSizeMake(295, 258);
                break;
                
            default:
                return CGSizeMake(0, 0);
                break;
        }
    }
    return CGSizeMake(268, 147);
}

- (void)dealloc
{
	[maskColor release];
	[eraser release];
    [super dealloc];
}


@end
