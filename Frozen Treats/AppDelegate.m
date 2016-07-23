//
//  AppDelegate.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/13/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuViewController.h"
#import "Defines.h"

@implementation AppDelegate
@synthesize frozenLocked, icecreamConesLocked, icecreamSandLocked, icecreamSundaeLocked, icePopsLocked, snowConesLocked;
@synthesize fromLastPage;
@synthesize firstTime;
@synthesize store;

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

#pragma mark - RevMob

- (void)showFullScreenAd
{
    //if(frozenLocked == YES)
    //{
        [[RevMobAds session] showFullscreen];
    //}
}

- (void)showPopupAd
{
    //if(frozenLocked == YES)
    //{
        [[RevMobAds session] showPopup];
    //}
}

- (void)revmobAdDidFailWithError:(NSError*)error
{
    NSLog(@"Ad failed with error: %@", error);
}

#pragma mark - Chartboost

- (void)showChartboostAd
{
    [cb showInterstitial];
}

#pragma mark - Flurry

- (void)promptReview
{
    BOOL hasReviewed = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasreviewed"];
    if(!hasReviewed)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Love Making Ice Cream?!"
                                                        message:@"I rate You 5 out of 5, can you please rate me?"
                                                       delegate:self
                                              cancelButtonTitle:@"No Thanks"
                                              otherButtonTitles:@"Sure!", nil];
        alert.tag = 15;
        [alert show];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 15)
    {
        if(buttonIndex == 1)
        {
//            [Flurry logEvent:@"Accepted_Review_Prompt"];
            
            if(([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending))
            {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:RATE_LINK_IOS7]];
            }
            else
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RATE_LINK_IOS6]];
            }
        }
    }
}

#pragma mark - Sounds

- (void)prepareSoundEffects
{
    NSURL *soundPath = nil;
    NSError *setCategoryError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&setCategoryError];
    
    
    soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"General_UIButtonSound_MS" ofType:@"caf"]];
    buttonTap = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
    [buttonTap setDelegate:nil];
    [buttonTap prepareToPlay];
    
    soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Magic Wand Noise-SoundBible.com-375928671" ofType:@"mp3"]];
    initialSound = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
    [initialSound setDelegate:nil];
    [initialSound prepareToPlay];
    
    soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Eating1_CF" ofType:@"mp3"]];
    sparkleSound = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
    [sparkleSound setDelegate:nil];
    [sparkleSound prepareToPlay];
    
    soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"CompletedDishMusic_CF" ofType:@"wav"]];
    finalSound = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
    [finalSound setDelegate:nil];
    [finalSound prepareToPlay];
    
    soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"PourSugar_Lemonade" ofType:@"caf"]];
    pourSugar = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
    [pourSugar setDelegate:nil];
    pourSugar.numberOfLoops = -1;
    
    soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"MIlkPour_Shake" ofType:@"mp3"]];
    pourLiquid = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
    [pourLiquid setDelegate:nil];
    
    soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Ice Cubes Falling into Machine" ofType:@"mp3"]];
    iceLemonade = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
    [iceLemonade setDelegate:nil];
    
    soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"StirringGlassBowl_CF" ofType:@"mp3"]];
    stirFlavor = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
    [stirFlavor setDelegate:nil];
    stirFlavor.numberOfLoops = -1;
    
    soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Ice Cream Pouring into Cone" ofType:@"mp3"]];
    iceCreamPouring = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
    [iceCreamPouring setDelegate:nil];
    iceCreamPouring.numberOfLoops = -1;
    
    soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Pull Ice Cream Lever" ofType:@"mp3"]];
    pullLever = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
    [pullLever setDelegate:nil];
    
    soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Selection Click" ofType:@"mp3"]];
    selectionClick = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
    [selectionClick setDelegate:nil];

    soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Adding Cocoa or Flour" ofType:@"mp3"]];
    addCocoa = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
    [addCocoa setDelegate:nil];

    soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Adding Egg" ofType:@"mp3"]];
    addEgg = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
    [addEgg setDelegate:nil];

    soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Adding Oil" ofType:@"mp3"]];
    addOil = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
    [addOil setDelegate:nil];

    soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Blender Mixing" ofType:@"mp3"]];
    blenderMix = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
    [blenderMix setDelegate:nil];
    blenderMix.numberOfLoops = -1;
    
    soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Clock Ticking while Baking" ofType:@"mp3"]];
    clockTicking = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
    [clockTicking setDelegate:nil];

    soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Crushing Ice" ofType:@"mp3"]];
    crushingIce = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
    [crushingIce setDelegate:nil];
    crushingIce.numberOfLoops = -1;

    soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Dipping Ice Cream into Flavor" ofType:@"mp3"]];
    dipIceCream = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
    [dipIceCream setDelegate:nil];

    soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Mixing Ingredients with Wooden Spoon" ofType:@"mp3"]];
    mixIngredients = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
    [mixIngredients setDelegate:nil];
    mixIngredients.numberOfLoops = -1;

    soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Popup Message" ofType:@"mp3"]];
    popup = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
    [popup setDelegate:nil];

    soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Putting Cookie Dough on Cookie Sheet" ofType:@"mp3"]];
    putCookieDough = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
    [putCookieDough setDelegate:nil];

    soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Putting Ice Cream in the Freezer" ofType:@"mp3"]];
    putInFreezer = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
    [putInFreezer setDelegate:nil];

    soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Putting Ice onto the Cone" ofType:@"mp3"]];
    putIceInCone = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
    [putIceInCone setDelegate:nil];

    soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Scooping Cookie dough with Metal Spoon" ofType:@"mp3"]];
    scoopCookie = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
    [scoopCookie setDelegate:nil];

    soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Scooping Crushed Ice" ofType:@"mp3"]];
    scoopIce = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
    [scoopIce setDelegate:nil];

    soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Scooping Ice Cream" ofType:@"mp3"]];
    scoopIceCream = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
    [scoopIceCream setDelegate:nil];

    soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Screen Slide" ofType:@"mp3"]];
    screenSlide = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
    [screenSlide setDelegate:nil];

    soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Sliding Cookie Sheet into Oven" ofType:@"mp3"]];
    slideSheetIn = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
    [slideSheetIn setDelegate:nil];

    soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Taking Cookie Sheet out of Oven" ofType:@"mp3"]];
    slideSheetOut = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
    [slideSheetOut setDelegate:nil];
    
    soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Items Spinning" ofType:@"mp3"]];
    spinningSound = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
    [spinningSound setDelegate:nil];
}

