//
//  SnowConesConeViewController.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/30/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "SnowConesConeViewController.h"
#import "SnowConesDropViewController.h"
#import "AppDelegate.h"

@implementation SnowConesConeViewController

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"SnowConesConeViewController-5" bundle:[NSBundle mainBundle]];
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
    [self reloadScroll];
    scroll.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width * 9, 0.0);
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        chooseLabel.frame = CGRectMake(91, 64, 587, 93);
    else if([UIScreen mainScreen].bounds.size.height == 568)
        chooseLabel.frame = CGRectMake(32, 80, 256, 42);
    else
        chooseLabel.frame = CGRectMake(32, 80, 256, 42);
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear |UIViewAnimationOptionAutoreverse animations:^
     {
         CGRect frame = chooseLabel.frame;
         frame.origin.y += frame.size.height/8;
         chooseLabel.frame = frame;
     } completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadScroll) name:@"update" object:nil];
    
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:30];
    [UIView animateWithDuration:1.0 animations:^{
        scroll.contentOffset = CGPointMake(0.0, 0.0);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction

- (IBAction)backClick:(id)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:27];
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) stopSoundEffect:30];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextClick:(id)sender
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) stopSoundEffect:30];
    if(scroll.contentOffset.x/[UIScreen mainScreen].bounds.size.width + 1 > 3 && ((AppDelegate*)[[UIApplication sharedApplication] delegate]).snowConesLocked == YES)
    {
        [self chooseLockedFlavor];
    }
    else
    {
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:27];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        cone = scroll.contentOffset.x/[UIScreen mainScreen].bounds.size.width + 1;
        
        SnowConesDropViewController *snowConesScoop = [[SnowConesDropViewController alloc] init];
        snowConesScoop.cone = cone;
        [self.navigationController pushViewController:snowConesScoop animated:YES];
        [snowConesScoop release];
    }
}

- (void)moldChosen:(UIButton*)sender
{
    cone = sender.tag;
    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:12];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    SnowConesDropViewController *snowConesScoop = [[SnowConesDropViewController alloc] init];
    snowConesScoop.cone = cone;
    [self.navigationController pushViewController:snowConesScoop animated:YES];
    [snowConesScoop release];
}

#pragma mark - Reload Scroll

- (void)chooseLockedFlavor
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:21];
    
    NSString *title = @"Unlock Snow Cones?";
    UAExampleModalPanel *modalPanel = [[UAExampleModalPanel alloc] initWithFrame:self.view.bounds title:title andPurchaseTag:4 andCustom:YES] ;
    
    modalPanel.onClosePressed = ^(UAModalPanel* panel)
    {
        [panel hideWithOnComplete:^(BOOL finished)
         {
             [panel removeFromSuperview];
         }];
        UADebugLog(@"onClosePressed block called from panel: %@", modalPanel);
    };
    
    modalPanel.onActionPressed = ^(UAModalPanel* panel)
    {
        UADebugLog(@"onActionPressed block called from panel: %@", modalPanel);
    };
    [self.view addSubview:modalPanel];
	
	[modalPanel showFromPoint:[self.view center]];
    [modalPanel setupStuff3];
    UADebugLog(@"UAModalView will display using blocks: %@", modalPanel);
}

- (void)reloadScroll
{
    for(UIView *view in [scroll subviews])
        [view removeFromSuperview];
    
    scroll.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 10, scroll.frame.size.height);
    
    for(int i = 1; i <= 10; i++)
    {
        UIButton *bowl = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * (i - 1) + 23, 289, 275, 147)];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            bowl.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * (i - 1) + 109, 554, 550, 300);
        
        
        [bowl setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"snowcone%d.png", i]] forState:UIControlStateNormal];
        
        if(i > 3 && [(AppDelegate *)[[UIApplication sharedApplication] delegate] snowConesLocked] == YES)
        {
            [bowl addTarget:self action:@selector(chooseLockedFlavor) forControlEvents:UIControlEventTouchUpInside];
            [scroll addSubview:bowl];
            [bowl release];
            
            UIImageView *locked = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * (i - 1) + ([UIScreen mainScreen].bounds.size.width - 50)/2, 310, 50, 65)];
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                locked.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * (i - 1) + ([UIScreen mainScreen].bounds.size.width - 50)/2, 604, 80, 100);
            
            
            locked.image = [UIImage imageNamed:@"lockSmall.png"];
            [scroll addSubview:locked];
            [locked release];
        }
        else
        {
            bowl.tag = i;
            [bowl addTarget:self action:@selector(moldChosen:) forControlEvents:UIControlEventTouchUpInside];
            [scroll addSubview:bowl];
            [bowl release];
        }
    }
}

@end
