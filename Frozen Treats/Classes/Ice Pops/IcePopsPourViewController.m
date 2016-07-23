//
//  IcePopsPourViewController.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/27/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "IcePopsPourViewController.h"
#import "IcePopsFreezerViewController.h"
#import "AppDelegate.h"

@implementation IcePopsPourViewController
@synthesize flavor, mold, stick;

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"IcePopsPourViewController-5" bundle:[NSBundle mainBundle]];
    else
        self = [super init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    moldImgView.frame = [self frameForStupidMask];
    powder.frame = [self frameForStupidMask];
    powderPour.frame = [self frameForStupidPour];

    CGRect bounds = powder.bounds;
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = bounds;
    maskLayer.contents = (id)[[UIImage imageNamed:[NSString stringWithFormat:@"maskPops%d.png", mold]] CGImage];
    powder.layer.mask = maskLayer;

    flavorView = [[UIView alloc] init];
    flavorView.backgroundColor = [self colorForMold];
    flavorView.alpha = 0.7;
    flavorView.frame = CGRectMake(0, moldImgView.frame.size.height, moldImgView.frame.size.width, moldImgView.frame.size.height);
    
    [powder addSubview:flavorView];
    
    
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
    
    tiltToPourLabel.hidden = NO;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        tiltToPourLabel.frame = CGRectMake(144, 462, 480, 100);
    else if([UIScreen mainScreen].bounds.size.height == 568)
        tiltToPourLabel.frame = CGRectMake(40, 257, 240, 54);
    else
        tiltToPourLabel.frame = CGRectMake(40, 180, 240, 54);
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear |UIViewAnimationOptionAutoreverse animations:^
     {
         CGRect frame = tiltToPourLabel.frame;
         frame.origin.y += frame.size.height/8;
         tiltToPourLabel.frame = frame;
     } completion:nil];

    
    moldImgView.frame = [self frameForStupidMask];
    powder.frame = [self frameForStupidMask];
    powderPour.frame = [self frameForStupidPour];
    
    if([UIScreen mainScreen].bounds.size.height == 568)
    {
        moldImgView.frame = CGRectMake(moldImgView.frame.origin.x, moldImgView.frame.origin.y + 55, moldImgView.frame.size.width, moldImgView.frame.size.height);
        powder.frame = CGRectMake(powder.frame.origin.x, powder.frame.origin.y + 55, powder.frame.size.width, powder.frame.size.height);
        powderPour.frame = CGRectMake(powderPour.frame.origin.x, powderPour.frame.origin.y + 55, powderPour.frame.size.width, powderPour.frame.size.height);
    }
    
    flavorView.frame = CGRectMake(0, moldImgView.frame.size.height, moldImgView.frame.size.width, moldImgView.frame.size.height);
    
    
//    textureMask = [CALayer layer];
//    textureMask.frame = CGRectMake(0, powder.frame.size.height, powder.frame.size.width, powder.frame.size.height);
//    textureMask.contents = (id)[[UIImage imageNamed:[NSString stringWithFormat:@"maskPops%d.png", mold]] CGImage];
//    powder.layer.mask = textureMask;
    
    packet.hidden = NO;
    packet.alpha = 1.0;
    
    powder.hidden = NO;
    powder.alpha = 1.0;
    
    nextButton.hidden = YES;
    sugar = 0;
    powderPour.alpha = 1.0;
    
    moldImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"p%d.png", mold]];
    powderPour.image = [self colorImage:flavor named:@"water_pour.png"];
    //powder.image = [self colorImage:flavor named:@"mix_coloured.png"];
    flavoredImgView.image = [self colorImage:flavor named:@"jug_texture_grey.png"];
    


//    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
//    accelerometer.updateInterval = 0.1;
//    accelerometer.delegate = self;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.f/60.f target:self selector:@selector(rotate:) userInfo:nil repeats:YES];
    timerPour = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(pour:) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction

