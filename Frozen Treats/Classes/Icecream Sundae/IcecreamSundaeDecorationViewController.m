//
//  IcecreamSundaeDecorationViewController.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/23/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "IcecreamSundaeDecorationViewController.h"
#import "IcecreamSundaeFinalViewController.h"
#import "AppDelegate.h"

@implementation IcecreamSundaeDecorationViewController
@synthesize  dish, flavor;

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"IcecreamSundaeDecorationViewController-5" bundle:[NSBundle mainBundle]];
    else
        self = [super init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    changes = [[NSMutableArray alloc] init];
//    drizzles = [[NSMutableArray alloc] init];
    extrasArray = [[NSMutableArray alloc] init];
    
    [self arrangeIcecream];
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
    
    if([(AppDelegate *)[[UIApplication sharedApplication] delegate] icecreamSundaeLocked] == YES)
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
    
    IcecreamSundaeFinalViewController *icecreamFinal = [[IcecreamSundaeFinalViewController alloc] init];
    icecreamFinal.flavor = flavor;
    icecreamFinal.dish = dish;
    //icecreamFinal.drizzles = drizzles;
    icecreamFinal.decorationsImage = img;
    [self.navigationController pushViewController:icecreamFinal animated:YES];
    [icecreamFinal release];
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

    /*
    NSMutableDictionary *md = [changes lastObject];
    if([[md objectForKey:@"type"] isEqualToString:@"drizzle"])
    {
        for(UIView *view in [self.view subviews])
        {
            if(view.tag > 0 && view.tag == [drizzles count])
            {
                [view removeFromSuperview];
            }
        }
        [drizzles removeLastObject];
        [changes removeLastObject];
    }
     */
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
    UIImage *temp = [UIImage imageNamed:[NSString stringWithFormat:@"dr%d.png", sender.tag]];
    
    label.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width - temp.size.width)/2, ([[UIScreen mainScreen] bounds].size.height - temp.size.height)/2, temp.size.width, temp.size.height);
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        temp = [UIImage imageNamed:[NSString stringWithFormat:@"dr%d@2x.png", sender.tag]];
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
                if([(AppDelegate*)[[UIApplication sharedApplication] delegate] icecreamSundaeLocked] == YES)
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
        scroll.contentSize = CGSizeMake(scroll.frame.size.width, 1000);
        for(int i = 0; i < 11; i++)
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
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                [label setImage:[UIImage imageNamed:[NSString stringWithFormat:@"dr%d@2x.png", i+1]] forState:UIControlStateNormal];
            else
            [label setImage:[UIImage imageNamed:[NSString stringWithFormat:@"dr%d.png", i+1]] forState:UIControlStateNormal];
            
            if(i >= 4)
            {
                if([(AppDelegate*)[[UIApplication sharedApplication] delegate] icecreamSundaeLocked] == YES)
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
                if([(AppDelegate*)[[UIApplication sharedApplication] delegate] icecreamSundaeLocked] == YES)
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

- (void)arrangeIcecream
{
    dishImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dish%d.png", dish]];
    scoop1.image = [UIImage imageNamed:[NSString stringWithFormat:@"scoop%d.png", flavor]];
    scoop2.image = [UIImage imageNamed:[NSString stringWithFormat:@"scoop%d.png", flavor]];
    scoop3.image = [UIImage imageNamed:[NSString stringWithFormat:@"scoop%d.png", flavor]];
    scoop4.image = [UIImage imageNamed:[NSString stringWithFormat:@"scoop%d.png", flavor]];
    scoop5.image = [UIImage imageNamed:[NSString stringWithFormat:@"scoop%d.png", flavor]];
    
    if([UIScreen mainScreen].bounds.size.height == 480)
    {
        switch(dish)
        {
            case 1:
            {
                dishImgView.frame = CGRectMake(84, 317, 153, 163);
                scoop1.frame = CGRectMake(88, 276, 75, 64);
                scoop2.frame = CGRectMake(152, 276, 75, 64);
                scoop3.frame = CGRectMake(117, 235, 75, 64);
                scoop4.image = nil;
                scoop5.image = nil;
            }
                break;
                
            case 2:
            {
                dishImgView.frame = CGRectMake(50, 317, 222, 163);
                scoop1.frame = CGRectMake(68, 277, 75, 64);
                scoop2.frame = CGRectMake(124, 260, 75, 64);
                scoop3.frame = CGRectMake(178, 277, 75, 64);
                scoop4.image = nil;
                scoop5.image = nil;
            }
                break;
                
            case 3:
            {
                dishImgView.frame = CGRectMake(49, 317, 222, 163);
                scoop1.frame = CGRectMake(68, 277, 75, 64);
                scoop2.frame = CGRectMake(124, 272, 75, 64);
                scoop3.frame = CGRectMake(178, 277, 75, 64);
                scoop4.frame = CGRectMake(95, 228, 75, 64);
                scoop5.frame = CGRectMake(151, 228, 75, 64);
            }
                break;
                
            case 4:
            case 5:
            case 6:
            {
                dishImgView.frame = CGRectMake(49, 317, 222, 163);
                scoop1.frame = CGRectMake(95, 272, 75, 64);
                scoop2.frame = CGRectMake(150, 272, 75, 64);
                scoop3.frame = CGRectMake(131, 239, 75, 64);
                scoop4.image = nil;
                scoop5.image = nil;
            }
                break;
                
            case 7:
            case 8:
            {
                dishImgView.frame = CGRectMake(49, 322, 222, 163);
                scoop1.frame = CGRectMake(63, 282, 75, 64);
                scoop2.frame = CGRectMake(124, 282, 75, 64);
                scoop3.frame = CGRectMake(183, 276, 75, 64);
                scoop4.frame = CGRectMake(96, 237, 75, 64);
                scoop5.frame = CGRectMake(156, 231, 75, 64);
            }
                break;
                
            case 9:
            case 10:
            case 11:
            case 28:
            {
                dishImgView.frame = CGRectMake(49, 337, 222, 163);
                scoop1.frame = CGRectMake(63, 327, 75, 64);
                scoop2.frame = CGRectMake(124, 327, 75, 64);
                scoop3.frame = CGRectMake(183, 321, 75, 64);
                scoop4.frame = CGRectMake(96, 282, 75, 64);
                scoop5.frame = CGRectMake(156, 276, 75, 64);
            }
                break;
                
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            {
                dishImgView.frame = CGRectMake(50, 317, 222, 163);
                scoop1.frame = CGRectMake(63, 282, 75, 64);
                scoop2.frame = CGRectMake(125, 282, 75, 64);
                scoop3.frame = CGRectMake(184, 276, 75, 64);
                scoop4.frame = CGRectMake(97, 237, 75, 64);
                scoop5.frame = CGRectMake(157, 231, 75, 64);
            }
                break;
                
            case 17:
            case 18:
            case 19:
            case 20:
            case 21:
            case 22:
            {
                dishImgView.frame = CGRectMake(50, 317, 222, 163);
                scoop1.frame = CGRectMake(92, 276, 75, 64);
                scoop2.frame = CGRectMake(156, 276, 75, 64);
                scoop3.frame = CGRectMake(124, 236, 75, 64);
                scoop4.image = nil;
                scoop5.image = nil;
            }
                break;
                
            case 23:
            {
                dishImgView.frame = CGRectMake(31, 294, 260, 191);
                scoop1.frame = CGRectMake(124, 376, 75, 64);
                scoop2.frame = CGRectMake(92, 325, 75, 64);
                scoop3.frame = CGRectMake(156, 325, 75, 64);
                scoop4.frame = CGRectMake(123, 283, 75, 64);
                scoop5.image = nil;
            }
                break;
                
            case 24:
            {
                dishImgView.frame = CGRectMake(45, 283, 230, 211);
                scoop1.frame = CGRectMake(150, 386, 75, 64);
                scoop2.frame = CGRectMake(107, 386, 75, 64);
                scoop3.frame = CGRectMake(56, 357, 75, 64);
                scoop4.frame = CGRectMake(183, 329, 75, 64);
                scoop5.frame = CGRectMake(123, 329, 75, 64);
            }
                break;
                
            case 25:
            {
                dishImgView.frame = CGRectMake(27, 275, 269, 247);
                scoop1.frame = CGRectMake(123, 376, 75, 64);
                scoop2.frame = CGRectMake(87, 327, 75, 64);
                scoop3.frame = CGRectMake(155, 321, 75, 64);
                scoop4.image = nil;
                scoop5.image = nil;
            }
                break;
                
            case 26:
            {
                dishImgView.frame = CGRectMake(27, 253, 269, 247);
                scoop1.frame = CGRectMake(123, 340, 75, 64);
                scoop2.frame = CGRectMake(104, 292, 75, 64);
                scoop3.frame = CGRectMake(170, 286, 75, 64);
                scoop4.frame = CGRectMake(62, 259, 75, 64);
                scoop5.frame = CGRectMake(131, 243, 75, 64);
            }
                break;
                
            case 27:
            {
                dishImgView.frame = CGRectMake(26, 242, 269, 247);
                scoop1.frame = CGRectMake(113, 366, 75, 64);
                scoop2.frame = CGRectMake(142, 312, 75, 64);
                scoop3.frame = CGRectMake(113, 264, 75, 64);
                scoop4.frame = CGRectMake(59, 254, 75, 64);
                scoop5.frame = CGRectMake(185, 259, 75, 64);
            }
                break;
                
            default:
                break;
        }
        
        dishImgView.frame = CGRectMake(dishImgView.frame.origin.x, dishImgView.frame.origin.y - 70, dishImgView.frame.size.width, dishImgView.frame.size.height);
        scoop1.frame = CGRectMake(scoop1.frame.origin.x, scoop1.frame.origin.y - 70, scoop1.frame.size.width, scoop1.frame.size.height);
        scoop2.frame = CGRectMake(scoop2.frame.origin.x, scoop2.frame.origin.y - 70, scoop2.frame.size.width, scoop2.frame.size.height);
        scoop3.frame = CGRectMake(scoop3.frame.origin.x, scoop3.frame.origin.y - 70, scoop3.frame.size.width, scoop3.frame.size.height);
        scoop4.frame = CGRectMake(scoop4.frame.origin.x, scoop4.frame.origin.y - 70, scoop4.frame.size.width, scoop4.frame.size.height);
        scoop5.frame = CGRectMake(scoop5.frame.origin.x, scoop5.frame.origin.y - 70, scoop5.frame.size.width, scoop5.frame.size.height);
    }
    else if([UIScreen mainScreen].bounds.size.height == 568)
    {
        switch(dish)
        {
            case 1:
            {
                dishImgView.frame = CGRectMake(84, 317, 153, 163);
                scoop1.frame = CGRectMake(88, 276, 75, 64);
                scoop2.frame = CGRectMake(152, 276, 75, 64);
                scoop3.frame = CGRectMake(117, 235, 75, 64);
                scoop4.image = nil;
                scoop5.image = nil;
            }
                break;
                
            case 2:
            {
                dishImgView.frame = CGRectMake(50, 317, 222, 163);
                scoop1.frame = CGRectMake(68, 277, 75, 64);
                scoop2.frame = CGRectMake(124, 260, 75, 64);
                scoop3.frame = CGRectMake(178, 277, 75, 64);
                scoop4.image = nil;
                scoop5.image = nil;
            }
                break;
                
            case 3:
            {
                dishImgView.frame = CGRectMake(49, 317, 222, 163);
                scoop1.frame = CGRectMake(68, 277, 75, 64);
                scoop2.frame = CGRectMake(124, 272, 75, 64);
                scoop3.frame = CGRectMake(178, 277, 75, 64);
                scoop4.frame = CGRectMake(95, 228, 75, 64);
                scoop5.frame = CGRectMake(151, 228, 75, 64);
            }
                break;
                
            case 4:
            case 5:
            case 6:
            {
                dishImgView.frame = CGRectMake(49, 317, 222, 163);
                scoop1.frame = CGRectMake(95, 272, 75, 64);
                scoop2.frame = CGRectMake(150, 272, 75, 64);
                scoop3.frame = CGRectMake(131, 239, 75, 64);
                scoop4.image = nil;
                scoop5.image = nil;
            }
                break;
                
            case 7:
            case 8:
            {
                dishImgView.frame = CGRectMake(49, 322, 222, 163);
                scoop1.frame = CGRectMake(63, 282, 75, 64);
                scoop2.frame = CGRectMake(124, 282, 75, 64);
                scoop3.frame = CGRectMake(183, 276, 75, 64);
                scoop4.frame = CGRectMake(96, 237, 75, 64);
                scoop5.frame = CGRectMake(156, 231, 75, 64);
            }
                break;
                
            case 9:
            case 10:
            case 11:
            case 28:
            {
                dishImgView.frame = CGRectMake(49, 337, 222, 163);
                scoop1.frame = CGRectMake(63, 327, 75, 64);
                scoop2.frame = CGRectMake(124, 327, 75, 64);
                scoop3.frame = CGRectMake(183, 321, 75, 64);
                scoop4.frame = CGRectMake(96, 282, 75, 64);
                scoop5.frame = CGRectMake(156, 276, 75, 64);
            }
                break;
                
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            {
                dishImgView.frame = CGRectMake(50, 317, 222, 163);
                scoop1.frame = CGRectMake(63, 282, 75, 64);
                scoop2.frame = CGRectMake(125, 282, 75, 64);
                scoop3.frame = CGRectMake(184, 276, 75, 64);
                scoop4.frame = CGRectMake(97, 237, 75, 64);
                scoop5.frame = CGRectMake(157, 231, 75, 64);
            }
                break;
                
            case 17:
            case 18:
            case 19:
            case 20:
            case 21:
            case 22:
            {
                dishImgView.frame = CGRectMake(50, 317, 222, 163);
                scoop1.frame = CGRectMake(92, 276, 75, 64);
                scoop2.frame = CGRectMake(156, 276, 75, 64);
                scoop3.frame = CGRectMake(124, 236, 75, 64);
                scoop4.image = nil;
                scoop5.image = nil;
            }
                break;
                
            case 23:
            {
                dishImgView.frame = CGRectMake(31, 294, 260, 191);
                scoop1.frame = CGRectMake(124, 376, 75, 64);
                scoop2.frame = CGRectMake(92, 325, 75, 64);
                scoop3.frame = CGRectMake(156, 325, 75, 64);
                scoop4.frame = CGRectMake(123, 283, 75, 64);
                scoop5.image = nil;
            }
                break;
                
            case 24:
            {
                dishImgView.frame = CGRectMake(45, 283, 230, 211);
                scoop1.frame = CGRectMake(150, 386, 75, 64);
                scoop2.frame = CGRectMake(107, 386, 75, 64);
                scoop3.frame = CGRectMake(56, 357, 75, 64);
                scoop4.frame = CGRectMake(183, 329, 75, 64);
                scoop5.frame = CGRectMake(123, 329, 75, 64);
            }
                break;
                
            case 25:
            {
                dishImgView.frame = CGRectMake(27, 275, 269, 247);
                scoop1.frame = CGRectMake(123, 376, 75, 64);
                scoop2.frame = CGRectMake(87, 327, 75, 64);
                scoop3.frame = CGRectMake(155, 321, 75, 64);
                scoop4.image = nil;
                scoop5.image = nil;
            }
                break;
                
            case 26:
            {
                dishImgView.frame = CGRectMake(27, 253, 269, 247);
                scoop1.frame = CGRectMake(123, 340, 75, 64);
                scoop2.frame = CGRectMake(104, 292, 75, 64);
                scoop3.frame = CGRectMake(170, 286, 75, 64);
                scoop4.frame = CGRectMake(62, 259, 75, 64);
                scoop5.frame = CGRectMake(131, 243, 75, 64);
            }
                break;
                
            case 27:
            {
                dishImgView.frame = CGRectMake(26, 242, 269, 247);
                scoop1.frame = CGRectMake(113, 366, 75, 64);
                scoop2.frame = CGRectMake(142, 312, 75, 64);
                scoop3.frame = CGRectMake(113, 264, 75, 64);
                scoop4.frame = CGRectMake(59, 254, 75, 64);
                scoop5.frame = CGRectMake(185, 259, 75, 64);
            }
                break;
                
            default:
                break;
        }
        
        dishImgView.frame = CGRectMake(dishImgView.frame.origin.x, dishImgView.frame.origin.y, dishImgView.frame.size.width, dishImgView.frame.size.height);
        scoop1.frame = CGRectMake(scoop1.frame.origin.x, scoop1.frame.origin.y, scoop1.frame.size.width, scoop1.frame.size.height);
        scoop2.frame = CGRectMake(scoop2.frame.origin.x, scoop2.frame.origin.y, scoop2.frame.size.width, scoop2.frame.size.height);
        scoop3.frame = CGRectMake(scoop3.frame.origin.x, scoop3.frame.origin.y, scoop3.frame.size.width, scoop3.frame.size.height);
        scoop4.frame = CGRectMake(scoop4.frame.origin.x, scoop4.frame.origin.y, scoop4.frame.size.width, scoop4.frame.size.height);
        scoop5.frame = CGRectMake(scoop5.frame.origin.x, scoop5.frame.origin.y, scoop5.frame.size.width, scoop5.frame.size.height);
    }
    else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        switch(dish)
        {
            case 1:
            {
                dishImgView.frame = CGRectMake(231, 693, 306, 331);
                scoop1.frame = CGRectMake(266, 629, 120, 105);
                scoop2.frame = CGRectMake(383, 629, 120, 105);
                scoop3.frame = CGRectMake(325, 568, 120, 105);
                scoop4.image = nil;
                scoop5.image = nil;
            }
                break;
                
            case 2:
            {
                dishImgView.frame = CGRectMake(203, 693, 364, 331);
                scoop1.frame = CGRectMake(215, 629, 120, 105);
                scoop2.frame = CGRectMake(318, 618, 120, 105);
                scoop3.frame = CGRectMake(426, 629, 120, 105);
                scoop4.image = nil;
                scoop5.image = nil;
            }
                break;
                
            case 3:
            {
                dishImgView.frame = CGRectMake(203, 693, 364, 331);
                scoop1.frame = CGRectMake(217, 629, 120, 105);
                scoop2.frame = CGRectMake(325, 629, 120, 105);
                scoop3.frame = CGRectMake(426, 629, 120, 105);
                scoop4.frame = CGRectMake(267, 559, 120, 105);
                scoop5.frame = CGRectMake(374, 554, 120, 105);
            }
                break;
                
            case 4:
            case 5:
            case 6:
            {
                dishImgView.frame = CGRectMake(203, 693, 364, 331);
                scoop1.frame = CGRectMake(267, 632, 120, 105);
                scoop2.frame = CGRectMake(376, 618, 120, 105);
                scoop3.frame = CGRectMake(317, 553, 120, 105);
                scoop4.image = nil;
                scoop5.image = nil;
            }
                break;
                
            case 7:
            case 8:
            {
                dishImgView.frame = CGRectMake(205, 732, 364, 331);
                scoop1.frame = CGRectMake(216, 714, 120, 105);
                scoop2.frame = CGRectMake(328, 707, 120, 105);
                scoop3.frame = CGRectMake(432, 707, 120, 105);
                scoop4.frame = CGRectMake(272, 648, 120, 105);
                scoop5.frame = CGRectMake(393, 639, 120, 105);
            }
                break;
                
            case 9:
            case 10:
            case 11:
            case 28:
            {
                dishImgView.frame = CGRectMake(201, 829, 364, 195);
                scoop1.frame = CGRectMake(216, 774, 120, 105);
                scoop2.frame = CGRectMake(328, 767, 120, 105);
                scoop3.frame = CGRectMake(432, 767, 120, 105);
                scoop4.frame = CGRectMake(272, 708, 120, 105);
                scoop5.frame = CGRectMake(393, 699, 120, 105);
            }
                break;
                
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            {
                dishImgView.frame = CGRectMake(189, 735, 391, 289);
                scoop1.frame = CGRectMake(216, 668, 120, 105);
                scoop2.frame = CGRectMake(328, 661, 120, 105);
                scoop3.frame = CGRectMake(432, 661, 120, 105);
                scoop4.frame = CGRectMake(268, 600, 120, 105);
                scoop5.frame = CGRectMake(389, 591, 120, 105);
            }
                break;
                
            case 17:
            case 18:
            case 19:
            case 20:
            case 21:
            case 22:
            {
                dishImgView.frame = CGRectMake(189, 735, 391, 289);
                scoop1.frame = CGRectMake(269, 663, 120, 105);
                scoop2.frame = CGRectMake(381, 656, 120, 105);
                scoop3.frame = CGRectMake(324, 591, 120, 105);
                scoop4.image = nil;
                scoop5.image = nil;
            }
                break;
                
            case 23:
            {
                dishImgView.frame = CGRectMake(189, 735, 391, 289);
                scoop1.frame = CGRectMake(324, 847, 120, 105);
                scoop2.frame = CGRectMake(268, 759, 120, 105);
                scoop3.frame = CGRectMake(380, 752, 120, 105);
                scoop4.frame = CGRectMake(316, 689, 120, 105);
                scoop5.image = nil;
            }
                break;
                
            case 24:
            {
                dishImgView.frame = CGRectMake(190, 735, 391, 289);
                scoop1.frame = CGRectMake(269, 862, 120, 105);
                scoop2.frame = CGRectMake(369, 868, 120, 105);
                scoop3.frame = CGRectMake(219, 770, 120, 105);
                scoop4.frame = CGRectMake(334, 776, 120, 105);
                scoop5.frame = CGRectMake(425, 770, 120, 105);
            }
                break;
                
            case 25:
            case 26:
            {
                dishImgView.frame = CGRectMake(189, 742, 391, 289);
                scoop1.frame = CGRectMake(324, 834, 120, 105);
                scoop2.frame = CGRectMake(266, 749, 120, 105);
                scoop3.frame = CGRectMake(379, 742, 120, 105);
                scoop4.image = nil;
                scoop5.image = nil;
            }
                break;
                
            case 27:
            {
                dishImgView.frame = CGRectMake(189, 742, 391, 289);
                scoop1.frame = CGRectMake(325, 855, 120, 105);
                scoop2.frame = CGRectMake(301, 770, 120, 105);
                scoop3.frame = CGRectMake(402, 727, 120, 105);
                scoop4.frame = CGRectMake(239, 720, 120, 105);
                scoop5.frame = CGRectMake(335, 675, 120, 105);
            }
                break;
                
            default:
                break;
        }
        
        dishImgView.frame = CGRectMake(dishImgView.frame.origin.x, dishImgView.frame.origin.y - 150, dishImgView.frame.size.width, dishImgView.frame.size.height);
        scoop1.frame = CGRectMake(scoop1.frame.origin.x, scoop1.frame.origin.y - 150, scoop1.frame.size.width, scoop1.frame.size.height);
        scoop2.frame = CGRectMake(scoop2.frame.origin.x, scoop2.frame.origin.y - 150, scoop2.frame.size.width, scoop2.frame.size.height);
        scoop3.frame = CGRectMake(scoop3.frame.origin.x, scoop3.frame.origin.y - 150, scoop3.frame.size.width, scoop3.frame.size.height);
        scoop4.frame = CGRectMake(scoop4.frame.origin.x, scoop4.frame.origin.y - 150, scoop4.frame.size.width, scoop4.frame.size.height);
        scoop5.frame = CGRectMake(scoop5.frame.origin.x, scoop5.frame.origin.y - 150, scoop5.frame.size.width, scoop5.frame.size.height);
    }
}

@end
