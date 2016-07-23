//
//  IcecreamSandFinalViewController.m
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/21/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "IcecreamSandFinalViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Defines.h"

@implementation IcecreamSandFinalViewController
@synthesize deco, icecream, fromFridge, decorationsImage;

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"IcecreamSandFinalViewController-5" bundle:[NSBundle mainBundle]];
    else
        self = [super init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view bringSubviewToFront:backButton];
    [self.view bringSubviewToFront:shareButton];
    [self.view bringSubviewToFront:saveButton];
    [self.view bringSubviewToFront:homeButton];
    [self.view bringSubviewToFront:eatAgainButton];

    
    decoration.image = [UIImage imageNamed:[NSString stringWithFormat:@"decoSand%d.png", deco]];
    icecreamImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"iceFlavor%d.png", icecream]];
    decoration.frame = [self frameForDeco];
    if([UIScreen mainScreen].bounds.size.height == 568)
        decoration.frame = CGRectMake(decoration.frame.origin.x, decoration.frame.origin.y + 33, decoration.frame.size.width, decoration.frame.size.height);
    
    decorations.image = decorationsImage;
    
    firstTime = YES;
    saved = NO;
    
    
    int timesFinished = [[[NSUserDefaults standardUserDefaults] objectForKey:@"timesFinished"] intValue] + 1;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", timesFinished] forKey:@"timesFinished"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if(timesFinished == 3 || timesFinished == 6 || timesFinished == 9 || timesFinished == 12 || timesFinished == 15)
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] promptReview];
    
//    [Flurry logEvent:@"IceCreamSandwich_Created"];
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
                [md setObject:@"icecream_sand" forKey:@"type"];
                [md setObject:[NSString stringWithFormat:@"%d", deco] forKey:@"deco"];
                [md setObject:[NSString stringWithFormat:@"%d", icecream] forKey:@"icecream"];
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
                [md setObject:@"icecream_sand" forKey:@"type"];
                [md setObject:[NSString stringWithFormat:@"%d", deco] forKey:@"deco"];
                [md setObject:[NSString stringWithFormat:@"%d", icecream] forKey:@"icecream"];
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
                [mySLComposerSheet setInitialText:FACEBOOK_TEXT_ICECREAM_SAND];
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

- (CGRect)frameForDeco
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        switch(deco)
        {
            case 1:
            case 2:
            case 4:
                return CGRectMake(144, 333, 463, 419);
                break;
                
            case 3:
                return CGRectMake(251, 320, 312, 469);
                break;
                
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
                return CGRectMake(145, 135, 471, 817);
                break;
                
            case 10:
            case 11:
                return CGRectMake(245, 315, 287, 430);
                break;
                
            case 12:
                return CGRectMake(178, 183, 413, 692);
                break;
                
            case 13:
            case 14:
                return CGRectMake(196, 320, 350, 424);
                break;
                
            case 15:
                return CGRectMake(152, 291, 470, 476);
                break;
                
            case 16:
                return CGRectMake(210, 382, 340, 346);
                break;
                
            case 17:
                return CGRectMake(145, 309, 494, 443);
                break;
                
            case 18:
            case 19:
            case 20:
                return CGRectMake(152, 304, 478, 502);
                break;
                
            case 21:
                return CGRectMake(185, 291, 386, 477);
                break;
                
            case 22:
                return CGRectMake(185, 334, 388, 442);
                break;
                
            case 23:
                return CGRectMake(195, 347, 343, 382);
                break;
                
            case 24:
                return CGRectMake(133, 288, 503, 474);
                break;
                
            case 25:
                return CGRectMake(144, 333, 463, 419);
                break;
                
            default:
                return CGRectMake(144, 333, 463, 419);
                break;
        }
    }
    else
    {
        switch(deco)
        {
            case 1:
            case 2:
            case 4:
                return CGRectMake(27, 158, 240, 219);
                break;
                
            case 3:
                return CGRectMake(62, 173, 205, 204);
                break;
                
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
                return CGRectMake(21, 128, 255, 286);
                break;
                
            case 10:
            case 11:
                return CGRectMake(21, 147, 255, 235);
                break;
                
            case 12:
                return CGRectMake(14, 139, 260, 258);
                break;
                
            case 13:
            case 14:
                return CGRectMake(51, 156, 181, 223);
                break;
                
            case 15:
                return CGRectMake(51, 147, 194, 232);
                break;
                
            case 16:
                return CGRectMake(62, 171, 170, 194);
                break;
                
            case 17:
                return CGRectMake(43, 159, 212, 218);
                break;
                
            case 18:
            case 19:
            case 20:
                return CGRectMake(39, 149, 216, 247);
                break;
                
            case 21:
                return CGRectMake(39, 149, 216, 238);
                break;
                
            case 22:
                return CGRectMake(60, 158, 175, 219);
                break;
                
            case 23:
                return CGRectMake(62, 156, 153, 223);
                break;
                
            case 24:
                return CGRectMake(45, 142, 205, 251);
                break;
                
            case 25:
                return CGRectMake(43, 142, 211, 251);
                break;
                
            default:
                break;
        }
    }
    
    return CGRectMake(43, 142, 211, 251);
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
        newImage.image = [UIImage imageNamed:@"background3.png"];
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
