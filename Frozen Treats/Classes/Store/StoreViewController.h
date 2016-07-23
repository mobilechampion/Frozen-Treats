//
//  StoreViewController.h
//  FairyFashion
//
//  Created by Alexandra Smau on 4/22/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface StoreViewController : UIViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    IBOutlet UIScrollView *scroll;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UIView *blockPurchasesView;
    
    SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
    NSArray *myProduct;
    
    int heightRow;
}

- (IBAction)backClick:(id)sender;
- (void)productClick:(UIButton*)sender;
- (void)requestProductData;
- (IBAction)restoreTransactions:(id)sender;

@end
