//
//  NSArray+Coordinate2D.h
//  JSONStage
//
//  Created by Adi Mathew on 7/30/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface NSArray (Coordinate2D)

//BOUNDING BOXES FORMATTED AS [lowLong, lowLat, hiLong, hiLat]

/**
 If "self" is a GeoJSON format NSArray with 2 elements, then this returns a CLLocationCoordinate2D, otherwise <null>.
 */
- (CLLocationCoordinate2D)coordinate2D;
/**
 If "self" is an array of GeoJSON format NSArray coordinates, then this returns a C array of CLLocationCoordinate2D and a pointer holding it's length.
 */
- (CLLocationCoordinate2D *)coordinate2DArrayWithLength: (NSUInteger *)length;
/**
 If "self" is a GeoJSON format bounding box NSArray with 4 elements, then this returns the center as a CLLocationCoordinate2D.
 */
- (CLLocationCoordinate2D)boundingBoxCenter;
/**
 Returns center of Bounding Box as NSString
 */
-(NSString *)boundingBoxCenterAsString;
/**
 If "self" is a GeoJSON format bounding box NSArray with 4 elements, then this returns whether the passed coordinate lies within itself or not.
 */
- (BOOL)boundingBoxContainsCoordinate2D: (CLLocationCoordinate2D)coordinate;
/**
 Returns whether self and parameter bbox intersect.
 */
-(BOOL)boundingBoxIntersectsBoundingBox: (NSArray *)bbox;
/**
 If "self" is a GeoJSON format bounding box NSArray with 4 elements, then this returns a  pointer to  a malloc'ed C Array of doubles.
 */
-(double *)boundingBoxAsCDoubleArray;

@end

@interface NSMutableArray (Coordinate2D)

/**
 If "self" is a GeoJSON format NSMutableArray with 2 elements then this returns a CLLocationCoordinate2D.
 */
- (CLLocationCoordinate2D)coordinate2D;
/**
 If "self" is an array of GeoJSON format NSMutableArray coordinates, then this returns a C array of CLLocationCoordinate2D.
 */
- (CLLocationCoordinate2D *)coordinate2DArrayWithLength: (NSUInteger *)length;
/**
 If "self" is a GeoJSON format bounding box NSMutableArray with 4 elements then this returns the center as a CLLocationCoordinate2D.
 */
- (CLLocationCoordinate2D)boundingBoxCenter;
/**
 Returns center of Bounding Box as NSString
 */
-(NSString *)boundingBoxCenterAsString;
/**
 If "self" is a GeoJSON format bounding box NSMutableArray with 4 elements, then this returns whether the passed coordinate lies within itself or not.
 */
- (BOOL)boundingBoxContainsCoordinate2D: (CLLocationCoordinate2D)coordinate;
/**
 Returns whether self and parameter bbox intersect.
 */
-(BOOL)boundingBoxIntersectsBoundingBox: (NSArray *)bbox;
/**
 If "self" is a GeoJSON format bounding box NSArray with 4 elements, then this returns a  pointer to  a malloc'ed C Array of doubles.
 */
-(double *)boundingBoxAsCDoubleArray;


@end