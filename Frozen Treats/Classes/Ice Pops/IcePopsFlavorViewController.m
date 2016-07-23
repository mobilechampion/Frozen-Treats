//
//  IcePopsFlavorViewController.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/27/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "IcePopsFlavorViewController.h"
#import "IcePopsStirViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@implementation IcePopsFlavorViewController
@synthesize mold, stick;

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"IcePopsFlavorViewController-5" bundle:[NSBundle mainBundle]];
    else
        self = [super init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    motionManager = [[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval  = 1.0/10.0; // Update at 10Hz
    if(motionManager.accelerometerAvailable)
    {
        NSLog(@"Accelerometer avaliable");
        queue = [NSOperationQueue currentQueue];
        [motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error)
         {
             CMAcceleration acceleration = accelerometerData.acceleration;
             currentX = acceleration.x;
         }];
    }
    else
    {
        NSLog(@"Accelerometer not avaliable");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadScroll) name:@"update" object:nil];
    [self reloadScroll];
    
    textureMask = [CALayer layer];
    textureMask.frame = CGRectMake(0, powder.frame.size.height, powder.frame.size.width, powder.frame.size.height);
    textureMask.contents = (id)[[UIImage imageNamed:@"punch_powder.png"] CGImage];
    powder.layer.mask = textureMask;
    
    tiltToPourLabel.hidden = YES;
    packet.hidden = YES;
    nextButton.hidden = YES;
    powderPour.hidden = YES;
    sugar = 0;
    
    flavorsButton.hidden = NO;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        tiltToPourLabel.frame = CGRectMake(144, 20, 480, 100);
    else if([UIScreen mainScreen].bounds.size.height == 568)
        tiltToPourLabel.frame = CGRectMake(40, 257, 240, 54);
    else
        tiltToPourLabel.frame = CGRectMake(40, 160, 240, 54);
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear |UIViewAnimationOptionAutoreverse animations:^
     {
         CGRect frame = tiltToPourLabel.frame;
         frame.origin.y += frame.size.height/8;
         tiltToPourLabel.frame = frame;
     } completion:nil];
}

#pragma mark - IBAction

- (IBAction)backClick:(id)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:27];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] stopSoundEffect:5];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
//    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
//    accelerometer.delegate = nil;
    
    if([timer isValid])
        [timer invalidate], timer = nil;
    if([timerPour isValid])
        [timerPour invalidate], timerPour = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextClick:(id)sender
{
    //[(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:27];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
//    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
//    accelerometer.delegate = nil;
    
    if([timer isValid])
        [timer invalidate], timer = nil;
    if([timerPour isValid])
        [timerPour invalidate], timerPour = nil;
    
    IcePopsStirViewController *icePopsStir = [[IcePopsStirViewController alloc] init];
    icePopsStir.flavor = flavor;
    icePopsStir.mold = mold;
    icePopsStir.stickx = stick;
    [self.navigationController pushViewController:icePopsStir animated:NO];
    [icePopsStir release];
}

- (IBAction)decorationsClick:(id)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:1];
    
    [scroll setContentOffset:CGPointMake(0.0, 0.0)];
    
    decorationsView.frame = CGRectMake(0, -[[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    [self.view addSubview:decorationsView];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
     {
         decorationsView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
     }
     completion:nil];
}

- (void)flavorChosen:(UIButton*)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:12];
    
    flavor = sender.tag;
    
    powderPour.image = [self colorImage:sender.tag named:@"flavor_texture_punch.png"];
    powder.image = [self colorImage:sender.tag named:@"punch_powder.png"];
    packet.image = [UIImage imageNamed:[NSString stringWithFormat:@"f%d.png", sender.tag]];
    
    tiltToPourLabel.hidden = NO;
    tiltToPourLabel.alpha = 1.0;
    
    flavorsButton.hidden = YES;
    
    packet.hidden = NO;
    packet.alpha = 1.0;
    
    powder.hidden = NO;
    powder.alpha = 1.0;
    
    powderPour.alpha = 1.0;
    
