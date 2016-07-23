//
//  AlbumViewController.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/20/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "AlbumViewController.h"
#import "IcecreamConeFinalViewController.h"
#import "IcecreamSandFinalViewController.h"
#import "IcecreamSundaeFinalViewController.h"
#import "IcePopsFinalViewController.h"
#import "SnowConesFinalViewController.h"

@implementation AlbumViewController

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"AlbumViewController-5" bundle:[NSBundle mainBundle]];
    else
        self = [super init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"alex_fairies"] != nil)
    {
        alex_fairies = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"alex_fairies"]];
        [alex_fairies retain];
    }
    else
        alex_fairies = [[NSMutableArray alloc] init];
    
    scroll.scrollEnabled = YES;
    scroll.contentSize = CGSizeMake([alex_fairies count] * [[UIScreen mainScreen] bounds].size.width, scroll.frame.size.height);
    scroll.alwaysBounceHorizontal = YES;
    scroll.bounces = YES;
    scroll.pagingEnabled = YES;
    
    int j = 0;
    for(int i = [alex_fairies count] - 1; i >= 0; i--)
    {
        UIImageView *paper = [[UIImageView alloc] initWithFrame:CGRectMake(j * [[UIScreen mainScreen] bounds].size.width, 30, 320, 430)];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            paper.frame = CGRectMake(j * [[UIScreen mainScreen] bounds].size.width, 30, 768, 960);
        else if([UIScreen mainScreen].bounds.size.height == 568)
            paper.frame = CGRectMake(j * [[UIScreen mainScreen] bounds].size.width, 30, 320, 518);
        
        paper.image = [UIImage imageNamed:@"paper.png"];
        [scroll addSubview:paper];
        [paper release];
        
        UIButton *imgView = [[UIButton alloc] initWithFrame:CGRectMake(j * [[UIScreen mainScreen] bounds].size.width, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        
        UIImage *img = [[UIImage alloc] initWithContentsOfFile:[[alex_fairies objectAtIndex:i] objectForKey:@"path"]];
        [imgView setBackgroundImage:img forState:UIControlStateNormal];
        [imgView addTarget:self action:@selector(goToFinal:) forControlEvents:UIControlEventTouchUpInside];
        imgView.tag = i;
        [scroll addSubview:imgView];
        [imgView release];
        
        j++;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //set initial frames
    if([UIScreen mainScreen].bounds.size.height == 480)
    {
        arrowLeft.frame = CGRectMake(10, 228, 49, 24);
        arrowRight.frame = CGRectMake(262, 228, 49, 24);
    }
    else if([UIScreen mainScreen].bounds.size.height == 568)
    {
        arrowLeft.frame = CGRectMake(10, 272, 49, 24);
        arrowRight.frame = CGRectMake(262, 272, 49, 24);
    }
    else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        arrowLeft.frame = CGRectMake(20, 482, 120, 59);
        arrowRight.frame = CGRectMake(628, 482, 120, 59);
    }
    arrowLeft.alpha = 1.0;
    arrowRight.alpha = 1.0;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //animate arrows
    [UIView animateWithDuration:0.7 delay:0.0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear |UIViewAnimationOptionAutoreverse animations:^
     {
         arrowLeft.frame = CGRectMake(arrowLeft.frame.origin.x - 4, arrowLeft.frame.origin.y - 2, arrowLeft.frame.size.width + 8, arrowLeft.frame.size.height + 4);
         arrowRight.frame = CGRectMake(arrowRight.frame.origin.x - 4, arrowRight.frame.origin.y - 2, arrowRight.frame.size.width + 8, arrowRight.frame.size.height + 4);
     } completion:nil];
    
    //remove after 4 seconds
    [self performSelector:@selector(arrowsDissappear) withObject:nil afterDelay:3.5];
}

- (void)arrowsDissappear
{
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^
     {
         arrowLeft.alpha = 0;
         arrowRight.alpha = 0;
     }
     completion:nil];
}

