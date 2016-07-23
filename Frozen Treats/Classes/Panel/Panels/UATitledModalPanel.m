//
//  UAModalTitledDisplayPanelView.m
//  UAModalPanel
//
//  Created by Matt Coneybeare on 1/8/12.
//  Copyright (c) 2012 Urban Apps. All rights reserved.
//

#import "UATitledModalPanel.h"
#import <QuartzCore/QuartzCore.h>

#define DEFAULT_TITLE_BAR_HEIGHT	40.0f

@implementation UATitledModalPanel

@synthesize titleBarHeight, titleBar, headerLabel;

- (void)dealloc {
    self.titleBar = nil;
	self.headerLabel = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
		self.titleBarHeight = DEFAULT_TITLE_BAR_HEIGHT;
		
		//CGFloat colors[8] = { 1, 1, 1, 1, 0, 0, 0, 1 };
//		self.titleBar = [UANoisyGradientBackground gradientWithFrame:CGRectZero
//															   style:UAGradientBackgroundStyleLinear
//															   color:colors
//															lineMode:UAGradientLineModeTopAndBottom
//														noiseOpacity:0.2
//														   blendMode:kCGBlendModeNormal];
        self.titleBar = [[UIView alloc]initWithFrame:CGRectZero];
        self.titleBar.backgroundColor = [UIColor clearColor];
		
		[self.roundedRect addSubview:self.titleBar];
		
		self.headerLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
		self.headerLabel.font = [UIFont systemFontOfSize:24];
		self.headerLabel.backgroundColor = [UIColor clearColor];
		self.headerLabel.textColor = [UIColor whiteColor];
		self.headerLabel.shadowColor = [UIColor blackColor];
		self.headerLabel.shadowOffset = CGSizeMake(0, -1);
		self.headerLabel.textAlignment = NSTextAlignmentCenter;
		[self.titleBar addSubview:self.headerLabel];

		
    }
    return self;
}



- (CGRect)titleBarFrame { 
	CGRect frame = [self.roundedRect bounds];
	return CGRectMake(frame.origin.x,
					  frame.origin.y + self.roundedRect.layer.borderWidth,
					  frame.size.width,
					  self.titleBarHeight - self.roundedRect.layer.borderWidth);
}


// overriding the subclass to make room for the title bar
- (CGRect)contentViewFrame {
	CGRect titleBarFrame = [self titleBarFrame];
	CGRect roundedRectFrame = [self roundedRectFrame];
	CGFloat y = titleBarFrame.origin.y + titleBarFrame.size.height;
	CGRect rect = CGRectMake(self.margin.left + self.padding.left,
							 self.margin.top + self.padding.top + y,
							 roundedRectFrame.size.width - self.padding.left - self.padding.right,
							 roundedRectFrame.size.height - y - self.padding.bottom - self.padding.bottom);
	return rect;
}


- (void)layoutSubviews {
	[super layoutSubviews];
	
	self.titleBar.frame = [self titleBarFrame];
    CGRect frame = self.titleBar.bounds;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        frame.origin.y += 180;
    else
        frame.origin.y += 50;
    
    self.headerLabel.frame = frame;
}


// Overrides

- (void)showAnimationStarting {
	self.contentView.alpha = 0.0;
	self.titleBar.alpha = 0.0;
}

- (void)showAnimationFinished {
	UADebugLog(@"Fading in content for modalPanel: %@", self);
	[UIView animateWithDuration:0.2
						  delay:0.0
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 self.contentView.alpha = 1.0;
						 self.titleBar.alpha = 1.0;
					 }
					 completion:nil];
}


@end
