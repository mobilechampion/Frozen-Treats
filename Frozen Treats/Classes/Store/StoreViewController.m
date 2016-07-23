//
//  StoreViewController.m
//  FairyFashion
//
//  Created by Alexandra Smau on 4/22/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "StoreViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import <StoreKit/StoreKit.h>
#import "Defines.h"

@implementation StoreViewController

- (id)init
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
        self = [super initWithNibName:@"StoreViewController-5" bundle:[NSBundle mainBundle]];
    else
        self = [super init];
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        heightRow = 300;
    else
        heightRow = 150;
    
    if([SKPaymentQueue canMakePayments])
	{
		NSLog(@"Can buy.");
		// Display a store to the user.
		//MyStoreObserver *observer = [[MyStoreObserver alloc] init];
		//[[SKPaymentQueue defaultQueue] addTransactionObserver:observer];
		[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [self requestProductData];
	}

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([SKPaymentQueue canMakePayments])
	{
		NSLog(@"Can buy.");
		// Display a store to the user.
		//MyStoreObserver *observer = [[MyStoreObserver alloc] init];
		//[[SKPaymentQueue defaultQueue] addTransactionObserver:observer];
		[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        if(myProduct != nil)
        {
            [blockPurchasesView removeFromSuperview];
            [activityIndicator stopAnimating];
        }
	}
	else
	{
		NSLog(@"Can NOT buy.");
		// Warn the user that purchases are disabled.
		UIAlertView *actionAlert;
        actionAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"In App Purchases are not available." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[actionAlert show];
        [actionAlert release];
	}
    
   
    scroll.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, heightRow * 7 + 5 * 2);
    for(int i = 0; i < 7; i++)
    {
        BOOL notLocked = NO;
        int newi;
        switch (i)
        {
            case 0:
                newi = 5;
                
                if(((AppDelegate *)[[UIApplication sharedApplication] delegate]).frozenLocked == NO)
                    notLocked = YES;
                break;
                
            case 1:
                newi = 0;
                
                if(((AppDelegate *)[[UIApplication sharedApplication] delegate]).icecreamConesLocked == NO)
                    notLocked = YES;
                break;
                
            case 2:
                newi = 1;
                
                if(((AppDelegate *)[[UIApplication sharedApplication] delegate]).icecreamSandLocked == NO)
                    notLocked = YES;
                break;
                
            case 3:
                newi = 2;
                
                if(((AppDelegate *)[[UIApplication sharedApplication] delegate]).icecreamSundaeLocked == NO)
                    notLocked = YES;
                break;
                
            case 4:
                newi = 3;
                
                if(((AppDelegate *)[[UIApplication sharedApplication] delegate]).icePopsLocked == NO)
                    notLocked = YES;
                break;
                
            case 5:
                newi = 4;
                
                if(((AppDelegate *)[[UIApplication sharedApplication] delegate]).snowConesLocked == NO)
                    notLocked = YES;
                break;
                
            default:
                break;
        }
        
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 5 + heightRow * i /*+ 5 * i*/, [UIScreen mainScreen].bounds.size.width, heightRow)];
        button.tag = newi;
        
        if(notLocked == NO)
        {
            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"unlock_%d.png", newi]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(productClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"unlock2_%d.png", newi]] forState:UIControlStateNormal];
        
        [scroll addSubview:button];
        [button release];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction

- (IBAction)backClick:(id)sender
{
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.3f;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromLeft;
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:1];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)productClick:(UIButton*)sender
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:1];
    if([SKPaymentQueue canMakePayments])
    {
        if([myProduct count] > 0)
        {
            SKProduct *selectedProd = [myProduct objectAtIndex:sender.tag];
            
            NSLog(@"prod identifier: %@, tag: %d", selectedProd.productIdentifier, sender.tag);
            //SKPayment *payment = [SKPayment paymentWithProductIdentifier:kMyFeatureIdentifier];
            SKPayment *payment = [SKPayment paymentWithProduct:selectedProd];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        }
    }
}


#pragma mark - SKProductsRequest methods

//- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
//{
//    // remove the transaction from the payment queue.
//    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//
//    //NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
//    if (wasSuccessful)
//    {
//        // send out a notification that we’ve finished the transaction
//       // [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
//        ((FMGAppDelegate*)[[UIApplication sharedApplication] delegate]).fairyLocked = NO;
//        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"fairyLocked"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//
//    }
//    else
//    {
//        // send out a notification for the failed transaction
//        //[[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
//    }
//}

- (void)completeTransaction:(SKPaymentTransaction*)transaction
{
	// Your application should implement these two methods.
    //[self recordTransaction: transaction];
    NSLog(@"id: %@", transaction.payment.productIdentifier);
	NSLog(@"Transaction complete.");
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    
    if([transaction.payment.productIdentifier isEqualToString:kId1])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"frozenLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).frozenLocked = NO;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"icecreamConesLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).icecreamConesLocked = NO;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"icecreamSandLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).icecreamSandLocked = NO;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"icecreamSundaeLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).icecreamSundaeLocked = NO;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"icePopsLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).icePopsLocked = NO;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"snowConesLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).snowConesLocked = NO;
    }
    else if([transaction.payment.productIdentifier isEqualToString:kId2])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"icecreamConesLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).icecreamConesLocked = NO;
    }
    else if([transaction.payment.productIdentifier isEqualToString:kId3])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"icecreamSandLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).icecreamSandLocked = NO;
    }
    else if([transaction.payment.productIdentifier isEqualToString:kId4])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"icecreamSundaeLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).icecreamSundaeLocked = NO;
    }
    else if([transaction.payment.productIdentifier isEqualToString:kId5])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"icePopsLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).icePopsLocked = NO;
    }
    else if([transaction.payment.productIdentifier isEqualToString:kId6])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"snowConesLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).snowConesLocked = NO;
    }
    
    if([(AppDelegate *)[[UIApplication sharedApplication] delegate] icecreamConesLocked] == NO && [(AppDelegate *)[[UIApplication sharedApplication] delegate] icecreamSandLocked] == NO && [(AppDelegate *)[[UIApplication sharedApplication] delegate] icecreamSundaeLocked] == NO && [(AppDelegate *)[[UIApplication sharedApplication] delegate] icePopsLocked] == NO && [(AppDelegate *)[[UIApplication sharedApplication] delegate] snowConesLocked] == NO)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"frozenLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).frozenLocked = NO;
    }
    
    [self reloadScroll];
    
    UIAlertView *actionAlert = [[UIAlertView alloc] initWithTitle:@"Succes" message:@"Transaction complete!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [actionAlert show];
    [actionAlert release];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"upgraded" object:nil];
}

- (void)restoreTransaction:(SKPaymentTransaction*)transaction
{
	NSLog(@"Transaction restored.");
    NSLog(@"id: %@", transaction.payment.productIdentifier);
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    
    if([transaction.payment.productIdentifier isEqualToString:kId1])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"frozenLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).frozenLocked = NO;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"icecreamConesLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).icecreamConesLocked = NO;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"icecreamSandLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).icecreamSandLocked = NO;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"icecreamSundaeLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).icecreamSundaeLocked = NO;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"icePopsLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).icePopsLocked = NO;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"snowConesLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).snowConesLocked = NO;
    }
    else if([transaction.payment.productIdentifier isEqualToString:kId2])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"icecreamConesLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).icecreamConesLocked = NO;
    }
    else if([transaction.payment.productIdentifier isEqualToString:kId3])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"icecreamSandLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).icecreamSandLocked = NO;
    }
    else if([transaction.payment.productIdentifier isEqualToString:kId4])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"icecreamSundaeLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).icecreamSundaeLocked = NO;
    }
    else if([transaction.payment.productIdentifier isEqualToString:kId5])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"icePopsLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).icePopsLocked = NO;
    }
    else if([transaction.payment.productIdentifier isEqualToString:kId6])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"snowConesLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).snowConesLocked = NO;
    }
    [self reloadScroll];
    
    UIAlertView *actionAlert = [[UIAlertView alloc] initWithTitle:@"Succes" message:@"Transaction restored!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [actionAlert show];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:nil];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"upgraded" object:nil];
}

//- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue*)queue
//{
//    for (SKPaymentTransaction *transaction in queue.transactions)
//    {
//        NSString *productID = transaction.payment.productIdentifier;
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productID];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//
//}

