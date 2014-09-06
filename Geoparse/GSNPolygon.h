//
//  GSNPolygon.h
//  JSONStage
//
//  Created by Adi Mathew on 7/1/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import "GSNObject.h"

@interface GSNPolygon : GSNObject <JSONFriendly, GSNGeometry>

/**
 NSArray containing an array of (lat,long) coordinate arrays.
 */
@property (nonatomic, strong) NSArray *coordinates;
/**
 NSArray derived from coordinates property, containing only inner rings/holes.
 */
@property (nonatomic, strong, readonly) NSArray *innerHoles;
/**
 Array of GSNLineStrings(LinearRings) objects that make up the polygon.
 */
@property (nonatomic, strong, readonly) NSArray *linearRings;
/**
 BOOL indicating whether the polygon has internal holes.
 */
@property (nonatomic, readonly, getter=hasHoles) BOOL holes;

#pragma mark - Initialization methods
- (instancetype)initWithCoordinates: (NSArray *)coordinates NS_DESIGNATED_INITIALIZER;

#pragma mark - File write convenience methods
- (NSDictionary *)convertToJSONObject;

#pragma mark - File Parsing convenience methods
+ (instancetype)createPolygonFromLinearRingArray: (NSArray *)rings;

#pragma mark - Object Methods
/**
 Returns an MKPolygon.
 */
- (MKShape *)shapeForMapKit;
@end
