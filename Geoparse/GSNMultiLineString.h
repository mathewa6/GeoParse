//
//  GSNMultiLineString.h
//  JSONStage
//
//  Created by Adi Mathew on 7/1/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import "GSNObject.h"

@interface GSNMultiLineString : GSNObject <JSONFriendly, GSNGeometry>

/**
 NSArray containing linestring coordinate arrays.
 */
@property (nonatomic, strong) NSArray *coordinates;
/**
 NSArray of GSNLineString objects.
 */
@property (nonatomic, strong, readonly) NSArray *lineStrings;

#pragma mark - Initialization methods
- (instancetype)initWithCoordinates: (NSArray *)coordinates NS_DESIGNATED_INITIALIZER;

#pragma mark - File write convenience methods
- (NSDictionary *)convertToJSONObject;

#pragma mark - File Parsing convenience methods
+ (instancetype)createMultiLineStringFromLineStringArray: (NSArray *)lines;

@end
