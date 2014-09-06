//
//  GSNPosition.h
//  JSONStage
//
//  Created by Adi Mathew on 6/21/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "GSNJSONFriendly.h"

@interface GSNPosition : NSObject <JSONFriendly>

/**
 CLLocationCoordinate2D to hold latitude and longitude. Pay attention to the awkward
 ordering of longitude, latitude in GeoJSON "coordinates" arrays.
 */
@property (nonatomic) CLLocationCoordinate2D coordinate;
/**
 Optional double to hold altitude.
 */
@property (nonatomic) CLLocationDistance altitude;

#pragma mark - Initialization methods
- (instancetype)initWithLatitude: (NSNumber *)latitude
                      longitude: (NSNumber *)longitude
                       altitude: (NSNumber *)altitude NS_DESIGNATED_INITIALIZER;

#pragma mark - File write convenience methods
- (NSArray *)convertToJSONObject;

#pragma mark - File Parsing convenience methods
+ (instancetype)createPositionWithArray: (NSArray *)coordinates error: (NSError * __autoreleasing *)error;
+ (instancetype)createPositionWithArray: (NSArray *)coordinates;


@end
