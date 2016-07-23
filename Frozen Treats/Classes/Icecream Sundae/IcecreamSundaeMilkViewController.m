//
//  IcecreamSundaeMilkViewController.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/23/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "IcecreamSundaeMilkViewController.h"
#import "IcecreamSundaeMixViewController.h"
#import "AppDelegate.h"

@implementation IcecreamSundaeMilkViewController
@synthesize flavor;

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"IcecreamSundaeMilkViewController-5" bundle:[NSBundle mainBundle]];
    else
        self = [super init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    flavorPowder.image = [self colorImage:flavor named:@"punch_powder.png"];
    
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
    
    textureMask = [CALayer layer];
    textureMask.frame = CGRectMake(0, powder.frame.size.height, powder.frame.size.width, powder.frame.size.height);
    textureMask.contents = (id)[[UIImage imageNamed:@"milk_mask.png"] CGImage];
    powder.layer.mask = textureMask;
    
    packet.hidden = NO;
    packet.alpha = 1.0;
    nextButton.hidden = YES;
    powderPour.hidden = YES;
    sugar = 0;
    
    
    tiltToPourLabel.hidden = NO;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        tiltToPourLabel.frame = CGRectMake(144, 10, 480, 100);
    else if([UIScreen mainScreen].bounds.size.height == 568)
        tiltToPourLabel.frame = CGRectMake(40, 14, 240, 54);
    else
        tiltToPourLabel.frame = CGRectMake(40, 7, 240, 54);
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear |UIViewAnimationOptionAutoreverse animations:^
     {
         CGRect frame = tiltToPourLabel.frame;
         frame.origin.y += frame.size.height/8;
         tiltToPourLabel.frame = frame;
     } completion:nil];

    
//    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
//    accelerometer.updateInterval = 0.1;
//    accelerometer.delegate = self;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.f/60.f target:self selector:@selector(rotate:) userInfo:nil repeats: YES];
    timerPour = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(pour:) userInfo:nil repeats: YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction

- (IBAction)backClick:(id)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:27];
    
//    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
//    accelerometer.delegate = nil;
    
    if([timer isValid])
        [timer invalidate], timer = nil;
    if([timerPour isValid])
        [timerPour invalidate], timerPour = nil;
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)nextClick:(id)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:27];
    
//    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
//    accelerometer.delegate = nil;
    
    if([timer isValid])
        [timer invalidate], timer = nil;
    if([timerPour isValid])
        [timerPour invalidate], timerPour = nil;

    IcecreamSundaeMixViewController *icecreamMix = [[IcecreamSundaeMixViewController alloc] init];
    icecreamMix.flavor = flavor;
    [self.navigationController pushViewController:icecreamMix animated:YES];
    [icecreamMix release];
}

#pragma mark

- (void)pour:(NSTimer*)theTimer
{
    if(pouring && ++sugar < 8)
    {
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) playSoundEffect:6];
        
        CABasicAnimation *anim = [[CABasicAnimation alloc] init];
        anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(textureMask.position.x, textureMask.position.y)];
        anim.keyPath = @"position";
        anim.timingFunction = [CAMediaTimingFunction functionWithName:@"linear"];
        anim.duration = 0.5;
        textureMask.position = CGPointMake(textureMask.position.x, textureMask.position.y - (textureMask.frame.size.height/7));
        [textureMask addAnimation:anim forKey:nil];
        
        tiltToPourLabel.hidden = YES;
    }
    
    if(sugar >= 8)
    {
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) stopSoundEffect:6];
        
        if([timer isValid])
            [timer invalidate], timer = nil;
        if([timerPour isValid])
            [timerPour invalidate], timerPour = nil;
        
        currentRotation = 0;
        pouring = NO;
        powderPour.hidden = YES;
        
        nextButton.hidden = NO;
        
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
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) stopSoundEffect:6];
    }
    
    packet.transform = CGAffineTransformMakeRotation(currentRotation);
}

//#pragma mark - UIAccelerometer
//
//- (void)accelerometer:(UIAccelerometer*)acelerometer didAccelerate:(UIAcceleration*)acceleration
//{
//    currentX = acceleration.x;
//}

#pragma mark - Color flavor

- (UIImage*)colorImage:(int)flavored named:(NSString*)name
{
    UIColor *flavorx;
    switch(flavored)
    {
        case 1:
            flavorx = [UIColor colorWithRed:0.470588 green:0.631373 blue:0.227451 alpha:1];
            break;
        case 2:
            flavorx = [UIColor colorWithRed:255./255.0 green:171.0/255.0 blue:0.0/255.0 alpha:1];
            break;
        case 3:
            flavorx = [UIColor colorWithRed:0.286275 green:0.000000 blue:0.180392 alpha:1];
            break;
        case 4:
            flavorx = [UIColor colorWithRed:98.0/255.0 green:178.0/255.0 blue:89.0/255.0 alpha:1];
            break;
        case 5:
            flavorx = [UIColor colorWithRed:235.0/255.0 green:78.0/255.0 blue:0.0/255.0 alpha:1];
            break;
        case 6:
            flavorx = [UIColor colorWithRed:0.894118 green:0.803922 blue:0.188235 alpha:1];
            break;
        case 7:
            flavorx = [UIColor colorWithRed:0.921569 green:0.105882 blue:0.090196 alpha:1];
            break;
        case 8:
            flavorx = [UIColor colorWithRed:0.160784 green:0.905882 blue:0.945098 alpha:1];
            break;
        case 9:
            flavorx = [UIColor colorWithRed:0.913726 green:0.000000 blue:0.109804 alpha:1];
            break;
        case 10:
            flavorx = [UIColor colorWithRed:0.815686 green:0.039216 blue:0.392157 alpha:1];
            break;
        case 11:
            flavorx = [UIColor colorWithRed:0.941177 green:0.062745 blue:0.603922 alpha:1];
            break;
        case 12:
            flavorx = [UIColor colorWithRed:71.0/255.0 green:176.0/255.0 blue:60.0/255.0 alpha:1];
            break;
        case 13:
            flavorx = [UIColor colorWithRed:255./255.0 green:171.0/255.0 blue:0.0/255.0 alpha:1];
            break;
        case 14:
            flavorx = [UIColor colorWithRed:0.929412 green:0.756863 blue:0.149020 alpha:1];
            break;
        case 15:
            flavorx = [UIColor colorWithRed:0.882353 green:0.650980 blue:0.258824 alpha:1];
            break;
        case 16:
            flavorx = [UIColor colorWithRed:0.627451 green:0.000000 blue:0.019608 alpha:1];
            break;
            
        default:
            flavorx = [UIColor colorWithRed:0.470588 green:0.631373 blue:0.227451 alpha:1];
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
