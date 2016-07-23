//
//  IcecreamSundaeFinalViewController.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/24/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "IcecreamSundaeFinalViewController.h"
#import "Defines.h"

@implementation IcecreamSundaeFinalViewController
@synthesize dish, flavor, fromFridge, drizzles, decorationsImage;

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"IcecreamSundaeFinalViewController-5" bundle:[NSBundle mainBundle]];
    else
        self = [super init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self arrangeIcecream];
    decorations.image = decorationsImage;
    
    
    [self.view bringSubviewToFront:bitesView];
    [self.view bringSubviewToFront:homeButton];
    [self.view bringSubviewToFront:saveButton];
    [self.view bringSubviewToFront:shareButton];
    [self.view bringSubviewToFront:backButton];
    [self.view bringSubviewToFront:eatAgainButton];

    
    firstTime = YES;
    saved = NO;
    
    
    int timesFinished = [[[NSUserDefaults standardUserDefaults] objectForKey:@"timesFinished"] intValue] + 1;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", timesFinished] forKey:@"timesFinished"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if(timesFinished == 3 || timesFinished == 6 || timesFinished == 9 || timesFinished == 12 || timesFinished == 15)
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] promptReview];
    
//    [Flurry logEvent:@"IceCreamSundae_Created"];
    if(fromFridge == NO)
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).fromLastPage = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    popClosed = NO;
    if(firstTime == YES)
    {
        [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:4];
        
        CAEmitterLayer *emitter = [CAEmitterLayer layer];
        emitter.emitterCells = [NSArray arrayWithObjects:[self sparkCell], nil];
        emitter.emitterShape = kCAEmitterLayerPoint;
        emitter.renderMode = kCAEmitterLayerAdditive;
        emitter.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2, ([UIScreen mainScreen].bounds.size.height - [UIScreen mainScreen].bounds.size.width)/2 + [UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
        emitter.birthRate = 1;
        [self.view.layer addSublayer:emitter];
        
        [self performSelector:@selector(stopEmitting:) withObject:emitter afterDelay:1.5];
        
        
        if([(AppDelegate*)[[UIApplication sharedApplication] delegate] icecreamConesLocked] == YES)
        {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"icecreamconefinal"] isEqualToString:@"1"])
            {
                [(AppDelegate*)[[UIApplication sharedApplication] delegate] showFullScreenAd];
                [(AppDelegate*)[[UIApplication sharedApplication] delegate] showChartboostAd];
                
                popClosed = YES;
                
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"icecreamconefinal"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            else
            {
                NSString *title = @"Great Job On Your Frozen Treat!";
                UAExampleModalPanel *modalPanel = [[UAExampleModalPanel alloc] initWithFrame:self.view.bounds title:title andPurchaseTag:0 andCustom:YES];
                
                modalPanel.onClosePressed = ^(UAModalPanel* panel)
                {
                    popClosed = YES;
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
                [modalPanel setupStuff2];
                UADebugLog(@"UAModalView will display using blocks: %@", modalPanel);
                
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"icecreamconefinal"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        else
            popClosed = YES;
        
        firstTime = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction

- (IBAction)backClick:(id)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:27];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] stopSoundEffect:4];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)homeClick:(id)sender
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] playSoundEffect:1];
    if(fromFridge == YES)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] stopSoundEffect:4];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).fromLastPage = YES;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if(saved == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"You didn't save your Ice Cream! Do you really want to leave?" delegate:self cancelButtonTitle:@"Leave" otherButtonTitles:@"Save", nil];
        [alert show];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] stopSoundEffect:4];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)shareClick:(id)sender
{
    if(imageWithBackground == nil)
    {
        [backButton removeFromSuperview];
        [shareButton removeFromSuperview];
        [saveButton removeFromSuperview];
        [homeButton removeFromSuperview];
        [eatAgainButton removeFromSuperview];
        [bitesView removeFromSuperview];
        
        if([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
            UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, [UIScreen mainScreen].scale);
        else
            UIGraphicsBeginImageContext(self.view.frame.size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        imageWithBackground = UIGraphicsGetImageFromCurrentImageContext();
        [imageWithBackground retain];
        
        [self.view addSubview:bitesView];
        [self.view addSubview:backButton];
        [self.view addSubview:shareButton];
        [self.view addSubview:saveButton];
        [self.view addSubview:homeButton];
        [self.view addSubview:eatAgainButton];
    }
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] playSoundEffect:1];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share Your Ice Cream" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share to Facebook", @"Email to Friends", nil];
    actionSheet.tag = 17;
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

- (IBAction)saveClick:(id)sender
{
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) playSoundEffect:1];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Save Your Ice Cream" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Save to Fridge", @"Save to Photos", nil];
    actionSheet.tag = 16;
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

