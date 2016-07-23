//
//  IcecreamConeDecorateViewController.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/15/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "IcecreamConeDecorateViewController.h"
#import "IcecreamConeFinalViewController.h"
#import "AppDelegate.h"

@implementation IcecreamConeDecorateViewController
@synthesize flavor1, flavor2, cone, dip;

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"IcecreamConeDecorateViewController-5" bundle:[NSBundle mainBundle]];
    else
        self = [super init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    icecream1.image = [UIImage imageNamed:[NSString stringWithFormat:@"icecream%d_1.png", flavor1]];
    icecream2.image = [UIImage imageNamed:[NSString stringWithFormat:@"icecream%d_2.png", flavor2]];
    icecream3.image = [UIImage imageNamed:[NSString stringWithFormat:@"icecream%d_3.png", flavor1]];
    icecream4.image = [UIImage imageNamed:[NSString stringWithFormat:@"icecream%d_4.png", flavor2]];
    coneImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"c%d.png", cone]];
    dipImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"d%d.png", dip]];
    changes = [[NSMutableArray alloc] init];
    extrasArray = [[NSMutableArray alloc] init];
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
    
    if([(AppDelegate *)[[UIApplication sharedApplication] delegate] icecreamConesLocked] == YES)
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
    
    IcecreamConeFinalViewController *iceConeFinal = [[IcecreamConeFinalViewController alloc] init];
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
         NSMutableDictionary *md = [changes lastObject];
         
         if([[md objectForKey:@"type"] isEqualToString:@"deco1"])
         {
             [changes removeLastObject];
             
             deco1 = -1;
             for(int i = 0; i < [changes count]; i++)
             {
                 if([[[changes objectAtIndex:i] objectForKey:@"type"] isEqualToString:@"deco1"])
                 {
                     deco1 = [[[changes objectAtIndex:i] objectForKey:@"pic_nr"] intValue];
                 }
             }
             
             if(deco1 == -1)
                 decoration1.image = nil;
             else
                 decoration1.image = [UIImage imageNamed:[NSString stringWithFormat:@"deco%d.png", deco1]];
             
         }
         else if([[md objectForKey:@"type"] isEqualToString:@"deco2"])
         {
             [changes removeLastObject];
             
             deco2 = -1;
             for(int i = 0; i < [changes count]; i++)
             {
                 if([[[changes objectAtIndex:i] objectForKey:@"type"] isEqualToString:@"deco2"])
                 {
                     deco2 = [[[changes objectAtIndex:i] objectForKey:@"pic_nr"] intValue];
                 }
             }
             
             if(deco2 == -1)
                 decoration2.image = nil;
             else
             {
                 decoration2.image = [UIImage imageNamed:[NSString stringWithFormat:@"deco%d.png", deco2]];
                 decoration2.frame = [self frameForDeco2];
                 
                 if([UIScreen mainScreen].bounds.size.height == 568)
                     decoration2.frame = CGRectMake(decoration2.frame.origin.x, decoration2.frame.origin.y + 80, decoration2.frame.size.width, decoration2.frame.size.height);
             }
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
    int deco = sender.tag;
    if(deco == 1 || deco == 2 || deco == 4 || deco > 8)
    {
        deco1 = sender.tag;
        decoration1.image = [UIImage imageNamed:[NSString stringWithFormat:@"deco%d.png", deco1]];
        
        NSMutableDictionary *md2 = [[NSMutableDictionary alloc] init];
        [md2 setObject:@"deco1" forKey:@"type"];
        [md2 setObject:[NSString stringWithFormat:@"%d", deco1] forKey:@"pic_nr"];
        [md2 setObject:[NSString stringWithFormat:@"%d", lastTag + 1] forKey:@"tag"];
        [changes addObject:md2];
        [md2 release];
        
        lastTag++;
    }
    else
    {
        deco2 = sender.tag;
        decoration2.image = [UIImage imageNamed:[NSString stringWithFormat:@"deco%d.png", deco2]];
        decoration2.frame = [self frameForDeco2];
        
        if([UIScreen mainScreen].bounds.size.height == 568)
            decoration2.frame = CGRectMake(decoration2.frame.origin.x, decoration2.frame.origin.y + 80, decoration2.frame.size.width, decoration2.frame.size.height);
        
        NSMutableDictionary *md2 = [[NSMutableDictionary alloc] init];
        [md2 setObject:@"deco2" forKey:@"type"];
        [md2 setObject:[NSString stringWithFormat:@"%d", deco2] forKey:@"pic_nr"];
        [md2 setObject:[NSString stringWithFormat:@"%d", lastTag + 1] forKey:@"tag"];
        [changes addObject:md2];
        [md2 release];
        
        lastTag++;
    }
    
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

#pragma mark - Helpers

- (CGRect)frameForDeco2
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        switch(deco2)
        {
            case 3:
                return CGRectMake(401, 276, 182, 250);
                break;
                
            case 5:
                return CGRectMake(389, 279, 182, 250);
                break;
                
            case 6:
            case 7:
                return CGRectMake(390, 256, 182, 250);
                break;
                
            case 8:
                return CGRectMake(422, 278, 168, 250);
                break;
                
            default:
                return CGRectMake(398, 284, 180, 255);
                break;
        }
    }
    else
    {
        switch(deco2)
        {
            case 3:
                return CGRectMake(165, 114, 101, 125);
                break;
                
            case 5:
                return CGRectMake(165, 124, 101, 125);
                break;
                
            case 6:
            case 7:
                return CGRectMake(162, 119, 101, 125);
                break;
                
            case 8:
                return CGRectMake(180, 129, 91, 125);
                break;
                
            default:
                return CGRectMake(169, 134, 91, 125);
                break;
        }
    }
}

#pragma mark - Reload scroll

- (void)chooseLockedFlavor
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:21];
    
    NSString *title = @"Unlock Ice Cream Cone?";
    UAExampleModalPanel *modalPanel = [[UAExampleModalPanel alloc] initWithFrame:self.view.bounds title:title andPurchaseTag:0 andCustom:YES] ;
    
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
                if([(AppDelegate*)[[UIApplication sharedApplication] delegate] icecreamConesLocked] == YES)
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
        scroll.contentSize = CGSizeMake(scroll.frame.size.width, 1300);
        for(int i = 0; i < 15; i++)
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
                scroll.contentSize = CGSizeMake(scroll.frame.size.width, 1024);
            }
            
            label.tag = i + 1;
            [label addTarget:self action:@selector(decorationChosen:) forControlEvents:UIControlEventTouchUpInside];
            [[label imageView] setContentMode:UIViewContentModeScaleAspectFit];
            
    //        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    //            [label setImage:[UIImage imageNamed:[NSString stringWithFormat:@"deco%d@2x.png", i+1]] forState:UIControlStateNormal];
    //        else
            [label setImage:[UIImage imageNamed:[NSString stringWithFormat:@"deco%d.png", i+1]] forState:UIControlStateNormal];
            
            if(i >= 5)
            {
                if([(AppDelegate*)[[UIApplication sharedApplication] delegate] icecreamConesLocked] == YES)
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
                if([(AppDelegate*)[[UIApplication sharedApplication] delegate] icecreamConesLocked] == YES)
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

@end
