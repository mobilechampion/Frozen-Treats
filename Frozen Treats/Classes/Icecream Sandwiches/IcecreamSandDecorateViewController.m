//
//  IcecreamSandDecorateViewController.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/21/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "IcecreamSandDecorateViewController.h"
#import "IcecreamSandFinalViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation IcecreamSandDecorateViewController
@synthesize icecream;

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"IcecreamSandDecorateViewController-5" bundle:[NSBundle mainBundle]];
    else
        self = [super init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    icecreamImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"iceFlavor%d.png", icecream]];
    changes = [[NSMutableArray alloc] init];
    extrasArray = [[NSMutableArray alloc] init];
    
    CGRect frame = topBiscuit.frame;
    frame.origin.x += [UIScreen mainScreen].bounds.size.width;
    topBiscuit.frame = frame;
    
    [UIView animateWithDuration:1.0 animations:^{
        CGRect frame = topBiscuit.frame;
        frame.origin.x -= [UIScreen mainScreen].bounds.size.width;
        topBiscuit.frame = frame;
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadScroll];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadScroll) name:@"update" object:nil];
    
    if([(AppDelegate *)[[UIApplication sharedApplication] delegate] icecreamSandLocked] == YES)
        [((AppDelegate*)[[UIApplication sharedApplication] delegate]) showPopupAd];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction

- (IBAction)backClick:(id)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:27];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextClick:(id)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:27];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(self.view.frame.size);
    [bigView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();

    
    IcecreamSandFinalViewController *iceSandFinal = [[IcecreamSandFinalViewController alloc] init];
    iceSandFinal.icecream = icecream;
    iceSandFinal.deco = deco;
    iceSandFinal.decorationsImage = img;
    [self.navigationController pushViewController:iceSandFinal animated:YES];
    [iceSandFinal release];
}

- (IBAction)undoClick:(id)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:1];

    BOOL foundDeco = NO;
    for(int i = 0; i < [changes count]; i++)
    {
        if([[[changes objectAtIndex:i] objectForKey:@"tag"] intValue] == lastTag)
        {
            foundDeco = YES;
        }
    }
    
    if(foundDeco == YES)
    {
        [changes removeLastObject];
            
        deco = -1;
        for(int i = 0; i < [changes count]; i++)
        {
            if([[[changes objectAtIndex:i] objectForKey:@"type"] isEqualToString:@"deco"])
            {
                deco = [[[changes objectAtIndex:i] objectForKey:@"pic_nr"] intValue];
            }
        }
        
        if(deco == -1)
            decoration.image = nil;
        else
        {
            decoration.image = [UIImage imageNamed:[NSString stringWithFormat:@"decoSand%d.png", deco]];
            decoration.frame = [self frameForDeco];
            
            if([UIScreen mainScreen].bounds.size.height == 568)
                decoration.frame = CGRectMake(decoration.frame.origin.x, decoration.frame.origin.y + 33, decoration.frame.size.width, decoration.frame.size.height);
        }
    }
    else
    {
        for(UIView *view in [bigView subviews])
        {
            if(view.tag == lastTag)
                [view removeFromSuperview];
        }
        
        if([[[extrasArray lastObject] objectForKey:@"tag"] intValue] == lastTag)
            [extrasArray removeLastObject];
    }
    
    if(lastTag > 1)
        lastTag--;
}

