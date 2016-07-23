//
//  BubblesGlassEffect.m
//  Make Drinks
//
//  Created by Alexandra Smau on 2/21/13.
//  Copyright (c) 2013 Free Maker Games, LCC. All rights reserved.
//

#import "BubblesGlassEffect.h"
#import <QuartzCore/QuartzCore.h>

@implementation BubblesGlassEffect
{
    CAEmitterLayer *smokeEmitter;
    //CAEmitterLayer *bubblesEmitter;
}

- (void)awakeFromNib
{
    smokeEmitter = (CAEmitterLayer*)self.layer;
    smokeEmitter.scale = 1.0;
    smokeEmitter.emitterShape = kCAEmitterLayerLine;
    
    
    
    CAEmitterCell *smokeCell = [CAEmitterCell emitterCell];
    smokeCell.contents = (id)[[UIImage imageNamed:@"piece_ice.png"] CGImage];
    [smokeCell setName:@"smokeCell"];
    smokeCell.birthRate = 0;
    smokeCell.lifetime = 2.2;
    smokeCell.lifetimeRange = 0.4;
    smokeCell.velocity = 60;
    smokeCell.velocityRange = 10;
    //smokeCell.yAcceleration = - 10;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        smokeCell.velocity = 150;
    }
    
    smokeCell.emissionLongitude = - M_PI_2 - M_PI_4 - 0.2;
    
    
    smokeCell.emissionRange = M_PI / 3; // 90 degree cone for variety
    smokeCell.scale = 1.5;
    smokeCell.scaleSpeed = 0.1;
    smokeCell.scaleRange = 0.05;
    
    smokeCell.spin = 1;
    smokeCell.spinRange = 6;
    //smokeCell.color = [[UIColor colorWithRed:90.0/255.0 green:0.0 blue:0.0 alpha:0.1] CGColor];
    
    
    smokeEmitter.emitterCells = [NSArray arrayWithObject:smokeCell];
    smokeEmitter.emitterPosition = CGPointMake(128, 110);
    smokeEmitter.emitterSize = CGSizeMake(20, 150);
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        smokeEmitter.scale = 1.5;
        smokeEmitter.emitterPosition = CGPointMake(230, 235);
        smokeEmitter.emitterSize = CGSizeMake(50, 550);
    }
    else if([UIScreen mainScreen].bounds.size.height == 568)
    {
        smokeEmitter.emitterPosition = CGPointMake(128 + 20, 110 + 80);
        smokeEmitter.emitterSize = CGSizeMake(20, 150);
    }
}

+ (Class)layerClass
{
    return [CAEmitterLayer class];
}

- (void)setIsEmitting:(BOOL)isEmitting
{
    if(isEmitting == YES)
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            [smokeEmitter setValue:[NSNumber numberWithInt:30] forKeyPath:@"emitterCells.smokeCell.birthRate"];
        else
            [smokeEmitter setValue:[NSNumber numberWithInt:20] forKeyPath:@"emitterCells.smokeCell.birthRate"];
    }
    else
        [smokeEmitter setValue:[NSNumber numberWithInt:0] forKeyPath:@"emitterCells.smokeCell.birthRate"];
}

- (void)setIsEmitingMiddle
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [smokeEmitter setValue:[NSNumber numberWithInt:60] forKeyPath:@"emitterCells.smokeCell.birthRate"];
    else
        [smokeEmitter setValue:[NSNumber numberWithInt:50] forKeyPath:@"emitterCells.smokeCell.birthRate"];
}

- (void)setIsEmittingLast
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [smokeEmitter setValue:[NSNumber numberWithInt:80] forKeyPath:@"emitterCells.smokeCell.birthRate"];
    else
        [smokeEmitter setValue:[NSNumber numberWithInt:80] forKeyPath:@"emitterCells.smokeCell.birthRate"];
}


