//
//  XmlParser.h
//  Pets
//
//  Created by Ana-Maria Stoica on 4/17/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MoreItem.h"
#import "FreeAppOfTheDAy.h"
@class MoreItem;
@class FreeAppOfTheDAy;

@interface XmlParser : NSObject<NSXMLParserDelegate>
{
    NSMutableString *currentElementValue;
    NSMutableArray * items;
    MoreItem * temporary;
    FreeAppOfTheDAy * free;
}
@property (nonatomic,retain) NSMutableArray * items;
@property (nonatomic,retain) FreeAppOfTheDAy * free;
- (XmlParser *) initXMLParser;
@end
