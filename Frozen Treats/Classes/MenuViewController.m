//
//  MenuViewController.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/13/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "MenuViewController.h"
#import "AlbumViewController.h"
#import "AppDelegate.h"
#import "IcecreamConeFirstViewController.h"
#import "IcecreamSandFirstViewController.h"
#import "IcecreamSundaeFirstViewController.h"
#import "IcePopsFirstViewController.h"
#import "SnowConesFirstViewController.h"
#import "MoreViewController.h"
#import "PrivacyPolicy.h"

@implementation MenuViewController

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"MenuViewController-5" bundle:[NSBundle mainBundle]];
    else
        self = [super init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"sounds"] isEqualToString:@"yes"])
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            [soundButton setBackgroundImage:[UIImage imageNamed:@"on@2x.png"] forState:UIControlStateNormal];
        else
            [soundButton setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"sounds"] isEqualToString:@"no"])
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            [soundButton setBackgroundImage:[UIImage imageNamed:@"off@2x.png"] forState:UIControlStateNormal];
        else
            [soundButton setBackgroundImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        backgroundImgView.animationImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"menu1~ipad.png"], [UIImage imageNamed:@"menu2~ipad.png"], [UIImage imageNamed:@"menu3~ipad.png"], nil];
    else if([UIScreen mainScreen].bounds.size.height == 568)
        backgroundImgView.animationImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"menu1_568.png"], [UIImage imageNamed:@"menu2_568.png"], [UIImage imageNamed:@"menu3_568.png"], nil];
    else
        backgroundImgView.animationImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"menu1.png"], [UIImage imageNamed:@"menu2.png"], [UIImage imageNamed:@"menu3.png"], nil];
    
    
    backgroundImgView.animationDuration = 0.6;
    [backgroundImgView startAnimating];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadScroll) name:@"update" object:nil];
    [self reloadScroll];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if([(AppDelegate*)[[UIApplication sharedApplication] delegate] fromLastPage] == YES)
    {
        if([(AppDelegate *)[[UIApplication sharedApplication] delegate] frozenLocked] == YES)
        {
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] showFullScreenAd];
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] showChartboostAd];
        }

        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).fromLastPage = NO;
    }
    
    if([(AppDelegate*)[[UIApplication sharedApplication] delegate] frozenLocked] == NO)
    {
        //storeButton.hidden = YES;
        //restoreButton.hidden = YES;
    }
    
    if([(AppDelegate*)[[UIApplication sharedApplication] delegate] firstTime] == YES)
    {
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:2];
        //        stars = [[Star alloc] initWithFrame:[UIScreen mainScreen].bounds];
        //        [self.view addSubview:stars];
        //        [stars decayOverTime:2.0];
        
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).firstTime = NO;
    }
    
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:0];
    rotation.toValue = [NSNumber numberWithFloat:(2*M_PI)];
    rotation.duration = 2.5; // Speed
    rotation.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
    [unlockSparkle.layer addAnimation:rotation forKey:@"Spin"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction

- (void)goToApp:(UIButton*)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:1];
    
    if([(AppDelegate*)[[UIApplication sharedApplication] delegate] frozenLocked] == YES)
    {
        if(sender.tag == 1)
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            IcecreamConeFirstViewController *icecreamCone = [[IcecreamConeFirstViewController alloc] init];
            [self.navigationController pushViewController:icecreamCone animated:YES];
            [icecreamCone release];
        }
        else if(sender.tag == 3)
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            IcecreamSandFirstViewController *icecreamSand = [[IcecreamSandFirstViewController alloc] init];
            [self.navigationController pushViewController:icecreamSand animated:YES];
            [icecreamSand release];
        }
        else if(sender.tag == 4)
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            IcecreamSundaeFirstViewController *icecreamSundae = [[IcecreamSundaeFirstViewController alloc] init];
            [self.navigationController pushViewController:icecreamSundae animated:YES];
            [icecreamSundae release];
        }
        else if(sender.tag == 5)
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            IcePopsFirstViewController *icePops = [[IcePopsFirstViewController alloc] init];
            [self.navigationController pushViewController:icePops animated:YES];
            [icePops release];
        }
        else if(sender.tag == 6)
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            SnowConesFirstViewController *snowCones = [[SnowConesFirstViewController alloc] init];
            [self.navigationController pushViewController:snowCones animated:YES];
            [snowCones release];
        }
        else
        {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(14 + 2  + 56 , 6, 56, 48)];
            button.tag = 5;
            
            [((AppDelegate *)[[UIApplication sharedApplication] delegate]).store productClick:button];
        }
    }
    else
    {
        if(sender.tag == 1)
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            IcecreamConeFirstViewController *icecreamCone = [[IcecreamConeFirstViewController alloc] init];
            [self.navigationController pushViewController:icecreamCone animated:YES];
            [icecreamCone release];
        }
        else if(sender.tag == 2)
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            IcecreamSandFirstViewController *icecreamSand = [[IcecreamSandFirstViewController alloc] init];
            [self.navigationController pushViewController:icecreamSand animated:YES];
            [icecreamSand release];
        }
        else if(sender.tag == 3)
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            IcecreamSundaeFirstViewController *icecreamSundae = [[IcecreamSundaeFirstViewController alloc] init];
            [self.navigationController pushViewController:icecreamSundae animated:YES];
            [icecreamSundae release];
        }
        else if(sender.tag == 4)
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            IcePopsFirstViewController *icePops = [[IcePopsFirstViewController alloc] init];
            [self.navigationController pushViewController:icePops animated:YES];
            [icePops release];
        }
        else if(sender.tag == 5)
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            SnowConesFirstViewController *snowCones = [[SnowConesFirstViewController alloc] init];
            [self.navigationController pushViewController:snowCones animated:YES];
            [snowCones release];
        }
    }
}