//    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
//    accelerometer.updateInterval = 0.1;
//    accelerometer.delegate = self;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.f/60.f target:self selector:@selector(rotate:) userInfo:nil repeats: YES];
    timerPour = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(pour:) userInfo:nil repeats: YES];
    
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
     {
         decorationsView.frame = CGRectMake(0, -[[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
     } completion:^(BOOL finished)
     {
         [decorationsView removeFromSuperview];
     }];
}

#pragma mark

- (void)pour:(NSTimer*)theTimer
{
    if(pouring && ++sugar < 5)
    {
        [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:5];
        
        CABasicAnimation *anim = [[CABasicAnimation alloc] init];
        anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(textureMask.position.x, textureMask.position.y)];
        anim.keyPath = @"position";
        anim.timingFunction = [CAMediaTimingFunction functionWithName:@"linear"];
        anim.duration = 0.5;
        textureMask.position = CGPointMake(textureMask.position.x, textureMask.position.y - (textureMask.frame.size.height/4));
        [textureMask addAnimation:anim forKey:nil];
        
        tiltToPourLabel.hidden = YES;
    }
    
    if(sugar >= 5)
    {
        [((AppDelegate*)[[UIApplication sharedApplication] delegate]) stopSoundEffect:5];
        
        if([timer isValid])
            [timer invalidate], timer = nil;
        if([timerPour isValid])
            [timerPour invalidate], timerPour = nil;
        
        currentRotation = 0;
        pouring = NO;
        powderPour.hidden = YES;
        //nextButton.hidden = NO;
        [self nextClick:nil];
        
//        UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
//        accelerometer.updateInterval = 0.1;
//        accelerometer.delegate = nil;
        
        //stirThePunchLabel.alpha = 0;
        //stirThePunchLabel.hidden = NO;
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
         {
             packet.alpha = 0;
             //stirThePunchLabel.alpha = 1;
         } completion:^(BOOL finished)
         {
             packet.hidden = YES;
         }];
        
        //stick.hidden = NO;
    }
}

- (void)rotate:(NSTimer*)theTimer
{
    double rotation = currentX * 2.2;
    if(rotation > 0)
        rotation = 0;
    
    rotation -= 0.15;
    
    double difference = rotation - currentRotation;
    currentRotation += difference * 0.05;
    
    if(currentRotation <= -1.3)
    {
        currentRotation = -1.3;
        //        if(tiltToPourLabel.alpha > 0)
        //        {
        //            [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
        //             {
        //                 tiltToPourLabel.alpha = 0;
        //             }
        //             completion:^(BOOL finished)
        //             {
        //                 tiltToPourLabel.hidden = YES;
        //             }];
        //        }
        pouring = YES;
        powderPour.hidden = NO;
    }
    else
    {
        pouring = NO;
        powderPour.hidden = YES;
        [((AppDelegate*)[[UIApplication sharedApplication] delegate]) stopSoundEffect:5];
    }
    
    packet.transform = CGAffineTransformMakeRotation(currentRotation);
}

//#pragma mark - UIAccelerometer
//
//- (void)accelerometer:(UIAccelerometer*)acelerometer didAccelerate:(UIAcceleration*)acceleration
//{
//    currentX = acceleration.x;
//}

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
    
    scroll.contentSize = CGSizeMake(scroll.frame.size.width, 1930);
    for(int i = 0; i < 24; i++)
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
        [label addTarget:self action:@selector(flavorChosen:) forControlEvents:UIControlEventTouchUpInside];
        [[label imageView] setContentMode:UIViewContentModeScaleAspectFit];
        
        //        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        //            [label setImage:[UIImage imageNamed:[NSString stringWithFormat:@"decoSand%d@2x.png", i+1]] forState:UIControlStateNormal];
        //        else
        [label setImage:[UIImage imageNamed:[NSString stringWithFormat:@"f%d.png", i+1]] forState:UIControlStateNormal];
        
        if(i >= 6)
        {
            if([(AppDelegate*)[[UIApplication sharedApplication] delegate] icePopsLocked] == YES)
            {
                UIImageView *locked = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 25)];
                locked.image = [UIImage imageNamed:@"lockSmall.png"];
                [label addSubview:locked];
                
                [label removeTarget:self action:@selector(flavorChosen:) forControlEvents:UIControlEventTouchUpInside];
                [label addTarget:self action:@selector(chooseLockedFlavor) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        [scroll addSubview:label];
        [label release];
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
