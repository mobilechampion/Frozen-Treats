//
//  IcecreamConeFillConeViewController.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/14/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "IcecreamConeFillConeViewController.h"
#import "IcecreamConeChooseDipViewController.h"
#import "AppDelegate.h"

@implementation IcecreamConeFillConeViewController
@synthesize flavor1, flavor2;

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"IcecreamConeFillConeViewController-5" bundle:[NSBundle mainBundle]];
    else
        self = [super init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        scroll.contentSize = CGSizeMake(106 * 20 + 10 * 21, scroll.frame.size.height);
    else
        scroll.contentSize = CGSizeMake(53 * 20 + 10 * 21, scroll.frame.size.height);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadScroll];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadScroll) name:@"update" object:nil];
    
    flavorImgView1.image = [self colorFirstImageWithName:@"flavor_mask.png"];
    flavorImgView2.image = [self colorImageWithName:@"flavor_mask.png"];
    
    icecream1.image = [UIImage imageNamed:[NSString stringWithFormat:@"icecream%d_1.png", flavor1]];
    icecream2.image = [UIImage imageNamed:[NSString stringWithFormat:@"icecream%d_2.png", flavor2]];
    icecream3.image = [UIImage imageNamed:[NSString stringWithFormat:@"icecream%d_3.png", flavor1]];
    icecream4.image = [UIImage imageNamed:[NSString stringWithFormat:@"icecream%d_4.png", flavor2]];
    
    icecream1.alpha = 0.0;
    icecream2.alpha = 0.0;
    icecream3.alpha = 0.0;
    icecream4.alpha = 0.0;
    
    
    NSArray *array = [[NSArray alloc] initWithObjects:[UIImage imageNamed:[NSString stringWithFormat:@"cream1-%d.png", flavor1]],
                      [UIImage imageNamed:[NSString stringWithFormat:@"cream2-%d.png", flavor1]],
                      [UIImage imageNamed:[NSString stringWithFormat:@"cream3-%d.png", flavor1]], nil];
    
    [pouringIcecream1 setAnimationImages:array];
    [pouringIcecream1 setAnimationDuration:0.5];
    [pouringIcecream1 setAnimationRepeatCount:-1];
    [pouringIcecream1 startAnimating];

    NSArray *array2 = [[NSArray alloc] initWithObjects:[UIImage imageNamed:[NSString stringWithFormat:@"cream1-%d.png", flavor2]],
                      [UIImage imageNamed:[NSString stringWithFormat:@"cream2-%d.png", flavor2]],
                      [UIImage imageNamed:[NSString stringWithFormat:@"cream3-%d.png", flavor2]], nil];
    
    [pouringIcecream2 setAnimationImages:array2];
    [pouringIcecream2 setAnimationDuration:0.5];
    [pouringIcecream2 setAnimationRepeatCount:-1];
    [pouringIcecream2 startAnimating];
    
    
    pouringIcecream1.hidden = YES;
    pouringIcecream2.hidden = YES;

    nextButton.hidden = YES;
    pullLeverLabel.hidden = YES;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        maxHandle = 126;
        minHandle = 94;
    }
    else
    {
        maxHandle = 264;
        minHandle = 200;
    }
    
    handleImgView.frame = CGRectMake(handleImgView.frame.origin.x, minHandle, handleImgView.frame.size.width, handleImgView.frame.size.height);
    
    scroll.contentOffset = CGPointMake(0.0, 0.0);
    scroll.hidden = NO;
    coneImgView.hidden = YES;
    pickConeLabel.hidden = NO;
    pullLeverLabel.hidden = YES;
    cone = 0;
    
    if([UIScreen mainScreen].bounds.size.height == 480)
    {
        machineView.frame = CGRectMake(machineView.frame.origin.x, 95, machineView.frame.size.width, machineView.frame.size.height);
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        pickConeLabel.frame = CGRectMake(98, 266, 574, 81);
        pullLeverLabel.frame = CGRectMake(40, 64, 508, 170);
    }
    else if([UIScreen mainScreen].bounds.size.height == 568)
    {
        pickConeLabel.frame = CGRectMake(20, 158, 287, 49);
        pullLeverLabel.frame = CGRectMake(20, 46 - 10, 254, 85);
    }
    else
    {
        pickConeLabel.frame = CGRectMake(20, 126, 287, 49);
        pullLeverLabel.frame = CGRectMake(20, 46 - 10, 254, 85);
    }
    
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear |UIViewAnimationOptionAutoreverse animations:^
     {
         CGRect frame = pickConeLabel.frame;
         frame.origin.y += frame.size.height/8;
         pickConeLabel.frame = frame;
         
         frame = pullLeverLabel.frame;
         frame.origin.y += frame.size.height/8;
         pullLeverLabel.frame = frame;
         
     } completion:nil];
    
    CGRect scFrame = scroll.frame;
    scFrame.origin.x += [UIScreen mainScreen].bounds.size.width;
    scroll.frame = scFrame;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:30];
    [UIView animateWithDuration:1.0 animations:^{
        CGRect scFrame = scroll.frame;
        scFrame.origin.x = 0;
        scroll.frame = scFrame;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -

- (void)coneSelected:(UIButton*)sender
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:12];
    
    cone = sender.tag;
    coneImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"c%d.png", cone]];
    coneImgView.alpha = 0.0;
    coneImgView.hidden = NO;
    
    pullLeverLabel.alpha = 0.0;
    pullLeverLabel.hidden = NO;
    
    [UIView animateWithDuration:0.8 animations:^{
        scroll.alpha = 0.0;
        coneImgView.alpha = 1.0;
        pickConeLabel.alpha = 0.0;
        pullLeverLabel.alpha = 1.0;
        
        if([UIScreen mainScreen].bounds.size.height == 480)
            machineView.frame = CGRectMake(machineView.frame.origin.x, machineView.frame.origin.y - 53, machineView.frame.size.width, machineView.frame.size.height);
    } completion:^(BOOL finished) {
        scroll.alpha = 1.0;
        scroll.hidden = YES;
        
        pickConeLabel.alpha = 1.0;
        pickConeLabel.hidden = YES;
    }];
}

