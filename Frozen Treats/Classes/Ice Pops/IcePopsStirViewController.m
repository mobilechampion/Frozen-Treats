//
//  IcePopsStirViewController.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/27/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "IcePopsStirViewController.h"
#import "IcePopsPourViewController.h"
#import "AppDelegate.h"

@implementation IcePopsStirViewController
@synthesize flavor, mold, stickx;

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"IcePopsStirViewController-5" bundle:[NSBundle mainBundle]];
    else
        self = [super init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    flavoredImgView.image = [self colorImage:flavor named:@"jug_texture_grey.png"];
    powder.image = [self colorImage:flavor named:@"punch_powder.png"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    nextButton.hidden = YES;
    flavoredImgView.alpha = 0.0;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        stirLabel.frame = CGRectMake(144, 43, 480, 65);
    else if([UIScreen mainScreen].bounds.size.height == 568)
        stirLabel.frame = CGRectMake(40, 29, 240, 35);
    else
        stirLabel.frame = CGRectMake(40, 27, 240, 35);
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear |UIViewAnimationOptionAutoreverse animations:^
     {
         CGRect frame = stirLabel.frame;
         frame.origin.y += frame.size.height/8;
         stirLabel.frame = frame;
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
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] stopSoundEffect:8];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextClick:(id)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:27];
    
    IcePopsPourViewController *icePopsPour = [[IcePopsPourViewController alloc] init];
    icePopsPour.mold = mold;
    icePopsPour.stick = stickx;
    icePopsPour.flavor = flavor;
    [self.navigationController pushViewController:icePopsPour animated:YES];
    [icePopsPour release];
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if([touch view] == stick)
    {
        touchingStick = YES;
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
        touchOffset = CGPointMake(touchPoint.x - stick.center.x, touchPoint.y - stick.center.y);
    }
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    if(touchingStick)
    {
        UITouch *touch = [[event allTouches] anyObject];
        if([touch view] == stick)
        {
            CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
            
            stick.center = CGPointMake(touchPoint.x - touchOffset.x, touchPoint.y - touchOffset.y);
            
            
            if([UIScreen mainScreen].bounds.size.height == 480)
            {
                if(stick.center.x > 190) {stick.center = CGPointMake(190, stick.center.y);}
                if(stick.center.x < 125) {stick.center = CGPointMake(125, stick.center.y);}
                if(stick.center.y > 295) {stick.center = CGPointMake(stick.center.x, 295);}
                if(stick.center.y < 156) {stick.center = CGPointMake(stick.center.x, 156);}
            }
            else if([UIScreen mainScreen].bounds.size.height == 568)
            {
                if(stick.center.x > 190) {stick.center = CGPointMake(190, stick.center.y);}
                if(stick.center.x < 125) {stick.center = CGPointMake(125, stick.center.y);}
                if(stick.center.y > 360) {stick.center = CGPointMake(stick.center.x, 360);}
                if(stick.center.y < 289) {stick.center = CGPointMake(stick.center.x, 289);}
            }
            else
            {
                if(stick.center.x > 438) {stick.center = CGPointMake(438, stick.center.y);}
                if(stick.center.x < 302) {stick.center = CGPointMake(302, stick.center.y);}
                if(stick.center.y > 648) {stick.center = CGPointMake(stick.center.x, 648);}
                if(stick.center.y < 500) {stick.center = CGPointMake(stick.center.x, 500);}
            }

            [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:8];
            
            
            
            if(flavoredImgView.alpha < 1.0)
            {
//                powder.alpha -= 0.005;
//                texture.alpha -= 0.025;
                flavoredImgView.alpha += 0.005;
            }
            else
            {
                if(nextButton.hidden == YES)
                {
                    nextButton.alpha = 0;
                    nextButton.hidden = NO;
                    //stirThePunchLabel.hidden = YES;
                    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
                     {
                         nextButton.alpha = 1.0;
                     } completion:nil];
                }
            }
        }
    }
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] stopSoundEffect:8];
    if(touchingStick)
        touchingStick = NO;
}

#pragma mark - Color flavor

