//
//  IcePopsIngredientsViewController.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/28/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "IcePopsIngredientsViewController.h"
#import "IcePopsFinalViewController.h"
#import "AppDelegate.h"

@implementation IcePopsIngredientsViewController
@synthesize flavor, mold, stick;

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"IcePopsIngredientsViewController-5" bundle:[NSBundle mainBundle]];
    else
        self = [super init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    extrasArray = [[NSMutableArray alloc] init];
    lastTag = 1;
    
    moldImgView.image = [self colorImage:flavor named:[NSString stringWithFormat:@"p%d.png", mold]];
    stickImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"stick%d.png", stick]];
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
    if([(AppDelegate *)[[UIApplication sharedApplication] delegate] icePopsLocked] == YES)
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

    IcePopsFinalViewController *icePopsFinal = [[IcePopsFinalViewController alloc] init];
    icePopsFinal.mold = mold;
    icePopsFinal.stick = stick;
    icePopsFinal.flavor = flavor;
    icePopsFinal.decorationsImage = img;
    [self.navigationController pushViewController:icePopsFinal animated:YES];
    [icePopsFinal release];
}

- (IBAction)undoClick:(id)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:1];
    
    for(UIView *view in [bigView subviews])
    {
        if(view.tag == lastTag)
            [view removeFromSuperview];
    }
    
    if([[[extrasArray lastObject] objectForKey:@"tag"] intValue] == lastTag)
        [extrasArray removeLastObject];
    
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
    
    UIImageView *label = [[UIImageView alloc] init];
    UIImage *temp = [UIImage imageNamed:[NSString stringWithFormat:@"i%d.png", sender.tag]];
    
    label.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width - temp.size.width)/2, ([[UIScreen mainScreen] bounds].size.height - temp.size.height)/2, temp.size.width, temp.size.height);
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        temp = [UIImage imageNamed:[NSString stringWithFormat:@"i%d@2x.png", sender.tag]];
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
    if([touches count] < 3)
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
                if([(AppDelegate*)[[UIApplication sharedApplication] delegate] icePopsLocked] == YES)
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
        scroll.contentSize = CGSizeMake(scroll.frame.size.width, 650);
        for(int i = 0; i < 10; i++)
        {
            int xCoord = 0;
            if(i % 2 == 0)
                xCoord = 40;
            else
                xCoord = 180;
            
            
            UIButton *label = [[UIButton alloc] initWithFrame:CGRectMake(xCoord, 20 + i/2 * 90 + i/2 * 30, 100, 90)];
            
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
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                [label setImage:[UIImage imageNamed:[NSString stringWithFormat:@"i%d@2x.png", i+1]] forState:UIControlStateNormal];
            else
                [label setImage:[UIImage imageNamed:[NSString stringWithFormat:@"i%d.png", i+1]] forState:UIControlStateNormal];
            
            if(i >= 4)
            {
                if([(AppDelegate*)[[UIApplication sharedApplication] delegate] icePopsLocked] == YES)
                {
                    UIImageView *locked = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 25)];
                    locked.image = [UIImage imageNamed:@"lockSmall.png"];
                    [label addSubview:locked];
                    [locked release];
                    
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
                if([(AppDelegate*)[[UIApplication sharedApplication] delegate] icePopsLocked] == YES)
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

#pragma mark - Color flavor

- (UIImage*)colorImage:(int)flavored named:(NSString*)name
{
    UIColor *flavorx;
    switch(flavored)
    {
        case 24:
            flavorx = [UIColor colorWithRed:6.0/255.0 green:84.0/255.0 blue:143.0/255.0 alpha:1.0];
            break;
            
        case 23:
            flavorx = [UIColor colorWithRed:142.0/255.0 green:3.0/255.0 blue:3.0/255.0 alpha:1.0];
            break;
            
        case 22:
            flavorx = [UIColor colorWithRed:33.0/255.0 green:141.0/255.0 blue:0.0/255.0 alpha:1.0];
            break;
            
        case 21:
            flavorx = [UIColor colorWithRed:143.0/255.0 green:84.0/255.0 blue:6.0/255.0 alpha:1.0];
            break;
            
        case 20:
            flavorx = [UIColor colorWithRed:133.0/255.0 green:0.0/255.0 blue:141.0/255.0 alpha:1.0];
            break;
            
            
        case 19:
            flavorx = [UIColor colorWithRed:251.0/255.0 green:248.0/255.0 blue:34.0/255.0 alpha:1.0];
            break;
            
        case 18:
            flavorx = [UIColor colorWithRed:109.0/255.0 green:178.0/255.0 blue:48.0/255.0 alpha:1.0];
            break;
            
            
        case 17:
            flavorx = [UIColor colorWithRed:255.0/255.0 green:153.0/255.0 blue:96.0/255.0 alpha:1.0];
            break;
            
            
        case 16:
            flavorx = [UIColor colorWithRed:214.0/255.0 green:3.0/255.0 blue:3.0/255.0 alpha:1.0];
            break;
            
        case 15:
            flavorx = [UIColor colorWithRed:156.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1.0];
            break;
            
        case 14:
            flavorx = [UIColor colorWithRed:252.0/255.0 green:176.0/255.0 blue:237/255.0 alpha:1.0];
            break;
            
        case 13:
            flavorx = [UIColor colorWithRed:60.0/255.0 green:0.0/255.0 blue:122.0/255.0 alpha:1.0];
            break;
            
        case 12:
            flavorx = [UIColor colorWithRed:30.0/255.0 green:20.0/255.0 blue:5.0/255.0 alpha:1.0];
            break;
            
        case 11:
            flavorx = [UIColor colorWithRed:22.0/255.0 green:219.0/255.0 blue:255.0/255.0 alpha:1.0];
            break;
            
        case 10:
            flavorx = [UIColor colorWithRed:255.0/255.0 green:162.0/255.0 blue:0.0/255.0 alpha:1.0];
            break;
            
        case 9:
            flavorx = [UIColor colorWithRed:255.0/255.0 green:208.0/255.0 blue:126.0/255.0 alpha:1.0];
            break;
            
        case 8:
            flavorx = [UIColor colorWithRed:79.0/255.0 green:0.0/255.0 blue:48.0/255.0 alpha:1.0];
            break;
            
        case 7:
            flavorx = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:168.0/255.0 alpha:1.0];
            break;
            
        case 6:
            flavorx = [UIColor colorWithRed:0.0/255.0 green:108.0/255.0 blue:255.0/255.0 alpha:1.0];
            break;
            
        case 5:
            flavorx = [UIColor colorWithRed:139.0/255.0 green:84.0/255.0 blue:53.0/255.0 alpha:1.0];
            break;
            
        case 4:
            flavorx = [UIColor colorWithRed:191.0/255.0 green:117.0/255.0 blue:43.0/255.0 alpha:1.0];
            break;
            
        case 3:
            flavorx = [UIColor colorWithRed:22.0/255.0 green:25.0/255.0 blue:14.0/255.0 alpha:1.0];
            break;
            
        case 2:
            flavorx = [UIColor colorWithRed:25.0/255.0 green:120.0/255.0 blue:105.0/255.0 alpha:1.0];
            break;
            
        case 1:
            flavorx = [UIColor colorWithRed:255.0/255.0 green:78.0/255.0 blue:0.0/255.0 alpha:1.0];
            break;
            
        default:
            flavorx = [UIColor colorWithRed:255.0/255.0 green:78.0/255.0 blue:0.0/255.0 alpha:1.0];
            break;
    }
    
    
    //load the image
    //NSString *name = @"texture_punch_grey.png";
    UIImage *img = [UIImage imageNamed:name];
    
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(img.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [flavorx setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}

@end