- (IBAction)backClick:(id)sender
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:27];
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) stopSoundEffect:30];
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) stopSoundEffect:9];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextClick:(id)sender
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:27];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    IcecreamConeChooseDipViewController *icecreamDip = [[IcecreamConeChooseDipViewController alloc] init];
    icecreamDip.flavor1 = flavor1;
    icecreamDip.flavor2 = flavor2;
    icecreamDip.cone = cone;
    [self.navigationController pushViewController:icecreamDip animated:YES];
    [icecreamDip release];
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if(cone != 0)
    {
        UITouch *touch = [touches anyObject];
        if([touch view] == handleImgView)
        {
            touchingHandle = YES;
            [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:10];
        }
        else
            touchingHandle = NO;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:machineView];
    if(touchingHandle == YES)
    {
        if(touchPoint.y - handleImgView.frame.size.height/2 >= minHandle && touchPoint.y - handleImgView.frame.size.height/2 <= maxHandle)
        {
            handleImgView.frame = CGRectMake(handleImgView.frame.origin.x, touchPoint.y - handleImgView.frame.size.height/2, handleImgView.frame.size.width, handleImgView.frame.size.height);
        }
        else if(touchPoint.y - handleImgView.frame.size.height/2 < minHandle)
        {
            handleImgView.frame = CGRectMake(handleImgView.frame.origin.x, minHandle, handleImgView.frame.size.width, handleImgView.frame.size.height);
        }
        else if(touchPoint.y - handleImgView.frame.size.height/2 > maxHandle)
        {
            handleImgView.frame = CGRectMake(handleImgView.frame.origin.x, maxHandle, handleImgView.frame.size.width, handleImgView.frame.size.height);
        }
        
        pouringIcecream1.hidden = NO;
        pouringIcecream2.hidden = NO;
        [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:9];
        
        if(touchPoint.y > minHandle + 10)
        {
            if(icecream4.alpha < 1.0)
            {
                if(![icecreamPourTimer isValid])
                    icecreamPourTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(icecreamAppearing) userInfo:nil repeats:YES];
                //[self icecreamAppearing];
            }
            else
            {
                pouringIcecream1.hidden = YES;
                pouringIcecream2.hidden = YES;
                [((AppDelegate*)[[UIApplication sharedApplication] delegate]) stopSoundEffect:9];

                if([icecreamPourTimer isValid])
                    [icecreamPourTimer invalidate], icecreamPourTimer = nil;
                
                pullLeverLabel.hidden = YES;
                nextButton.hidden = NO;
            }
        }
        else
        {
            pouringIcecream1.hidden = YES;
            pouringIcecream2.hidden = YES;
            [((AppDelegate*)[[UIApplication sharedApplication] delegate]) stopSoundEffect:9];

            if([icecreamPourTimer isValid])
                [icecreamPourTimer invalidate], icecreamPourTimer = nil;
        }
    }
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    touchingHandle = NO;
    //[pourWater setIsEmitting:NO];
    
    pouringIcecream1.hidden = YES;
    pouringIcecream2.hidden = YES;
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) stopSoundEffect:9];

    if([icecreamPourTimer isValid])
        [icecreamPourTimer invalidate], icecreamPourTimer = nil;
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^
     {
         handleImgView.frame = CGRectMake(handleImgView.frame.origin.x, minHandle, handleImgView.frame.size.width, handleImgView.frame.size.height);
     } completion:nil];
    
}

