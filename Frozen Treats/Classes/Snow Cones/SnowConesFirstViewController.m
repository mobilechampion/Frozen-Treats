//
//  SnowConesFirstViewController.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/30/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "SnowConesFirstViewController.h"
#import "SnowConesConeViewController.h"
#import "AppDelegate.h"

@implementation SnowConesFirstViewController

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"SnowConesFirstViewController-5" bundle:[NSBundle mainBundle]];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    textureMask = [CALayer layer];
    textureMask.frame = CGRectMake(0, powder.frame.size.height, powder.frame.size.width, powder.frame.size.height);
    textureMask.contents = (id)[[UIImage imageNamed:@"shaved_ice.png"] CGImage];
    powder.layer.mask = textureMask;
    
    packet.hidden = NO;
    packet.alpha = 1.0;
    nextButton.hidden = YES;
    sugar = 0;
    cubesNr = 0;
    pressButtonLabel.hidden = YES;
    
    [machineButton setUserInteractionEnabled:NO];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [machineButton setBackgroundImage:[UIImage imageNamed:@"off_machine@2x.png"] forState:UIControlStateNormal];
    else
        [machineButton setBackgroundImage:[UIImage imageNamed:@"off_machine.png"] forState:UIControlStateNormal];
    
//    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
//    accelerometer.updateInterval = 0.1;
//    accelerometer.delegate = self;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.f/60.f target:self selector:@selector(rotate:) userInfo:nil repeats:YES];
    timerPour = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(pour:) userInfo:nil repeats:YES];
    
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        pressButtonLabel.frame = CGRectMake(144, 125, 480, 80);
    else if([UIScreen mainScreen].bounds.size.height == 568)
        pressButtonLabel.frame = CGRectMake(40, 97, 240, 39);
    else
        pressButtonLabel.frame = CGRectMake(40, 58, 240, 39);
    
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear |UIViewAnimationOptionAutoreverse animations:^
     {
         CGRect frame = pressButtonLabel.frame;
         frame.origin.y += frame.size.height/8;
         pressButtonLabel.frame = frame;
     } completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"snowconesfirst"] isEqualToString:@"yes"])
    {
    }
    else
    {
        if([(AppDelegate *)[[UIApplication sharedApplication] delegate] snowConesLocked] == YES)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice:" message:@"While playing Snow Cones Maker you will see ads. If you purchase the unlock Snow Cones pack, ads will be removed." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"snowconesfirst"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark 

- (void)stopEmitting
{
    emitter.birthRate = 0;
    [emitter performSelector:@selector(removeFromSuperlayer) withObject:nil afterDelay:3.0];
}

- (void)startEmitting
{
    emitter.birthRate = 1;
}

- (CAEmitterCell*)sparkCell
{
    CAEmitterCell *spark = [CAEmitterCell emitterCell];
    spark.color = [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:0.3].CGColor;
    spark.contents = (id)[UIImage imageNamed:@"Particle.png"].CGImage;
    spark.birthRate = 16;
    spark.lifetime = 1.7;
    spark.scale = 0.8;
//    spark.scaleRange = 0.2;
    spark.emissionLongitude = - M_PI - M_PI_4 - 0.1;
    spark.velocity = 95;
    spark.spin = 0.5;
//    spark.velocityRange = 8;
    //spark.yAcceleration = -100;
//    spark.alphaRange = 0.5;
//    spark.alphaSpeed = -1;
//    spark.spin = 1;
//    spark.spinRange = 6;
    
//    spark.alphaRange = 0.6;
//    spark.redRange = 2;
//    spark.greenRange = 3;
//    spark.blueRange = 3;
    [spark setName:@"spark"];
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        spark.scale = 2.0;
        spark.lifetime = 1.9;
        spark.velocity = 200;
    }
    return spark;
}

#pragma mark - IBAction

- (IBAction)backClick:(id)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:27];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] stopSoundEffect:7];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] stopSoundEffect:18];
    
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
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:27];
    
//    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
//    accelerometer.delegate = nil;
    
    if([timer isValid])
        [timer invalidate], timer = nil;
    if([timerPour isValid])
        [timerPour invalidate], timerPour = nil;
    
    SnowConesConeViewController *snowCones = [[SnowConesConeViewController alloc] init];
    [self.navigationController pushViewController:snowCones animated:YES];
    [snowCones release];
}

- (IBAction)startMachine:(id)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:18];
    [bubbles setIsEmittingLast];

    [machineButton setUserInteractionEnabled:NO];
    pressButtonLabel.hidden = YES;
    
    pouring = YES;
    timerIce = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(pourShavedIce:) userInfo:nil repeats:YES];
}

#pragma mark

#define RANDOM_INT(__MIN__, __MAX__) ((__MIN__) + arc4random() % ((__MAX__+1 - __MIN__)))

