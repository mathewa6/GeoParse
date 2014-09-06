//
//  GSNMultiPoint.h
//  JSONStage
//
//  Created by Adi Mathew on 7/1/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import "GSNObject.h"

@interface GSNMultiPoint : GSNObject <JSONFriendly, GSNGeometry>

/**
 NSArray containing an array of coordinates.
 */
@property (nonatomic, strong) NSArray *coordinates;
/**
 Array of GSNPoints.
 */
@property (nonatomic, strong, readonly) NSArray *points;

#pragma mark - Initialization methods
- (instancetype)initWithCoordinates: (NSArray *)coordinates NS_DESIGNATED_INITIALIZER;

#pragma mark - File write convenience methods
- (NSDictionary *)convertToJSONObject;

#pragma mark - File Parsing convenience methods
+ (instancetype)createMultiPointfromPointArray: (NSArray *)points;

@end
