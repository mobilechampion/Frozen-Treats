//
//  IcecreamSandFirstViewController.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/20/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "IcecreamSandFirstViewController.h"
#import "IcecreamSandCookieViewController.h"
#import "AppDelegate.h"

@implementation IcecreamSandFirstViewController

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"IcecreamSandFirstViewController-5" bundle:[NSBundle mainBundle]];
    else
        self = [super init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"icecreamsandfirst"] isEqualToString:@"yes"])
    {
    }
    else
    {
        if([(AppDelegate *)[[UIApplication sharedApplication] delegate] icecreamSandLocked] == YES)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice:" message:@"While playing Ice Cream Sandwiches Maker you will see ads. If you purchase the unlock Ice Cream Sandwiches pack, ads will be removed." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"icecreamsandfirst"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        spoonView.frame = CGRectMake(54, 101, 353, 194);
        eggImgView.frame = CGRectMake(493, 15, 126, 214);
        cocoImgView.frame = CGRectMake(88, 303, 284, 182);
        flourImgView.frame = CGRectMake(431, 303, 250, 182);
        woodSpoon.frame = CGRectMake(410, 608, 347, 155);
    }
    else if([UIScreen mainScreen].bounds.size.height == 568)
    {
        spoonView.frame = CGRectMake(20, 54, 175, 99);
        eggImgView.frame = CGRectMake(214, 30, 63, 107);
        cocoImgView.frame = CGRectMake(25, 174, 142, 91);
        flourImgView.frame = CGRectMake(175, 179, 125, 86);
        woodSpoon.frame = CGRectMake(151, 333, 172, 83);
    }
    else
    {
        spoonView.frame = CGRectMake(20, 35, 175, 99);
        eggImgView.frame = CGRectMake(218, 0, 63, 107);
        cocoImgView.frame = CGRectMake(25, 137, 142, 91);
        flourImgView.frame = CGRectMake(175, 142, 125, 86);
        woodSpoon.frame = CGRectMake(152, 290, 170, 83);
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        addIngredientsLabel.frame = CGRectMake(82, 7, 604, 102);
        mixIngrediendsLabel.frame = CGRectMake(77, 210, 604, 106);
    }
    else if([UIScreen mainScreen].bounds.size.height == 568)
    {
        addIngredientsLabel.frame = CGRectMake(9, 11, 302, 51);
        mixIngrediendsLabel.frame = CGRectMake(9, 132, 302, 53);
    }
    else
    {
        addIngredientsLabel.frame = CGRectMake(9, 5, 302, 51);
        mixIngrediendsLabel.frame = CGRectMake(9, 106, 302, 53);
    }
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear |UIViewAnimationOptionAutoreverse animations:^
     {
         CGRect frame = addIngredientsLabel.frame;
         frame.origin.y += frame.size.height/8;
         addIngredientsLabel.frame = frame;
         
         frame = mixIngrediendsLabel.frame;
         frame.origin.y += frame.size.height/8;
         mixIngrediendsLabel.frame = frame;
         
     } completion:nil];

    
    nextButton.alpha = 0.0;
    coco = NO;
    flour = NO;
    oil = NO;
    egg = NO;
    mixing = NO;
    
    flourBowlImgView.alpha = 0.0;
    cocoBowlImgView.alpha = 0.0;
    oilBowlImgView.alpha = 0.0;
    eggBowlImgView.alpha = 0.0;
    doughImgView.alpha = 0.0;
    
    spoonView.alpha = 1.0;
    eggImgView.alpha = 1.0;
    cocoImgView.alpha = 1.0;
    flourImgView.alpha = 1.0;
    
    mixIngrediendsLabel.hidden = YES;
    addIngredientsLabel.hidden = NO;
    woodSpoon.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction

