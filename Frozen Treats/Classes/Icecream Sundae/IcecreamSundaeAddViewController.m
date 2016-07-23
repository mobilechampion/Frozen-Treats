//
//  IcecreamSundaeAddViewController.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/23/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "IcecreamSundaeAddViewController.h"
#import "IcecreamSundaeDishViewController.h"
#import "AppDelegate.h"

@implementation IcecreamSundaeAddViewController
@synthesize flavor;

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"IcecreamSundaeAddViewController-5" bundle:[NSBundle mainBundle]];
    else
        self = [super init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    icecreamBefore.image = [self colorImage:flavor named:@"icecream_before.png"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    nextButton.hidden = YES;
    dragLabel.hidden = NO;
    bowlView.userInteractionEnabled = YES;

    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        bowlView.frame = CGRectMake(199, 277, 370, 218);
    else if([UIScreen mainScreen].bounds.size.height == 568)
        bowlView.frame = CGRectMake(51, 179, 218, 109);
    else
        bowlView.frame = CGRectMake(51, 139, 218, 109);
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        dragLabel.frame = CGRectMake(144, 26, 480, 138);
    else if([UIScreen mainScreen].bounds.size.height == 568)
        dragLabel.frame = CGRectMake(40, 30, 240, 74);
    else
        dragLabel.frame = CGRectMake(40, 14, 240, 74);
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear |UIViewAnimationOptionAutoreverse animations:^
     {
         CGRect frame = dragLabel.frame;
         frame.origin.y += frame.size.height/8;
         dragLabel.frame = frame;
     } completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction

- (IBAction)backClick:(id)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:27];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] stopSoundEffect:22];
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)nextClick:(id)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:27];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] stopSoundEffect:22];
    
    IcecreamSundaeDishViewController *icecreamDish = [[IcecreamSundaeDishViewController alloc] init];
    icecreamDish.flavor = flavor;
    [self.navigationController pushViewController:icecreamDish animated:YES];
    [icecreamDish release];
}

#pragma mark - Touches

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    UITouch *touch = [touches anyObject];
    
    float minX, minY, maxY;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        minX = 384;
        minY = 386;
        maxY = 895;
    }
    else if([UIScreen mainScreen].bounds.size.height == 568)
    {
        minX = 160;
        minY = 234;
        maxY = 498;
    }
    else
    {
        minX = 160;
        minY = 194;
        maxY = 406;
    }
    
    
    if([touch view] == bowlView && ![dragLabel isHidden])
    {
        touchPoint.x = minX;
        if(touchPoint.y < minY)
            touchPoint.y = minY;
        
        if(touchPoint.y > maxY)
        {
            touchPoint.y = maxY;
            dragLabel.hidden = YES;
            bowlView.userInteractionEnabled = NO;
            nextButton.hidden = NO;
            
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:22];
        }
        
        bowlView.center = touchPoint;
    }
}

#pragma mark - Color flavor

- (UIImage*)colorImage:(int)flavored named:(NSString*)name
{
    UIColor *flavorx;
    switch(flavored)
    {
        case 1:
            flavorx = [UIColor colorWithRed:0.470588 green:0.631373 blue:0.227451 alpha:1];
            break;
        case 2:
            flavorx = [UIColor colorWithRed:255./255.0 green:171.0/255.0 blue:0.0/255.0 alpha:1];
            break;
        case 3:
            flavorx = [UIColor colorWithRed:0.286275 green:0.000000 blue:0.180392 alpha:1];
            break;
        case 4:
            flavorx = [UIColor colorWithRed:98.0/255.0 green:178.0/255.0 blue:89.0/255.0 alpha:1];
            break;
        case 5:
            flavorx = [UIColor colorWithRed:235.0/255.0 green:78.0/255.0 blue:0.0/255.0 alpha:1];
            break;
        case 6:
            flavorx = [UIColor colorWithRed:0.894118 green:0.803922 blue:0.188235 alpha:1];
            break;
        case 7:
            flavorx = [UIColor colorWithRed:0.921569 green:0.105882 blue:0.090196 alpha:1];
            break;
        case 8:
            flavorx = [UIColor colorWithRed:0.160784 green:0.905882 blue:0.945098 alpha:1];
            break;
        case 9:
            flavorx = [UIColor colorWithRed:0.913726 green:0.000000 blue:0.109804 alpha:1];
            break;
        case 10:
            flavorx = [UIColor colorWithRed:0.815686 green:0.039216 blue:0.392157 alpha:1];
            break;
        case 11:
            flavorx = [UIColor colorWithRed:0.941177 green:0.062745 blue:0.603922 alpha:1];
            break;
        case 12:
            flavorx = [UIColor colorWithRed:71.0/255.0 green:176.0/255.0 blue:60.0/255.0 alpha:1];
            break;
        case 13:
            flavorx = [UIColor colorWithRed:255./255.0 green:171.0/255.0 blue:0.0/255.0 alpha:1];
            break;
        case 14:
            flavorx = [UIColor colorWithRed:0.929412 green:0.756863 blue:0.149020 alpha:1];
            break;
        case 15:
            flavorx = [UIColor colorWithRed:0.882353 green:0.650980 blue:0.258824 alpha:1];
            break;
        case 16:
            flavorx = [UIColor colorWithRed:0.627451 green:0.000000 blue:0.019608 alpha:1];
            break;
            
        default:
            flavorx = [UIColor colorWithRed:0.470588 green:0.631373 blue:0.227451 alpha:1];
            break;
    }
    
    
    //load the image
    //NSString *name = @"texture_punch_grey.png";
    UIImage *img = [UIImage imageNamed:name];
    
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(img.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [flavorx setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}

@end
