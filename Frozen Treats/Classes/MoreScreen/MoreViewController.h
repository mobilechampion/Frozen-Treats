//
//  MoreViewController.h
//  Pets
//
//  Created by Ana-Maria Stoica on 4/1/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "FreeAppOfTheDAy.h"

@interface MoreViewController : UIViewController
{
   Reachability *internetReachableFoo;
    IBOutlet UIScrollView * scroll;
}
@property (nonatomic,retain) NSMutableArray * arrayOfStrings;
@property (nonatomic,retain) IBOutlet UIButton * stars;
@property (nonatomic,retain) IBOutlet UIButton * button;
@property (nonatomic,retain) IBOutlet UIImageView * freeAppOftheDay;
@property (nonatomic,retain) IBOutlet UIImageView *collect;
@property (nonatomic,retain) IBOutlet UIImageView * ray;
@property (nonatomic,retain) FreeAppOfTheDAy * free;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView * activity;
@property (nonatomic,retain) NSMutableArray * theItems;
-(IBAction)Back:(id)sender;
-(IBAction)Rate:(id)sender;
@end
