//
//  GSNPoint.h
//  JSONStage
//
//  Created by Adi Mathew on 6/21/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import "GSNObject.h"
#import "GSNPosition.h"

@interface GSNPoint : GSNObject <JSONFriendly, GSNGeometry>

/**
 NSArray containing a latitude and longitude.
 */
@property (nonatomic, strong) NSArray *coordinates;

/**
 GSNPosition with the latitude and longitude of the Point.
 */
@property (nonatomic, strong) GSNPosition *position;

#pragma mark - Initialization methods
/**
 Designated initializer. Array must be a coordinate pair(+ optional altitude).
 */
- (instancetype)initWithCoordinates: (NSArray *)coordinates NS_DESIGNATED_INITIALIZER;

#pragma mark - File write convenience methods
- (NSDictionary *)convertToJSONObject;

#pragma mark - File Parsing convenience methods
+ (instancetype)createPointWithPosition: (GSNPosition *)position;

#pragma mark - Object Methods
/**
 Returns a CLLocationCoordinate2D struct representing the point. Works ONLY if coordinates member has 2 elements: [longitude, latitude].
 */
- (CLLocationCoordinate2D)coordinate2D;
/**
 Returns MKPointAnnotation.
 */
- (MKShape *)shapeForMapKit;

@end