- (void)goToFinal:(UIButton*)sender
{
    int flavor1;
    int flavor2;
    int cone;
    int dip;
    int deco1;
    int deco2;
    int deco;
    int icecream;
    NSString *type = @"";
    int dish;
    int flavor;
    int mold;
    int stick;
    int shape;
    UIImage *img;
    UIImage *awsomeImg;
    NSMutableArray *drizzles = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [alex_fairies count]; i++)
    {
        if(sender.tag == i)
        {
            type = [[alex_fairies objectAtIndex:i] objectForKey:@"type"];
            flavor1 = [[[alex_fairies objectAtIndex:i] objectForKey:@"flavor1"] intValue];
            flavor2 = [[[alex_fairies objectAtIndex:i] objectForKey:@"flavor2"] intValue];
            cone = [[[alex_fairies objectAtIndex:i] objectForKey:@"cone"] intValue];
            dip = [[[alex_fairies objectAtIndex:i] objectForKey:@"dip"] intValue];
            deco1 = [[[alex_fairies objectAtIndex:i] objectForKey:@"deco1"] intValue];
            deco2 = [[[alex_fairies objectAtIndex:i] objectForKey:@"deco2"] intValue];
            deco = [[[alex_fairies objectAtIndex:i] objectForKey:@"deco"] intValue];
            icecream = [[[alex_fairies objectAtIndex:i] objectForKey:@"icecream"] intValue];
            dish = [[[alex_fairies objectAtIndex:i] objectForKey:@"dish"] intValue];
            flavor = [[[alex_fairies objectAtIndex:i] objectForKey:@"flavor"] intValue];
            drizzles = [[alex_fairies objectAtIndex:i] objectForKey:@"drizzles"];
            mold = [[[alex_fairies objectAtIndex:i] objectForKey:@"mold"] intValue];
            stick = [[[alex_fairies objectAtIndex:i] objectForKey:@"stick"] intValue];
            shape = [[[alex_fairies objectAtIndex:i] objectForKey:@"shape"] intValue];
            img = [[alex_fairies objectAtIndex:i] objectForKey:@"decorations"];
            awsomeImg = [[alex_fairies objectAtIndex:i] objectForKey:@"awsomeImage"];
        }
    }
    
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:27];
    
    if([type isEqualToString:@"icecream_cone"])
    {
        IcecreamConeFinalViewController *iceConeFinal = [[IcecreamConeFinalViewController alloc] init];
        iceConeFinal.fromFridge = YES;
        iceConeFinal.flavor1 = flavor1;
        iceConeFinal.flavor2 = flavor2;
        iceConeFinal.cone = cone;
        iceConeFinal.dip = dip;
        iceConeFinal.deco1 = deco1;
        iceConeFinal.deco2 = deco2;
        iceConeFinal.decorationsImage = img;
        [self.navigationController pushViewController:iceConeFinal animated:YES];
        [iceConeFinal release];
    }
    else if([type isEqualToString:@"icecream_sand"])
    {
        IcecreamSandFinalViewController *iceSandFinal = [[IcecreamSandFinalViewController alloc] init];
        iceSandFinal.fromFridge = YES;
        iceSandFinal.icecream = icecream;
        iceSandFinal.deco = deco;
        iceSandFinal.decorationsImage = img;
        [self.navigationController pushViewController:iceSandFinal animated:YES];
        [iceSandFinal release];
    }
    else if([type isEqualToString:@"icecream_sundae"])
    {
        IcecreamSundaeFinalViewController *icecreamFinal = [[IcecreamSundaeFinalViewController alloc] init];
        icecreamFinal.fromFridge = YES;
        icecreamFinal.flavor = flavor;
        icecreamFinal.dish = dish;
        icecreamFinal.decorationsImage = img;
        [self.navigationController pushViewController:icecreamFinal animated:YES];
        [icecreamFinal release];
    }
    else if([type isEqualToString:@"icepop"])
    {
        IcePopsFinalViewController *icePopsFinal = [[IcePopsFinalViewController alloc] init];
        icePopsFinal.fromFridge = YES;
        icePopsFinal.mold = mold;
        icePopsFinal.stick = stick;
        icePopsFinal.flavor = flavor;
        icePopsFinal.decorationsImage = img;
        [self.navigationController pushViewController:icePopsFinal animated:YES];
        [icePopsFinal release];
    }
    else if([type isEqualToString:@"snowcone"])
    {
        SnowConesFinalViewController *snowFinal = [[SnowConesFinalViewController alloc] init];
        snowFinal.fromFridge = YES;
        snowFinal.cone = cone;
        snowFinal.flavor = flavor;
        snowFinal.shape = shape;
        snowFinal.decorationsImage = img;
        snowFinal.awsomeImage = awsomeImg;
        [self.navigationController pushViewController:snowFinal animated:YES];
        [snowFinal release];
    }
}

- (IBAction)backClick:(id)sender
{
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) playSoundEffect:27];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Dealloc

- (void)dealloc
{
    [scroll release];
    [arrowLeft release];
    [arrowRight release];
    [alex_fairies release];
    
    [super dealloc];
}

@end