- (void)icecreamAppearing
{
    if(icecream1.alpha < 1.0)
        icecream1.alpha += 0.05;
    else if(icecream2.alpha < 1.0)
        icecream2.alpha += 0.05;
    else if(icecream3.alpha < 1.0)
        icecream3.alpha += 0.05;
    else if(icecream4.alpha < 1.0)
        icecream4.alpha += 0.1;
    
    if(icecream4.alpha >= 1.0)
    {
        pouringIcecream1.hidden = YES;
        pouringIcecream2.hidden = YES;
        [((AppDelegate*)[[UIApplication sharedApplication] delegate]) stopSoundEffect:9];
        
        if([icecreamPourTimer isValid])
            [icecreamPourTimer invalidate], icecreamPourTimer = nil;
        
        pullLeverLabel.hidden = YES;
        nextButton.hidden = NO;
    }
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
            color = [UIColor colorWithRed:255.0/255.0 green:34.0/255.0 blue:89.0/255.0 alpha:0.8];
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
    for(UIView *view in [scroll subviews])
        [view removeFromSuperview];
    
    for(int i = 1; i <= 20; i++)
    {
        UIButton *conex = [[UIButton alloc] initWithFrame:CGRectMake(53 * (i - 1) + i * 10, 4, 53, 70)];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            conex.frame = CGRectMake(106 * (i - 1) + i * 10, 4, 106, 140);
        
        [conex setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"c%d.png", i]] forState:UIControlStateNormal];
        
        if(i > 5 && [(AppDelegate *)[[UIApplication sharedApplication] delegate] icecreamConesLocked] == YES)
        {
            UIImageView *locked = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 25)];
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                locked.frame = CGRectMake(10, 10, 40, 50);
            
            locked.image = [UIImage imageNamed:@"lockSmall.png"];
            [conex addSubview:locked];
            [locked release];
            
            conex.tag = 0;
            [conex addTarget:self action:@selector(chooseLockedFlavor) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [conex addTarget:self action:@selector(coneSelected:) forControlEvents:UIControlEventTouchUpInside];
            conex.tag = i;
        }
        
        [scroll addSubview:conex];
        [conex release];
    }
}

@end