- (IBAction)decorationsClick:(id)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:1];
    [scroll setContentOffset:CGPointMake(0.0, 0.0)];
    lastDecoration = 2;
    [self reloadScroll];
    
    decorationsView.frame = CGRectMake(0, -[[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    [self.view addSubview:decorationsView];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
     {
         decorationsView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
     }
     completion:nil];
}

- (IBAction)drawOnsClick:(id)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:1];
    [scroll setContentOffset:CGPointMake(0.0, 0.0)];
    lastDecoration = 1;
    [self reloadScroll];
    
    decorationsView.frame = CGRectMake(0, -[[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    [self.view addSubview:decorationsView];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
     {
         decorationsView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
     }
     completion:nil];
}

- (IBAction)extrasClick:(id)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:1];
    [scroll setContentOffset:CGPointMake(0.0, 0.0)];
    lastDecoration = 3;
    [self reloadScroll];
    
    decorationsView.frame = CGRectMake(0, -[[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    [self.view addSubview:decorationsView];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
     {
         decorationsView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
     }
                     completion:nil];
}

- (void)decorationChosen:(UIButton*)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:12];
    
    movingStopped = YES;
    deco = sender.tag;
    decoration.image = [UIImage imageNamed:[NSString stringWithFormat:@"decoSand%d.png", deco]];
    decoration.frame = [self frameForDeco];
    if([UIScreen mainScreen].bounds.size.height == 568)
        decoration.frame = CGRectMake(decoration.frame.origin.x, decoration.frame.origin.y + 33, decoration.frame.size.width, decoration.frame.size.height);
    
    
    NSMutableDictionary *md2 = [[NSMutableDictionary alloc] init];
    [md2 setObject:@"deco" forKey:@"type"];
    [md2 setObject:[NSString stringWithFormat:@"%d", deco] forKey:@"pic_nr"];
    [md2 setObject:[NSString stringWithFormat:@"%d", lastTag + 1] forKey:@"tag"];
    [changes addObject:md2];
    [md2 release];
    
    lastTag++;
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
     {
         decorationsView.frame = CGRectMake(0, -[[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
     } completion:^(BOOL finished)
     {
         [decorationsView removeFromSuperview];
     }];
}

- (void)drawOnChosen:(UIButton*)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:12];
    currentDrawingImage = [UIImage imageNamed:[NSString stringWithFormat:@"x%d", sender.tag]];
    movingStopped = NO;
    lastDecoration = 1;
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
     {
         decorationsView.frame = CGRectMake(0, -[[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
     } completion:^(BOOL finished)
     {
         [decorationsView removeFromSuperview];
     }];
}

- (void)extrasChosen:(UIButton*)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:12];
    movingStopped = YES;
    
    UIImageView *label = [[UIImageView alloc] init];
    UIImage *temp = [UIImage imageNamed:[NSString stringWithFormat:@"ex%d.png", sender.tag]];
    
    
    label.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width - temp.size.width)/2, ([[UIScreen mainScreen] bounds].size.height - temp.size.height)/2, temp.size.width, temp.size.height);
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        //temp = [UIImage imageNamed:[NSString stringWithFormat:@"dr%d@2x.png", sender.tag]];
        label.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width - temp.size.width)/2, ([[UIScreen mainScreen] bounds].size.height - temp.size.height)/2, temp.size.width, temp.size.height);
    }
    
    label.image = temp;
    label.tag = lastTag + 1;
    lastTag++;
    label.userInteractionEnabled = YES;
    label.exclusiveTouch = YES;
    [bigView addSubview:label];
    //[self.view insertSubview:label belowSubview:backButton];
    [label release];
    
    NSMutableDictionary *md = [[NSMutableDictionary alloc] init];
    [md setObject:[NSString stringWithFormat:@"%d", sender.tag] forKey:@"pic"];
    [md setObject:NSStringFromCGRect(label.frame) forKey:@"frame"];
    [md setObject:[NSString stringWithFormat:@"%d", lastTag] forKey:@"tag"];
    [extrasArray addObject:md];
    [md release];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
     {
         decorationsView.frame = CGRectMake(0, -[[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
     } completion:^(BOOL finished)
     {
         [decorationsView removeFromSuperview];
     }];
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    BOOL foundExtra = NO;
    UITouch *touch = [[event allTouches] anyObject];
    for(int i = 0; i < [extrasArray count]; i++)
    {
        if([[[extrasArray objectAtIndex:i] objectForKey:@"tag"] intValue] == [touch view].tag)
        {
            //        if([touch view] == imgView)
            //        {
            touchedExtra = YES;
            lastTouchedExtra = [touch view].tag;
            foundExtra = YES;
            //        }
        }
    }
    
    if(foundExtra == NO)
    {
        if(movingStopped == NO)
        {
            drawOn = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, currentDrawingImage.size.width/2, currentDrawingImage.size.height/2)];
            drawOn.image = currentDrawingImage;
            drawOn.tag = lastTag + 1;
            lastTag++;
            
            CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
            drawOn.center = CGPointMake(touchPoint.x, touchPoint.y);
            [bigView addSubview:drawOn];
            //[self.view insertSubview:drawOn belowSubview:backButton];
            lastTouchedPoint = touchPoint;
        }
    }
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    if(touchedExtra == YES)
    {
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
        UITouch *touch = [touches anyObject];
        
        int indexIngr;
        for(int i = 0; i < [extrasArray count]; i++)
        {
            if([[[extrasArray objectAtIndex:i] objectForKey:@"tag"] intValue] == [touch view].tag)
            {
                indexIngr = i;
                [touch view].center = touchPoint;
            }
        }
        
        NSMutableDictionary *md = [[NSMutableDictionary alloc] init];
        [md setObject:[[extrasArray objectAtIndex:indexIngr] objectForKey:@"pic"] forKey:@"pic"];
        [md setObject:NSStringFromCGRect([touch view].frame) forKey:@"frame"];
        [md setObject:[NSString stringWithFormat:@"%d", [touch view].tag] forKey:@"tag"];
        
        [extrasArray replaceObjectAtIndex:indexIngr withObject:md];
        
        
        //        if([touch view].tag > 0)
        //        {
        //            [touch view].center = touchPoint;
        //
        //            int tagLabel = [touch view].tag;
        //            NSMutableDictionary *md = [[NSMutableDictionary alloc] init];
        //            [md setObject:[[ingredients objectAtIndex:tagLabel - 1] objectForKey:@"pic"] forKey:@"pic"];
        //            [md setObject:NSStringFromCGRect([touch view].frame) forKey:@"frame"];
        //
        //            [ingredients replaceObjectAtIndex:tagLabel - 1 withObject:md];
        //        }
    }
    else if(lastDecoration == 1)//draw on apple
    {
        if(movingStopped == NO)
        {
            CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
            if([self isFarEnoughFrom:touchPoint])
            {
                drawOn = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, currentDrawingImage.size.width/2, currentDrawingImage.size.height/2)];
                drawOn.image = currentDrawingImage;
                drawOn.tag = lastTag;

                
                drawOn.center = CGPointMake(touchPoint.x, touchPoint.y);
                [bigView addSubview:drawOn];
                //[self.view insertSubview:drawOn belowSubview:backButton];
                
                lastTouchedPoint = touchPoint;
            }
        }
    }
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    touchedExtra = NO;
    //movingStopped = YES;
    lastTouchedExtra = -1;
}

