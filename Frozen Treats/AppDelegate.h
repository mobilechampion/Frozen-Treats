//
//  AppDelegate.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/13/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RevMobAds/RevMobAds.h>
#import <AVFoundation/AVFoundation.h>
//#import "Flurry.h"
#import "StoreViewController.h"
#import "UAExampleModalPanel.h"
#import "Chartboost.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BOOL frozenLocked;
    BOOL icecreamConesLocked;
    BOOL icecreamSandLocked;
    BOOL icecreamSundaeLocked;
    BOOL icePopsLocked;
    BOOL snowConesLocked;
    
    BOOL fromLastPage;
    BOOL firstTime;
    
    StoreViewController *store;
    
    AVAudioPlayer *buttonTap;
    AVAudioPlayer *initialSound;
    AVAudioPlayer *finalSound;
    AVAudioPlayer *sparkleSound;
    AVAudioPlayer *pourSugar;
    AVAudioPlayer *pourLiquid;
    AVAudioPlayer *iceLemonade;
    AVAudioPlayer *stirFlavor;
    
    AVAudioPlayer *iceCreamPouring;
    AVAudioPlayer *pullLever;
    AVAudioPlayer *selectionClick;
    AVAudioPlayer *addCocoa;
    AVAudioPlayer *addEgg;
    AVAudioPlayer *addOil;
    AVAudioPlayer *blenderMix;
    AVAudioPlayer *clockTicking;
    AVAudioPlayer *crushingIce;
    AVAudioPlayer *dipIceCream;
    AVAudioPlayer *mixIngredients;
    AVAudioPlayer *popup;
    AVAudioPlayer *putCookieDough;
    AVAudioPlayer *putInFreezer;
    AVAudioPlayer *putIceInCone;
    AVAudioPlayer *scoopCookie;
    AVAudioPlayer *scoopIce;
    AVAudioPlayer *scoopIceCream;
    AVAudioPlayer *screenSlide;
    AVAudioPlayer *slideSheetIn;
    AVAudioPlayer *slideSheetOut;
    AVAudioPlayer *spinningSound;
    
    Chartboost *cb;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (nonatomic, retain) StoreViewController *store;

@property (nonatomic) BOOL frozenLocked;
@property (nonatomic) BOOL icecreamConesLocked;
@property (nonatomic) BOOL icecreamSandLocked;
@property (nonatomic) BOOL icecreamSundaeLocked;
@property (nonatomic) BOOL icePopsLocked;
@property (nonatomic) BOOL snowConesLocked;

@property (nonatomic) BOOL fromLastPage;
@property (nonatomic) BOOL firstTime;

- (void)showFullScreenAd;
- (void)showPopupAd;
- (void)promptReview;
- (void)showChartboostAd;

- (void)playSoundEffect:(NSInteger)sound;
- (void)stopSoundEffect:(NSInteger)sound;

@end
