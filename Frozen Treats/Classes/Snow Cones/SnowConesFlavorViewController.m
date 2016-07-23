//
//  SnowConesFlavorViewController.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/31/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "SnowConesFlavorViewController.h"
#import "SnowConesDecorateViewController.h"
#import "AppDelegate.h"
#import "WipeAwayView.h"

@implementation SnowConesFlavorViewController
@synthesize  cone, shape;

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"SnowConesFlavorViewController-5" bundle:[NSBundle mainBundle]];
    else
        self = [super init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    coneImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"snowcone%d.png", cone]];
    shapeImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"a%d.png", shape]];
    shapeImgView.frame = [self frameForShape];
    flavorImgView.frame = [self frameForShape];
    
    shapeImgView.userInteractionEnabled = YES;
    
    CGRect bounds = shapeImgView.bounds;
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = bounds;
    maskLayer.contents = (id)[[UIImage imageNamed:[NSString stringWithFormat:@"a%d.png", shape]] CGImage];
    shapeImgView.layer.mask = maskLayer;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadScroll) name:@"update" object:nil];
    
    tapDrawLabel.hidden = YES;
    bottleFlavor.hidden = YES;
    pouringFlavor.hidden = YES;
    chooseFlavorLabel.hidden = NO;
    flavorImgView.image = nil;
    
    [self undoClick:nil];
    
    bottle1.hidden = NO;
    bottle2.hidden = NO;
    bottle3.hidden = NO;
    bottle4.hidden = NO;
    bottle5.hidden = NO;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        chooseFlavorLabel.frame = CGRectMake(98, 266, 574, 81);
    else if([UIScreen mainScreen].bounds.size.height == 568)
        chooseFlavorLabel.frame = CGRectMake(20, 158, 287, 49);
    else
        chooseFlavorLabel.frame = CGRectMake(20, 126, 287, 48);
    
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear |UIViewAnimationOptionAutoreverse animations:^
     {
         CGRect frame = chooseFlavorLabel.frame;
         frame.origin.y += frame.size.height/8;
         chooseFlavorLabel.frame = frame;
     } completion:nil];
    
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        tapDrawLabel.frame = CGRectMake(44, 621, 680, 97);
    else if([UIScreen mainScreen].bounds.size.height == 568)
        tapDrawLabel.frame = CGRectMake(5, 88, 315, 46);
    else
        tapDrawLabel.frame = CGRectMake(5, 77, 315, 46);
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear |UIViewAnimationOptionAutoreverse animations:^
     {
         CGRect frame = tapDrawLabel.frame;
         frame.origin.y += frame.size.height/8;
         tapDrawLabel.frame = frame;
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
    
    if([(AppDelegate *)[[UIApplication sharedApplication] delegate] snowConesLocked] == YES)
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
    
    for(UIView *view in [drawingView subviews])
    {
        if(view.tag == 589)
            [view removeFromSuperview];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextClick:(id)sender
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:27];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    
    SnowConesDecorateViewController *snowConesFlavor = [[SnowConesDecorateViewController alloc] init];
    snowConesFlavor.flavor = flavor;
    snowConesFlavor.cone = cone;
    snowConesFlavor.shape = shape;
    
    
    
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(drawingView.frame.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(drawingView.frame.size);
    [drawingView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    
    UIImage *mask1 = [UIImage imageNamed:[NSString stringWithFormat:@"a%d.png", shape]];
    UIImage *mask = [self rotate:mask1 scaledToSize:shapeImgView.frame.size];
    
    UIGraphicsBeginImageContextWithOptions(drawingView.frame.size, NO, 0.0);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToMask(context, drawingView.frame, mask.CGImage);
    [img drawAtPoint:CGPointZero];

    UIImage *maskedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
    snowConesFlavor.awsomeImage = maskedImage;
    
    [self.navigationController pushViewController:snowConesFlavor animated:YES];
    [snowConesFlavor release];
}

- (IBAction)flavorSelected:(UIButton*)sender
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:12];

    flavor = sender.tag;
    [drawingView changeFlavor:flavor];
    
    chooseFlavorLabel.hidden = YES;
    tapDrawLabel.hidden = NO;

    bottleFlavor.image = [UIImage imageNamed:[NSString stringWithFormat:@"bottle_%d.png", flavor]];
    pouringFlavor.image = [UIImage imageNamed:[NSString stringWithFormat:@"pour_%d.png", flavor]];
    bottleFlavor.hidden = NO;
    
    flavorImgView.image = [self colorImageWithName:[NSString stringWithFormat:@"a%d.png", shape]];
}

