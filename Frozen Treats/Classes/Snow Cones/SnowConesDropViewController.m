//
//  SnowConesDropViewController.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/30/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "SnowConesDropViewController.h"
#import "SnowConesShapeViewController.h"
#import "AppDelegate.h"

@implementation SnowConesDropViewController
@synthesize cone;

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"SnowConesDropViewController-5" bundle:[NSBundle mainBundle]];
    else
        self = [super init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    coneImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"snowcone%d.png", cone]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    scoopLabel.hidden = NO;
    nextButton.hidden = YES;
    scoopSpoon.alpha = 0.0;
    sugar = 0;
    textureMask = [CALayer layer];
    textureMask.frame = CGRectMake(0, texture.frame.size.height, texture.frame.size.width, texture.frame.size.height);
    textureMask.contents = (id)[[UIImage imageNamed:@"a1.png"] CGImage];
    texture.layer.mask = textureMask;
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        scoopLabel.frame = CGRectMake(143, 244, 480, 100);
    else if([UIScreen mainScreen].bounds.size.height == 568)
        scoopLabel.frame = CGRectMake(40, 116, 240, 46);
    else
        scoopLabel.frame = CGRectMake(40, 113, 240, 46);
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear |UIViewAnimationOptionAutoreverse animations:^
     {
         CGRect frame = scoopLabel.frame;
         frame.origin.y += frame.size.height/8;
         scoopLabel.frame = frame;
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextClick:(id)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:27];
    
    SnowConesShapeViewController *snowConesShape = [[SnowConesShapeViewController alloc] init];
    snowConesShape.cone = cone;
    [self.navigationController pushViewController:snowConesShape animated:YES];
    [snowConesShape release];
}

#pragma mark - Touches

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    UITouch *touch = [touches anyObject];
    
    if([touch view] == scoopView)
    {
        scoopView.center = touchPoint;
        
        if([self checkIfOverBowl:touchPoint] == YES)
        {
            if(scoopSpoon.alpha == 0.0 && sugar < 6)
            {
                scoopSpoon.alpha = 1.0;
                [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:25];
            }
        }
        
        if([self checkIFOverSheet:touchPoint] == YES)
        {
            if(sugar < 6 && scoopSpoon.alpha == 1.0)
            {
                [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:23];
                
                CABasicAnimation *anim = [[CABasicAnimation alloc] init];
                anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(textureMask.position.x, textureMask.position.y)];
                anim.keyPath = @"position";
                anim.timingFunction = [CAMediaTimingFunction functionWithName:@"linear"];
                anim.duration = 0.5;
                textureMask.position = CGPointMake(textureMask.position.x, textureMask.position.y - (textureMask.frame.size.height/7));
                [textureMask addAnimation:anim forKey:nil];
                
                sugar++;
                scoopSpoon.alpha = 0.0;
                
                if(sugar == 6)
                {
                    nextButton.hidden = NO;
                    scoopLabel.hidden = YES;
                }
            }
        }
    }
}

- (BOOL)checkIfOverBowl:(CGPoint)touchPoint
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if(touchPoint.x > 175 && touchPoint.x < 594)
        {
            if(touchPoint.y > 231 && touchPoint.y < 398)
                return YES;
        }
    }
    else if([UIScreen mainScreen].bounds.size.height == 568)
    {
        if(touchPoint.x > 77 && touchPoint.x < 257)
        {
            if(touchPoint.y > 112 && touchPoint.y < 200)
                return YES;
        }
    }
    else
    {
        if(touchPoint.x > 77 && touchPoint.x < 257)
        {
            if(touchPoint.y > 112 && touchPoint.y < 200)
                return YES;
        }
    }
    
    return NO;
}

- (BOOL)checkIFOverSheet:(CGPoint)touchPoint
{
    if(touchPoint.x > coneImgView.frame.origin.x && touchPoint.x < coneImgView.frame.origin.x + coneImgView.frame.size.width)
    {
        if(touchPoint.y > coneImgView.frame.origin.y && touchPoint.y < coneImgView.frame.origin.y + coneImgView.frame.size.height)
            return YES;
    }
    
    return NO;
}

@end