- (UIImage*)colorImage:(int)flavored named:(NSString*)name
{
    UIColor *flavorx;
    switch(flavored)
    {
        case 24:
            flavorx = [UIColor colorWithRed:6.0/255.0 green:84.0/255.0 blue:143.0/255.0 alpha:1.0];
            break;
            
        case 23:
            flavorx = [UIColor colorWithRed:142.0/255.0 green:3.0/255.0 blue:3.0/255.0 alpha:1.0];
            break;
            
        case 22:
            flavorx = [UIColor colorWithRed:33.0/255.0 green:141.0/255.0 blue:0.0/255.0 alpha:1.0];
            break;
            
        case 21:
            flavorx = [UIColor colorWithRed:143.0/255.0 green:84.0/255.0 blue:6.0/255.0 alpha:1.0];
            break;
            
        case 20:
            flavorx = [UIColor colorWithRed:133.0/255.0 green:0.0/255.0 blue:141.0/255.0 alpha:1.0];
            break;
            
            
        case 19:
            flavorx = [UIColor colorWithRed:251.0/255.0 green:248.0/255.0 blue:34.0/255.0 alpha:1.0];
            break;
            
        case 18:
            flavorx = [UIColor colorWithRed:109.0/255.0 green:178.0/255.0 blue:48.0/255.0 alpha:1.0];
            break;
            
            
        case 17:
            flavorx = [UIColor colorWithRed:255.0/255.0 green:153.0/255.0 blue:96.0/255.0 alpha:1.0];
            break;
            
            
        case 16:
            flavorx = [UIColor colorWithRed:214.0/255.0 green:3.0/255.0 blue:3.0/255.0 alpha:1.0];
            break;
            
        case 15:
            flavorx = [UIColor colorWithRed:156.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1.0];
            break;
            
        case 14:
            flavorx = [UIColor colorWithRed:252.0/255.0 green:176.0/255.0 blue:237/255.0 alpha:1.0];
            break;
            
        case 13:
            flavorx = [UIColor colorWithRed:60.0/255.0 green:0.0/255.0 blue:122.0/255.0 alpha:1.0];
            break;
            
        case 12:
            flavorx = [UIColor colorWithRed:30.0/255.0 green:20.0/255.0 blue:5.0/255.0 alpha:1.0];
            break;
            
        case 11:
            flavorx = [UIColor colorWithRed:22.0/255.0 green:219.0/255.0 blue:255.0/255.0 alpha:1.0];
            break;
            
        case 10:
            flavorx = [UIColor colorWithRed:255.0/255.0 green:162.0/255.0 blue:0.0/255.0 alpha:1.0];
            break;
            
        case 9:
            flavorx = [UIColor colorWithRed:255.0/255.0 green:208.0/255.0 blue:126.0/255.0 alpha:1.0];
            break;
            
        case 8:
            flavorx = [UIColor colorWithRed:79.0/255.0 green:0.0/255.0 blue:48.0/255.0 alpha:1.0];
            break;
            
        case 7:
            flavorx = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:168.0/255.0 alpha:1.0];
            break;
            
        case 6:
            flavorx = [UIColor colorWithRed:0.0/255.0 green:108.0/255.0 blue:255.0/255.0 alpha:1.0];
            break;
            
        case 5:
            flavorx = [UIColor colorWithRed:139.0/255.0 green:84.0/255.0 blue:53.0/255.0 alpha:1.0];
            break;
            
        case 4:
            flavorx = [UIColor colorWithRed:191.0/255.0 green:117.0/255.0 blue:43.0/255.0 alpha:1.0];
            break;
            
        case 3:
            flavorx = [UIColor colorWithRed:22.0/255.0 green:25.0/255.0 blue:14.0/255.0 alpha:1.0];
            break;
            
        case 2:
            flavorx = [UIColor colorWithRed:25.0/255.0 green:120.0/255.0 blue:105.0/255.0 alpha:1.0];
            break;
            
        case 1:
            flavorx = [UIColor colorWithRed:255.0/255.0 green:78.0/255.0 blue:0.0/255.0 alpha:1.0];
            break;
            
        default:
            flavorx = [UIColor colorWithRed:255.0/255.0 green:78.0/255.0 blue:0.0/255.0 alpha:1.0];
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