- (IBAction)backClick:(id)sender
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) stopSoundEffect:13];
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) stopSoundEffect:14];
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) stopSoundEffect:20];
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:27];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextClick:(id)sender
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:27];
    IcecreamSandCookieViewController *icecreamCookie = [[IcecreamSandCookieViewController alloc] init];
    [self.navigationController pushViewController:icecreamCookie animated:YES];
    [icecreamCookie release];
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
            oil = YES;
            [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:15];
            [UIView animateWithDuration:1.0 animations:^{
                spoonView.alpha = 0.0;
                oilBowlImgView.alpha = 1.0;
            }
            completion:^(BOOL finished) {
                 if(oil == YES && flour == YES && egg == YES && coco == YES)
                     [self goToNextStep];
             }];
        }
    }
    if([touch view] == flourImgView)
    {
        flourImgView.center = touchPoint;
        
        if([self checkIfOverBowl:touchPoint] == YES)
        {
            flour = YES;
            [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:13];
            [UIView animateWithDuration:1.0 animations:^{
                flourImgView.alpha = 0.0;
                flourBowlImgView.alpha = 1.0;
            }
            completion:^(BOOL finished) {
                if(oil == YES && flour == YES && egg == YES && coco == YES)
                    [self goToNextStep];
            }];
        }
    }
    if([touch view] == cocoImgView)
    {
        cocoImgView.center = touchPoint;
        
        if([self checkIfOverBowl:touchPoint] == YES)
        {
            coco = YES;
            [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:13];
            [UIView animateWithDuration:1.0 animations:^{
                cocoImgView.alpha = 0.0;
                cocoBowlImgView.alpha = 1.0;
            }
            completion:^(BOOL finished) {
                if(oil == YES && flour == YES && egg == YES && coco == YES)
                    [self goToNextStep];
            }];
        }
    }
    if([touch view] == eggImgView)
    {
        eggImgView.center = touchPoint;
        
        if([self checkIfOverBowl:touchPoint] == YES)
        {
            egg = YES;
            [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:14];
            [UIView animateWithDuration:1.0 animations:^{
                eggImgView.alpha = 0.0;
                eggBowlImgView.alpha = 1.0;
            }
            completion:^(BOOL finished) {
                if(oil == YES && flour == YES && egg == YES && coco == YES)
                    [self goToNextStep];
            }];
        }
    }
    if([touch view] == woodSpoon)
    {
        woodSpoon.center = touchPoint;
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            if(touchPoint.x > 200 && touchPoint.x < 600)
            {
                if(touchPoint.y > 660 && touchPoint.y < 1000)
                {
                    [self mixIngredients];
                    mixing = YES;
                    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:20];
                    if(![mixingSound isValid])
                        mixingSound = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(playMixingSound) userInfo:nil repeats:YES];
                }
            }
        }
        else if([UIScreen mainScreen].bounds.size.height == 568)
        {
            if(touchPoint.x > 100 && touchPoint.x < 250)
            {
                if(touchPoint.y > 370 && touchPoint.y < 520)
                {
                    [self mixIngredients];
                    mixing = YES;
                    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:20];
                    if(![mixingSound isValid])
                        mixingSound = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(playMixingSound) userInfo:nil repeats:YES];
                }
            }
        }
        else
        {
            if(touchPoint.x > 155 && touchPoint.x < 268)
            {
                if(touchPoint.y > 332 && touchPoint.y < 462)
                {
                    [self mixIngredients];
                    mixing = YES;
                    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:20];
                    if(![mixingSound isValid])
                        mixingSound = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(playMixingSound) userInfo:nil repeats:YES];
                }
            }
        }
    }
}

- (BOOL)checkIfOverBowl:(CGPoint)touchPoint
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if(touchPoint.x > 200 && touchPoint.x < 600)
        {
            if(touchPoint.y > 660 && touchPoint.y < 1000)
                return YES;
        }
    }
    else if([UIScreen mainScreen].bounds.size.height == 568)
    {
        if(touchPoint.x > 100 && touchPoint.x < 250)
        {
            if(touchPoint.y > 370 && touchPoint.y < 520)
                return YES;
        }
    }
    else
    {
        if(touchPoint.x > 120 && touchPoint.x < 200)
        {
            if(touchPoint.y > 330 && touchPoint.y < 420)
                return YES;
        }
    }
    
    return NO;
}

- (void)goToNextStep
{
    mixingSound = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(playMixingSound) userInfo:nil repeats:YES];
    
    mixIngrediendsLabel.hidden = NO;
    addIngredientsLabel.hidden = YES;
    woodSpoon.hidden = NO;
}

- (void)playMixingSound
{
    if(mixing == YES)
    {
        [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:20];
        mixing = NO;
    }
    else
    {
        [((AppDelegate*)[[UIApplication sharedApplication] delegate]) stopSoundEffect:20];
        if([mixingSound isValid])
            [mixingSound invalidate], mixingSound = nil;
    }
}

- (void)mixIngredients
{
    eggBowlImgView.alpha -= 0.005;
    oilBowlImgView.alpha -= 0.005;
    flourBowlImgView.alpha -= 0.005;
    cocoBowlImgView.alpha -= 0.005;
    doughImgView.alpha += 0.005;
    
    if(doughImgView.alpha > 0.9)
    {
        [UIView animateWithDuration:1.0 animations:^{
            woodSpoon.alpha = 0.0;
            nextButton.alpha = 1.0;
            mixIngrediendsLabel.alpha = 0.0;
        }
         completion:^(BOOL finished)
         {
             woodSpoon.alpha = 1.0;
             woodSpoon.hidden = YES;
             mixIngrediendsLabel.alpha = 1.0;
             mixIngrediendsLabel.hidden = YES;
         }];
    }
}

@end