- (IBAction)backClick:(id)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:27];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] stopSoundEffect:6];
    
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
    
    IcePopsFreezerViewController *icePopsFreezer = [[IcePopsFreezerViewController alloc] init];
    icePopsFreezer.flavor = flavor;
    icePopsFreezer.mold = mold;
    icePopsFreezer.stick = stick;
    [self.navigationController pushViewController:icePopsFreezer animated:YES];
    [icePopsFreezer release];
}

#pragma mark

- (void)pour:(NSTimer*)theTimer
{
    if(pouring && ++sugar < 8)
    {
        tiltToPourLabel.hidden = YES;
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) playSoundEffect:6];
        
//        CABasicAnimation *anim = [[CABasicAnimation alloc] init];
//        anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(textureMask.position.x, textureMask.position.y)];
//        anim.keyPath = @"position";
//        anim.timingFunction = [CAMediaTimingFunction functionWithName:@"linear"];
//        anim.duration = 0.5;
//        
//        CGRect frame = flavorView.frame;
//        frame.origin.y -= moldImgView.frame.size.height/7;
//        flavorView.frame = frame;
//        
//        [flavorView.layer addAnimation:anim forKey:nil];
        
        //0.5603
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
         {
            CGRect frame = flavorView.frame;
            frame.origin.y -= moldImgView.frame.size.height/7;
            flavorView.frame = frame;
        } completion:nil];
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
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] stopSoundEffect:6];
    }
    
    packet.transform = CGAffineTransformMakeRotation(currentRotation);
}

//#pragma mark - UIAccelerometer
//
//- (void)accelerometer:(UIAccelerometer*)acelerometer didAccelerate:(UIAcceleration*)acceleration
//{
//    currentX = acceleration.x;
//}

#pragma mark - Helpers

- (CGRect)frameForStupidPour
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        switch(mold)
        {
            case 1:
            case 2:
                return CGRectMake(243, 253 - 30, 237, 662 + 30);
                break;
                
            case 3:
                return CGRectMake(243, 253 - 30, 237, 567 + 30);
                break;
                
            case 4:
                return CGRectMake(243, 253 - 30, 237, 628 + 30);
                break;
                
            case 13:
                return CGRectMake(243, 253 - 30, 237, 580 + 30);
                break;
                
            case 5:
            case 6:
            case 7:
            case 10:
            case 11:
            case 12:
            case 14:
            case 19:
                return CGRectMake(243, 253 - 30, 237, 661 + 30);
                break;
                
            case 8:
                return CGRectMake(243, 253 - 30, 237, 564 + 30);
                break;
                
            case 9:
            case 16:
            case 20:
                return CGRectMake(243, 253 - 30, 237, 631 + 30);
                break;
                
            case 15:
                return CGRectMake(243, 253 - 30, 237, 629 + 30);
                break;
                
            case 17:
                return CGRectMake(243, 253 - 30, 237, 670 + 30);
                break;
                
            case 18:
                return CGRectMake(243, 253 - 30, 237, 588 + 30);
                break;
                
            default:
                return CGRectMake(0, 0, 0, 0);
                break;
        }
    }
    else
    {
        switch(mold)
        {
            case 1:
            case 2:
                return CGRectMake(112, 111, 56, 307);
                break;
                
            case 3:
                return CGRectMake(112, 111, 56, 259);
                break;
                
            case 4:
            case 13:
                return CGRectMake(112, 111, 56, 284);
                break;
                
            case 5:
            case 6:
            case 7:
            case 10:
            case 11:
            case 12:
            case 14:
            case 19:
                return CGRectMake(112, 111, 56, 311);
                break;
                
            case 8:
                return CGRectMake(112, 111, 56, 268);
                break;
                
            case 9:
            case 16:
                return CGRectMake(112, 111, 56, 305);
                break;
                
            case 15:
                return CGRectMake(112, 111, 56, 294);
                break;
                
            case 17:
                return CGRectMake(112, 111, 56, 316);
                break;
                
            case 18:
                return CGRectMake(112, 111, 56, 279);
                break;
                
            case 20:
                return CGRectMake(112, 111, 56, 301);
                break;
                
            default:
                return CGRectMake(0, 0, 0, 0);
                break;
        }
    }
}

