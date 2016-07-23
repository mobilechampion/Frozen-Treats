//
//  SnowConesShapeViewController.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/30/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "SnowConesShapeViewController.h"
#import "SnowConesFlavorViewController.h"
#import "AppDelegate.h"

@implementation SnowConesShapeViewController
@synthesize cone;

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"SnowConesShapeViewController-5" bundle:[NSBundle mainBundle]];
    else
        self = [super init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    coneImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"snowcone%d.png", cone]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadScroll];
    
    scroll.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width * 9, 0.0);
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextClick:(id)sender
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) stopSoundEffect:30];
    if(scroll.contentOffset.x/[UIScreen mainScreen].bounds.size.width + 1 > 4 && ((AppDelegate*)[[UIApplication sharedApplication] delegate]).snowConesLocked == YES)
    {
        [self chooseLockedFlavor];
    }
    else
    {
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:27];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        shape = scroll.contentOffset.x/[UIScreen mainScreen].bounds.size.width + 1;
        
        SnowConesFlavorViewController *snowConesFlavor = [[SnowConesFlavorViewController alloc] init];
        snowConesFlavor.cone = cone;
        snowConesFlavor.shape = shape;
        [self.navigationController pushViewController:snowConesFlavor animated:YES];
        [snowConesFlavor release];
    }
}

- (void)moldChosen:(UIButton*)sender
{
    shape = sender.tag;
    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:12];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    SnowConesFlavorViewController *snowConesFlavor = [[SnowConesFlavorViewController alloc] init];
    snowConesFlavor.cone = cone;
    snowConesFlavor.shape = shape;
    [self.navigationController pushViewController:snowConesFlavor animated:YES];
    [snowConesFlavor release];
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
        UIImageView *shapeImg = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * (i - 1) + 27, 0, 268, 232)];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            shapeImg.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * (i - 1) + 120, 0, 527, 460);
        
        [shapeImg setContentMode:UIViewContentModeScaleAspectFit];
        shapeImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"a%d.png", i]];
        [scroll addSubview:shapeImg];
        [shapeImg release];
        
        UIButton *bowl = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * (i - 1) + 27, 0, 268, 232)];
        //[bowl setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"a%d.png", i]] forState:UIControlStateNormal];
        
        if(i > 4 && [(AppDelegate*)[[UIApplication sharedApplication] delegate] snowConesLocked] == YES)
        {
            [bowl addTarget:self action:@selector(chooseLockedFlavor) forControlEvents:UIControlEventTouchUpInside];
            [scroll addSubview:bowl];
            [bowl release];
            
            UIImageView *locked = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * (i - 1) + ([UIScreen mainScreen].bounds.size.width - 50)/2, 110, 50, 65)];
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                locked.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * (i - 1) + ([UIScreen mainScreen].bounds.size.width - 80)/2, 205, 80, 100);
            
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
