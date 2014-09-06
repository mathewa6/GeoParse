//
//  GSNLineString.h
//  JSONStage
//
//  Created by Adi Mathew on 7/1/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import "GSNObject.h"

@interface GSNLineString : GSNObject <JSONFriendly, GSNGeometry>

/**
 NSArray containing 2 or more coordinates.
 */
@property (nonatomic, strong) NSArray *coordinates;
/**
 Array of at least 2 GSNPoints.
 */
@property (nonatomic, strong, readonly) NSArray *points;
/**
 BOOL indicating whether 4 or more coordinates with first and last being equivalent.
 */
@property (nonatomic, readonly, getter=isLinearRing) BOOL linearRing;

#pragma mark - Initialization methods
- (instancetype)initWithCoordinates: (NSArray *)coordinates NS_DESIGNATED_INITIALIZER;

#pragma mark - File write convenience methods
- (NSDictionary *)convertToJSONObject;

#pragma mark - File Parsing convenience methods
+ (instancetype)createLineStringfromPointArray: (NSArray *)points;

#pragma mark - Object Methods
/**
 Returns an MKPolyline.
 */
- (MKShape *)shapeForMapKit;
@end
