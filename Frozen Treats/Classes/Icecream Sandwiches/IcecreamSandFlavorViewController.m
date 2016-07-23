//
//  IcecreamSandFlavorViewController.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/21/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "IcecreamSandFlavorViewController.h"
#import "IcecreamSandDecorateViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation IcecreamSandFlavorViewController

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"IcecreamSandFlavorViewController-5" bundle:[NSBundle mainBundle]];
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
    nextButton.hidden = YES;
    icecreamImgView.image = nil;
    icecream = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadScroll) name:@"update" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction

- (IBAction)backClick:(id)sender
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:27];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextClick:(id)sender
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:27];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    IcecreamSandDecorateViewController *iceDecorate = [[IcecreamSandDecorateViewController alloc] init];
    iceDecorate.icecream = icecream;
    [self.navigationController pushViewController:iceDecorate animated:YES];
    [iceDecorate release];
}

- (void)icecreamChosen:(UIButton*)sender
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:12];
    
    icecream = sender.tag;
    icecreamImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"iceFlavor%d.png", icecream]];
    nextButton.hidden = NO;
}

#pragma mark -

- (void)chooseLockedFlavor
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:21];
    
    NSString *title = @"Unlock Ice Cream Sandwiches?";
    UAExampleModalPanel *modalPanel = [[UAExampleModalPanel alloc] initWithFrame:self.view.bounds title:title andPurchaseTag:1 andCustom:YES] ;
    
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
    
    scroll.contentSize = CGSizeMake(55 * 10 + 10 * 20 + 20, scroll.frame.size.height);
    
    for(int i = 0; i < 10; i++)
    {
        UIButton *flavor = [[UIButton alloc] initWithFrame:CGRectMake(20 + i * 55 + i * 20, 5, 55, 50)];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            flavor.frame = CGRectMake(20 + i * 126 + i * 20, 5, 126, 120);
            scroll.contentSize = CGSizeMake(126 * 10 + 10 * 20 + 20, scroll.frame.size.height);
        }
        
        flavor.tag = i + 1;
        [flavor addTarget:self action:@selector(icecreamChosen:) forControlEvents:UIControlEventTouchUpInside];
        [flavor setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"s%d.png", i+1]] forState:UIControlStateNormal];
        
        if(i >= 3)
        {
            if([(AppDelegate*)[[UIApplication sharedApplication] delegate] icecreamSandLocked] == YES)
            {
                UIImageView *locked = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 25)];
                locked.image = [UIImage imageNamed:@"lockSmall.png"];
                [flavor addSubview:locked];
                
                [flavor removeTarget:self action:@selector(icecreamChosen:) forControlEvents:UIControlEventTouchUpInside];
                [flavor addTarget:self action:@selector(chooseLockedFlavor) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        [scroll addSubview:flavor];
        [flavor release];
    }
}

@end
