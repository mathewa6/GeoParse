//
//  GSNParser.h
//  JSONStage
//
//  Created by Adi Mathew on 7/15/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GSNParserDelegate.h"
#import "GSNObject.h"
#import "GSNAllGeometries.h"

@interface GSNParser : NSObject

@property (nonatomic, weak) id<GSNParserDelegate> delegate;

/**
 Reads file from app Bundle with filename parameter formatted as @"filename.geojson".
 */
- (void)parseFile: (NSString *) filename; // withDelegate: (id<GSNParserDelegate>)delegate;
/**
 Reads file from a web URL and passes it to delegate when done.
 */
- (void)parseURL: (NSString *) url; // withDelegate: (id<GSNParserDelegate>)delegate;

@end