- (void)playSoundEffect:(NSInteger)sound
{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"sounds"] isEqualToString:@"yes"])
    {
        if(sound == 1)
        {
            [buttonTap stop];
            [buttonTap setCurrentTime:0.0];
            [buttonTap play];
        }
        else if(sound == 2)
        {
            [initialSound play];
        }
        else if(sound == 3)
        {
            [sparkleSound stop];
            [sparkleSound setCurrentTime:0.0];
            [sparkleSound play];
        }
        else if(sound == 4)
        {
            [finalSound setCurrentTime:0.0];
            [finalSound play];
        }
        else if(sound == 5)
        {
            [pourSugar prepareToPlay];
            [pourSugar play];
        }
        else if(sound == 6)
        {
            pourLiquid.numberOfLoops = -1;
            [pourLiquid prepareToPlay];
            [pourLiquid play];
        }
        else if(sound == 7)
        {
            [iceLemonade prepareToPlay];
            [iceLemonade play];
        }
        else if(sound == 8)
        {
            [stirFlavor prepareToPlay];
            [stirFlavor play];
        }
        else if(sound == 9)
        {
            [iceCreamPouring prepareToPlay];
            [iceCreamPouring play];
        }
        else if(sound == 10)
        {
            [pullLever prepareToPlay];
            [pullLever play];
        }
        else if(sound == 12)
        {
            [selectionClick prepareToPlay];
            [selectionClick play];
        }
        else if(sound == 13)
        {
            [addCocoa setCurrentTime:0.0];
            [addCocoa prepareToPlay];
            [addCocoa play];
        }
        else if(sound == 14)
        {
            [addEgg prepareToPlay];
            [addEgg play];
        }
        else if(sound == 15)
        {
            [addOil prepareToPlay];
            [addOil play];
        }
        else if(sound == 16)
        {
            [blenderMix setCurrentTime:0.0];
            [blenderMix prepareToPlay];
            [blenderMix play];
        }
        else if(sound == 17)
        {
            [clockTicking setCurrentTime:0.0];
            [clockTicking prepareToPlay];
            [clockTicking play];
        }
        else if(sound == 18)
        {
            [crushingIce setCurrentTime:0.0];
            [crushingIce prepareToPlay];
            [crushingIce play];
        }
        else if(sound == 19)
        {
            [dipIceCream prepareToPlay];
            [dipIceCream play];
        }
        else if(sound == 20)
        {
            [mixIngredients prepareToPlay];
            [mixIngredients play];
        }
        else if(sound == 21)
        {
            [popup prepareToPlay];
            [popup play];
        }
        else if(sound == 31)
        {
            [putCookieDough setCurrentTime:0.0];
            [putCookieDough prepareToPlay];
            [putCookieDough play];
        }
        else if(sound == 22)
        {
            [putInFreezer prepareToPlay];
            [putInFreezer play];
        }
        else if(sound == 23)
        {
            [putIceInCone prepareToPlay];
            [putIceInCone play];
        }
        else if(sound == 24)
        {
            [scoopCookie setCurrentTime:0.0];
            [scoopCookie prepareToPlay];
            [scoopCookie play];
        }
        else if(sound == 25)
        {
            [scoopIce setCurrentTime:0.0];
            [scoopIce prepareToPlay];
            [scoopIce play];
        }
        else if(sound == 26)
        {
            [scoopIceCream setCurrentTime:0.0];
            [scoopIceCream prepareToPlay];
            [scoopIceCream play];
        }
        else if(sound == 27)
        {
            [screenSlide prepareToPlay];
            [screenSlide play];
        }
        else if(sound == 28)
        {
            [slideSheetIn setCurrentTime:0.0];
            [slideSheetIn prepareToPlay];
            [slideSheetIn play];
        }
        else if(sound == 29)
        {
            [slideSheetOut setCurrentTime:0.0];
            [slideSheetOut prepareToPlay];
            [slideSheetOut play];
        }
        else if(sound == 30)
        {
            [spinningSound setCurrentTime:0.0];
            [spinningSound prepareToPlay];
            [spinningSound play];
        }
    }
}

