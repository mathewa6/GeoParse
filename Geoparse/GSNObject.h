//
//  GSNObject.h
//  JSONStage
//
//  Created by Adi Mathew on 6/19/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "GSNJSONFriendly.h"
#import "GSNGeometry.h"
#import "GSNCRSObject.h"

@interface GSNObject : NSObject <JSONFriendly>

/**
 NSString that determines the "type" of the GeoJSON object. "Point", "Polygon", etc.
 */
@property (nonatomic, strong) NSString *type;
/**
 GSNCRSObject containing the Coordinate Reference System object with "type" and "properties".
 */
@property (nonatomic, strong) NSDictionary *crs;
/**
 NSArray containing bounding box
 */
@property (nonatomic, strong) NSArray *bbox;

- (instancetype)initWithType:(NSString *)type crs:(NSDictionary *)crs bbox:(NSArray *)bbox;
- (BOOL)isObjectOfType: (NSString *)type;

+ (id)objectFromDictionary: (NSDictionary *)dictionary;
+ (id)objectFromArray: (NSArray *)array ofType: (NSUInteger)geometryType withBBox: (NSArray *)bbox;

@end