//- (void)awakeFromNib
//{
//    bubblesEmitter = (CAEmitterLayer*)self.layer;
//    bubblesEmitter.emitterShape = kCAEmitterLayerLine;
//    bubblesEmitter.scale = 1.0;
//    bubblesEmitter.emitterMode = kCAEmitterLayerOutline;
//  
//    CAEmitterCell *bubble = [CAEmitterCell emitterCell];
//    bubble.birthRate = 0;
//    bubble.lifetime = 3.0;
//    bubble.contents = (id)[[UIImage imageNamed:@"bubbleBig@2x.png"] CGImage];
//    [bubble setName:@"bubble"];
//    bubble.velocity = 20;
//    bubble.velocityRange = 20;
//    bubble.emissionLongitude = M_PI;
//    bubble.yAcceleration = -30;
//    bubble.scale = 0.4; 
//    
//    bubblesEmitter.renderMode = kCAEmitterLayerAdditive;
//    bubblesEmitter.emitterPosition = CGPointMake(45, 300);
//    bubblesEmitter.emitterSize = CGSizeMake(90, 300);
//    
//    
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        bubblesEmitter.scale = 1.3;
//        bubble.lifetime = 10.0;
//        
//        bubblesEmitter.emitterPosition = CGPointMake(84, 514);
//        bubblesEmitter.emitterSize = CGSizeMake(196, 514);
//    }
//    
//    bubblesEmitter.emitterCells = [NSArray arrayWithObject:bubble];
//    
//    
////    upperBubbles = [CAEmitterLayer layer];
////    upperBubbles.emitterShape = kCAEmitterLayerLine;
////    upperBubbles.scale = 0.6;
////    
////    CAEmitterCell *bubble2 = [CAEmitterCell emitterCell];
////    bubble2.birthRate = 0;//27
////    bubble2.lifetime = 0.4;
////    bubble2.contents = (id)[[UIImage imageNamed:@"bubbleBig@2x.png"] CGImage];
////    [bubble2 setName:@"bubblex"];
////    bubble2.velocity = 5;
////    bubble2.velocityRange = 0;
////    bubble2.yAcceleration = 0;
////    
////    upperBubbles.renderMode = kCAEmitterLayerAdditive;
////    upperBubbles.emitterCells = [NSArray arrayWithObject:bubble2];
////    upperBubbles.emitterPosition = CGPointMake(45, 10);
////    upperBubbles.emitterSize = CGSizeMake(120, 266);
////    
////    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
////    {
////        upperBubbles.scale = 0.85;
////        if(fromFinal == NO)
////            upperBubbles.emitterPosition = CGPointMake(84, 13);
////        else
////            upperBubbles.emitterPosition = CGPointMake(84, -5);
////        upperBubbles.emitterSize = CGSizeMake(200, 514);
////    }
////
////    [bubblesEmitter addSublayer:upperBubbles];
//}
//
//+ (Class)layerClass
//{
//    return [CAEmitterLayer class];
//}
//
//- (void)setIsEmitting:(BOOL)isEmitting
//{
//    if(isEmitting == YES)
//    {
//        [bubblesEmitter setValue:[NSNumber numberWithInt:110] forKeyPath:@"emitterCells.bubble.birthRate"];
//        //[self performSelector:@selector(startUpper) withObject:nil afterDelay:2.5];
//    }
//    else
//    {
//        [bubblesEmitter setValue:[NSNumber numberWithInt:0] forKeyPath:@"emitterCells.bubble.birthRate"];
//       // [upperBubbles setValue:[NSNumber numberWithInt:0] forKeyPath:@"emitterCells.bubblex.birthRate"];
//    }
//}
//
//- (void)changeLifetimeForHeight:(float)height
//{
//     if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//     {
//         if(previousLifetime <= 0.96)
//         {
//             previousLifetime = 0;
//             [bubblesEmitter setValue:[NSNumber numberWithInt:0] forKeyPath:@"emitterCells.bubble.birthRate"];
//             [upperBubbles setValue:[NSNumber numberWithInt:0] forKeyPath:@"emitterCells.bubblex.birthRate"];
//             return;
//         }
//         
//         if(fromFinal == NO)
//             upperBubbles.emitterPosition = CGPointMake(84, height * 55.1 + 13);
//         else
//             upperBubbles.emitterPosition = CGPointMake(84, height * 55.1 - 5);
//         
//         previousLifetime = previousLifetime - 0.21;
//         if(previousLifetime < 1.4)
//             previousLifetime = previousLifetime - 0.4;
//     }
//    else
//    {
//        if(previousLifetime < 0.5)
//        {
//            previousLifetime = 0;
//            [bubblesEmitter setValue:[NSNumber numberWithInt:0] forKeyPath:@"emitterCells.bubble.birthRate"];
//            [upperBubbles setValue:[NSNumber numberWithInt:0] forKeyPath:@"emitterCells.bubblex.birthRate"];
//            return;
//        }
//        
//        upperBubbles.emitterPosition = CGPointMake(45, height * 27.7 + 10);
//        
//        previousLifetime = previousLifetime - 0.15;
//        if(previousLifetime < 1.0)
//            previousLifetime = previousLifetime - 0.2;
//    }
//    
//    [bubblesEmitter setValue:[NSNumber numberWithFloat:previousLifetime] forKeyPath:@"emitterCells.bubble.lifetime"];
//}
//
//- (void)startUpper
//{
//    [upperBubbles setValue:[NSNumber numberWithInt:27] forKeyPath:@"emitterCells.bubblex.birthRate"];
//}
//
//- (void)setColor:(int)flavor
//{
//    UIColor *color;
//    switch(flavor)
//    {
//        case 1:
//            color = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:75.0/255.0 alpha:1];
//            break;
//            
//        case 2:
//            color = [UIColor colorWithRed:242.0/255.0 green:222.0/255.0 blue:46.0/255.0 alpha:1];
//            break;
//            
//        case 3:
//            color = [UIColor colorWithRed:242.0/255.0 green:46.0/255.0 blue:124.0/255.0 alpha:1];
//            break;
//            
//        case 4:
//            color = [UIColor colorWithRed:148.0/255.0 green:17.0/255.0 blue:17.0/255.0 alpha:1];
//            break;
//            
//        case 5:
//            color = [UIColor colorWithRed:56.0/255.0 green:220.0/255.0 blue:73.0/255.0 alpha:1];
//            break;
//            
//        case 6:
//            color = [UIColor colorWithRed:104.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1];
//            break;
//            
//        case 7:
//            color = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:75.0/255.0 alpha:1];
//            break;
//            
//        case 8:
//            color = [UIColor colorWithRed:154.0/255.0 green:192.0/255.0 blue:112.0/255.0 alpha:1];
//            break;
//            
//        case 9:
//            color = [UIColor colorWithRed:220.0/255.0 green:62.0/255.0 blue:62.0/255.0 alpha:1];
//            break;
//            
//        case 10:
//            color = [UIColor colorWithRed:243.0/255.0 green:212.0/255.0 blue:86.0/255.0 alpha:1];
//            break;
//            
//        case 11:
//            color = [UIColor colorWithRed:56.0/255.0 green:220.0/255.0 blue:73.0/255.0 alpha:1];
//            break;
//            
//        case 12:
//            color = [UIColor colorWithRed:226.0/255.0 green:79.0/255.0 blue:25.0/255.0 alpha:1];
//            break;
//            
//        case 13:
//            color = [UIColor colorWithRed:183.0/255.0 green:46.0/255.0 blue:210.0/255.0 alpha:1];
//            break;
//            
//        case 14:
//            color = [UIColor colorWithRed:247.0/255.0 green:125.0/255.0 blue:73.0/255.0 alpha:1];
//            break;
//            
//        case 15:
//            color = [UIColor colorWithRed:239.0/255.0 green:191.0/255.0 blue:0.0 alpha:1];
//            break;
//            
//        default:
//            break;
//    }
//
//    
//    CAEmitterCell *fire = [CAEmitterCell emitterCell];
//	[fire setName:@"bubble"];
//	fire.birthRate			= 110;
//	fire.emissionLongitude  = M_PI;
//	fire.velocity			= -10;
//	fire.velocityRange		= 10;
//	fire.emissionRange		= 1.1;
//	fire.yAcceleration		= -100;
//	fire.scaleSpeed			= 0.1;
//    previousLifetime        = 2.15;
//	fire.lifetime			= 2.15;
////    previousLifetime        = 2;
////	fire.lifetime			= 2;
//	fire.color = [color CGColor];
//	fire.contents = (id)[[UIImage imageNamed:@"bubbleBig@2x.png"] CGImage];
//    
//    
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        fire.lifetime = 3.05;
//        previousLifetime = 3.05;
//        fire.emissionRange = 1.5;
//    }
//
//    bubblesEmitter.emitterCells = [NSArray arrayWithObject:fire];
//    
//    
//    CAEmitterCell *bubble2 = [CAEmitterCell emitterCell];
//    bubble2.birthRate = 0;
//    bubble2.lifetime = 0.4;
//    bubble2.contents = (id)[[UIImage imageNamed:@"bubbleBig@2x.png"] CGImage];
//    [bubble2 setName:@"bubblex"];
//    bubble2.velocity = 5;
//    bubble2.color = [color CGColor];
//    bubble2.velocityRange = 0;
//    bubble2.yAcceleration = 0;
//
//    upperBubbles.emitterCells = [NSArray arrayWithObject:bubble2];
//}
//
//- (void)reset
//{
//    [bubblesEmitter setValue:[NSNumber numberWithInt:110] forKeyPath:@"emitterCells.bubble.birthRate"];
//    [upperBubbles setValue:[NSNumber numberWithInt:0] forKeyPath:@"emitterCells.bubblex.birthRate"];
//    [self performSelector:@selector(startUpper) withObject:nil afterDelay:2.5];
//    previousLifetime = 2.15;
//    upperBubbles.emitterPosition = CGPointMake(45, 10);
//    [bubblesEmitter setValue:[NSNumber numberWithFloat:2.15] forKeyPath:@"emitterCells.bubble.lifetime"];
//    
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        previousLifetime = 3.05;
//        if(fromFinal == NO)
//            upperBubbles.emitterPosition = CGPointMake(84, 13);
//        else
//            upperBubbles.emitterPosition = CGPointMake(84, -5);
//        [bubblesEmitter setValue:[NSNumber numberWithFloat:3.05] forKeyPath:@"emitterCells.bubble.lifetime"];
//    }
//}
//
//- (void)setFromFinal:(BOOL)boolValue
//{
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        fromFinal = boolValue;
//        if(fromFinal == YES)
//            upperBubbles.emitterPosition = CGPointMake(84, -5);
//    }
//}

@end
