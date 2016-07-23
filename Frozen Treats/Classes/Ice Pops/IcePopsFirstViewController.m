//
//  IcePopsFirstViewController.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/27/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "IcePopsFirstViewController.h"
#import "IcePopsStickViewController.h"
#import "AppDelegate.h"

@implementation IcePopsFirstViewController

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"IcePopsFirstViewController-5" bundle:[NSBundle mainBundle]];
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
    
    scroll.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width * 10, 0.0);
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        slideLabel.frame = CGRectMake(134, 70, 500, 97);
    else if([UIScreen mainScreen].bounds.size.height == 568)
        slideLabel.frame = CGRectMake(35, 50, 251, 48);
    else
        slideLabel.frame = CGRectMake(35, 37, 251, 48);
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear |UIViewAnimationOptionAutoreverse animations:^
     {
         CGRect frame = slideLabel.frame;
         frame.origin.y += frame.size.height/8;
         slideLabel.frame = frame;
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
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"icepopsfirst"] isEqualToString:@"yes"])
    {
    }
    else
    {
        if([(AppDelegate *)[[UIApplication sharedApplication] delegate] icePopsLocked] == YES)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice:" message:@"While playing Ice Pops Maker you will see ads. If you purchase the unlock Ice Pops pack, ads will be removed." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"icepopsfirst"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
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
    if(scroll.contentOffset.x/[UIScreen mainScreen].bounds.size.width + 1 > 3 && ((AppDelegate*)[[UIApplication sharedApplication] delegate]).icePopsLocked == YES)
    {
        [self chooseLockedFlavor];
    }
    else
    {
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:27];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        mold = scroll.contentOffset.x/[UIScreen mainScreen].bounds.size.width + 1;
        
        IcePopsStickViewController *icePopsFlavor = [[IcePopsStickViewController alloc] init];
        icePopsFlavor.mold = mold;
        [self.navigationController pushViewController:icePopsFlavor animated:YES];
        [icePopsFlavor release];
    }
}

- (void)moldChosen:(UIButton*)sender
{
    mold = sender.tag;
    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:12];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    IcePopsStickViewController *icePopsFlavor = [[IcePopsStickViewController alloc] init];
    icePopsFlavor.mold = mold;
    [self.navigationController pushViewController:icePopsFlavor animated:YES];
    [icePopsFlavor release];
}

#pragma mark - Reload Scroll

- (void)chooseLockedFlavor
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:21];
    
    NSString *title = @"Unlock Ice Pops?";
    UAExampleModalPanel *modalPanel = [[UAExampleModalPanel alloc] initWithFrame:self.view.bounds title:title andPurchaseTag:3 andCustom:YES] ;
    
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
    
    scroll.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 20, scroll.frame.size.height);
    
    for(int i = 1; i <= 20; i++)
    {
//        UIImageView *stickx = [[UIImageView alloc] initWithFrame:CGRectMake(149 + [UIScreen mainScreen].bounds.size.width * (i - 1), 259, 23, 234)];
//        
//        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//            stickx.frame = CGRectMake(360 + [UIScreen mainScreen].bounds.size.width * (i - 1), 497, 49, 444);
//        
//        stickx.image = [UIImage imageNamed:[NSString stringWithFormat:@"stick%d.png", i]];
//        [stickx setContentMode:UIViewContentModeScaleAspectFit];
//        [scroll addSubview:stickx];
//        [stickx release];
        
        UIImageView *moldx = [[UIImageView alloc] initWithFrame:CGRectMake(52 + [UIScreen mainScreen].bounds.size.width * (i - 1), 126, 217, 223)];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            moldx.frame = CGRectMake(194 + [UIScreen mainScreen].bounds.size.width * (i - 1), 249, 380, 380);
        
        moldx.image = [UIImage imageNamed:[NSString stringWithFormat:@"p%d.png", i]];
        [moldx setContentMode:UIViewContentModeScaleAspectFit];
        [scroll addSubview:moldx];
        [moldx release];

        
        UIButton *bowl = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * (i - 1), 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        if(i > 3 && [(AppDelegate *)[[UIApplication sharedApplication] delegate] icePopsLocked] == YES)
        {
            [bowl addTarget:self action:@selector(chooseLockedFlavor) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *locked = [[UIImageView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 50)/2, 210, 50, 65)];
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                locked.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 80)/2, 400, 80, 100);
            
            locked.image = [UIImage imageNamed:@"lockSmall.png"];
            [bowl addSubview:locked];
            [locked release];
        }
        else
        {
            bowl.tag = i;
            [bowl addTarget:self action:@selector(moldChosen:) forControlEvents:UIControlEventTouchUpInside];
        }
        [scroll addSubview:bowl];
        [bowl release];
    }
}

@end