- (IBAction)undoClick:(id)sender
{
    bottleFlavor.hidden = YES;
    pouringFlavor.hidden = YES;
    chooseFlavorLabel.hidden = NO;
    flavorImgView.image = nil;
    tapDrawLabel.hidden = YES;
    
    bottle1.hidden = NO;
    bottle2.hidden = NO;
    bottle3.hidden = NO;
    bottle4.hidden = NO;
    bottle5.hidden = NO;
    
    
    
    [drawingView removeFromSuperview];
    drawingView = nil;
    
    drawingView = [[DrawingView alloc] initWithFrame:CGRectMake(0, 0, shapeImgView.frame.size.width, shapeImgView.frame.size.height) andFlavor:flavor];
    drawingView.alpha = 0.5;
    drawingView.backgroundColor = [UIColor clearColor];
    drawingView.userInteractionEnabled = YES;
    [shapeImgView addSubview:drawingView];
    [drawingView release];
    
    [drawingView changeFlavor:0];
}

#pragma mark - Helpers

- (UIImage*)rotate:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, newSize.height);
    CGContextScaleCTM(context, 1, -1);
    
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (CGRect)frameForShape
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        switch(shape)
        {
            case 1:
                return CGRectMake(119, 333, 536, 294);
                break;
                
            case 2:
                return CGRectMake(88, 228, 592, 406);
                break;
                
            case 3:
                return CGRectMake(95, 184, 578, 446);
                break;
                
            case 4:
                return CGRectMake(106, 224, 478, 446);
                break;
                
            case 5:
                return CGRectMake(110, 207, 548, 446);
                break;
                
            case 6:
                return CGRectMake(116, 168, 536, 486);
                break;
                
            case 7:
                return CGRectMake(74, 222, 620, 404);
                break;
                
            case 8:
                return CGRectMake(147, 131, 474, 528);
                break;
                
            case 9:
                return CGRectMake(89, 219, 590, 410);
                break;
                
            case 10:
                return CGRectMake(89, 248, 590, 516);
                break;
                
            default:
                return CGRectMake(0, 0, 0, 0);
                break;
        }
    }
    else if([UIScreen mainScreen].bounds.size.height == 568)
    {
        switch(shape)
        {
            case 1:
                return CGRectMake(26, 195 + 70, 268, 147);
                break;
                
            case 2:
                return CGRectMake(12, 143 + 70, 296, 203);
                break;
                
            case 3:
                return CGRectMake(14, 115 + 70, 289, 223);
                break;
                
            case 4:
                return CGRectMake(26, 144 + 70, 239, 223);
                break;
                
            case 5:
                return CGRectMake(26, 136 + 70, 274, 223);
                break;
                
            case 6:
                return CGRectMake(26, 118 + 70, 268, 243);
                break;
                
            case 7:
                return CGRectMake(5, 144 + 70, 310, 202);
                break;
                
            case 8:
                return CGRectMake(33, 79 + 70, 254, 283);
                break;
                
            case 9:
                return CGRectMake(13, 137 + 70, 295, 205);
                break;
                
            case 10:
                return CGRectMake(13, 185 + 70, 295, 258);
                break;
                
            default:
                return CGRectMake(0, 0, 0, 0);
                break;
        }
    }
    else
    {
        switch(shape)
        {
            case 1:
                return CGRectMake(26, 195, 268, 147);
                break;
                
            case 2:
                return CGRectMake(12, 143, 296, 203);
                break;
                
            case 3:
                return CGRectMake(14, 115, 289, 223);
                break;
                
            case 4:
                return CGRectMake(26, 144, 239, 223);
                break;
                
            case 5:
                return CGRectMake(26, 136, 274, 223);
                break;
                
            case 6:
                return CGRectMake(26, 118, 268, 243);
                break;
                
            case 7:
                return CGRectMake(5, 144, 310, 202);
                break;
                
            case 8:
                return CGRectMake(33, 79, 254, 283);
                break;
                
            case 9:
                return CGRectMake(13, 137, 295, 205);
                break;
                
            case 10:
                return CGRectMake(13, 185, 295, 258);
                break;
                
            default:
                return CGRectMake(0, 0, 0, 0);
                break;
        }
    }
    return CGRectMake(0, 0, 0, 0);
}

#pragma mark - Color image

- (UIImage*)colorImageWithName:(NSString*)name
{
    UIColor *color;
    switch(flavor)
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
    CGContextDrawPath(context, kCGPathFill);
    
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
    
    NSString *title = @"Unlock Snow Cones?";
    UAExampleModalPanel *modalPanel = [[UAExampleModalPanel alloc] initWithFrame:self.view.bounds title:title andPurchaseTag:4 andCustom:YES] ;
    
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
    if([(AppDelegate *)[[UIApplication sharedApplication] delegate] snowConesLocked] == NO)
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
