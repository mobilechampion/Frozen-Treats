//
//  IcecreamConeChooseDipViewController.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/15/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "IcecreamConeChooseDipViewController.h"
#import "IcecreamConeDecorateViewController.h"
#import "AppDelegate.h"

@implementation IcecreamConeChooseDipViewController
@synthesize flavor1, flavor2, cone;

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"IcecreamConeChooseDipViewController-5" bundle:[NSBundle mainBundle]];
    else
        self = [super init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    scroll.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 10, scroll.frame.size.height);
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(-2.9);
    icecreamView.transform = transform;
    
    icecream1.image = [UIImage imageNamed:[NSString stringWithFormat:@"icecream%d_1.png", flavor1]];
    icecream2.image = [UIImage imageNamed:[NSString stringWithFormat:@"icecream%d_2.png", flavor2]];
    icecream3.image = [UIImage imageNamed:[NSString stringWithFormat:@"icecream%d_3.png", flavor1]];
    icecream4.image = [UIImage imageNamed:[NSString stringWithFormat:@"icecream%d_4.png", flavor2]];
    coneImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"c%d.png", cone]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadScroll];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadScroll) name:@"update" object:nil];
    
    nextButton.hidden = YES;
    dipConeLabel.hidden = YES;
    chooseFlavorLabel.hidden = NO;
    scroll.hidden = NO;
    icecreamView.hidden = YES;
    scroll.contentOffset = CGPointMake(0, 0);
    
    for(UIView *view in [self.view subviews])
    {
        if(view.tag == 26)
            [view removeFromSuperview];
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        icecreamView.frame = CGRectMake(484, 129, 160, 381);
    else if([UIScreen mainScreen].bounds.size.height == 568)
        icecreamView.frame = CGRectMake(209, 112, 72, 274);
    else
        icecreamView.frame = CGRectMake(209, 61, 72, 186);


    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        chooseFlavorLabel.frame = CGRectMake(124, 116, 520, 75);
        dipConeLabel.frame = CGRectMake(142, 33, 484, 88);
    }
    else if([UIScreen mainScreen].bounds.size.height == 568)
    {
        chooseFlavorLabel.frame = CGRectMake(30, 81, 260, 41);
        dipConeLabel.frame = CGRectMake(39, 29, 242, 44);
    }
    else
    {
        chooseFlavorLabel.frame = CGRectMake(30, 81, 260, 41);
        dipConeLabel.frame = CGRectMake(39, 29, 242, 44);
    }

    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear |UIViewAnimationOptionAutoreverse animations:^
     {
         CGRect frame = chooseFlavorLabel.frame;
         frame.origin.y += frame.size.height/8;
         chooseFlavorLabel.frame = frame;
         
         frame = dipConeLabel.frame;
         frame.origin.y += frame.size.height/8;
         dipConeLabel.frame = frame;
         
     } completion:nil];

//    CGRect scFrame = scroll.frame;
//    scFrame.origin.x += [UIScreen mainScreen].bounds.size.width * 10;
//    scroll.frame = scFrame;

    scroll.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width * 9, 0.0);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:30];
    [UIView animateWithDuration:1.5 animations:^{
        scroll.contentOffset = CGPointMake(0.0, 0.0);
//        CGRect scFrame = scroll.frame;
//        scFrame.origin.x = 0;
//        scroll.frame = scFrame;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction

- (IBAction)backClick:(id)sender
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:27];
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) stopSoundEffect:30];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextClick:(id)sender
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:27];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    IcecreamConeDecorateViewController *iceConeDecorate = [[IcecreamConeDecorateViewController alloc] init];
    iceConeDecorate.flavor1 = flavor1;
    iceConeDecorate.flavor2 = flavor2;
    iceConeDecorate.cone = cone;
    iceConeDecorate.dip = dip;
    [self.navigationController pushViewController:iceConeDecorate animated:YES];
    [iceConeDecorate release];
}

#pragma mark -

