//
//  UAModalExampleView.h
//  UAModalPanel
//
//  Created by Matt Coneybeare on 1/8/12.
//  Copyright (c) 2012 Urban Apps. All rights reserved.
//

#import "UATitledModalPanel.h"
//#import "iCarousel.h"

@interface UAExampleModalPanel : UATitledModalPanel <UITableViewDataSource> {
	UIView			*v;
	IBOutlet UIView	*viewLoadedFromXib;
}

@property (nonatomic, retain) IBOutlet UIView *viewLoadedFromXib;
@property (nonatomic,assign) int theTag;
@property (nonatomic, retain) NSMutableArray *items2;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title andPurchaseTag:(int)tag andCustom:(BOOL)custom;
- (IBAction)buttonPressed:(id)sender;
- (void)closeIt;
- (void)setupStuff3;
- (void)setupStuff2;

@end