- (CGRect)frameForStupidMask
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        switch(mold)
        {
            case 1:
                return CGRectMake(209, 547, 183, 380);
                break;
                
            case 2:
                return CGRectMake(189, 481, 226, 461);
                break;
                
            case 3:
                return CGRectMake(92, 555, 409, 395);
                break;
                
            case 4:
                return CGRectMake(111, 581, 374, 356);
                break;
                
            case 5:
                return CGRectMake(92, 649, 409, 395);
                break;
                
            case 6:
                return CGRectMake(128, 618, 341, 310);
                break;
                
            case 7:
                return CGRectMake(104, 663, 375, 260);
                break;
                
            case 8:
                return CGRectMake(115, 582, 376, 332);
                break;
                
            case 9:
                return CGRectMake(107, 602, 378, 310);
                break;
                
            case 10:
                return CGRectMake(116, 553, 362, 372);
                break;
                
            case 11:
                return CGRectMake(128, 554, 334, 372);
                break;
                
            case 12:
                return CGRectMake(158, 556, 220, 370);
                break;
                
            case 13:
                return CGRectMake(122, 582, 378, 332);
                break;
                
            case 14:
                return CGRectMake(108, 568, 378, 375);
                break;
                
            case 15:
                return CGRectMake(194, 531, 209, 402);
                break;
                
            case 16:
                return CGRectMake(123, 573, 414, 353);
                break;
                
            case 17:
                return CGRectMake(186, 550, 304, 388);
                break;
                
            case 18:
                return CGRectMake(122, 561, 352, 372);
                break;
                
            case 19:
                return CGRectMake(187, 557, 226, 372);
                break;
                
            case 20:
                return CGRectMake(111, 578, 378, 332);
                break;
                
            default:
                return CGRectMake(0, 0, 0, 0);
                break;
        }
    }
    else
    {
        switch(mold)
        {
            case 1:
                return CGRectMake(81, 241, 90, 186);
                break;
                
            case 2:
                return CGRectMake(77, 234, 99, 202);
                break;
                
            case 3:
                return CGRectMake(33, 246, 187, 181);
                break;
                
            case 4:
                return CGRectMake(32, 245, 187, 178);
                break;
                
            case 5:
                return CGRectMake(33, 302, 186, 135);
                break;
                
            case 6:
                return CGRectMake(41, 277, 171, 155);
                break;
                
            case 7:
                return CGRectMake(32, 297, 188, 130);
                break;
                
            case 8:
                return CGRectMake(32, 261, 189, 166);
                break;
                
            case 9:
                return CGRectMake(32, 272, 189, 155);
                break;
                
            case 10:
                return CGRectMake(36, 241, 181, 186);
                break;
                
            case 11:
                return CGRectMake(43, 242, 167, 186);
                break;
                
            case 12:
                return CGRectMake(58, 242, 110, 185);
                break;
                
            case 13:
                return CGRectMake(32, 270, 189, 166);
                break;
                
            case 14:
                return CGRectMake(32, 249, 189, 187);
                break;
                
            case 15:
                return CGRectMake(77, 241, 98, 187);
                break;
                
            case 16:
                return CGRectMake(32, 274, 189, 161);
                break;
                
            case 17:
                return CGRectMake(69, 242, 152, 194);
                break;
                
            case 18:
                return CGRectMake(38, 249, 176, 186);
                break;
                
            case 19:
                return CGRectMake(70, 241, 113, 186);
                break;
                
            case 20:
                return CGRectMake(32, 271, 189, 166);
                break;

            default:
                return CGRectMake(0, 0, 0, 0);
                break;
        }
    }
}

#pragma mark - Color flavor

- (UIColor*)colorForMold
{
    UIColor *flavorx;
    switch(flavor)
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

    return flavorx;
}

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
