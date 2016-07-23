//
//  IcecreamSundaeMixViewController.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/23/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "IcecreamSundaeMixViewController.h"
#import "IcecreamSundaeAddViewController.h"
#import "AppDelegate.h"

@implementation IcecreamSundaeMixViewController
@synthesize flavor;

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"IcecreamSundaeMixViewController-5" bundle:[NSBundle mainBundle]];
    else
        self = [super init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    flavorPowder.image = [self colorImage:flavor named:@"punch_powder.png"];
    mixContent.image = [self colorImage:flavor named:@"mix_coloured.png"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    mixButton.userInteractionEnabled = YES;
    shakeStopped = NO;
    nextButton.hidden = YES;
    shakeLabel.alpha = 0.0;
    mixContent.alpha = 0.0;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        topPart.frame = CGRectMake(100, 492, 276, 172);
        mixButton.frame = CGRectMake(278 - 119, 530, 72, 72);
    }
    else if([UIScreen mainScreen].bounds.size.height == 568)
    {
        topPart.frame = CGRectMake(0, 288, 138, 86);
        mixButton.frame = CGRectMake(85 - 56, 306, 37, 37);
    }
    else
    {
        topPart.frame = CGRectMake(0, 238, 138, 86);
        mixButton.frame = CGRectMake(85 - 56, 257, 37, 37);
    }
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        shakeLabel.frame = CGRectMake(73, 120, 622, 85);
    else if([UIScreen mainScreen].bounds.size.height == 568)
        shakeLabel.frame = CGRectMake(20, 60, 280, 43);
    else
        shakeLabel.frame = CGRectMake(20, 45, 280, 43);
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear |UIViewAnimationOptionAutoreverse animations:^
     {
         CGRect frame = shakeLabel.frame;
         frame.origin.y += frame.size.height/8;
         shakeLabel.frame = frame;
     } completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.75 animations:^
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            topPart.frame = CGRectMake(219, 492, 276, 172);
            mixButton.frame = CGRectMake(278, 530, 72, 72);
        }
        else if([UIScreen mainScreen].bounds.size.height == 568)
        {
            topPart.frame = CGRectMake(56, 288, 138, 86);
            mixButton.frame = CGRectMake(85, 306, 37, 37);
        }
        else
        {
            topPart.frame = CGRectMake(56, 238, 138, 86);
            mixButton.frame = CGRectMake(85, 257, 37, 37);
        }
    }
    completion:^(BOOL finished)
    {
        [UIView animateWithDuration:0.5 animations:^{
            shakeLabel.alpha = 1.0;
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction

- (IBAction)backClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:27];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] stopSoundEffect:16];
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)nextClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:27];
    
    IcecreamSundaeAddViewController *icecreamFreezer = [[IcecreamSundaeAddViewController alloc] init];
    icecreamFreezer.flavor = flavor;
    [self.navigationController pushViewController:icecreamFreezer animated:YES];
    [icecreamFreezer release];
}

- (IBAction)startMix:(id)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:16];

    [self shakeMachine];
    mixButton.userInteractionEnabled = NO;
}

#pragma mark - Shake

- (void)shakeMachine
{
    [UIView animateWithDuration:0.03 delay:0 options:UIViewAnimationOptionCurveLinear animations:^
     {
         CGRect frame = blenderView.frame;
         frame.origin.y += 2;
         frame.origin.x += 2;
         blenderView.frame = frame;
         
         mixContent.alpha += 0.01;
         
         if(mixContent.alpha >= 1.0)
         {
             nextButton.hidden = NO;
             
             shakeLabel.alpha = 0.0;
             shakeStopped = YES;
         }
     }
     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.03 delay:0 options:UIViewAnimationOptionCurveLinear animations:^
          {
              CGRect frame = blenderView.frame;
              frame.origin.x -= 4;
              frame.origin.y -= 4;
              blenderView.frame = frame;
              
              mixContent.alpha += 0.01;
              
              if(mixContent.alpha >= 1.0)
              {
                  nextButton.hidden = NO;
                  shakeLabel.alpha = 0.0;
                  shakeStopped = YES;
              }
          }
          completion:^(BOOL finished)
          {
              [UIView animateWithDuration:0.03 delay:0 options:UIViewAnimationOptionCurveLinear animations:^
               {
                   CGRect frame = blenderView.frame;
                   frame.origin.x += 4;
                   blenderView.frame = frame;
                   
                   mixContent.alpha += 0.01;
                   
                   if(mixContent.alpha >= 1.0)
                   {
                       nextButton.hidden = NO;
                       shakeLabel.alpha = 0.0;
                       shakeStopped = YES;
                   }
               }
               completion:^(BOOL finished)
               {
                   [UIView animateWithDuration:0.03 delay:0 options:UIViewAnimationOptionCurveLinear animations:^
                    {
                        CGRect frame = blenderView.frame;
                        frame.origin.x -= 2;
                        frame.origin.y += 2;
                        blenderView.frame = frame;
                        
                        mixContent.alpha += 0.01;
                        
                        if(mixContent.alpha >= 1.0)
                        {
                            nextButton.hidden = NO;
                            shakeLabel.alpha = 0.0;
                            shakeStopped = YES;
                        }
                    }
                    completion:^(BOOL finished)
                    {
                        [blenderView.layer removeAllAnimations];
                        if(shakeStopped == NO)
                        {
                            [self shakeMachine];
                        }
                        else
                        {
                            [(AppDelegate*)[[UIApplication sharedApplication] delegate] stopSoundEffect:16];
                        }
                    }];
               }];
          }];
     }];
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
