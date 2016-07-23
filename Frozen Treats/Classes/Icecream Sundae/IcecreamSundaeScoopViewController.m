//
//  IcecreamSundaeScoopViewController.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/23/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "IcecreamSundaeScoopViewController.h"
#import "IcecreamSundaeDecorationViewController.h"
#import "AppDelegate.h"

@implementation IcecreamSundaeScoopViewController
@synthesize  dish, flavor;

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"IcecreamSundaeScoopViewController-5" bundle:[NSBundle mainBundle]];
    else
        self = [super init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self arrangeIcecream];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    scoop1.alpha = 0.0;
    scoop2.alpha = 0.0;
    scoop3.alpha = 0.0;
    scoop4.alpha = 0.0;
    scoop5.alpha = 0.0;
    scoops = 0;
    nextButton.hidden = YES;
    scoopLabel.hidden = NO;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        scoopView.frame = CGRectMake(49, 375, 288, 180);
    else if([UIScreen mainScreen].bounds.size.height == 568)
        scoopView.frame = CGRectMake(20, 187, 196, 107);
    else
        scoopView.frame = CGRectMake(20, 177, 196, 107);
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        scoopLabel.frame = CGRectMake(164, 10, 443, 151);
    else if([UIScreen mainScreen].bounds.size.height == 568)
        scoopLabel.frame = CGRectMake(40, 9, 240, 95);
    else
        scoopLabel.frame = CGRectMake(40, 9, 240, 95);
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear |UIViewAnimationOptionAutoreverse animations:^
     {
         CGRect frame = scoopLabel.frame;
         frame.origin.y += frame.size.height/8;
         scoopLabel.frame = frame;
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextClick:(id)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:27];
    
    IcecreamSundaeDecorationViewController *icecreamDecorate = [[IcecreamSundaeDecorationViewController alloc] init];
    icecreamDecorate.flavor = flavor;
    icecreamDecorate.dish = dish;
    [self.navigationController pushViewController:icecreamDecorate animated:YES];
    [icecreamDecorate release];
}

#pragma mark - Touches

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    UITouch *touch = [touches anyObject];
    
    if([touch view] == scoopView)
    {
        scoopView.center = touchPoint;
        
        if([self checkIfOverBowl:touchPoint] == YES)
        {
            if(scoopSpoon.alpha == 0.0 && scoops < nrScoops)
            {
                scoopSpoon.alpha = 1.0;
                [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:26];
            }
        }
        
        if([self checkIFOverSheet:touchPoint] == YES)
        {
            if(scoopSpoon.alpha == 1.0 && scoops < nrScoops)
            {
                scoops++;
                
                scoopSpoon.alpha = 0.0;
                if(scoops == 1)
                    scoop1.alpha = 1.0;
                else if(scoops == 2)
                    scoop2.alpha = 1.0;
                else if(scoops == 3)
                {
                    scoop3.alpha = 1.0;
                    if(nrScoops == 3)
                    {
                        nextButton.hidden = NO;
                        scoopLabel.hidden = YES;
                    }
                }
                else if(scoops == 4)
                {
                    scoop4.alpha = 1.0;
                    if(nrScoops == 4)
                    {
                        nextButton.hidden = NO;
                        scoopLabel.hidden = YES;
                    }
                }
                else if(scoops == 5)
                {
                    scoop5.alpha = 1.0;
                    nextButton.hidden = NO;
                    scoopLabel.hidden = YES;
                }
            }
        }
    }
}

- (BOOL)checkIfOverBowl:(CGPoint)touchPoint
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if(touchPoint.x > 175 && touchPoint.x < 594)
        {
            if(touchPoint.y > 231 && touchPoint.y < 398)
                return YES;
        }
    }
    else if([UIScreen mainScreen].bounds.size.height == 568)
    {
        if(touchPoint.x > 77 && touchPoint.x < 257)
        {
            if(touchPoint.y > 112 && touchPoint.y < 200)
                return YES;
        }
    }
    else
    {
        if(touchPoint.x > 77 && touchPoint.x < 257)
        {
            if(touchPoint.y > 112 && touchPoint.y < 200)
                return YES;
        }
    }
    
    return NO;
}

