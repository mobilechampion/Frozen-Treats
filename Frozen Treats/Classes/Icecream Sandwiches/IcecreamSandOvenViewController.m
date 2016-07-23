//
//  IcecreamSandOvenViewController.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/21/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "IcecreamSandOvenViewController.h"
#import "IcecreamSandFlavorViewController.h"
#import "AppDelegate.h"

@implementation IcecreamSandOvenViewController

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"IcecreamSandOvenViewController-5" bundle:[NSBundle mainBundle]];
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
    
    sand1.alpha = 0.0;
    sand2.alpha = 0.0;
    sand3.alpha = 0.0;
    sand4.alpha = 0.0;
    sand5.alpha = 0.0;
    sand6.alpha = 0.0;
    
    nextButton.hidden = YES;
    dragCookieLabel.hidden = NO;
    dragCookieOutLabel.hidden = YES;
    sheetView.userInteractionEnabled = YES;
    bakingLabel.hidden = YES;
    baked = NO;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        dragCookieLabel.frame = CGRectMake(28, 117, 725, 97);
        dragCookieOutLabel.frame = CGRectMake(23, 104, 735, 151);
    }
    else if([UIScreen mainScreen].bounds.size.height == 568)
    {
        dragCookieLabel.frame = CGRectMake(6, 55, 314, 47);
        dragCookieOutLabel.frame = CGRectMake(3, 44, 314, 79);
    }
    else
    {
        dragCookieLabel.frame = CGRectMake(6, 55, 314, 47);
        dragCookieOutLabel.frame = CGRectMake(6, 46, 314, 79);
    }
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear |UIViewAnimationOptionAutoreverse animations:^
     {
         CGRect frame = dragCookieLabel.frame;
         frame.origin.y += frame.size.height/8;
         dragCookieLabel.frame = frame;
         
         frame = dragCookieOutLabel.frame;
         frame.origin.y += frame.size.height/8;
         dragCookieOutLabel.frame = frame;
         
     } completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction

- (IBAction)backClick:(id)sender
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:27];
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) stopSoundEffect:17];
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) stopSoundEffect:28];
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) stopSoundEffect:29];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextClick:(id)sender
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:27];
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) stopSoundEffect:29];
    IcecreamSandFlavorViewController *iceSandFlavor = [[IcecreamSandFlavorViewController alloc] init];
    [self.navigationController pushViewController:iceSandFlavor animated:YES];
    [iceSandFlavor release];
}

#pragma mark - Touches

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    UITouch *touch = [touches anyObject];
    
    float minX, minY, maxY;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        minX = 384;
        minY = 400;
        maxY = 842;
    }
    else if([UIScreen mainScreen].bounds.size.height == 568)
    {
        minX = 164;
        minY = 230;
        maxY = 482;
    }
    else
    {
        minX = 164;
        minY = 193;
        maxY = 394;
    }
    
    
    if([touch view] == sheetView)
    {
        if(baked == NO)
        {
            touchPoint.x = minX;
            if(touchPoint.y < minY)
                touchPoint.y = minY;
            
            if(touchPoint.y > maxY)
            {
                if(![dragCookieLabel isHidden])
                {
                    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:28];
                    [self performSelector:@selector(updateTime) withObject:nil afterDelay:1.0];
                }
                
                
                touchPoint.y = maxY;
                dragCookieLabel.hidden = YES;
                sheetView.userInteractionEnabled = NO;
                baked = YES;
                bakingLabel.hidden = NO;
            }
            
            sheetView.center = touchPoint;
        }
        else if(![dragCookieOutLabel isHidden])
        {
            touchPoint.x = minX;
            
            if(touchPoint.y > maxY)
                touchPoint.y = maxY;
            
            if(touchPoint.y < minY)
            {
                touchPoint.y = minY;

                nextButton.hidden = NO;
                dragCookieOutLabel.hidden = YES;
                sheetView.userInteractionEnabled = NO;
                [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:29];
            }
            
            sheetView.center = touchPoint;
        }
    }
}

- (void)updateTime
{
    [UIView animateWithDuration:7.0 animations:^{
        sand1.alpha = 1.0;
        sand2.alpha = 1.0;
        sand3.alpha = 1.0;
        sand4.alpha = 1.0;
        sand5.alpha = 1.0;
        sand6.alpha = 1.0;
    }];
    
    analogClock2 = nil;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        analogClock2 = [[PSAnalogClockView alloc] initWithFrame:CGRectMake(120, 138, 121, 121)];
        analogClock2.center = CGPointMake(164, 172);
    }
    else
    {
        analogClock2 = [[PSAnalogClockView alloc] initWithFrame:CGRectMake(120, 138, 141, 149)];
        analogClock2.center = self.view.center;
    }
    
    analogClock2.clockFaceImage  = [UIImage imageNamed:@"clock"];
    analogClock2.hourHandImage = [UIImage imageNamed:@"sageataSus"];
    analogClock2.secondHandImage = [UIImage imageNamed:@"sageataDreapta"];
    analogClock2.centerCapImage  = [UIImage imageNamed:@"bulina"];
    
    [self.view addSubview:analogClock2];
    [analogClock2 start];
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:17];
    
    //[(AppDelegate *)[[UIApplication sharedApplication] delegate] playSoundEffect:20];
    [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(stopClock) userInfo:nil repeats:NO];
}

- (void)stopClock
{
    [analogClock2 stop];
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) stopSoundEffect:17];
    [analogClock2 removeFromSuperview];
    [analogClock2 release];
    
    bakingLabel.hidden = YES;
    dragCookieOutLabel.hidden = NO;
    sheetView.userInteractionEnabled = YES;
}

@end
