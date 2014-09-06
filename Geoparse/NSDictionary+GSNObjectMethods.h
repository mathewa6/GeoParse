//
//  NSDictionary+GSNGeometryType.h
//  JSONStage
//
//  Created by Adi Mathew on 7/5/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import "GSNObjectClasses/GSNObjectTypes.h"

@interface NSDictionary (GSNObjectMethods)

/**
 Returns the NS_ENUM value of the Object type contained IFF it is a legal
 GEOJSON geometry type.
 */
- (NSUInteger)typeOfObjectContained;
/**
 NSString of type of object. Calls -objectForKey:(id). Use if object is NOT
 a GEOJSON Geometry.
 */
- (NSString *)objectTypeString;

/**
 Returns the NSArray for the 'coordinates' key of a GeoJSON geometry Object.
 */
- (NSArray *)coordinatesOfGeometryContained;
/**
 CRS system of object, if defined. Calls -objectForKey:(id).
 */
- (NSDictionary *)coordinateReferenceSystem;
/**
 bbox of object, if defined. Calls -objectForKey:(id).
 */
- (NSArray *)boundingBox;
/**
 For use with GeometryCollections. Calls -objectForKey:(id).
 */
- (NSArray *)geometriesContained;
/**
 For use with FeatureCollections. Calls -objectForKey: (id).
 */
- (NSArray *)featuresContained;

@end