- (BOOL)checkIFOverSheet:(CGPoint)touchPoint
{
    if(touchPoint.x > dishImgView.frame.origin.x && touchPoint.x < dishImgView.frame.origin.x + dishImgView.frame.size.width)
    {
        if(touchPoint.y > dishImgView.frame.origin.y && touchPoint.y < dishImgView.frame.origin.y + dishImgView.frame.size.height)
            return YES;
    }
    
    return NO;
}


#pragma mark - Helpers

- (void)arrangeIcecream
{
    dishImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dish%d.png", dish]];
    scoop1.image = [UIImage imageNamed:[NSString stringWithFormat:@"scoop%d.png", flavor]];
    scoop2.image = [UIImage imageNamed:[NSString stringWithFormat:@"scoop%d.png", flavor]];
    scoop3.image = [UIImage imageNamed:[NSString stringWithFormat:@"scoop%d.png", flavor]];
    scoop4.image = [UIImage imageNamed:[NSString stringWithFormat:@"scoop%d.png", flavor]];
    scoop5.image = [UIImage imageNamed:[NSString stringWithFormat:@"scoop%d.png", flavor]];
    scoopSpoon.image = [UIImage imageNamed:[NSString stringWithFormat:@"scoop%d.png", flavor]];
    icecreamBowl.image = [UIImage imageNamed:[NSString stringWithFormat:@"t%d.png", flavor]];

    if([UIScreen mainScreen].bounds.size.height == 480)
    {
        switch(dish)
        {
            case 1:
            {
                dishImgView.frame = CGRectMake(84, 317, 153, 163);
                scoop1.frame = CGRectMake(88, 276, 75, 64);
                scoop2.frame = CGRectMake(152, 276, 75, 64);
                scoop3.frame = CGRectMake(117, 235, 75, 64);
                scoop4.image = nil;
                scoop5.image = nil;
                nrScoops = 3;
            }
            break;
                
            case 2:
            {
                dishImgView.frame = CGRectMake(50, 317, 222, 163);
                scoop1.frame = CGRectMake(68, 277, 75, 64);
                scoop2.frame = CGRectMake(124, 260, 75, 64);
                scoop3.frame = CGRectMake(178, 277, 75, 64);
                scoop4.image = nil;
                scoop5.image = nil;
                nrScoops = 3;
            }
            break;
                
            case 3:
            {
                dishImgView.frame = CGRectMake(49, 317, 222, 163);
                scoop1.frame = CGRectMake(68, 277, 75, 64);
                scoop2.frame = CGRectMake(124, 272, 75, 64);
                scoop3.frame = CGRectMake(178, 277, 75, 64);
                scoop4.frame = CGRectMake(95, 228, 75, 64);
                scoop5.frame = CGRectMake(151, 228, 75, 64);
                nrScoops = 5;
            }
            break;

            case 4:
            case 5:
            case 6:
            {
                dishImgView.frame = CGRectMake(49, 317, 222, 163);
                scoop1.frame = CGRectMake(95, 272, 75, 64);
                scoop2.frame = CGRectMake(150, 272, 75, 64);
                scoop3.frame = CGRectMake(131, 239, 75, 64);
                scoop4.image = nil;
                scoop5.image = nil;
                nrScoops = 3;
            }
            break;
                
            case 7:
            case 8:
            {
                dishImgView.frame = CGRectMake(49, 322, 222, 163);
                scoop1.frame = CGRectMake(63, 282, 75, 64);
                scoop2.frame = CGRectMake(124, 282, 75, 64);
                scoop3.frame = CGRectMake(183, 276, 75, 64);
                scoop4.frame = CGRectMake(96, 237, 75, 64);
                scoop5.frame = CGRectMake(156, 231, 75, 64);
                nrScoops = 5;
            }
            break;
                
            case 9:
            case 10:
            case 11:
            case 28:
            {
                dishImgView.frame = CGRectMake(49, 337, 222, 163);
                scoop1.frame = CGRectMake(63, 327, 75, 64);
                scoop2.frame = CGRectMake(124, 327, 75, 64);
                scoop3.frame = CGRectMake(183, 321, 75, 64);
                scoop4.frame = CGRectMake(96, 282, 75, 64);
                scoop5.frame = CGRectMake(156, 276, 75, 64);
                nrScoops = 5;
            }
            break;
                
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            {
                dishImgView.frame = CGRectMake(50, 317, 222, 163);
                scoop1.frame = CGRectMake(63, 282, 75, 64);
                scoop2.frame = CGRectMake(125, 282, 75, 64);
                scoop3.frame = CGRectMake(184, 276, 75, 64);
                scoop4.frame = CGRectMake(97, 237, 75, 64);
                scoop5.frame = CGRectMake(157, 231, 75, 64);
                nrScoops = 5;
            }
            break;
                
            case 17:
            case 18:
            case 19:
            case 20:
            case 21:
            case 22:
            {
                dishImgView.frame = CGRectMake(50, 317, 222, 163);
                scoop1.frame = CGRectMake(92, 276, 75, 64);
                scoop2.frame = CGRectMake(156, 276, 75, 64);
                scoop3.frame = CGRectMake(124, 236, 75, 64);
                scoop4.image = nil;
                scoop5.image = nil;
                nrScoops = 3;
            }
            break;
                
            case 23:
            {
                dishImgView.frame = CGRectMake(31, 294, 260, 191);
                scoop1.frame = CGRectMake(124, 376, 75, 64);
                scoop2.frame = CGRectMake(92, 325, 75, 64);
                scoop3.frame = CGRectMake(156, 325, 75, 64);
                scoop4.frame = CGRectMake(123, 283, 75, 64);
                scoop5.image = nil;
                nrScoops = 4;
            }
            break;
                
            case 24:
            {
                dishImgView.frame = CGRectMake(45, 283, 230, 211);
                scoop1.frame = CGRectMake(150, 386, 75, 64);
                scoop2.frame = CGRectMake(107, 386, 75, 64);
                scoop3.frame = CGRectMake(56, 357, 75, 64);
                scoop4.frame = CGRectMake(183, 329, 75, 64);
                scoop5.frame = CGRectMake(123, 329, 75, 64);
                nrScoops = 5;
            }
            break;
                
            case 25:
            {
                dishImgView.frame = CGRectMake(27, 275, 269, 247);
                scoop1.frame = CGRectMake(123, 376, 75, 64);
                scoop2.frame = CGRectMake(87, 327, 75, 64);
                scoop3.frame = CGRectMake(155, 321, 75, 64);
                scoop4.image = nil;
                scoop5.image = nil;
                nrScoops = 3;
            }
            break;
                
            case 26:
            {
                dishImgView.frame = CGRectMake(27, 253, 269, 247);
                scoop1.frame = CGRectMake(123, 340, 75, 64);
                scoop2.frame = CGRectMake(104, 292, 75, 64);
                scoop3.frame = CGRectMake(170, 286, 75, 64);
                scoop4.frame = CGRectMake(62, 259, 75, 64);
                scoop5.frame = CGRectMake(131, 243, 75, 64);
                nrScoops = 5;
            }
            break;
                
            case 27:
            {
                dishImgView.frame = CGRectMake(26, 242, 269, 247);
                scoop1.frame = CGRectMake(113, 366, 75, 64);
                scoop2.frame = CGRectMake(142, 312, 75, 64);
                scoop3.frame = CGRectMake(113, 264, 75, 64);
                scoop4.frame = CGRectMake(59, 254, 75, 64);
                scoop5.frame = CGRectMake(185, 259, 75, 64);
                nrScoops = 5;
            }
            break;
                
            default:
                break;
        }
    }
    else if([UIScreen mainScreen].bounds.size.height == 568)
    {
        switch(dish)
        {
            case 1:
            {
                dishImgView.frame = CGRectMake(84, 317, 153, 163);
                scoop1.frame = CGRectMake(88, 276, 75, 64);
                scoop2.frame = CGRectMake(152, 276, 75, 64);
                scoop3.frame = CGRectMake(117, 235, 75, 64);
                scoop4.image = nil;
                scoop5.image = nil;
                nrScoops = 3;
            }
                break;
                
            case 2:
            {
                dishImgView.frame = CGRectMake(50, 317, 222, 163);
                scoop1.frame = CGRectMake(68, 277, 75, 64);
                scoop2.frame = CGRectMake(124, 260, 75, 64);
                scoop3.frame = CGRectMake(178, 277, 75, 64);
                scoop4.image = nil;
                scoop5.image = nil;
                nrScoops = 3;
            }
                break;
                
            case 3:
            {
                dishImgView.frame = CGRectMake(49, 317, 222, 163);
                scoop1.frame = CGRectMake(68, 277, 75, 64);
                scoop2.frame = CGRectMake(124, 272, 75, 64);
                scoop3.frame = CGRectMake(178, 277, 75, 64);
                scoop4.frame = CGRectMake(95, 228, 75, 64);
                scoop5.frame = CGRectMake(151, 228, 75, 64);
                nrScoops = 5;
            }
                break;
                
            case 4:
            case 5:
            case 6:
            {
                dishImgView.frame = CGRectMake(49, 317, 222, 163);
                scoop1.frame = CGRectMake(95, 272, 75, 64);
                scoop2.frame = CGRectMake(150, 272, 75, 64);
                scoop3.frame = CGRectMake(131, 239, 75, 64);
                scoop4.image = nil;
                scoop5.image = nil;
                nrScoops = 3;
            }
                break;
                
            case 7:
            case 8:
            {
                dishImgView.frame = CGRectMake(49, 322, 222, 163);
                scoop1.frame = CGRectMake(63, 282, 75, 64);
                scoop2.frame = CGRectMake(124, 282, 75, 64);
                scoop3.frame = CGRectMake(183, 276, 75, 64);
                scoop4.frame = CGRectMake(96, 237, 75, 64);
                scoop5.frame = CGRectMake(156, 231, 75, 64);
                nrScoops = 5;
            }
                break;
                
            case 9:
            case 10:
            case 11:
            case 28:
            {
                dishImgView.frame = CGRectMake(49, 337, 222, 163);
                scoop1.frame = CGRectMake(63, 327, 75, 64);
                scoop2.frame = CGRectMake(124, 327, 75, 64);
                scoop3.frame = CGRectMake(183, 321, 75, 64);
                scoop4.frame = CGRectMake(96, 282, 75, 64);
                scoop5.frame = CGRectMake(156, 276, 75, 64);
                nrScoops = 5;
            }
                break;
                
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            {
                dishImgView.frame = CGRectMake(50, 317, 222, 163);
                scoop1.frame = CGRectMake(63, 282, 75, 64);
                scoop2.frame = CGRectMake(125, 282, 75, 64);
                scoop3.frame = CGRectMake(184, 276, 75, 64);
                scoop4.frame = CGRectMake(97, 237, 75, 64);
                scoop5.frame = CGRectMake(157, 231, 75, 64);
                nrScoops = 5;
            }
                break;
                
            case 17:
            case 18:
            case 19:
            case 20:
            case 21:
            case 22:
            {
                dishImgView.frame = CGRectMake(50, 317, 222, 163);
                scoop1.frame = CGRectMake(92, 276, 75, 64);
                scoop2.frame = CGRectMake(156, 276, 75, 64);
                scoop3.frame = CGRectMake(124, 236, 75, 64);
                scoop4.image = nil;
                scoop5.image = nil;
                nrScoops = 3;
            }
                break;
                
            case 23:
            {
                dishImgView.frame = CGRectMake(31, 294, 260, 191);
                scoop1.frame = CGRectMake(124, 376, 75, 64);
                scoop2.frame = CGRectMake(92, 325, 75, 64);
                scoop3.frame = CGRectMake(156, 325, 75, 64);
                scoop4.frame = CGRectMake(123, 283, 75, 64);
                scoop5.image = nil;
                nrScoops = 4;
            }
                break;
                
            case 24:
            {
                dishImgView.frame = CGRectMake(45, 283, 230, 211);
                scoop1.frame = CGRectMake(150, 386, 75, 64);
                scoop2.frame = CGRectMake(107, 386, 75, 64);
                scoop3.frame = CGRectMake(56, 357, 75, 64);
                scoop4.frame = CGRectMake(183, 329, 75, 64);
                scoop5.frame = CGRectMake(123, 329, 75, 64);
                nrScoops = 5;
            }
                break;
                
            case 25:
            {
                dishImgView.frame = CGRectMake(27, 275, 269, 247);
                scoop1.frame = CGRectMake(123, 376, 75, 64);
                scoop2.frame = CGRectMake(87, 327, 75, 64);
                scoop3.frame = CGRectMake(155, 321, 75, 64);
                scoop4.image = nil;
                scoop5.image = nil;
                nrScoops = 3;
            }
                break;
                
            case 26:
            {
                dishImgView.frame = CGRectMake(27, 253, 269, 247);
                scoop1.frame = CGRectMake(123, 340, 75, 64);
                scoop2.frame = CGRectMake(104, 292, 75, 64);
                scoop3.frame = CGRectMake(170, 286, 75, 64);
                scoop4.frame = CGRectMake(62, 259, 75, 64);
                scoop5.frame = CGRectMake(131, 243, 75, 64);
                nrScoops = 5;
            }
                break;
                
            case 27:
            {
                dishImgView.frame = CGRectMake(26, 242, 269, 247);
                scoop1.frame = CGRectMake(113, 366, 75, 64);
                scoop2.frame = CGRectMake(142, 312, 75, 64);
                scoop3.frame = CGRectMake(113, 264, 75, 64);
                scoop4.frame = CGRectMake(59, 254, 75, 64);
                scoop5.frame = CGRectMake(185, 259, 75, 64);
                nrScoops = 5;
            }
                break;
                
            default:
                break;
        }
        
        dishImgView.frame = CGRectMake(dishImgView.frame.origin.x, dishImgView.frame.origin.y + 50, dishImgView.frame.size.width, dishImgView.frame.size.height);
        scoop1.frame = CGRectMake(scoop1.frame.origin.x, scoop1.frame.origin.y + 50, scoop1.frame.size.width, scoop1.frame.size.height);
        scoop2.frame = CGRectMake(scoop2.frame.origin.x, scoop2.frame.origin.y + 50, scoop2.frame.size.width, scoop2.frame.size.height);
        scoop3.frame = CGRectMake(scoop3.frame.origin.x, scoop3.frame.origin.y + 50, scoop3.frame.size.width, scoop3.frame.size.height);
        scoop4.frame = CGRectMake(scoop4.frame.origin.x, scoop4.frame.origin.y + 50, scoop4.frame.size.width, scoop4.frame.size.height);
        scoop5.frame = CGRectMake(scoop5.frame.origin.x, scoop5.frame.origin.y + 50, scoop5.frame.size.width, scoop5.frame.size.height);
    }
    else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        switch(dish)
        {
            case 1:
            {
                dishImgView.frame = CGRectMake(231, 693, 306, 331);
                scoop1.frame = CGRectMake(266, 629, 120, 105);
                scoop2.frame = CGRectMake(383, 629, 120, 105);
                scoop3.frame = CGRectMake(325, 568, 120, 105);
                scoop4.image = nil;
                scoop5.image = nil;
                nrScoops = 3;
            }
                break;
                
            case 2:
            {
                dishImgView.frame = CGRectMake(203, 693, 364, 331);
                scoop1.frame = CGRectMake(215, 629, 120, 105);
                scoop2.frame = CGRectMake(318, 618, 120, 105);
                scoop3.frame = CGRectMake(426, 629, 120, 105);
                scoop4.image = nil;
                scoop5.image = nil;
                nrScoops = 3;
            }
                break;
                
            case 3:
            {
                dishImgView.frame = CGRectMake(203, 693, 364, 331);
                scoop1.frame = CGRectMake(217, 629, 120, 105);
                scoop2.frame = CGRectMake(325, 629, 120, 105);
                scoop3.frame = CGRectMake(426, 629, 120, 105);
                scoop4.frame = CGRectMake(267, 559, 120, 105);
                scoop5.frame = CGRectMake(374, 554, 120, 105);
                nrScoops = 5;
            }
                break;
                
            case 4:
            case 5:
            case 6:
            {
                dishImgView.frame = CGRectMake(203, 693, 364, 331);
                scoop1.frame = CGRectMake(267, 632, 120, 105);
                scoop2.frame = CGRectMake(376, 618, 120, 105);
                scoop3.frame = CGRectMake(317, 553, 120, 105);
                scoop4.image = nil;
                scoop5.image = nil;
                nrScoops = 3;
            }
                break;
                
            case 7:
            case 8:
            {
                dishImgView.frame = CGRectMake(205, 732, 364, 331);
                scoop1.frame = CGRectMake(216, 714, 120, 105);
                scoop2.frame = CGRectMake(328, 707, 120, 105);
                scoop3.frame = CGRectMake(432, 707, 120, 105);
                scoop4.frame = CGRectMake(272, 648, 120, 105);
                scoop5.frame = CGRectMake(393, 639, 120, 105);
                nrScoops = 5;
            }
                break;
                
            case 9:
            case 10:
            case 11:
            case 28:
            {
                dishImgView.frame = CGRectMake(201, 829, 364, 195);
                scoop1.frame = CGRectMake(216, 774, 120, 105);
                scoop2.frame = CGRectMake(328, 767, 120, 105);
                scoop3.frame = CGRectMake(432, 767, 120, 105);
                scoop4.frame = CGRectMake(272, 708, 120, 105);
                scoop5.frame = CGRectMake(393, 699, 120, 105);
                nrScoops = 5;
            }
                break;
                
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            {
                dishImgView.frame = CGRectMake(189, 735, 391, 289);
                scoop1.frame = CGRectMake(216, 668, 120, 105);
                scoop2.frame = CGRectMake(328, 661, 120, 105);
                scoop3.frame = CGRectMake(432, 661, 120, 105);
                scoop4.frame = CGRectMake(268, 600, 120, 105);
                scoop5.frame = CGRectMake(389, 591, 120, 105);
                nrScoops = 5;
            }
                break;
                
            case 17:
            case 18:
            case 19:
            case 20:
            case 21:
            case 22:
            {
                dishImgView.frame = CGRectMake(189, 735, 391, 289);
                scoop1.frame = CGRectMake(269, 663, 120, 105);
                scoop2.frame = CGRectMake(381, 656, 120, 105);
                scoop3.frame = CGRectMake(324, 591, 120, 105);
                scoop4.image = nil;
                scoop5.image = nil;
                nrScoops = 3;
            }
                break;
                
            case 23:
            {
                dishImgView.frame = CGRectMake(189, 735, 391, 289);
                scoop1.frame = CGRectMake(324, 847, 120, 105);
                scoop2.frame = CGRectMake(268, 759, 120, 105);
                scoop3.frame = CGRectMake(380, 752, 120, 105);
                scoop4.frame = CGRectMake(316, 689, 120, 105);
                scoop5.image = nil;
                nrScoops = 4;
            }
                break;
                
            case 24:
            {
                dishImgView.frame = CGRectMake(190, 735, 391, 289);
                scoop1.frame = CGRectMake(269, 862, 120, 105);
                scoop2.frame = CGRectMake(369, 868, 120, 105);
                scoop3.frame = CGRectMake(219, 770, 120, 105);
                scoop4.frame = CGRectMake(334, 776, 120, 105);
                scoop5.frame = CGRectMake(425, 770, 120, 105);
                nrScoops = 5;
            }
                break;
                
            case 25:
            case 26:
            {
                dishImgView.frame = CGRectMake(189, 742, 391, 289);
                scoop1.frame = CGRectMake(324, 834, 120, 105);
                scoop2.frame = CGRectMake(266, 749, 120, 105);
                scoop3.frame = CGRectMake(379, 742, 120, 105);
                scoop4.image = nil;
                scoop5.image = nil;
                nrScoops = 3;
            }
                break;

            case 27:
            {
                dishImgView.frame = CGRectMake(189, 742, 391, 289);
                scoop1.frame = CGRectMake(325, 855, 120, 105);
                scoop2.frame = CGRectMake(301, 770, 120, 105);
                scoop3.frame = CGRectMake(402, 727, 120, 105);
                scoop4.frame = CGRectMake(239, 720, 120, 105);
                scoop5.frame = CGRectMake(335, 675, 120, 105);
                nrScoops = 5;
            }
                break;
                
            default:
                break;
        }
    }
}


@end
