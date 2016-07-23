//
//  MoreItem.m
//  Pets
//
//  Created by Ana-Maria Stoica on 4/17/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "MoreItem.h"

@implementation MoreItem
@synthesize appName;
@synthesize picUrl;
@synthesize iTunesURL;
@synthesize facebookId;

-(void)dealloc
{
    [appName release];
    [picUrl release];
    [iTunesURL release];
    [facebookId release];
    [super dealloc];
}

@end
