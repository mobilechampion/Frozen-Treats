//
//  XmlParser.m
//  Pets
//
//  Created by Ana-Maria Stoica on 4/17/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "XmlParser.h"

@implementation XmlParser

@synthesize items;
@synthesize free;
- (XmlParser *)initXMLParser
{
    [super init];
    
	return self;
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	//NSLog(@"%@", elementName);
	
	if ([elementName isEqualToString:@"items"])
	{
        items = nil;
		items = [[NSMutableArray alloc]init];
	}
	
	else if ([elementName isEqualToString:@"item"])
	{
       
        
            temporary = [[MoreItem alloc]init];
    }
    else if ([elementName isEqualToString:@"itemf"])
	{
        
        
        free = [[FreeAppOfTheDAy alloc]init];
    }
	
	
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (!currentElementValue)
	{
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	}
	
	else
	{
		[currentElementValue appendString:string];
	}
	
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	//NSLog(@"currentelementValue : %@",currentElementValue);
	
    if ([elementName isEqualToString:@"items"])
	{
        
      
	}
    else if([elementName isEqualToString:@"name"])
    {
        temporary.appName = currentElementValue;
        
    }
    else if([elementName isEqualToString:@"linkitunes"])
    {
        temporary.iTunesURL = currentElementValue;
    }
    else if([elementName isEqualToString:@"linkpicture"])
    {
        temporary.picUrl = currentElementValue;
        
        
    }
    else if([elementName isEqualToString:@"facebookid"])
    {
        temporary.facebookId = currentElementValue;
        
        //   NSLog(@"data respectiva - END :  %@",temporay.start_date);
    }
	    else if ([elementName isEqualToString:@"item"])
	{
        
        MoreItem * test = [[MoreItem alloc]init];
        test.appName = temporary.appName;
        test.picUrl = temporary.picUrl ;
        test.iTunesURL = temporary.iTunesURL;
        test.facebookId = temporary.facebookId;
        [items addObject:test];
    }
    
        else if([elementName isEqualToString:@"namef"])
        {
            free.appName = currentElementValue;
            
        }
        else if([elementName isEqualToString:@"linkitunesf"])
        {
            free.iTunesURL = currentElementValue;
        }
        else if([elementName isEqualToString:@"linkpicturef"])
        {
            free.picUrl = currentElementValue;
            
            
        }
        else if([elementName isEqualToString:@"facebookidf"])
        {
            free.facebookId = currentElementValue;
            
            //   NSLog(@"data respectiva - END :  %@",temporay.start_date);
        }
	    else if ([elementName isEqualToString:@"itemf"])
        {
            
         
        }
	

	
	[currentElementValue release];
	currentElementValue = nil;
}


@end
