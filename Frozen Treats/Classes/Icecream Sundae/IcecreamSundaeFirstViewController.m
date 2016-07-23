//
//  IcecreamSundaeFirstViewController.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/22/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "IcecreamSundaeFirstViewController.h"
#import "IcecreamSundaeSugarViewController.h"
#import "AppDelegate.h"

@implementation IcecreamSundaeFirstViewController

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"IcecreamSundaeFirstViewController-5" bundle:[NSBundle mainBundle]];
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"icecreamsundaefirst"] isEqualToString:@"yes"])
    {
    }
    else
    {
        if([(AppDelegate *)[[UIApplication sharedApplication] delegate] icecreamSundaeLocked] == YES)
        {
            
            NSString *fgfkgfdString = @"While playing Ice Cream Sundae Maker you will see ads. If you purchase the unlock Ice Cream Sundae pack, ads will be removed.";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice:" message:fgfkgfdString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            alert.message=fgfkgfdString;
            [alert show];
            [alert release];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"icecreamsundaefirst"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
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
    
    packet.hidden = YES;
    nextButton.hidden = YES;
    powderPour.hidden = YES;
    sugar = 0;
    
    selectAFlavorLabel.hidden = NO;
    flavorsButton.hidden = NO;
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        selectAFlavorLabel.frame = CGRectMake(144, 279, 480, 76);
    else if([UIScreen mainScreen].bounds.size.height == 568)
        selectAFlavorLabel.frame = CGRectMake(40, 143, 240, 43);
    else
        selectAFlavorLabel.frame = CGRectMake(40, 105, 240, 43);
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear |UIViewAnimationOptionAutoreverse animations:^
     {
         CGRect frame = selectAFlavorLabel.frame;
         frame.origin.y += frame.size.height/8;
         selectAFlavorLabel.frame = frame;         
     } completion:nil];
    
    
    tiltToPourLabel.hidden = YES;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        tiltToPourLabel.frame = CGRectMake(144, 296, 480, 100);
    else if([UIScreen mainScreen].bounds.size.height == 568)
        tiltToPourLabel.frame = CGRectMake(40, 200, 240, 54);
    else
        tiltToPourLabel.frame = CGRectMake(40, 156, 240, 54);
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear |UIViewAnimationOptionAutoreverse animations:^
     {
         CGRect frame = tiltToPourLabel.frame;
         frame.origin.y += frame.size.height/8;
         tiltToPourLabel.frame = frame;
     } completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction

- (IBAction)backClick:(id)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:27];
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) stopSoundEffect:5];
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
    
    IcecreamSundaeSugarViewController *icecreamSugar = [[IcecreamSundaeSugarViewController alloc] init];
    icecreamSugar.flavor = flavor;
    [self.navigationController pushViewController:icecreamSugar animated:NO];
    [icecreamSugar release];
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
    
    tiltToPourLabel.hidden = NO;
    flavor = sender.tag;
    
    powderPour.image = [self colorImage:sender.tag named:@"flavor_texture_punch.png"];
    powder.image = [self colorImage:sender.tag named:@"punch_powder.png"];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        packet.image = [UIImage imageNamed:[NSString stringWithFormat:@"flavorSundae%d@2x.png", sender.tag]];
    else
        packet.image = [UIImage imageNamed:[NSString stringWithFormat:@"flavorSundae%d.png", sender.tag]];
    
    selectAFlavorLabel.hidden = YES;
    
//    tiltToPourLabel.hidden = NO;
//    tiltToPourLabel.alpha = 1.0;
    
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
    if(pouring && ++sugar < 4)
    {
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) playSoundEffect:5];
        
        CABasicAnimation *anim = [[CABasicAnimation alloc] init];
        anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(textureMask.position.x, textureMask.position.y)];
        anim.keyPath = @"position";
        anim.timingFunction = [CAMediaTimingFunction functionWithName:@"linear"];
        anim.duration = 0.5;
        textureMask.position = CGPointMake(textureMask.position.x, textureMask.position.y - (textureMask.frame.size.height/3));
        [textureMask addAnimation:anim forKey:nil];
        
        tiltToPourLabel.hidden = YES;
    }
    
    if(sugar >= 4)
    {
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) stopSoundEffect:5];
        
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
        
        [self nextClick:nil];
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
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) stopSoundEffect:5];
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
    
    scroll.contentSize = CGSizeMake(scroll.frame.size.width, 1280);
    for(int i = 0; i < 16; i++)
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
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            [label setImage:[UIImage imageNamed:[NSString stringWithFormat:@"flavorSundae%d@2x.png", i+1]] forState:UIControlStateNormal];
        else
            [label setImage:[UIImage imageNamed:[NSString stringWithFormat:@"flavorSundae%d.png", i+1]] forState:UIControlStateNormal];
        
        if(i >= 5)
        {
            if([(AppDelegate*)[[UIApplication sharedApplication] delegate] icecreamSundaeLocked] == YES)
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
