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
 Reads file from app Bundle with filename parameter formatted as <filename.extensions>.
 */
- (void)parseFile:(NSString *) filename;

@end