- (IBAction)eatAgain:(id)sender
{
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) playSoundEffect:1];
    
    for(UIView *view in [bitesView subviews])
    {
        if(view.tag == 39)
            [view removeFromSuperview];
    }
}

#pragma mark - Share/Save

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:1];
    if(actionSheet.tag == 16)
    {
        if(buttonIndex == 0)
        {
            saved = YES;
//            [Flurry logEvent:@"Saved_To_Album"];
            //Album
            [self.view setBackgroundColor:[UIColor clearColor]];
            [backButton removeFromSuperview];
            [shareButton removeFromSuperview];
            [saveButton removeFromSuperview];
            [homeButton removeFromSuperview];
            [eatAgainButton removeFromSuperview];
            [bitesView removeFromSuperview];
            [backgroundImgView removeFromSuperview];
            
            if([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
                UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, [UIScreen mainScreen].scale);
            else
                UIGraphicsBeginImageContext(self.view.frame.size);
            [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            
            [self.view addSubview:bitesView];
            [self.view addSubview:backButton];
            [self.view addSubview:shareButton];
            [self.view addSubview:saveButton];
            [self.view addSubview:homeButton];
            [self.view addSubview:eatAgainButton];
            [self.view insertSubview:backgroundImgView atIndex:0];
            
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
            NSNumber *timeStampObj = [NSNumber numberWithDouble:timeStamp];
            
            NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",timeStampObj]];
            NSData *imageData = UIImagePNGRepresentation(img);
            [imageData writeToFile:savedImagePath atomically:NO];
            
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"alex_fairies"] == nil)
            {
                NSMutableArray *alex_drinks = [[NSMutableArray alloc] init];
                NSMutableDictionary *md = [[NSMutableDictionary alloc] init];
                [md setObject:savedImagePath forKey:@"path"];
                [md setObject:@"icecream_sundae" forKey:@"type"];
                [md setObject:[NSString stringWithFormat:@"%d", dish] forKey:@"dish"];
                [md setObject:[NSString stringWithFormat:@"%d", flavor] forKey:@"flavor"];
                [md setObject:decorationsImage forKey:@"decorations"];
                [alex_drinks addObject:md];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:alex_drinks];
                [defaults setObject:data forKey:@"alex_fairies"];
                [defaults synchronize];
            }
            else
            {
                NSMutableArray *alex_drinks = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"alex_fairies"]];
                NSMutableDictionary *md = [[NSMutableDictionary alloc] init];
                [md setObject:savedImagePath forKey:@"path"];
                [md setObject:@"icecream_sundae" forKey:@"type"];
                [md setObject:[NSString stringWithFormat:@"%d", dish] forKey:@"dish"];
                [md setObject:[NSString stringWithFormat:@"%d", flavor] forKey:@"flavor"];
                [md setObject:decorationsImage forKey:@"decorations"];
                [alex_drinks addObject:md];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:alex_drinks];
                [defaults setObject:data forKey:@"alex_fairies"];
                [defaults synchronize];
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Your treat is saved! You can find it in the freezer!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else if(buttonIndex == 1)
        {
            saved = YES;
//            [Flurry logEvent:@"Saved_To_Photos"];
            //Photos
            if(imageWithBackground == nil)
            {
                [backButton removeFromSuperview];
                [shareButton removeFromSuperview];
                [saveButton removeFromSuperview];
                [homeButton removeFromSuperview];
                [eatAgainButton removeFromSuperview];
                [bitesView removeFromSuperview];
                
                if([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
                    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, [UIScreen mainScreen].scale);
                else
                    UIGraphicsBeginImageContext(self.view.frame.size);
                [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
                imageWithBackground = UIGraphicsGetImageFromCurrentImageContext();
                [imageWithBackground retain];
                
                [self.view addSubview:bitesView];
                [self.view addSubview:backButton];
                [self.view addSubview:shareButton];
                [self.view addSubview:saveButton];
                [self.view addSubview:homeButton];
                [self.view addSubview:eatAgainButton];
            }
            
            UIImageWriteToSavedPhotosAlbum(imageWithBackground, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    if(actionSheet.tag == 17)
    {
        if(buttonIndex == 0)
        {
            //Facebook
//            [Flurry logEvent:@"Shared_With_Facebook"];
            
            if(imageWithBackground == nil)
            {
                [backButton removeFromSuperview];
                [shareButton removeFromSuperview];
                [saveButton removeFromSuperview];
                [homeButton removeFromSuperview];
                [eatAgainButton removeFromSuperview];
                [bitesView removeFromSuperview];
                
                if([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
                    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, [UIScreen mainScreen].scale);
                else
                    UIGraphicsBeginImageContext(self.view.frame.size);
                [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
                imageWithBackground = UIGraphicsGetImageFromCurrentImageContext();
                [imageWithBackground retain];
                
                [self.view addSubview:bitesView];
                [self.view addSubview:backButton];
                [self.view addSubview:shareButton];
                [self.view addSubview:saveButton];
                [self.view addSubview:homeButton];
                [self.view addSubview:eatAgainButton];
            }
            
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
            {
                SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                [mySLComposerSheet setInitialText:FACEBOOK_TEXT_ICECREAM_SUNDAE];
                [mySLComposerSheet addImage:imageWithBackground];
                [mySLComposerSheet addURL:[NSURL URLWithString:ITUNES_LINK]];
                
                [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result)
                 {
                     switch(result)
                     {
                         case SLComposeViewControllerResultCancelled:
                             NSLog(@"Post Canceled");
                             break;
                         case SLComposeViewControllerResultDone:
                             NSLog(@"Post Sucessful");
                             break;
                         default:
                             break;
                     }
                 }];
                
                [self presentViewController:mySLComposerSheet animated:YES completion:nil];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please log in on Facebook before using this feature" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }
        else if(buttonIndex == 1)
        {
            //Email
//            [Flurry logEvent:@"Shared_With_Email"];
            
            if([MFMailComposeViewController canSendMail])
            {
                MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
                mailer.mailComposeDelegate = self;
                [mailer setSubject:EMAIL_SUBJECT];
                
                //[imageWithBackground retain];
                NSData *imageData = UIImagePNGRepresentation(imageWithBackground);
                [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"IceCream"];
                
                NSString *emailBody = EMAIL_MESSAGE;
                [mailer setMessageBody:emailBody isHTML:YES];
                
                [self presentViewController:mailer animated:YES completion:nil];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                                message:@"Your device doesn't support this feature."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch(result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
	UIAlertView *alert;
    
	if(error)
		alert = [[UIAlertView alloc] initWithTitle:@"Failure"
										   message:@"This pic couldn't be saved in your photo album."
										  delegate:nil cancelButtonTitle:@"Ok"
								 otherButtonTitles:nil];
	else
		alert = [[UIAlertView alloc] initWithTitle:@""
										   message:@"This pic was saved in your photo album"
										  delegate:nil cancelButtonTitle:@"Ok"
								 otherButtonTitles:nil];
	[alert show];
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) playSoundEffect:1];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).fromLastPage = YES;
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] stopSoundEffect:4];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    else
    {
        [alertView dismissWithClickedButtonIndex:1 animated:YES];
        [self saveClick:nil];
    }
}

#pragma mark - Helpers

- (void)arrangeIcecream
{
    dishImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dish%d.png", dish]];
    scoop1.image = [UIImage imageNamed:[NSString stringWithFormat:@"scoop%d.png", flavor]];
    scoop2.image = [UIImage imageNamed:[NSString stringWithFormat:@"scoop%d.png", flavor]];
    scoop3.image = [UIImage imageNamed:[NSString stringWithFormat:@"scoop%d.png", flavor]];
    scoop4.image = [UIImage imageNamed:[NSString stringWithFormat:@"scoop%d.png", flavor]];
    scoop5.image = [UIImage imageNamed:[NSString stringWithFormat:@"scoop%d.png", flavor]];
    
    if([UIScreen mainScreen].bounds.size.height == 480)
    {
        switch(dish)
        {
            case 1:
            {
                dishImgView.frame = CGRectMake(84, 317, 153, 163);
                scoop1.frame = CGRectMake(88, 276, 75, 64);
                scoop2.frame = CGRectMake(152, 276, 75, 64);
                scoop3.frame = CGRectMake(117, 235, 75, 64);
                scoop4.image = nil;
                scoop5.image = nil;
            }
                break;
                
            case 2:
            {
                dishImgView.frame = CGRectMake(50, 317, 222, 163);
                scoop1.frame = CGRectMake(68, 277, 75, 64);
                scoop2.frame = CGRectMake(124, 260, 75, 64);
                scoop3.frame = CGRectMake(178, 277, 75, 64);
                scoop4.image = nil;
                scoop5.image = nil;
            }
                break;
                
            case 3:
            {
                dishImgView.frame = CGRectMake(49, 317, 222, 163);
                scoop1.frame = CGRectMake(68, 277, 75, 64);
                scoop2.frame = CGRectMake(124, 272, 75, 64);
                scoop3.frame = CGRectMake(178, 277, 75, 64);
                scoop4.frame = CGRectMake(95, 228, 75, 64);
                scoop5.frame = CGRectMake(151, 228, 75, 64);
            }
                break;
                
            case 4:
            case 5:
            case 6:
            {
                dishImgView.frame = CGRectMake(49, 317, 222, 163);
                scoop1.frame = CGRectMake(95, 272, 75, 64);
                scoop2.frame = CGRectMake(150, 272, 75, 64);
                scoop3.frame = CGRectMake(131, 239, 75, 64);
                scoop4.image = nil;
                scoop5.image = nil;
            }
                break;
                
            case 7:
            case 8:
            {
                dishImgView.frame = CGRectMake(49, 322, 222, 163);
                scoop1.frame = CGRectMake(63, 282, 75, 64);
                scoop2.frame = CGRectMake(124, 282, 75, 64);
                scoop3.frame = CGRectMake(183, 276, 75, 64);
                scoop4.frame = CGRectMake(96, 237, 75, 64);
                scoop5.frame = CGRectMake(156, 231, 75, 64);
            }
                break;
                
            case 9:
            case 10:
            case 11:
            case 28:
            {
                dishImgView.frame = CGRectMake(49, 337, 222, 163);
                scoop1.frame = CGRectMake(63, 327, 75, 64);
                scoop2.frame = CGRectMake(124, 327, 75, 64);
                scoop3.frame = CGRectMake(183, 321, 75, 64);
                scoop4.frame = CGRectMake(96, 282, 75, 64);
                scoop5.frame = CGRectMake(156, 276, 75, 64);
            }
                break;
                
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            {
                dishImgView.frame = CGRectMake(50, 317, 222, 163);
                scoop1.frame = CGRectMake(63, 282, 75, 64);
                scoop2.frame = CGRectMake(125, 282, 75, 64);
                scoop3.frame = CGRectMake(184, 276, 75, 64);
                scoop4.frame = CGRectMake(97, 237, 75, 64);
                scoop5.frame = CGRectMake(157, 231, 75, 64);
            }
                break;
                
            case 17:
            case 18:
            case 19:
            case 20:
            case 21:
            case 22:
            {
                dishImgView.frame = CGRectMake(50, 317, 222, 163);
                scoop1.frame = CGRectMake(92, 276, 75, 64);
                scoop2.frame = CGRectMake(156, 276, 75, 64);
                scoop3.frame = CGRectMake(124, 236, 75, 64);
                scoop4.image = nil;
                scoop5.image = nil;
            }
                break;
                
            case 23:
            {
                dishImgView.frame = CGRectMake(31, 294, 260, 191);
                scoop1.frame = CGRectMake(124, 376, 75, 64);
                scoop2.frame = CGRectMake(92, 325, 75, 64);
                scoop3.frame = CGRectMake(156, 325, 75, 64);
                scoop4.frame = CGRectMake(123, 283, 75, 64);
                scoop5.image = nil;
            }
                break;
                
            case 24:
            {
                dishImgView.frame = CGRectMake(45, 283, 230, 211);
                scoop1.frame = CGRectMake(150, 386, 75, 64);
                scoop2.frame = CGRectMake(107, 386, 75, 64);
                scoop3.frame = CGRectMake(56, 357, 75, 64);
                scoop4.frame = CGRectMake(183, 329, 75, 64);
                scoop5.frame = CGRectMake(123, 329, 75, 64);
            }
                break;
                
            case 25:
            {
                dishImgView.frame = CGRectMake(27, 275, 269, 247);
                scoop1.frame = CGRectMake(123, 376, 75, 64);
                scoop2.frame = CGRectMake(87, 327, 75, 64);
                scoop3.frame = CGRectMake(155, 321, 75, 64);
                scoop4.image = nil;
                scoop5.image = nil;
            }
                break;
                
            case 26:
            {
                dishImgView.frame = CGRectMake(27, 253, 269, 247);
                scoop1.frame = CGRectMake(123, 340, 75, 64);
                scoop2.frame = CGRectMake(104, 292, 75, 64);
                scoop3.frame = CGRectMake(170, 286, 75, 64);
                scoop4.frame = CGRectMake(62, 259, 75, 64);
                scoop5.frame = CGRectMake(131, 243, 75, 64);
            }
                break;
                
            case 27:
            {
                dishImgView.frame = CGRectMake(26, 242, 269, 247);
                scoop1.frame = CGRectMake(113, 366, 75, 64);
                scoop2.frame = CGRectMake(142, 312, 75, 64);
                scoop3.frame = CGRectMake(113, 264, 75, 64);
                scoop4.frame = CGRectMake(59, 254, 75, 64);
                scoop5.frame = CGRectMake(185, 259, 75, 64);
            }
                break;
                
            default:
                break;
        }
        
        dishImgView.frame = CGRectMake(dishImgView.frame.origin.x, dishImgView.frame.origin.y - 70, dishImgView.frame.size.width, dishImgView.frame.size.height);
        scoop1.frame = CGRectMake(scoop1.frame.origin.x, scoop1.frame.origin.y - 70, scoop1.frame.size.width, scoop1.frame.size.height);
        scoop2.frame = CGRectMake(scoop2.frame.origin.x, scoop2.frame.origin.y - 70, scoop2.frame.size.width, scoop2.frame.size.height);
        scoop3.frame = CGRectMake(scoop3.frame.origin.x, scoop3.frame.origin.y - 70, scoop3.frame.size.width, scoop3.frame.size.height);
        scoop4.frame = CGRectMake(scoop4.frame.origin.x, scoop4.frame.origin.y - 70, scoop4.frame.size.width, scoop4.frame.size.height);
        scoop5.frame = CGRectMake(scoop5.frame.origin.x, scoop5.frame.origin.y - 70, scoop5.frame.size.width, scoop5.frame.size.height);
    }
    else if([UIScreen mainScreen].bounds.size.height == 568)
    {
        switch(dish)
        {
            case 1:
            {
                dishImgView.frame = CGRectMake(84, 317, 153, 163);
                scoop1.frame = CGRectMake(88, 276, 75, 64);
                scoop2.frame = CGRectMake(152, 276, 75, 64);
                scoop3.frame = CGRectMake(117, 235, 75, 64);
                scoop4.image = nil;
                scoop5.image = nil;
            }
                break;
                
            case 2:
            {
                dishImgView.frame = CGRectMake(50, 317, 222, 163);
                scoop1.frame = CGRectMake(68, 277, 75, 64);
                scoop2.frame = CGRectMake(124, 260, 75, 64);
                scoop3.frame = CGRectMake(178, 277, 75, 64);
                scoop4.image = nil;
                scoop5.image = nil;
            }
                break;
                
            case 3:
            {
                dishImgView.frame = CGRectMake(49, 317, 222, 163);
                scoop1.frame = CGRectMake(68, 277, 75, 64);
                scoop2.frame = CGRectMake(124, 272, 75, 64);
                scoop3.frame = CGRectMake(178, 277, 75, 64);
                scoop4.frame = CGRectMake(95, 228, 75, 64);
                scoop5.frame = CGRectMake(151, 228, 75, 64);
            }
                break;
                
            case 4:
            case 5:
            case 6:
            {
                dishImgView.frame = CGRectMake(49, 317, 222, 163);
                scoop1.frame = CGRectMake(95, 272, 75, 64);
                scoop2.frame = CGRectMake(150, 272, 75, 64);
                scoop3.frame = CGRectMake(131, 239, 75, 64);
                scoop4.image = nil;
                scoop5.image = nil;
            }
                break;
                
            case 7:
            case 8:
            {
                dishImgView.frame = CGRectMake(49, 322, 222, 163);
                scoop1.frame = CGRectMake(63, 282, 75, 64);
                scoop2.frame = CGRectMake(124, 282, 75, 64);
                scoop3.frame = CGRectMake(183, 276, 75, 64);
                scoop4.frame = CGRectMake(96, 237, 75, 64);
                scoop5.frame = CGRectMake(156, 231, 75, 64);
            }
                break;
                
            case 9:
            case 10:
            case 11:
            case 28:
            {
                dishImgView.frame = CGRectMake(49, 337, 222, 163);
                scoop1.frame = CGRectMake(63, 327, 75, 64);
                scoop2.frame = CGRectMake(124, 327, 75, 64);
                scoop3.frame = CGRectMake(183, 321, 75, 64);
                scoop4.frame = CGRectMake(96, 282, 75, 64);
                scoop5.frame = CGRectMake(156, 276, 75, 64);
            }
                break;
                
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            {
                dishImgView.frame = CGRectMake(50, 317, 222, 163);
                scoop1.frame = CGRectMake(63, 282, 75, 64);
                scoop2.frame = CGRectMake(125, 282, 75, 64);
                scoop3.frame = CGRectMake(184, 276, 75, 64);
                scoop4.frame = CGRectMake(97, 237, 75, 64);
                scoop5.frame = CGRectMake(157, 231, 75, 64);
            }
                break;
                
            case 17:
            case 18:
            case 19:
            case 20:
            case 21:
            case 22:
            {
                dishImgView.frame = CGRectMake(50, 317, 222, 163);
                scoop1.frame = CGRectMake(92, 276, 75, 64);
                scoop2.frame = CGRectMake(156, 276, 75, 64);
                scoop3.frame = CGRectMake(124, 236, 75, 64);
                scoop4.image = nil;
                scoop5.image = nil;
            }
                break;
                
            case 23:
            {
                dishImgView.frame = CGRectMake(31, 294, 260, 191);
                scoop1.frame = CGRectMake(124, 376, 75, 64);
                scoop2.frame = CGRectMake(92, 325, 75, 64);
                scoop3.frame = CGRectMake(156, 325, 75, 64);
                scoop4.frame = CGRectMake(123, 283, 75, 64);
                scoop5.image = nil;
            }
                break;
                
            case 24:
            {
                dishImgView.frame = CGRectMake(45, 283, 230, 211);
                scoop1.frame = CGRectMake(150, 386, 75, 64);
                scoop2.frame = CGRectMake(107, 386, 75, 64);
                scoop3.frame = CGRectMake(56, 357, 75, 64);
                scoop4.frame = CGRectMake(183, 329, 75, 64);
                scoop5.frame = CGRectMake(123, 329, 75, 64);
            }
                break;
                
            case 25:
            {
                dishImgView.frame = CGRectMake(27, 275, 269, 247);
                scoop1.frame = CGRectMake(123, 376, 75, 64);
                scoop2.frame = CGRectMake(87, 327, 75, 64);
                scoop3.frame = CGRectMake(155, 321, 75, 64);
                scoop4.image = nil;
                scoop5.image = nil;
            }
                break;
                
            case 26:
            {
                dishImgView.frame = CGRectMake(27, 253, 269, 247);
                scoop1.frame = CGRectMake(123, 340, 75, 64);
                scoop2.frame = CGRectMake(104, 292, 75, 64);
                scoop3.frame = CGRectMake(170, 286, 75, 64);
                scoop4.frame = CGRectMake(62, 259, 75, 64);
                scoop5.frame = CGRectMake(131, 243, 75, 64);
            }
                break;
                
            case 27:
            {
                dishImgView.frame = CGRectMake(26, 242, 269, 247);
                scoop1.frame = CGRectMake(113, 366, 75, 64);
                scoop2.frame = CGRectMake(142, 312, 75, 64);
                scoop3.frame = CGRectMake(113, 264, 75, 64);
                scoop4.frame = CGRectMake(59, 254, 75, 64);
                scoop5.frame = CGRectMake(185, 259, 75, 64);
            }
                break;
                
            default:
                break;
        }
        
        dishImgView.frame = CGRectMake(dishImgView.frame.origin.x, dishImgView.frame.origin.y, dishImgView.frame.size.width, dishImgView.frame.size.height);
        scoop1.frame = CGRectMake(scoop1.frame.origin.x, scoop1.frame.origin.y, scoop1.frame.size.width, scoop1.frame.size.height);
        scoop2.frame = CGRectMake(scoop2.frame.origin.x, scoop2.frame.origin.y, scoop2.frame.size.width, scoop2.frame.size.height);
        scoop3.frame = CGRectMake(scoop3.frame.origin.x, scoop3.frame.origin.y, scoop3.frame.size.width, scoop3.frame.size.height);
        scoop4.frame = CGRectMake(scoop4.frame.origin.x, scoop4.frame.origin.y, scoop4.frame.size.width, scoop4.frame.size.height);
        scoop5.frame = CGRectMake(scoop5.frame.origin.x, scoop5.frame.origin.y, scoop5.frame.size.width, scoop5.frame.size.height);
    }
    else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        switch(dish)
        {
            case 1:
            {
                dishImgView.frame = CGRectMake(231, 693, 306, 331);
                scoop1.frame = CGRectMake(266, 629, 120, 105);
                scoop2.frame = CGRectMake(383, 629, 120, 105);
                scoop3.frame = CGRectMake(325, 568, 120, 105);
                scoop4.image = nil;
                scoop5.image = nil;
            }
                break;
                
            case 2:
            {
                dishImgView.frame = CGRectMake(203, 693, 364, 331);
                scoop1.frame = CGRectMake(215, 629, 120, 105);
                scoop2.frame = CGRectMake(318, 618, 120, 105);
                scoop3.frame = CGRectMake(426, 629, 120, 105);
                scoop4.image = nil;
                scoop5.image = nil;
            }
                break;
                
            case 3:
            {
                dishImgView.frame = CGRectMake(203, 693, 364, 331);
                scoop1.frame = CGRectMake(217, 629, 120, 105);
                scoop2.frame = CGRectMake(325, 629, 120, 105);
                scoop3.frame = CGRectMake(426, 629, 120, 105);
                scoop4.frame = CGRectMake(267, 559, 120, 105);
                scoop5.frame = CGRectMake(374, 554, 120, 105);
            }
                break;
                
            case 4:
            case 5:
            case 6:
            {
                dishImgView.frame = CGRectMake(203, 693, 364, 331);
                scoop1.frame = CGRectMake(267, 632, 120, 105);
                scoop2.frame = CGRectMake(376, 618, 120, 105);
                scoop3.frame = CGRectMake(317, 553, 120, 105);
                scoop4.image = nil;
                scoop5.image = nil;
            }
                break;
                
            case 7:
            case 8:
            {
                dishImgView.frame = CGRectMake(205, 732, 364, 331);
                scoop1.frame = CGRectMake(216, 714, 120, 105);
                scoop2.frame = CGRectMake(328, 707, 120, 105);
                scoop3.frame = CGRectMake(432, 707, 120, 105);
                scoop4.frame = CGRectMake(272, 648, 120, 105);
                scoop5.frame = CGRectMake(393, 639, 120, 105);
            }
                break;
                
            case 9:
            case 10:
            case 11:
            case 28:
            {
                dishImgView.frame = CGRectMake(201, 829, 364, 195);
                scoop1.frame = CGRectMake(216, 774, 120, 105);
                scoop2.frame = CGRectMake(328, 767, 120, 105);
                scoop3.frame = CGRectMake(432, 767, 120, 105);
                scoop4.frame = CGRectMake(272, 708, 120, 105);
                scoop5.frame = CGRectMake(393, 699, 120, 105);
            }
                break;
                
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            {
                dishImgView.frame = CGRectMake(189, 735, 391, 289);
                scoop1.frame = CGRectMake(216, 668, 120, 105);
                scoop2.frame = CGRectMake(328, 661, 120, 105);
                scoop3.frame = CGRectMake(432, 661, 120, 105);
                scoop4.frame = CGRectMake(268, 600, 120, 105);
                scoop5.frame = CGRectMake(389, 591, 120, 105);
            }
                break;
                
            case 17:
            case 18:
            case 19:
            case 20:
            case 21:
            case 22:
            {
                dishImgView.frame = CGRectMake(189, 735, 391, 289);
                scoop1.frame = CGRectMake(269, 663, 120, 105);
                scoop2.frame = CGRectMake(381, 656, 120, 105);
                scoop3.frame = CGRectMake(324, 591, 120, 105);
                scoop4.image = nil;
                scoop5.image = nil;
            }
                break;
                
            case 23:
            {
                dishImgView.frame = CGRectMake(189, 735, 391, 289);
                scoop1.frame = CGRectMake(324, 847, 120, 105);
                scoop2.frame = CGRectMake(268, 759, 120, 105);
                scoop3.frame = CGRectMake(380, 752, 120, 105);
                scoop4.frame = CGRectMake(316, 689, 120, 105);
                scoop5.image = nil;
            }
                break;
                
            case 24:
            {
                dishImgView.frame = CGRectMake(190, 735, 391, 289);
                scoop1.frame = CGRectMake(269, 862, 120, 105);
                scoop2.frame = CGRectMake(369, 868, 120, 105);
                scoop3.frame = CGRectMake(219, 770, 120, 105);
                scoop4.frame = CGRectMake(334, 776, 120, 105);
                scoop5.frame = CGRectMake(425, 770, 120, 105);
            }
                break;
                
            case 25:
            case 26:
            {
                dishImgView.frame = CGRectMake(189, 742, 391, 289);
                scoop1.frame = CGRectMake(324, 834, 120, 105);
                scoop2.frame = CGRectMake(266, 749, 120, 105);
                scoop3.frame = CGRectMake(379, 742, 120, 105);
                scoop4.image = nil;
                scoop5.image = nil;
            }
                break;
                
            case 27:
            {
                dishImgView.frame = CGRectMake(189, 742, 391, 289);
                scoop1.frame = CGRectMake(325, 855, 120, 105);
                scoop2.frame = CGRectMake(301, 770, 120, 105);
                scoop3.frame = CGRectMake(402, 727, 120, 105);
                scoop4.frame = CGRectMake(239, 720, 120, 105);
                scoop5.frame = CGRectMake(335, 675, 120, 105);
            }
                break;
                
            default:
                break;
        }
        
        dishImgView.frame = CGRectMake(dishImgView.frame.origin.x, dishImgView.frame.origin.y - 150, dishImgView.frame.size.width, dishImgView.frame.size.height);
        scoop1.frame = CGRectMake(scoop1.frame.origin.x, scoop1.frame.origin.y - 150, scoop1.frame.size.width, scoop1.frame.size.height);
        scoop2.frame = CGRectMake(scoop2.frame.origin.x, scoop2.frame.origin.y - 150, scoop2.frame.size.width, scoop2.frame.size.height);
        scoop3.frame = CGRectMake(scoop3.frame.origin.x, scoop3.frame.origin.y - 150, scoop3.frame.size.width, scoop3.frame.size.height);
        scoop4.frame = CGRectMake(scoop4.frame.origin.x, scoop4.frame.origin.y - 150, scoop4.frame.size.width, scoop4.frame.size.height);
        scoop5.frame = CGRectMake(scoop5.frame.origin.x, scoop5.frame.origin.y - 150, scoop5.frame.size.width, scoop5.frame.size.height);
    }
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if(popClosed == YES)
    {
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] playSoundEffect:3];
        
        UIImageView *newImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        newImage.tag = 39;
        newImage.image = [UIImage imageNamed:@"background4.png"];
        
        if(dish > 6)
        {
            UIImageView *dishTemp = [[UIImageView alloc] initWithFrame:dishImgView.frame];
            dishTemp.image = [UIImage imageNamed:[NSString stringWithFormat:@"dish%d.png", dish]];
            [dishTemp setContentMode:UIViewContentModeScaleAspectFit];
            [newImage addSubview:dishTemp];
            [dishTemp release];
        }
        
        
        UIImage *_maskingImage = [UIImage imageNamed:@"biteMask.png"];
        CALayer *_maskingLayer = [CALayer layer];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            _maskingLayer.frame = CGRectMake(touchPoint.x - 50, touchPoint.y - 50, 100, 100);
        else
            _maskingLayer.frame = CGRectMake(touchPoint.x - 30, touchPoint.y - 30, 60, 60);
        
        [_maskingLayer setContents:(id)[_maskingImage CGImage]];
        [newImage.layer setMask:_maskingLayer];
        [bitesView addSubview:newImage];
        [newImage release];
        
        [self.view bringSubviewToFront:backButton];
        [self.view bringSubviewToFront:shareButton];
        [self.view bringSubviewToFront:saveButton];
        [self.view bringSubviewToFront:homeButton];
        [self.view bringSubviewToFront:eatAgainButton];
        
        
        ///////////////////////////////////////////////////////////////////////////////////
        CAEmitterLayer *emitter = [CAEmitterLayer layer];
        emitter.emitterCells = [NSArray arrayWithObjects:[self sparkCell2], nil];
        emitter.emitterShape = kCAEmitterLayerCircle;
        emitter.emitterPosition = CGPointMake(touchPoint.x, touchPoint.y);
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            emitter.emitterSize = CGSizeMake(90, 90);
        else
            emitter.emitterSize = CGSizeMake(50, 50);
        
        emitter.renderMode = kCAEmitterLayerAdditive;
        emitter.birthRate = 1;
        [self.view.layer addSublayer:emitter];
        
        [self performSelector:@selector(stopEmitting2:) withObject:emitter afterDelay:0.3];
        ///////////////////////////////////////////////////////////////////////////////////
    }
}

#pragma mark - Particles Final Animation

- (void)stopEmitting:(CAEmitterLayer*)emitter
{
    emitter.birthRate = 0;
    [emitter performSelector:@selector(removeFromSuperlayer) withObject:nil afterDelay:3.0];
}

- (CAEmitterCell*)sparkCell
{
    CAEmitterCell *spark = [CAEmitterCell emitterCell];
    spark.contents = (id)[UIImage imageNamed:@"white-star.png"].CGImage;
    spark.birthRate = 700;
    spark.lifetime = 3;
    spark.scale = 0.1;
    spark.scaleRange = 0.2;
    spark.emissionRange = 2 * M_PI;
    spark.velocity = 180;
    spark.velocityRange = 8;
    //spark.yAcceleration = -100;
    spark.alphaRange = 0.5;
    spark.alphaSpeed = -1;
    spark.spin = 1;
    spark.spinRange = 6;
    spark.alphaRange = 0.6;
    spark.redRange = 2;
    spark.greenRange = 3;
    spark.blueRange = 3;
    [spark setName:@"spark"];
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        spark.scale = 0.25;
        spark.lifetime = 5;
        spark.velocity = 350;
    }
    return spark;
}

#pragma mark - Particles Touch

- (void)stopEmitting2:(CAEmitterLayer*)emitter
{
    emitter.birthRate = 0;
    [emitter performSelector:@selector(removeFromSuperlayer) withObject:nil afterDelay:3.0];
}

- (CAEmitterCell*)sparkCell2
{
    CAEmitterCell *spark = [CAEmitterCell emitterCell];
    spark.contents = (id)[UIImage imageNamed:@"spark.png"].CGImage;
    spark.birthRate = 400;
    spark.lifetime = 3;
    spark.scale = 0.1;
    spark.scaleRange = 0.2;
    spark.emissionRange = 2 * M_PI;
    spark.velocity = 10;
    spark.velocityRange = 5;
    spark.alphaRange = 0.5;
    spark.alphaSpeed = -1;
    spark.spin = 1;
    spark.spinRange = 6;
    spark.alphaRange = 0.8;
    spark.redRange = 2;
    spark.greenRange = 1;
    spark.blueRange = 1;
    [spark setName:@"spark"];
    return spark;
}

@end
