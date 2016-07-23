//
//  IcecreamConeFlavorViewController.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/14/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "IcecreamConeFlavorViewController.h"
#import "IcecreamConeFillConeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@implementation IcecreamConeFlavorViewController
@synthesize flavor1;

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"IcecreamConeFlavorViewController-5" bundle:[NSBundle mainBundle]];
    else
        self = [super init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    flavorImgView1.image = [self colorFirstImageWithName:@"flavor_mask.png"];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadScroll) name:@"update" object:nil];
    
    tiltToPourLabel.hidden = YES;
    nextButton.hidden = YES;
    bottleFlavor.hidden = YES;
    pouringFlavor.hidden = YES;
    chooseFlavorLabel.hidden = NO;
    flavorImgView2.image = nil;
    
    bottle1.hidden = NO;
    bottle2.hidden = NO;
    bottle3.hidden = NO;
    bottle4.hidden = NO;
    bottle5.hidden = NO;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        chooseFlavorLabel.frame = CGRectMake(134, 296, 500, 151);
    else if([UIScreen mainScreen].bounds.size.height == 568)
        chooseFlavorLabel.frame = CGRectMake(26, 191, 268, 79);
    else
        chooseFlavorLabel.frame = CGRectMake(26, 137, 268, 79);
    
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear |UIViewAnimationOptionAutoreverse animations:^
     {
         CGRect frame = chooseFlavorLabel.frame;
         frame.origin.y += frame.size.height/8;
         chooseFlavorLabel.frame = frame;
     } completion:nil];
    
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        tiltToPourLabel.frame = CGRectMake(144, 85, 480, 100);
    else if([UIScreen mainScreen].bounds.size.height == 568)
        tiltToPourLabel.frame = CGRectMake(40, 60, 240, 54);
    else
        tiltToPourLabel.frame = CGRectMake(40, 37, 240, 54);
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear |UIViewAnimationOptionAutoreverse animations:^
     {
         CGRect frame = tiltToPourLabel.frame;
         frame.origin.y += frame.size.height/8;
         tiltToPourLabel.frame = frame;
     } completion:nil];

    
    
    for(UIView *view in [bottle3 subviews])
    {
        if(view.tag == 89)
            [view removeFromSuperview];
    }
    
    [bottle3 removeTarget:self action:@selector(chooseLockedFlavor) forControlEvents:UIControlEventTouchUpInside];
    [bottle3 addTarget:self action:@selector(flavorSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    for(UIView *view in [bottle4 subviews])
    {
        if(view.tag == 89)
            [view removeFromSuperview];
    }
    
    [bottle4 removeTarget:self action:@selector(chooseLockedFlavor) forControlEvents:UIControlEventTouchUpInside];
    [bottle4 addTarget:self action:@selector(flavorSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    for(UIView *view in [bottle5 subviews])
    {
        if(view.tag == 89)
            [view removeFromSuperview];
    }
    
    [bottle5 removeTarget:self action:@selector(chooseLockedFlavor) forControlEvents:UIControlEventTouchUpInside];
    [bottle5 addTarget:self action:@selector(flavorSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    if([(AppDelegate *)[[UIApplication sharedApplication] delegate] icecreamConesLocked] == YES)
    {
        UIImageView *locked = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 25)];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            locked.frame = CGRectMake(10, 10, 40, 50);
        
        locked.tag = 89;
        locked.image = [UIImage imageNamed:@"lockSmall.png"];
        [bottle3 addSubview:locked];
        [bottle3 removeTarget:self action:@selector(flavorSelected:) forControlEvents:UIControlEventTouchUpInside];
        [bottle3 addTarget:self action:@selector(chooseLockedFlavor) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *locked2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 25)];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            locked2.frame = CGRectMake(10, 10, 40, 50);
        
        locked2.tag = 89;
        locked2.image = [UIImage imageNamed:@"lockSmall.png"];
        [bottle4 addSubview:locked2];
        [bottle4 removeTarget:self action:@selector(flavorSelected:) forControlEvents:UIControlEventTouchUpInside];
        [bottle4 addTarget:self action:@selector(chooseLockedFlavor) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *locked3 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 25)];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            locked3.frame = CGRectMake(10, 10, 40, 50);
        
        locked3.tag = 89;
        locked3.image = [UIImage imageNamed:@"lockSmall.png"];
        [bottle5 addSubview:locked3];
        [bottle5 removeTarget:self action:@selector(flavorSelected:) forControlEvents:UIControlEventTouchUpInside];
        [bottle5 addTarget:self action:@selector(chooseLockedFlavor) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction

- (IBAction)backClick:(id)sender
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:27];
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) stopSoundEffect:6];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
//    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
//    accelerometer.delegate = nil;
    
    if([timerPour isValid])
        [timerPour invalidate], timerPour = nil;
    if([timer isValid])
        [timer invalidate], timer = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextClick:(id)sender
{
    //[((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:27];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
//    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
//    accelerometer.delegate = nil;
    
    if([timerPour isValid])
        [timerPour invalidate], timerPour = nil;
    if([timer isValid])
        [timer invalidate], timer = nil;

    IcecreamConeFillConeViewController *iceCone = [[IcecreamConeFillConeViewController alloc] init];
    iceCone.flavor1 = flavor1;
    iceCone.flavor2 = flavor2;
    [self.navigationController pushViewController:iceCone animated:YES];
    [iceCone release];
}

- (IBAction)flavorSelected:(UIButton*)sender
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:12];
    
    flavor2 = sender.tag;
    chooseFlavorLabel.hidden = YES;
    bottle1.hidden = YES;
    bottle2.hidden = YES;
    bottle3.hidden = YES;
    bottle4.hidden = YES;
    bottle5.hidden = YES;
    tiltToPourLabel.hidden = NO;
    
    bottleFlavor.image = [UIImage imageNamed:[NSString stringWithFormat:@"bottle_%d.png", flavor2]];
    pouringFlavor.image = [UIImage imageNamed:[NSString stringWithFormat:@"pour_%d.png", flavor2]];
    bottleFlavor.hidden = NO;
    
    flavorImgView2.image = [self colorImageWithName:@"flavor_mask.png"];
    maskLayer = [CALayer layer];
    maskLayer.frame = CGRectMake(0, flavorImgView2.frame.size.height, flavorImgView2.frame.size.width, flavorImgView2.frame.size.height);
    maskLayer.contents = (id)[[UIImage imageNamed:@"flavor_mask.png"] CGImage];
    flavorImgView2.layer.mask = maskLayer;
    
