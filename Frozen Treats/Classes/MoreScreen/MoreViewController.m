//
//  MoreViewController.m
//  Pets
//
//  Created by Ana-Maria Stoica on 4/1/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "MoreViewController.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "XmlParser.h"
#import "FreeAppOfTheDAy.h"
#import <QuartzCore/QuartzCore.h>
#import "Defines.h"

@implementation MoreViewController

@synthesize arrayOfStrings;
@synthesize stars;
@synthesize button;
@synthesize theItems;
@synthesize collect;
@synthesize activity;
@synthesize freeAppOftheDay;
@synthesize ray;
@synthesize free;


#pragma mark -

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"MoreViewController-5" bundle:[NSBundle mainBundle]];
    else
        self = [super init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    internetReachableFoo = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [internetReachableFoo currentReachabilityStatus];
    
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            UIAlertView * noInt = [[UIAlertView alloc]initWithTitle:@"Ouups!" message:@"You don't have a internet connection! Please come back later." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [noInt show];
            [noInt release];;
            // self.internetActive = NO;
            
            break;
        }
        case ReachableViaWiFi:
        {
            [self performSelector:@selector(startDownloading) withObject:nil afterDelay:0.5];
            NSLog(@"The internet is working via WIFI.");
            //  self.internetActive = YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            //   self.internetActive = YES;
            
            break;
        }
    }

    

    [super viewWillAppear:animated];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)startDownloading
{
    
    for (UIView * view in [scroll subviews]) {
        if (view == stars || view == button ||view == collect||view == freeAppOftheDay||view == ray) {
            
        }
        else [view removeFromSuperview];
    }
    NSString * urlString = [[NSString alloc]initWithContentsOfURL:[NSURL URLWithString:MOREGAMES_LINK] encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"result : %@",urlString);
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc]initWithContentsOfURL:[NSURL URLWithString:MOREGAMES_LINK]];
    XmlParser *parser = [[XmlParser alloc] init];
    [xmlParser setDelegate:parser];
    
        BOOL success = [xmlParser parse];
 if (success) {
     theItems = nil;
     theItems = parser.items;
     
     if (parser.free) {
         
          free = (FreeAppOfTheDAy *)parser.free;
         
         CGPoint center = self.freeAppOftheDay.center;
         CGPoint center2 = self.collect.center;
         CABasicAnimation *rotation;
         rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
         rotation.fromValue = [NSNumber numberWithFloat:0];
         rotation.toValue = [NSNumber numberWithFloat:(2*M_PI)];
         rotation.duration = 0.5; // Speed
         rotation.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
         [ray.layer addAnimation:rotation forKey:@"Spin"];
         [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear |UIViewAnimationOptionAutoreverse | UIViewAnimationOptionAllowUserInteraction animations:^
          {
              CGRect frame = self.freeAppOftheDay.frame;
              frame.origin.y += frame.size.height/8;
              frame.size.width += frame.size.width/8;
              self.freeAppOftheDay.frame = frame;
              self.freeAppOftheDay.center = CGPointMake(self.freeAppOftheDay.center.x  , center.y);
                                
              
              CGRect frame2 = self.collect.frame;
              frame2.origin.y += frame2.size.height/8;
              frame2.size.width += frame2.size.width/8;
              self.collect.frame = frame2;
              self.collect.center = CGPointMake(self.collect.center.x  , center2.y);
              
              
              
          } completion:nil];
         
         UIButton * starButton = [[UIButton alloc]init];
         [starButton setImage:[UIImage imageNamed:@"blankStarB"] forState:UIControlStateNormal];
         [starButton setImage:[UIImage imageNamed:@"blankStarY"] forState:UIControlStateSelected];
         starButton.tag = -1;
         UIButton *thebutton = [[UIButton alloc]init];
         
         UILabel *label = [[UILabel alloc]init];
         label.backgroundColor =  [UIColor clearColor];
         label.textColor = [UIColor whiteColor];
         label.text = free.appName;
         label.adjustsFontSizeToFitWidth = YES;
         label.numberOfLines = 2;
         label.font = [UIFont boldSystemFontOfSize:14.0f];
         label.minimumScaleFactor = 0.4;
         label.textAlignment = NSTextAlignmentCenter;
         thebutton.tag = -1;
         NSURL* aURL = [NSURL URLWithString:[free.picUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
         NSData* data = [[NSData alloc] initWithContentsOfURL:aURL];
         UIImage * image ;
         if (data) {
             image = [UIImage imageWithData:data];
         }
         else
         {
             image = [UIImage imageNamed:@"Icon.png"];
         }
         [starButton addTarget:self action:@selector(getApp:) forControlEvents:UIControlEventTouchUpInside];
         [thebutton addTarget:self action:@selector(getApp:) forControlEvents:UIControlEventTouchUpInside];
         [thebutton setBackgroundImage:image forState:UIControlStateNormal];
         
         
         if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
         {
             thebutton.frame = CGRectMake(50,  freeAppOftheDay.frame.origin.y + freeAppOftheDay.frame.size.height +40, 84, 84);
             thebutton.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, thebutton.center.y);
             starButton.frame = CGRectMake(thebutton.center.x -29, thebutton.frame.origin.y - 50, 58, 58);
             label.frame = CGRectMake(thebutton.frame.origin.x, thebutton.frame.origin.y + thebutton.frame.size.height +1,  thebutton.frame.size.width, 50);
         }
         else
         {
             thebutton.frame = CGRectMake(446 - 150, freeAppOftheDay.frame.origin.y + freeAppOftheDay.frame.size.height +40+128 - 100, 198, 198);
             starButton.frame = CGRectMake(505 - 150, thebutton.frame.origin.y - 85, 80, 80);
             label.frame = CGRectMake(thebutton.frame.origin.x, thebutton.frame.origin.y + thebutton.frame.size.height +5,  thebutton.frame.size.width, 50);
         }
         
         [scroll addSubview:thebutton];
         [scroll addSubview:starButton];
         [scroll addSubview:label];
         
         
         if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"fb%@:",free.facebookId]]]) {
             starButton.selected = YES;
         }
         
         
         
         
     }
     
      int scrollSize = 0;
     for (int i =0; i<[theItems count]; i ++) {
         
         MoreItem * new = (MoreItem *)[theItems objectAtIndex:i];
         NSLog(@"the name: %@",new.appName);
         //here load the screen!
         
         UIButton * starButton = [[UIButton alloc]init];
         [starButton setImage:[UIImage imageNamed:@"blankStarB"] forState:UIControlStateNormal];
         [starButton setImage:[UIImage imageNamed:@"blankStarY"] forState:UIControlStateSelected];
         starButton.tag = i;
         UIButton * thebutton = [[UIButton alloc]init];
         UILabel * label = [[UILabel alloc]init];
         label.backgroundColor =  [UIColor clearColor];
         label.textColor = [UIColor whiteColor];
         label.text = new.appName;
         label.adjustsFontSizeToFitWidth = YES;
         label.numberOfLines = 2;
         label.font = [UIFont boldSystemFontOfSize:14.0f];
        label.minimumScaleFactor = 0.4;
         label.textAlignment = NSTextAlignmentCenter;
         thebutton.tag = i;
         NSURL* aURL = [NSURL URLWithString:[new.picUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
         NSData* data = [[NSData alloc] initWithContentsOfURL:aURL];
         UIImage * image ;
         if (data) {
             image = [UIImage imageWithData:data];
         }
         else
         {
             image = [UIImage imageNamed:@"Icon.png"];
         }
         [starButton addTarget:self action:@selector(getApp:) forControlEvents:UIControlEventTouchUpInside];
         [thebutton addTarget:self action:@selector(getApp:) forControlEvents:UIControlEventTouchUpInside];
         [thebutton setBackgroundImage:image forState:UIControlStateNormal];
         if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
             if(i%2 == 0)
             {
                 thebutton.frame = CGRectMake(50, (i/2)*200 + collect.frame.origin.y + collect.frame.size.height +40, 84, 84);
                 starButton.frame = CGRectMake(63, thebutton.frame.origin.y - 50, 58, 58);
                 label.frame = CGRectMake(thebutton.frame.origin.x, thebutton.frame.origin.y + thebutton.frame.size.height +1,  thebutton.frame.size.width, 50);
               
             }
             else
             {
                
                  thebutton.frame = CGRectMake(184, (i/2)*200 + collect.frame.origin.y + collect.frame.size.height +40, 84, 84);
                 starButton.frame = CGRectMake(197, thebutton.frame.origin.y - 50, 58, 58);
                  label.frame = CGRectMake(thebutton.frame.origin.x, thebutton.frame.origin.y + thebutton.frame.size.height +1,  thebutton.frame.size.width, 50);
             }

         }
         else
         {
             if(i%2 == 0)
             {
                 thebutton.frame = CGRectMake(124, (i/2)*350 + collect.frame.origin.y + collect.frame.size.height +40+128, 198, 198);
                 starButton.frame = CGRectMake(183, thebutton.frame.origin.y - 85, 80, 80);
                 label.frame = CGRectMake(thebutton.frame.origin.x, thebutton.frame.origin.y + thebutton.frame.size.height +5,  thebutton.frame.size.width, 50);
             }
             else
             {
                 thebutton.frame = CGRectMake(446, (i/2)*350 + collect.frame.origin.y + collect.frame.size.height +40+128, 198, 198);
                 starButton.frame = CGRectMake(505, thebutton.frame.origin.y - 85, 80, 80);
                 label.frame = CGRectMake(thebutton.frame.origin.x, thebutton.frame.origin.y + thebutton.frame.size.height +5,  thebutton.frame.size.width, 50);
             }
         }
         
         [scroll addSubview:thebutton];
         [scroll addSubview:starButton];
         [scroll addSubview:label];
         
        scrollSize += starButton.frame.size.height +thebutton.frame.size.height + label.frame.size.height +10;
         
         if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"fb%@:", new.facebookId]]])
         {
             starButton.selected = YES;
         }
     }
     
     [scroll setContentSize:CGSizeMake(scroll.frame.size.width,self.collect.frame.origin.y + self.collect.frame.size.height +scrollSize/2 )];
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
         [scroll setContentSize:CGSizeMake(scroll.frame.size.width, self.collect.frame.origin.y + self.collect.frame.size.height +scrollSize/2 + 100)];
     }
     
     

    
    }
    activity.hidden = YES;
    //parse the xml!
}