- (BOOL)isFarEnoughFrom:(CGPoint)touchedPoint
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if(touchedPoint.x < lastTouchedPoint.x - 35)
            return YES;
        
        if(touchedPoint.x > lastTouchedPoint.x + 35)
            return YES;
        
        if(touchedPoint.y > lastTouchedPoint.y + 35)
            return YES;
        
        if(touchedPoint.y < lastTouchedPoint.y - 35)
            return YES;
    }
    else
    {
        if(touchedPoint.x < lastTouchedPoint.x - 25)
            return YES;
        
        if(touchedPoint.x > lastTouchedPoint.x + 25)
            return YES;
        
        if(touchedPoint.y > lastTouchedPoint.y + 25)
            return YES;
        
        if(touchedPoint.y < lastTouchedPoint.y - 25)
            return YES;
        
    }
    
    return NO;
}

#pragma mark - Reload scroll

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
    
    if(lastDecoration == 1)
    {
        scroll.contentSize = CGSizeMake(scroll.frame.size.width, 2100);
        for(int i = 0; i < 25; i++)
        {
            int xCoord = 0;
            if(i % 2 == 0)
                xCoord = 40;
            else
                xCoord = 180;
            
            
            UIButton *label = [[UIButton alloc] initWithFrame:CGRectMake(xCoord, 20 + i/2 * 130 + i/2 * 30, 100, 130)];
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                int xCoord = 0;
                if(i % 4 == 0)
                    xCoord = 73;
                else if(i % 4 == 1)
                    xCoord = 250;
                else if(i % 4 == 2)
                    xCoord = 426;
                else if(i % 4 == 3)
                    xCoord = 603;
                
                label.frame = CGRectMake(xCoord, 20 + i/4 * 130 + i/4 * 30, 100, 130);
                scroll.contentSize = CGSizeMake(scroll.frame.size.width, 1100);
            }
            
            label.tag = i + 1;
            [label addTarget:self action:@selector(drawOnChosen:) forControlEvents:UIControlEventTouchUpInside];
            [[label imageView] setContentMode:UIViewContentModeScaleAspectFit];
            
            //        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            //            [label setImage:[UIImage imageNamed:[NSString stringWithFormat:@"deco%d@2x.png", i+1]] forState:UIControlStateNormal];
            //        else
            [label setImage:[UIImage imageNamed:[NSString stringWithFormat:@"x%d.png", i+1]] forState:UIControlStateNormal];
            
            if(i >= 6)
            {
                if([(AppDelegate*)[[UIApplication sharedApplication] delegate] icecreamSandLocked] == YES)
                {
                    UIImageView *locked = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 25)];
                    locked.image = [UIImage imageNamed:@"lockSmall.png"];
                    [label addSubview:locked];
                    
                    [label removeTarget:self action:@selector(drawOnChosen:) forControlEvents:UIControlEventTouchUpInside];
                    [label addTarget:self action:@selector(chooseLockedFlavor) forControlEvents:UIControlEventTouchUpInside];
                }
            }
            
            [scroll addSubview:label];
            [label release];
        }
    }
    else if(lastDecoration == 2)
    {
        scroll.contentSize = CGSizeMake(scroll.frame.size.width, 2100);
        for(int i = 0; i < 25; i++)
        {
            int xCoord = 0;
            if(i % 2 == 0)
                xCoord = 40;
            else
                xCoord = 180;
            
            
            UIButton *label = [[UIButton alloc] initWithFrame:CGRectMake(xCoord, 20 + i/2 * 130 + i/2 * 30, 100, 130)];
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                int xCoord = 0;
                if(i % 4 == 0)
                    xCoord = 73;
                else if(i % 4 == 1)
                    xCoord = 250;
                else if(i % 4 == 2)
                    xCoord = 426;
                else if(i % 4 == 3)
                    xCoord = 603;
                
                label.frame = CGRectMake(xCoord, 20 + i/4 * 130 + i/4 * 30, 100, 130);
                scroll.contentSize = CGSizeMake(scroll.frame.size.width, 1150);
            }
            
            label.tag = i + 1;
            [label addTarget:self action:@selector(decorationChosen:) forControlEvents:UIControlEventTouchUpInside];
            [[label imageView] setContentMode:UIViewContentModeScaleAspectFit];
            
            //        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            //            [label setImage:[UIImage imageNamed:[NSString stringWithFormat:@"decoSand%d@2x.png", i+1]] forState:UIControlStateNormal];
            //        else
            [label setImage:[UIImage imageNamed:[NSString stringWithFormat:@"decoSand%d.png", i+1]] forState:UIControlStateNormal];
            
            if(i >= 5)
            {
                if([(AppDelegate*)[[UIApplication sharedApplication] delegate] icecreamSandLocked] == YES)
                {
                    UIImageView *locked = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 25)];
                    locked.image = [UIImage imageNamed:@"lockSmall.png"];
                    [label addSubview:locked];
                    
                    [label removeTarget:self action:@selector(decorationChosen:) forControlEvents:UIControlEventTouchUpInside];
                    [label addTarget:self action:@selector(chooseLockedFlavor) forControlEvents:UIControlEventTouchUpInside];
                }
            }
            
            [scroll addSubview:label];
            [label release];
        }
    }
    else if(lastDecoration == 3)
    {
        scroll.contentSize = CGSizeMake(scroll.frame.size.width, 3100);
        for(int i = 0; i < 37; i++)
        {
            int xCoord = 0;
            if(i % 2 == 0)
                xCoord = 40;
            else
                xCoord = 180;
            
            
            UIButton *label = [[UIButton alloc] initWithFrame:CGRectMake(xCoord, 20 + i/2 * 130 + i/2 * 30, 100, 130)];
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                int xCoord = 0;
                if(i % 4 == 0)
                    xCoord = 73;
                else if(i % 4 == 1)
                    xCoord = 250;
                else if(i % 4 == 2)
                    xCoord = 426;
                else if(i % 4 == 3)
                    xCoord = 603;
                
                label.frame = CGRectMake(xCoord, 20 + i/4 * 130 + i/4 * 30, 100, 130);
                scroll.contentSize = CGSizeMake(scroll.frame.size.width, 1600);
            }
            
            label.tag = i + 1;
            [label addTarget:self action:@selector(extrasChosen:) forControlEvents:UIControlEventTouchUpInside];
            [[label imageView] setContentMode:UIViewContentModeScaleAspectFit];
            
            //        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            //            [label setImage:[UIImage imageNamed:[NSString stringWithFormat:@"deco%d@2x.png", i+1]] forState:UIControlStateNormal];
            //        else
            [label setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ex%d.png", i+1]] forState:UIControlStateNormal];
            
            if(i >= 8)
            {
                if([(AppDelegate*)[[UIApplication sharedApplication] delegate] icecreamSandLocked] == YES)
                {
                    UIImageView *locked = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 25)];
                    locked.image = [UIImage imageNamed:@"lockSmall.png"];
                    [label addSubview:locked];
                    
                    [label removeTarget:self action:@selector(extrasChosen:) forControlEvents:UIControlEventTouchUpInside];
                    [label addTarget:self action:@selector(chooseLockedFlavor) forControlEvents:UIControlEventTouchUpInside];
                }
            }
            
            [scroll addSubview:label];
            [label release];
        }
    }
}

