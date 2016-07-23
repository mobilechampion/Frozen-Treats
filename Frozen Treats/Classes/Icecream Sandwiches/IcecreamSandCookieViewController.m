//
//  IcecreamSandCookieViewController.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/20/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "IcecreamSandCookieViewController.h"
#import "IcecreamSandOvenViewController.h"
#import "AppDelegate.h"

@implementation IcecreamSandCookieViewController

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"IcecreamSandCookieViewController-5" bundle:[NSBundle mainBundle]];
    else
        self = [super init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        spoonView.frame = CGRectMake(418, 354, 360, 132);
    else if([UIScreen mainScreen].bounds.size.height == 568)
        spoonView.frame = CGRectMake(135, 260, 180, 66);
    else
        spoonView.frame = CGRectMake(135, 219, 180, 66);
    
    nextButton.hidden = YES;
    
    cookies = 0;
    spoonCookie.alpha = 0.0;
    cookie1.alpha = 0.0;
    cookie2.alpha = 0.0;
    cookie3.alpha = 0.0;
    cookie4.alpha = 0.0;
    cookie5.alpha = 0.0;
    cookie6.alpha = 0.0;
    
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        dragLabel.frame = CGRectMake(34, 20, 700, 88);
    else if([UIScreen mainScreen].bounds.size.height == 568)
        dragLabel.frame = CGRectMake(16, 20, 289, 45);
    else
        dragLabel.frame = CGRectMake(16, 20, 289, 45);
    
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
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:27];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextClick:(id)sender
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:27];
    
    IcecreamSandOvenViewController *icecreamOven = [[IcecreamSandOvenViewController alloc] init];
    [self.navigationController pushViewController:icecreamOven animated:YES];
    [icecreamOven release];
}

#pragma mark - Touches

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    UITouch *touch = [touches anyObject];
    
    if([touch view] == spoonView)
    {
        spoonView.center = touchPoint;
        
        if([self checkIfOverBowl:touchPoint] == YES)
        {
            if(spoonCookie.alpha == 0.0 && cookies < 6)
            {
                spoonCookie.alpha = 1.0;
                [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:24];
            }
        }
        
        if([self checkIFOverSheet:touchPoint] == YES)
        {
            if(spoonCookie.alpha == 1.0 && cookies < 6)
            {
                [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:31];
                
                cookies++;
                spoonCookie.alpha = 0.0;
                if(cookies == 1)
                    cookie1.alpha = 1.0;
                else if(cookies == 2)
                    cookie2.alpha = 1.0;
                else if(cookies == 3)
                    cookie3.alpha = 1.0;
                else if(cookies == 4)
                    cookie4.alpha = 1.0;
                else if(cookies == 5)
                    cookie5.alpha = 1.0;
                else if(cookies == 6)
                {
                    cookie6.alpha = 1.0;
                    nextButton.hidden = NO;
                }
            }
        }
    }
}

- (BOOL)checkIfOverBowl:(CGPoint)touchPoint
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if(touchPoint.x > 240 && touchPoint.x < 590)
        {
            if(touchPoint.y > 140 && touchPoint.y < 420)
                return YES;
        }
    }
    else if([UIScreen mainScreen].bounds.size.height == 568)
    {
        if(touchPoint.x > 80 && touchPoint.x < 240)
        {
            if(touchPoint.y > 87 && touchPoint.y < 235)
                return YES;
        }
    }
    else
    {
        if(touchPoint.x > 80 && touchPoint.x < 240)
        {
            if(touchPoint.y > 87 && touchPoint.y < 235)
                return YES;
        }
    }
    
    return NO;
}

- (BOOL)checkIFOverSheet:(CGPoint)touchPoint
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if(touchPoint.x > 112 && touchPoint.x < 690)
        {
            if(touchPoint.y > 555 && touchPoint.y < 910)
                return YES;
        }
    }
    else if([UIScreen mainScreen].bounds.size.height == 568)
    {
        if(touchPoint.x > 50 && touchPoint.x < 280)
        {
            if(touchPoint.y > 356 && touchPoint.y < 486)
                return YES;
        }
    }
    else
    {
        if(touchPoint.x > 50 && touchPoint.x < 280)
        {
            if(touchPoint.y > 300 && touchPoint.y < 430)
                return YES;
        }
    }
    
    return NO;
}

@end