- (IBAction)Back:(id)sender
{
    //[[(AppDelegate *)[[UIApplication sharedApplication] delegate] buttonPlay] setCurrentTime:0.0];
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:1];
    
    [UIView
     transitionWithView:self.navigationController.view
     duration:1.0
     options:UIViewAnimationOptionTransitionCurlUp
     animations:^{
         [self.navigationController popViewControllerAnimated:NO];
     }
     completion:NULL];
    
}
-(void)getApp:(UIButton *)sender
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:1];
    if (sender.tag != -1) {
        MoreItem * item = (MoreItem *)[theItems objectAtIndex:sender.tag];
        [[UIApplication sharedApplication ]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",item.iTunesURL]]];
    }
    else
    {
        //here open the app of the day
         [[UIApplication sharedApplication ]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",free.iTunesURL]]];
    }
   
}

- (IBAction)Rate:(id)sender
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:1];
    //[[(AppDelegate *)[[UIApplication sharedApplication] delegate] buttonPlay] setCurrentTime:0.0];
   // [[(AppDelegate *)[[UIApplication sharedApplication] delegate] buttonPlay] play];
//    [Flurry logEvent:@"Accepted_Review_Prompt"];
    
    if(([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending))
    {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:RATE_LINK_IOS7]];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RATE_LINK_IOS6]];
    }
}

#pragma mark - Dealloc

- (void)dealloc
{
    [scroll release];
    [super dealloc];
}


@end
