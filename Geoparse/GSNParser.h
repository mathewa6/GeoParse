//
//  GSNParser.h
//  JSONStage
//
//  Created by Adi Mathew on 7/15/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GSNParserDelegate.h"
#import "GSNObjectClasses/GSNObject.h"
#import "GSNObjectClasses/GSNObjectTypes.h"

//@protocol GSNParserDelegate;

@interface GSNParser : NSObject

@property (nonatomic, strong) NSString *type;

/**
 Reads file from app Bundle with filename parameter formatted as <filename.extensions>.
 */
- (void)parseFile:(NSString *) filename withDelegate: (id<GSNParserDelegate>)delegate;

@end