//    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
//    accelerometer.updateInterval = 0.1;
//    accelerometer.delegate = self;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.f/60.f target:self selector:@selector(rotate:) userInfo:nil repeats:YES];
    timerPour = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(pour:) userInfo:nil repeats:YES];
}

//#pragma mark - Accelerometer
//
//- (void)accelerometer:(UIAccelerometer *)acelerometer didAccelerate:(UIAcceleration*)acceleration
//{
//    currentX = acceleration.x;
//}

- (void)pour:(NSTimer*)theTimer
{
    if(pouring == YES)
    {
        pouringFlavor.hidden = NO;
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) playSoundEffect:6];
        //[milkSplash setIsEmitting:YES];
        
        float tempPosition;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            tempPosition = 130;
        else
            tempPosition = 70;
        
        if(maskLayer.position.y > tempPosition)
        {
            CABasicAnimation *anim = [[CABasicAnimation alloc] init];
            anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(maskLayer.position.x, maskLayer.position.y)];
            anim.keyPath = @"position";
            anim.timingFunction = [CAMediaTimingFunction functionWithName:@"linear"];
            anim.duration = 0.25;
            maskLayer.position = CGPointMake(maskLayer.position.x, maskLayer.position.y - (maskLayer.frame.size.height/10));
            [maskLayer addAnimation:anim forKey:nil];
            
            tiltToPourLabel.hidden = YES;
            //[milkSplash setIsEmitting:YES];
            //[self performSelector:@selector(milkSplashStopEmitting) withObject:nil afterDelay:0.15];
        }
        else
        {
            [((AppDelegate *)[[UIApplication sharedApplication] delegate]) stopSoundEffect:6];
            
            if([timerPour isValid])
                [timerPour invalidate], timerPour = nil;
            if([timer isValid])
                [timer invalidate], timer = nil;
            
            currentRotation = 0;
            //nextButton.hidden = NO;
            //[milkSplash setIsEmitting:NO];
            [self nextClick:nil];
            
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
             {
                 bottleFlavor.alpha = 0;
                 pouringFlavor.alpha = 0;
             }
             completion:^(BOOL finished)
             {
                 bottleFlavor.hidden = YES;
                 bottleFlavor.alpha = 1.0;
                 
                 pouringFlavor.hidden = YES;
                 // [((FMGAppDelegate *)[[UIApplication sharedApplication] delegate]) stopSoundEffect:5];
                 pouringFlavor.alpha = 1.0;
             }];
        }
    }
    else
    {
        pouringFlavor.hidden = YES;
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) stopSoundEffect:6];
        //[milkSplash setIsEmitting:NO];
    }
}