- (void)dipChosen:(UIButton*)sender
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:12];
    
    dip = sender.tag;
    dipImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"d%d.png", dip]];
    dipImgView.alpha = 0.0;
    
    dipConeLabel.hidden = NO;
    chooseFlavorLabel.hidden = YES;
    scroll.hidden = YES;
    icecreamView.hidden = NO;
    
    UIImageView *dipx = [[UIImageView alloc] initWithFrame:CGRectMake(36, 79 + 189, 246, 146)];
    
    if([UIScreen mainScreen].bounds.size.height == 568)
        dipx.frame = CGRectMake(36, 79 + 189 + 88, 246, 146);
    else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        dipx.frame = CGRectMake(127, 148 + 462, 519, 315);

    dipx.tag = 26;
    dipx.image = [UIImage imageNamed:[NSString stringWithFormat:@"dip%d.png", dip]];
    [self.view addSubview:dipx];
    [dipx release];
    
    UIImageView *bowl = [[UIImageView alloc] initWithFrame:CGRectMake(34, 68 + 189, 253, 167)];
    
    if([UIScreen mainScreen].bounds.size.height == 568)
        bowl.frame = CGRectMake(34, 68 + 189 + 88, 253, 167);
    else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        bowl.frame = CGRectMake(121, 123 + 462, 537, 356);
    
    bowl.tag = 26;
    bowl.image = [UIImage imageNamed:@"dip_bowl.png"];
    [self.view addSubview:bowl];
    [bowl release];
}

#pragma mark - Touches

//- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
//{
//    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
//    UITouch *touch = [touches anyObject];
//    if([touch view].tag == 15)
//    {
//        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//        {
//            if(touchPoint.x < 177) touchPoint.x = 177;
//            if(touchPoint.x > 540) touchPoint.x = 540;
//            if(touchPoint.y > 158 + 430) touchPoint.y = 158 + 430;
//            
//        }
//        else if([UIScreen mainScreen].bounds.size.height == 568)
//        {
//            if(touchPoint.x < 90) touchPoint.x = 90;
//            if(touchPoint.x > 260) touchPoint.x = 260;
//            if(touchPoint.y > 253 + 44) touchPoint.y = 253 + 44;
//        }
//        else
//        {
//            if(touchPoint.x < 70) touchPoint.x = 70;
//            if(touchPoint.x > 220) touchPoint.x = 220;
//            if(touchPoint.y > 253) touchPoint.y = 253;
//        }
//        
//        [touch view].center = touchPoint;
//        
//        //if in bowl starttimer
//        //else stoptimer
//        
//        if(dipImgView.alpha < 0.8)
//        {
//            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//            {
//                if(touchPoint.y > 450)
//                {
//                    if(![startColoring isValid])
//                    {
//                        startColoring = [NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(colorDip) userInfo:nil repeats:YES];
//                        [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:19];
//                    }
//                    //[self colorDip];
//                }
//                else
//                {
//                    if([startColoring isValid])
//                        [startColoring invalidate], startColoring = nil;
//                }
//            }
//            else
//            {
//                if(touchPoint.y > 250)
//                {
//                    if(![startColoring isValid])
//                    {
//                        startColoring = [NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(colorDip) userInfo:nil repeats:YES];
//                        [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:19];
//                    }
//                    //[self colorDip];
//                }
//                else
//                {
//                    if([startColoring isValid])
//                        [startColoring invalidate], startColoring = nil;
//                }
//            }
//        }
//        else
//        {
//        }
//    }
//}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    UITouch *touch = [touches anyObject];
    if([touch view].tag == 15)
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            if(touchPoint.x < 177) touchPoint.x = 177;
            if(touchPoint.x > 540) touchPoint.x = 540;
            if(touchPoint.y > 158 + 430) touchPoint.y = 158 + 430;

        }
        else if([UIScreen mainScreen].bounds.size.height == 568)
        {
            if(touchPoint.x < 90) touchPoint.x = 90;
            if(touchPoint.x > 260) touchPoint.x = 260;
            if(touchPoint.y > 253 + 44) touchPoint.y = 253 + 44;
        }
        else
        {
            if(touchPoint.x < 70) touchPoint.x = 70;
            if(touchPoint.x > 220) touchPoint.x = 220;
            if(touchPoint.y > 253) touchPoint.y = 253;
        }
        
        [touch view].center = touchPoint;
        
        //if in bowl starttimer
        //else stoptimer
        
        if(dipImgView.alpha < 0.7)
        {
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                if(touchPoint.y > 450)
                {
                    if(![startColoring isValid])
                    {
                        startColoring = [NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(colorDip) userInfo:nil repeats:YES];
                        [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:19];
                    }
                    //[self colorDip];
                }
                else
                {
                    if([startColoring isValid])
                        [startColoring invalidate], startColoring = nil;
                }
            }
            else
            {
                if(touchPoint.y > 250)
                {
                    if(![startColoring isValid])
                    {
                        startColoring = [NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(colorDip) userInfo:nil repeats:YES];
                        [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:19];
                    }
                    //[self colorDip];
                }
                else
                {
                    if([startColoring isValid])
                        [startColoring invalidate], startColoring = nil;
                }
            }
        }
    }
}