- (void)pour:(NSTimer*)theTimer
{
        if(cubesPouring && ++cubesNr < 20)
        {
            UIImage *image = [UIImage imageNamed:@"ice_cube.png"];
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                UIImageView *cube = [[UIImageView alloc] initWithFrame:CGRectMake(packet.center.x - packet.frame.size.width/1.7, packet.center.y, 20, 20)];
                cube.image = image;
                cube.alpha = 0.6;
                [self.view insertSubview:cube atIndex:1];
                
                CGRect frame = cube.frame;
                frame.size = CGSizeMake(frame.size.width * 2, frame.size.height * 2);
                cube.frame = frame;
                
                float cubeTransform = RANDOM_INT(-314, 314)/100.f;
                [UIView animateWithDuration:(RANDOM_INT(100, 120)/135.f) delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^
                 {
                     int offset = 60 + (cubesNr * 0.6);
                     if(cubesNr % 2 == 0)
                         cube.center = CGPointMake(215 + RANDOM_INT(0, offset), 350);
                     else
                         cube.center = CGPointMake(215 - RANDOM_INT(0, offset), 350);
                     
                     cube.transform = CGAffineTransformMakeRotation(cubeTransform);
                 } completion:^(BOOL finished) {
                     [cube removeFromSuperview];
                 }];
            }
            else
            {
                UIImageView *cube = [[UIImageView alloc] initWithFrame:CGRectMake(packet.center.x - packet.frame.size.width/1.7, packet.center.y, 12, 12)];
                cube.image = image;
                cube.alpha = 0.6;
                [self.view insertSubview:cube atIndex:1];
                
                CGRect frame = cube.frame;
                frame.size = CGSizeMake(frame.size.width * 2, frame.size.height * 2);
                cube.frame = frame;
                
                float cubeTransform = RANDOM_INT(-314, 314)/100.f;
                [UIView animateWithDuration:(RANDOM_INT(100, 120)/135.f) delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^
                 {
                     
                     if([UIScreen mainScreen].bounds.size.height == 568)
                     {
                         int offset = 20 + (cubesNr * 0.8);
                         if(cubesNr % 2 == 0)
                             cube.center = CGPointMake(85 + RANDOM_INT(0, offset), 230);
                         else
                             cube.center = CGPointMake(85 - RANDOM_INT(0, offset), 230);
                     }
                     else
                     {
                         int offset = 20 + (cubesNr * 0.8);
                         if(cubesNr % 2 == 0)
                             cube.center = CGPointMake(85 + RANDOM_INT(0, offset), 180);
                         else
                             cube.center = CGPointMake(85 - RANDOM_INT(0, offset), 180);
                     }
                     
                     cube.transform = CGAffineTransformMakeRotation(cubeTransform);
                 } completion:^(BOOL finished) {
                     [cube removeFromSuperview];
                 }];
            }
        }
    
    
        if(cubesNr >= 20)
        {
            [((AppDelegate*)[[UIApplication sharedApplication] delegate]) stopSoundEffect:7];
            
            if([timer isValid])
                [timer invalidate], timer = nil;
            if([timerPour isValid])
                [timerPour invalidate], timerPour = nil;
            
            currentRotation = 0;
            cubesPouring = NO;
            
            pressButtonLabel.hidden = NO;
            pressButtonLabel.alpha = 0.0;
            
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
             {
                 packet.alpha = 0;
                 pressButtonLabel.alpha = 1.0;
             }
             completion:^(BOOL finished)
             {
                 packet.hidden = YES;
                 packet.alpha = 1.0;
                 
                 [machineButton setUserInteractionEnabled:YES];
                 if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                     [machineButton setBackgroundImage:[UIImage imageNamed:@"on_machine@2x.png"] forState:UIControlStateNormal];
                 else
                     [machineButton setBackgroundImage:[UIImage imageNamed:@"on_machine.png"] forState:UIControlStateNormal];
             }];

            currentRotation = 0;
        }
//    }
}

- (void)pourShavedIce:(NSTimer*)theTimer
{
    if(pouring && ++sugar < 9)
    {
        //[((FMGAppDelegate *)[[UIApplication sharedApplication] delegate]) playSoundEffect:11];
        
        CABasicAnimation *anim = [[CABasicAnimation alloc] init];
        anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(textureMask.position.x, textureMask.position.y)];
        anim.keyPath = @"position";
        anim.timingFunction = [CAMediaTimingFunction functionWithName:@"linear"];
        anim.duration = 0.5;
        textureMask.position = CGPointMake(textureMask.position.x, textureMask.position.y - (textureMask.frame.size.height/8));
        [textureMask addAnimation:anim forKey:nil];
    }
    
    if(sugar >= 9)
    {
        //[((AppDelegate *)[[UIApplication sharedApplication] delegate]) stopSoundEffect:11];
        
        [bubbles setIsEmitting:NO];
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] stopSoundEffect:18];
        if([timerIce isValid])
            [timerIce invalidate], timerIce = nil;
        
        currentRotation = 0;
        pouring = NO;
        //powderPour.hidden = YES;
        nextButton.hidden = NO;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            [machineButton setBackgroundImage:[UIImage imageNamed:@"off_machine@2x.png"] forState:UIControlStateNormal];
        else
            [machineButton setBackgroundImage:[UIImage imageNamed:@"off_machine.png"] forState:UIControlStateNormal];
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
        //pouring = YES;
        cubesPouring = YES;
        //powderPour.hidden = NO;
        [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:7];
    }
    else
    {
        //pouring = NO;
        cubesPouring = NO;
        //powderPour.hidden = YES;
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) stopSoundEffect:7];
    }
    
    packet.transform = CGAffineTransformMakeRotation(currentRotation);
}

//#pragma mark - UIAccelerometer
//
//- (void)accelerometer:(UIAccelerometer*)acelerometer didAccelerate:(UIAcceleration*)acceleration
//{
//    currentX = acceleration.x;
//}

@end