- (void)failedTransaction:(SKPaymentTransaction*)transaction
{
    if(transaction.error.code != SKErrorPaymentCancelled)
    {
		UIAlertView *actionAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Product purchase failed." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[actionAlert show];
        [actionAlert release];
    }
    else
    {
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] showFullScreenAd];
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] showChartboostAd];
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)paymentQueue:(SKPaymentQueue*)queue updatedTransactions:(NSArray*)transactions
{
    for(SKPaymentTransaction *transaction in transactions)
    {
        switch(transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void)requestProductData
{
	NSLog(@"about to retrieve products...");
    //	SKProductsRequest *request = [[SKProductsRequest alloc]
    //								 initWithProductIdentifiers:
    //								 [NSSet setWithObjects: kId0, kId1, kId2, kId3, nil]];
    //	request.delegate = self;
    //	[request start];
    
    
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObjects:kId1, kId2, kId3, kId4, kId5, kId6, nil]];
    
	productsRequest.delegate = self;
	[productsRequest start];
}


- (void)productsRequest:(SKProductsRequest*)request didReceiveResponse:(SKProductsResponse*)response
{
	myProduct = response.products;
    [myProduct retain];
	//NSArray *invalidProducts = response.invalidProductIdentifiers;
	// populate UI
	NSLog(@"Products:");
    
	for (int i = 0; i < [myProduct count]; i++)
    {
        //		NSLog(@"Product title: %@" , [[myProduct objectAtIndex:i] localizedTitle]);
        //		NSLog(@"Product description: %@" , [[myProduct objectAtIndex:i] localizedDescription]);
        //		NSLog(@"Product price: %@" , [[myProduct objectAtIndex:i] price]);
		NSLog(@"Product id: %@" , [[myProduct objectAtIndex:i] productIdentifier]);
	}
    [blockPurchasesView removeFromSuperview];
    [activityIndicator stopAnimating];
}



//------------------------------------------------------------

- (IBAction)restoreTransactions:(id)sender
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:1];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark - Reload

- (void)reloadScroll
{
    for(UIView *view in [scroll subviews])
        [view removeFromSuperview];
    
    scroll.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, heightRow * 7 + 5 * 2);
    for(int i = 0; i < 7; i++)
    {
        BOOL notLocked = NO;
        int newi;
        switch (i)
        {
            case 0:
                newi = 5;
                
                if(((AppDelegate *)[[UIApplication sharedApplication] delegate]).frozenLocked == NO)
                    notLocked = YES;
                break;
                
            case 1:
                newi = 0;
                
                if(((AppDelegate *)[[UIApplication sharedApplication] delegate]).icecreamConesLocked == NO)
                    notLocked = YES;
                break;
                
            case 2:
                newi = 1;
                
                if(((AppDelegate *)[[UIApplication sharedApplication] delegate]).icecreamSandLocked == NO)
                    notLocked = YES;
                break;
                
            case 3:
                newi = 2;
                
                if(((AppDelegate *)[[UIApplication sharedApplication] delegate]).icecreamSundaeLocked == NO)
                    notLocked = YES;
                break;
                
            case 4:
                newi = 3;
                
                if(((AppDelegate *)[[UIApplication sharedApplication] delegate]).icePopsLocked == NO)
                    notLocked = YES;
                break;
                
            case 5:
                newi = 4;
                
                if(((AppDelegate *)[[UIApplication sharedApplication] delegate]).snowConesLocked == NO)
                    notLocked = YES;
                break;
                
            default:
                break;
        }
        
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 5 + heightRow * i /*+ 5 * i*/, [UIScreen mainScreen].bounds.size.width, heightRow)];
        button.tag = newi;
        
        if(notLocked == NO)
        {
            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"unlock_%d.png", newi]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(productClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"unlock2_%d.png", newi]] forState:UIControlStateNormal];
        
        [scroll addSubview:button];
        [button release];
    }
}

#pragma mark - Dealloc

- (void)dealloc
{
    [scroll release];
    [activityIndicator release];
    [blockPurchasesView release];
    [proUpgradeProduct release];
    [productsRequest release];
    [myProduct release];
    
    [super dealloc];
}


@end