#pragma mark - Coloring

- (void)colorDip
{
    if(dipImgView.alpha < 0.7)
        dipImgView.alpha += 0.01;
    else
    {
        dipImgView.alpha += 0.01;
        //stop timer
        //nextButton.hidden = NO;
        dipConeLabel.hidden = YES;
        [self animateIcecream];
        
        if([startColoring isValid])
            [startColoring invalidate], startColoring = nil;
    }
}

- (void)animateIcecream
{
    if([nextButton isHidden])
    {
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^
         {
                CGAffineTransform transform = CGAffineTransformMakeRotation(-0.2 - 3.14);
                icecreamView.transform = transform;
         }
         completion:^(BOOL finished)
         {
             [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^
              {
                    CGAffineTransform transform = CGAffineTransformMakeRotation(0.2 - 3.14);
                    icecreamView.transform = transform;
              } completion:^(BOOL finished)
              {
                  
                  int max = 0;
                  if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                      max = 350;
                  else if([UIScreen mainScreen].bounds.size.height == 568)
                      max = 150;
                  else
                      max = 120;
                  
                  if(icecreamView.frame.origin.y > max)
                      [self animateIcecream];
                  else
                  {
                      nextButton.hidden = NO;
                      [icecreamView.layer removeAllAnimations];
                  }
              }];
         }];
    }
}

#pragma mark - Reload scroll

- (void)chooseLockedFlavor
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:21];
    
    NSString *title = @"Unlock Ice Cream Cone?";
    UAExampleModalPanel *modalPanel = [[UAExampleModalPanel alloc] initWithFrame:self.view.bounds title:title andPurchaseTag:0 andCustom:YES];
    
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
    
    for(int i = 1; i <= 10; i++)
    {
        UIImageView *dipx = [[UIImageView alloc] initWithFrame:CGRectMake(36 + [UIScreen mainScreen].bounds.size.width * (i - 1), 79, 246, 146)];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            dipx.frame = CGRectMake(127 + [UIScreen mainScreen].bounds.size.width * (i - 1), 148, 519, 315);
        
        dipx.image = [UIImage imageNamed:[NSString stringWithFormat:@"dip%d.png", i]];
        [scroll addSubview:dipx];
        [dipx release];
        
        UIButton *bowl = [[UIButton alloc] initWithFrame:CGRectMake(34 + [UIScreen mainScreen].bounds.size.width * (i - 1), 68, 253, 167)];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            bowl.frame = CGRectMake(121 + [UIScreen mainScreen].bounds.size.width * (i - 1), 123, 537, 356);
        
        [bowl setBackgroundImage:[UIImage imageNamed:@"dip_bowl.png"] forState:UIControlStateNormal];
        
        if(i > 3 && [(AppDelegate *)[[UIApplication sharedApplication] delegate] icecreamConesLocked] == YES)
        {
            [bowl addTarget:self action:@selector(chooseLockedFlavor) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *locked = [[UIImageView alloc] initWithFrame:CGRectMake(98, 40, 50, 65)];
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                locked.frame = CGRectMake(219, 108, 80, 100);
            
            locked.image = [UIImage imageNamed:@"lockSmall.png"];
            [bowl addSubview:locked];
            [locked release];
        }
        else
        {
            bowl.tag = i;
            [bowl addTarget:self action:@selector(dipChosen:) forControlEvents:UIControlEventTouchUpInside];
        }
        [scroll addSubview:bowl];
        [bowl release];
    }
}

@end