- (void)milkSplashStopEmitting
{
    //[milkSplash setIsEmitting:NO];
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
        //        if(tiltPourLabel.alpha > 0)
        //        {
        //            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
        //             {
        //                 tiltPourLabel.alpha = 0;
        //             }
        //             completion:^(BOOL finished)
        //             {
        //                 tiltPourLabel.hidden = YES;
        //                 tiltPourLabel.alpha = 1.0;
        //             }];
        //        }
        //[((FMGAppDelegate *)[[UIApplication sharedApplication] delegate]) playSoundEffect:10];
        pouring = YES;
        //[milkSplash setIsEmitting:YES];
    }
    else
    {
        //[((FMGAppDelegate *)[[UIApplication sharedApplication] delegate]) stopSoundEffect:10];
        pouring = NO;
        //[milkSplash setIsEmitting:NO];
    }
    bottleFlavor.transform = CGAffineTransformMakeRotation(currentRotation);
}

#pragma mark - Color image

- (UIImage*)colorImageWithName:(NSString*)name
{
    UIColor *color;
    switch(flavor2)
    {
        case 1:
            color = [UIColor yellowColor];
            break;
            
        case 2:
            color = [UIColor greenColor];
            break;
            
        case 3:
            color = [UIColor redColor];
            break;
            
        case 4:
            color = [UIColor colorWithRed:255.0/255.0 green:34.0/255.0 blue:89.0/255.0 alpha:0.7];
            break;
            
        case 5:
            color = [UIColor colorWithRed:0.0/255.0 green:132.0/255.0 blue:233.0/255.0 alpha:0.7];
            break;
            
        default:
            color = [UIColor clearColor];
            break;
    }
    
    // load the image
    //NSString *name = @"milk_fall_texture_milkshake.png";
    UIImage *img = [UIImage imageNamed:name];
    
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(img.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
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

- (UIImage*)colorFirstImageWithName:(NSString*)name
{
    UIColor *color;
    switch(flavor1)
    {
        case 1:
            color = [UIColor yellowColor];
            break;
            
        case 2:
            color = [UIColor greenColor];
            break;
            
        case 3:
            color = [UIColor redColor];
            break;
            
        case 4:
            color = [UIColor colorWithRed:255.0/255.0 green:34.0/255.0 blue:89.0/255.0 alpha:0.7];
            break;
            
        case 5:
            color = [UIColor colorWithRed:0.0/255.0 green:132.0/255.0 blue:233.0/255.0 alpha:0.7];
            break;
            
        default:
            color = [UIColor clearColor];
            break;
    }
    
    // load the image
    //NSString *name = @"milk_fall_texture_milkshake.png";
    UIImage *img = [UIImage imageNamed:name];
    
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(img.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
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
    if([(AppDelegate *)[[UIApplication sharedApplication] delegate] icecreamConesLocked] == NO)
    {
        for(UIView *view in [bottle3 subviews])
        {
            if(view.tag == 89)
                [view removeFromSuperview];
        }
        
        [bottle3 removeTarget:self action:@selector(chooseLockedFlavor) forControlEvents:UIControlEventTouchUpInside];
        [bottle3 addTarget:self action:@selector(flavorSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        for(UIView *view in [bottle4 subviews])
        {
            if(view.tag == 89)
                [view removeFromSuperview];
        }
        
        [bottle4 removeTarget:self action:@selector(chooseLockedFlavor) forControlEvents:UIControlEventTouchUpInside];
        [bottle4 addTarget:self action:@selector(flavorSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        for(UIView *view in [bottle5 subviews])
        {
            if(view.tag == 89)
                [view removeFromSuperview];
        }
        
        [bottle5 removeTarget:self action:@selector(chooseLockedFlavor) forControlEvents:UIControlEventTouchUpInside];
        [bottle5 addTarget:self action:@selector(flavorSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
}

@end
