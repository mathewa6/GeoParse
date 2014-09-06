//
//  GSNMultiPolygon.h
//  JSONStage
//
//  Created by Adi Mathew on 7/1/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import "GSNObject.h"

@interface GSNMultiPolygon : GSNObject <JSONFriendly, GSNGeometry>

/**
 NSArray containing GSNPolygon arrays.
 */
@property (nonatomic, strong) NSArray *coordinates;
/**
 Array of GSNPolygons.
 */
@property (nonatomic, strong, readonly) NSArray *polygons;

#pragma mark - Initialization methods
- (instancetype)initWithCoordinates: (NSArray *)coordinates NS_DESIGNATED_INITIALIZER;

#pragma mark - File write convenience methods
- (NSDictionary *)convertToJSONObject;

#pragma mark - File Parsing convenience methods
+ (instancetype)createMultiPolygonFromPolygonArray: (NSArray *)polygons;

#pragma mark - Object Methods
/**
 Returns an NSArray of MKPolygons.
 */
- (NSArray *)shapeForMapKit;

@end