- (IBAction)albumClick:(id)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:22];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    AlbumViewController *album = [[AlbumViewController alloc] init];
    [self.navigationController pushViewController:album animated:YES];
    [album release];
}

- (IBAction)soundClick:(id)sender
{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"sounds"] isEqualToString:@"no"])
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            [soundButton setBackgroundImage:[UIImage imageNamed:@"on@2x.png"] forState:UIControlStateNormal];
        else
            [soundButton setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"sounds"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            [soundButton setBackgroundImage:[UIImage imageNamed:@"off@2x.png"] forState:UIControlStateNormal];
        else
            [soundButton setBackgroundImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"sounds"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (IBAction)storeClick:(id)sender
{
    if([((AppDelegate *)[[UIApplication sharedApplication] delegate]) frozenLocked] == YES)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(14 + 2  + 56 , 6, 56, 48)];
        button.tag = 5;
        
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).store productClick:button];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You've already purchased everything!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (IBAction)moreClick:(id)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:1];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    MoreViewController *moreScreen = [[MoreViewController alloc] init];
    
    [UIView transitionWithView:self.navigationController.view duration:1.0 options:UIViewAnimationOptionTransitionCurlDown animations:^
     {
         [self.navigationController pushViewController:moreScreen animated:NO];
     }
     completion:nil];
    
    [moreScreen release];
}

- (IBAction)restoreClick:(id)sender
{
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).store restoreTransactions:nil];
}

- (IBAction)PrivacyPolicy:(id)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:1];
    PrivacyPolicy *privacy = [[PrivacyPolicy alloc] init];
    [self presentViewController:privacy animated:YES completion:nil];
}

#pragma mark - Reload

- (void)reloadScroll
{
    for(UIView *view in [scroll subviews])
        [view removeFromSuperview];
    
    
    if([((AppDelegate *)[[UIApplication sharedApplication] delegate]) frozenLocked] == YES)
    {
        scroll.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 7, scroll.frame.size.height);
        
        for(int i = 1; i <= 7; i++)
        {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * (i - 1) + 72, 8, 176, 204)];
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * (i - 1) + 213, 41, 343, 370);
            
            if(i == 2 || i == 7)
                [button setBackgroundImage:[UIImage imageNamed:@"icon_0.png"] forState:UIControlStateNormal];
            else if(i == 1)
                [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%d.png", i]] forState:UIControlStateNormal];
            else
                [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%d.png", i - 1]] forState:UIControlStateNormal];
            
            button.tag = i;
            [button addTarget:self action:@selector(goToApp:) forControlEvents:UIControlEventTouchUpInside];
            [scroll addSubview:button];
            [button release];
        }
    }
    else
    {
        scroll.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 5, scroll.frame.size.height);
        
        for(int i = 1; i <= 5; i++)
        {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * (i - 1) + 72, 8, 176, 204)];
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * (i - 1) + 213, 41, 343, 370);
            
            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%d.png", i]] forState:UIControlStateNormal];
            button.tag = i;
            [button addTarget:self action:@selector(goToApp:) forControlEvents:UIControlEventTouchUpInside];
            [scroll addSubview:button];
            [button release];
        }
    }
}

@end
