//
//  SnowConesShapeViewController.h
//  Frozen Treats
//
//  Created by Alexandra Smau on 5/30/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnowConesShapeViewController : UIViewController
{
    IBOutlet UIScrollView *scroll;
    IBOutlet UIImageView *coneImgView;

    int cone;
    int shape;
}

@property (nonatomic) int cone;

@end
