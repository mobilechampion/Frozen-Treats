//
//  UAModalExampleView.m
//  UAModalPanel
//
//  Created by Matt Coneybeare on 1/8/12.
//  Copyright (c) 2012 Urban Apps. All rights reserved.
//

#import "UAExampleModalPanel.h"
#import "AppDelegate.h"

#define BLACK_BAR_COMPONENTS				{ 0.22, 0.22, 0.22, 1.0, 0.07, 0.07, 0.07, 1.0 }
#define textAll @"Or Unlock Everything, \n Remove Ads and Save Money!"

@implementation UAExampleModalPanel

@synthesize viewLoadedFromXib;
@synthesize theTag;
@synthesize items2;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title andPurchaseTag:(int)tag andCustom:(BOOL)custom{
	if ((self = [super initWithFrame:frame]))
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeIt) name:@"update" object:nil];
        
        self.items2 = [NSMutableArray array];
        for (int i = 1; i < 5; i++)
        {
            [items2 addObject:[NSNumber numberWithInt:i]];
        }
        self.padding = UIEdgeInsetsMake(-30.0, 20.0, -10.0, 20.0);
		//self.headerLabel.text = title;
       // self.headerLabel.font = [UIFont fontWithName:@"TriniganFG" size:14.0];
        if (custom) {
            self.padding = UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0);
            self.headerLabel.text = title;
            self.headerLabel.numberOfLines = 2;
            self.headerLabel.font = [UIFont fontWithName:@"UsuziItalic" size:8.0];
        }
		self.theTag = tag;
		
		////////////////////////////////////
		// RANDOMLY CUSTOMIZE IT
		////////////////////////////////////
		// Show the defaults mostly, but once in awhile show a completely random funky one
		//if (arc4random() % 4 == 0) {
			// Funky time.
			UADebugLog(@"Showing a randomized panel for modalPanel: %@", self);
			
			// Margin between edge of container frame and panel. Default = {20.0, 20.0, 20.0, 20.0}
			self.margin = UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0);
			
			// Margin between edge of panel and the content area. Default = {20.0, 20.0, 20.0, 20.0}
			
			
			// Border color of the panel. Default = [UIColor whiteColor]
			self.borderColor = [UIColor clearColor];
			
			// Border width of the panel. Default = 1.5f;
			self.borderWidth = 1.5f;
			
			// Corner radius of the panel. Default = 4.0f
			self.cornerRadius =  4.0f;
			
			// Color of the panel itself. Default = [UIColor colorWithWhite:0.0 alpha:0.8]
			self.contentColor = [UIColor clearColor];
			
			// Shows the bounce animation. Default = YES
			self.shouldBounce = YES;
			
			// Shows the actionButton. Default title is nil, thus the button is hidden by default
			[self.actionButton setTitle:@"SHARE" forState:UIControlStateNormal];
        
            //[self.actionButton.titleLabel setFont:[UIFont fontWithName:@"TriniganFG" size:16.0]];

			// Height of the title view. Default = 40.0f
			[self setTitleBarHeight:40.0f];

			[self headerLabel].font = [UIFont fontWithName:@"UsuziItalic" size:14.0];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [self headerLabel].font = [UIFont fontWithName:@"UsuziItalic" size:30.0];
        }
        
        if (custom) {
           self.contentContainer.image = [UIImage imageNamed:@"pop.png"];
        }
		
	}	
	return self;
}

- (void)setupStuff2
{
    self.headerLabel.textColor = [UIColor colorWithRed:10.0f/255.0f green:15.0f/255.0f blue:174.0f/255.0f alpha:1.0f];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [self headerLabel].font = [UIFont systemFontOfSize:40];
    else
        [self headerLabel].font = [UIFont systemFontOfSize:18];
    
    UILabel *row1 = [[UILabel alloc] initWithFrame:CGRectMake(-10, 50, 240, 50)];
    row1.text = @"We've got a special deal for you!";
    row1.textColor = [UIColor colorWithRed:10.0f/255.0f green:15.0f/255.0f blue:174.0f/255.0f alpha:1.0f];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        row1.font = [UIFont systemFontOfSize:30];
        row1.frame = CGRectMake(120, 160, 700, 200);
    }
    else
    {
        row1.font = [UIFont systemFontOfSize:15];
        row1.frame = CGRectMake(20, 30, 240, 50);
    }
    row1.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:row1];
    [row1 release];

    
    UITextView *text = [[UITextView alloc] init];
    text.userInteractionEnabled = NO;
    text.backgroundColor = [UIColor clearColor];
    text.textColor = [UIColor colorWithRed:10.0f/255.0f green:15.0f/255.0f blue:174.0f/255.0f alpha:1.0f];
    text.text = @"Do you want to unlock all the makers at a great price and never see any ads ever again?";
    text.textAlignment = NSTextAlignmentCenter;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        text.font = [UIFont systemFontOfSize:30];
        text.frame = CGRectMake(-10, 300, 700, 200);
    }
    else
    {
        text.font = [UIFont systemFontOfSize:15];
        text.frame = CGRectMake(0, 75, 240, 200);
    }
    [self.contentView addSubview:text];
    [text release];
    
    
    UIButton *testButton = [[UIButton alloc] init];
    [testButton setBackgroundImage:[UIImage imageNamed:@"noThanks.png"] forState:UIControlStateNormal];
    testButton.frame = CGRectMake(20, 155, 200, 60);
    testButton.tag = theTag;
    testButton.exclusiveTouch = YES;
    [testButton addTarget:self action:@selector(closeIt) forControlEvents:UIControlEventTouchUpInside];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        testButton.frame = CGRectMake(250, 420, 200, 100);
    }

    [self.contentView addSubview:testButton];
    [testButton release];

    
    UIButton *unlockAll = [[UIButton alloc] initWithFrame:CGRectMake(97-40 - 60, 250 - 35, 250, 140)];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        unlockAll.frame = CGRectMake(100, 550, 500, 280);
    
    unlockAll.exclusiveTouch = YES;
    [unlockAll setBackgroundImage:[UIImage imageNamed:@"locked.png"] forState:UIControlStateNormal];
    [unlockAll addTarget:self action:@selector(unlockEverything) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:unlockAll];
    [unlockAll release];
}

