//
//  IcecreamSundaeDishViewController.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/23/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "IcecreamSundaeDishViewController.h"
#import "IcecreamSundaeScoopViewController.h"
#import "AppDelegate.h"

@implementation IcecreamSundaeDishViewController
@synthesize flavor;

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"IcecreamSundaeDishViewController-5" bundle:[NSBundle mainBundle]];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:27];
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) stopSoundEffect:30];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextClick:(id)sender
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) stopSoundEffect:30];
    if(scroll.contentOffset.x/[UIScreen mainScreen].bounds.size.width + 1 > 7 && ((AppDelegate*)[[UIApplication sharedApplication] delegate]).icecreamSundaeLocked == YES)
    {
        [self chooseLockedFlavor];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:27];
        
        IcecreamSundaeScoopViewController *icecreamScoop = [[IcecreamSundaeScoopViewController alloc] init];
        icecreamScoop.flavor = flavor;
        icecreamScoop.dish = scroll.contentOffset.x/[UIScreen mainScreen].bounds.size.width + 1 + 6;
        [self.navigationController pushViewController:icecreamScoop animated:YES];
        [icecreamScoop release];
    }
}

- (void)dishChosen:(UIButton*)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:12];
    
    IcecreamSundaeScoopViewController *icecreamScoop = [[IcecreamSundaeScoopViewController alloc] init];
    icecreamScoop.flavor = flavor;
    icecreamScoop.dish = sender.tag;
    [self.navigationController pushViewController:icecreamScoop animated:YES];
    [icecreamScoop release];
}

#pragma mark - Reload scroll

- (void)chooseLockedFlavor
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:21];
    
    NSString *title = @"Unlock Ice Cream Sundae?";
    UAExampleModalPanel *modalPanel = [[UAExampleModalPanel alloc] initWithFrame:self.view.bounds title:title andPurchaseTag:2 andCustom:YES] ;
    
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
    
    scroll.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 22, scroll.frame.size.height);
    
    for(int i = 1; i <= 22; i++)
    {
        int newi = i + 6;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(34 + [UIScreen mainScreen].bounds.size.width * (i - 1), 186, 253, 194)];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            imgView.frame = CGRectMake(234 + [UIScreen mainScreen].bounds.size.width * (i - 1), 423, 300, 451);
        
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dish%d.png", newi]];
        [imgView setContentMode:UIViewContentModeScaleAspectFit];
        [scroll addSubview:imgView];
        [imgView release];
        
        
        
        UIButton *bowl = [[UIButton alloc] initWithFrame:CGRectMake(34 + [UIScreen mainScreen].bounds.size.width * (i - 1), 186, 253, 194)];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            bowl.frame = CGRectMake(234 + [UIScreen mainScreen].bounds.size.width * (i - 1), 423, 300, 451);
        

        if(i > 7 && [(AppDelegate *)[[UIApplication sharedApplication] delegate] icecreamSundaeLocked] == YES)
        {
            [bowl addTarget:self action:@selector(chooseLockedFlavor) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *locked = [[UIImageView alloc] initWithFrame:CGRectMake(98, 40, 50, 65)];
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                locked.frame = CGRectMake(98, 40, 80, 100);
            
            locked.image = [UIImage imageNamed:@"lockSmall.png"];
            [bowl addSubview:locked];
            [locked release];
        }
        else
        {
            bowl.tag = newi;
            [bowl addTarget:self action:@selector(dishChosen:) forControlEvents:UIControlEventTouchUpInside];
        }
        [scroll addSubview:bowl];
        [bowl release];
    }
}


@end
