//
//  GSNFeature.h
//  JSONStage
//
//  Created by Adi Mathew on 7/7/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import "GSNObject.h"

@interface GSNFeature : GSNObject <JSONFriendly, MKAnnotation>

/**
 NSDictionary containing a geometry.
 */
@property (nonatomic, strong) NSDictionary *geometry;
/**
 NSDictionary of properties specific to the Feature. "name", "building", etc.
 */
@property (nonatomic, strong) NSDictionary *properties;
/**
 String member to be used as identifier as per the GeoJSON spec.
 */
@property (nonatomic, strong) NSString *identifier;

/**
 GSNObject containing a geometry object.
 */
@property (nonatomic, strong, readonly) GSNObject *geometryObject;
/**
 NSString with geometry type. Skips initialization of a new GSNObject, for typechecking.
 */
@property (nonatomic, strong) NSString *geometryTypeString;
/**
 NS_ENUM GSNGeomtry indicating the type of geometry contained.
 @see GSNObjectTypes.h
 */
@property (nonatomic) GSNGeometryType geometryType;
/**
 Name of the feature. 
 Can be accessed directly from properties[@"name"], if available.
 */
@property (nonatomic, strong) NSString *name;

/**
 MKAnnotation properties.
 */
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) CLLocation *location;

/**
 NSArray of CLLocation objects containing the corners that result in the given bbox.
 */
@property (nonatomic, strong, readonly) NSArray *cornerPoints;

- (NSDictionary *)convertToJSONObject;
- (instancetype)initWithJSONDictionary: (NSDictionary *)feature;

- (CLLocationDistance)distanceFrom: (GSNFeature *)feature;
- (CLLocationDistance)distanceFromLocation: (CLLocation *)location;

CLLocationCoordinate2D* cornerPointsToCLLocationCoordinate2DArray(NSArray *cornerPoints);

@end