- (void)setupStuff3
{
    self.headerLabel.textColor = [UIColor colorWithRed:10.0f/255.0f green:15.0f/255.0f blue:174.0f/255.0f alpha:1.0f];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [self headerLabel].font = [UIFont systemFontOfSize:40];
    else
        [self headerLabel].font = [UIFont systemFontOfSize:20];
    
    
    UIButton *testButton = [[UIButton alloc] init];
    [testButton setBackgroundImage:[UIImage imageNamed:@"buttonpop.png"] forState:UIControlStateNormal];
    [testButton setTitle:@"4.99$" forState:UIControlStateNormal];
    [testButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    testButton.frame = CGRectMake(40, 0 + 50, 160, 60);
    testButton.tag = theTag;
    testButton.exclusiveTouch = YES;
    [testButton addTarget:self action:@selector(unlockPack:) forControlEvents:UIControlEventTouchUpInside];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        testButton.frame = CGRectMake(250, 0 + 220, 200, 100);
    }
    
    testButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:testButton];
    [testButton release];
    
    
    UITextView *text = [[UITextView alloc] init];
    text.userInteractionEnabled = NO;
    text.backgroundColor = [UIColor clearColor];
    text.textColor = [UIColor colorWithRed:10.0f/255.0f green:15.0f/255.0f blue:174.0f/255.0f alpha:1.0f];
    text.text = textAll;
    text.textAlignment = NSTextAlignmentCenter;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        text.font = [UIFont systemFontOfSize:30];
        text.frame = CGRectMake(-10, 400, 700, 200);
    }
    else
    {
        text.font = [UIFont systemFontOfSize:15];
        text.frame = CGRectMake(0, 100 + 45, 240, 200);
    }
    [self.contentView addSubview:text];
    [text release];

    
    UIButton *unlockAll = [[UIButton alloc] initWithFrame:CGRectMake(97-40 - 60, 250 - 35, 250, 140)];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        unlockAll.frame = CGRectMake(100, 550, 500, 280);
    
    unlockAll.exclusiveTouch = YES;
    [unlockAll setBackgroundImage:[UIImage imageNamed:@"locked.png"] forState:UIControlStateNormal];
    [unlockAll addTarget:self action:@selector(unlockEverything) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:unlockAll];
    [unlockAll release];
}

#pragma mark -

- (void)unlockPack:(UIButton*)sender
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:1];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(14 + 2  + 56 , 6, 56, 48)];
    button.tag = sender.tag;
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).store productClick:button];
}

- (void)unlockEverything
{
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) playSoundEffect:1];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(14 + 2  + 56 , 6, 56, 48)];
    button.tag = 5;
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).store productClick:button];
}

- (void)closeIt
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super closePressed:nil];
}

- (void)dealloc
{
    [v release];
	[viewLoadedFromXib release];
    [super dealloc];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	[v setFrame:self.contentView.bounds];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier = @"UAModalPanelCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil)
    {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
	}
	
	[cell.textLabel setText:[NSString stringWithFormat:@"Row %d", indexPath.row]];
	
	return cell;
}



#pragma mark - Actions
- (IBAction)buttonPressed:(id)sender {
	// The button was pressed. Lets do something with it.
	
	// Maybe the delegate wants something to do with it...
	if ([delegate respondsToSelector:@selector(superAwesomeButtonPressed:)]) {
		[delegate performSelector:@selector(superAwesomeButtonPressed:) withObject:sender];
	
	// Or perhaps someone is listening for notifications 
	} else {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"SuperAwesomeButtonPressed" object:sender];
	}
		
	NSLog(@"Super Awesome Button pressed!");
}

@end
