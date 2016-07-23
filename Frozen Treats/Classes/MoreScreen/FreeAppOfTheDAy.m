//
//  FreeAppOfTheDAy.m
//  Pets
//
//  Created by Ana-Maria Stoica on 4/19/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "FreeAppOfTheDAy.h"

@implementation FreeAppOfTheDAy
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