#pragma mark - Helpers

- (CGRect)frameForDeco
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        switch(deco)
        {
            case 1:
            case 2:
            case 4:
                return CGRectMake(144, 333, 463, 419);
                break;
                
            case 3:
                return CGRectMake(251, 320, 312, 469);
                break;
                
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
                return CGRectMake(145, 135, 471, 817);
                break;
                
            case 10:
            case 11:
                return CGRectMake(245, 315, 287, 430);
                break;
                
            case 12:
                return CGRectMake(178, 183, 413, 692);
                break;
                
            case 13:
            case 14:
                return CGRectMake(196, 320, 350, 424);
                break;
                
            case 15:
                return CGRectMake(152, 291, 470, 476);
                break;
                
            case 16:
                return CGRectMake(210, 382, 340, 346);
                break;
                
            case 17:
                return CGRectMake(145, 309, 494, 443);
                break;
                
            case 18:
            case 19:
            case 20:
                return CGRectMake(152, 304, 478, 502);
                break;
                
            case 21:
                return CGRectMake(185, 291, 386, 477);
                break;
                
            case 22:
                return CGRectMake(185, 334, 388, 442);
                break;
                
            case 23:
                return CGRectMake(195, 347, 343, 382);
                break;
                
            case 24:
                return CGRectMake(133, 288, 503, 474);
                break;
                
            case 25:
                return CGRectMake(144, 333, 463, 419);
                break;
                
            default:
                return CGRectMake(144, 333, 463, 419);
                break;
        }

    }
    else
    {
        switch(deco)
        {
            case 1:
            case 2:
            case 4:
                return CGRectMake(27, 158, 240, 219);
                break;
                
            case 3:
                return CGRectMake(62, 173, 205, 204);
                break;
                
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
                return CGRectMake(21, 128, 255, 286);
                break;
                
            case 10:
            case 11:
                return CGRectMake(21, 147, 255, 235);
                break;
                
            case 12:
                return CGRectMake(14, 139, 260, 258);
                break;
                
            case 13:
            case 14:
                return CGRectMake(51, 156, 181, 223);
                break;
                
            case 15:
                return CGRectMake(51, 147, 194, 232);
                break;
                
            case 16:
                return CGRectMake(62, 171, 170, 194);
                break;
                
            case 17:
                return CGRectMake(43, 159, 212, 218);
                break;
                
            case 18:
            case 19:
            case 20:
                return CGRectMake(39, 149, 216, 247);
                break;
                
            case 21:
                return CGRectMake(39, 149, 216, 238);
                break;
                
            case 22:
                return CGRectMake(60, 158, 175, 219);
                break;
                
            case 23:
                return CGRectMake(62, 156, 153, 223);
                break;
                
            case 24:
                return CGRectMake(45, 142, 205, 251);
                break;
                
            case 25:
                return CGRectMake(43, 142, 211, 251);
                break;
                
            default:
                return CGRectMake(43, 142, 211, 251);
                break;
        }
    }
    
    return CGRectMake(43, 142, 211, 251);
}

@end