- (void)stopSoundEffect:(NSInteger)sound
{
    if(sound == 4)
    {
        [finalSound stop];
    }
    else if(sound == 5)
    {
        [pourSugar stop];
    }
    else if(sound == 6)
    {
        [pourLiquid stop];
    }
    else if (sound == 7)
    {
        [iceLemonade stop];
    }
    else if(sound == 8)
    {
        [stirFlavor stop];
    }
    else if(sound == 9)
    {
        [iceCreamPouring stop];
    }
    else if(sound == 13)
    {
        [addCocoa stop];
    }
    else if(sound == 14)
    {
        [addEgg stop];
    }
    else if(sound == 16)
    {
        [blenderMix stop];
    }
    else if(sound == 17)
    {
        [clockTicking stop];
    }
    else if(sound == 18)
    {
        [crushingIce stop];
    }
    else if(sound == 20)
    {
        [mixIngredients stop];
    }
    else if(sound == 22)
    {
        [mixIngredients stop];
    }
    else if(sound == 28)
    {
        [slideSheetIn stop];
    }
    else if(sound == 29)
    {
        [slideSheetOut stop];
    }
    else if(sound == 30)
    {
        [spinningSound stop];
    } //31 is last :)
}

#pragma mark - Locked

- (void)initializeLocked
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"frozenLocked"] == nil)
    {
        frozenLocked = YES;
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"frozenLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"frozenLocked"] isEqualToString:@"YES"])
    {
        frozenLocked = YES;
    }
    else
    {
        frozenLocked = NO;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"icecreamConesLocked"];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"icecreamSandLocked"];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"icecreamSundaeLocked"];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"icePopsLocked"];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"snowConesLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"icecreamConesLocked"] == nil)
    {
        icecreamConesLocked = YES;
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"icecreamConesLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"icecreamConesLocked"] isEqualToString:@"YES"])
    {
        icecreamConesLocked = YES;
    }
    else
    {
        icecreamConesLocked = NO;
    }
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"icecreamSandLocked"] == nil)
    {
        icecreamSandLocked = YES;
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"icecreamSandLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"icecreamSandLocked"] isEqualToString:@"YES"])
    {
        icecreamSandLocked = YES;
    }
    else
    {
        icecreamSandLocked = NO;
    }
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"icecreamSundaeLocked"] == nil)
    {
        icecreamSundaeLocked = YES;
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"icecreamSundaeLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"icecreamSundaeLocked"] isEqualToString:@"YES"])
    {
        icecreamSundaeLocked = YES;
    }
    else
    {
        icecreamSundaeLocked = NO;
    }
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"icePopsLocked"] == nil)
    {
        icePopsLocked = YES;
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"icePopsLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"icePopsLocked"] isEqualToString:@"YES"])
    {
        icePopsLocked = YES;
    }
    else
    {
        icePopsLocked = NO;
    }
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"snowConesLocked"] == nil)
    {
        snowConesLocked = YES;
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"snowConesLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"snowConesLocked"] isEqualToString:@"YES"])
    {
        snowConesLocked = YES;
    }
    else
    {
        snowConesLocked = NO;
    }

    store = [[StoreViewController alloc] init];
}

#pragma mark - Application

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [RevMobAds startSessionWithAppID:REVMOB_ID];
//    [Flurry startSession:FLURRY_ID];
    
    fromLastPage = YES;
    firstTime = YES;
    
    [self initializeLocked];
    [self prepareSoundEffects];
    
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"sounds"] isEqualToString:@"no"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"sounds"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"timesFinished"] == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"timesFinished"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    
    MenuViewController *menuViewController = [[MenuViewController alloc] init];
    
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:menuViewController] autorelease];
    self.navigationController.navigationBarHidden = YES;
    self.window.rootViewController = self.navigationController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    cb = [Chartboost sharedChartboost];
    
    cb.appId = CHARTBOOST_ID;
    cb.appSignature = CHARTBOOST_SIGNATURE;
    
    // Required for use of delegate methods. See "Advanced Topics" section below.
    //cb.delegate = self;
    
    // Begin a user session. Must not be dependent on user actions or any prior network requests.
    // Must be called every time your app becomes active.
    [cb startSession];
    
    // Show an interstitial
    //[cb showInterstitial];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
