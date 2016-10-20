//
//  GSNFeature.m
//  JSONStage
//
//  Created by Adi Mathew on 7/7/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import "GSNFeature.h"

@interface GSNFeature ()

@property (nonatomic, readwrite) NSArray *cornerPoints;

@end

@implementation GSNFeature

-(NSString *)description {
    return self.name ? self.name : @"Empty Feature";
}

- (GSNObject *)geometryObject
{
    return [GSNObject objectFromDictionary:self.geometry];
}

-(GSNGeometryType)geometryType
{
    return [self.geometry typeOfObjectContained];
}

-(NSString *)title
{
    if (!_title) {
        _title = self.name;
    }
    
    return _title;
}

-(CLLocationCoordinate2D)coordinate
{
    if (self.geometryType == kGSNGeometryTypePoint) {
        _coordinate = [self.geometry[@"coordinates"] coordinate2D];
    }
    //Normally we'd compare latitude and longitude by using a differece factor epsilon, but since we're checking for uninitialized coordinates, we'll directly compare to 0.0
    if (!CLLocationCoordinate2DIsValid(_coordinate) || (_coordinate.latitude == 0.0 && _coordinate.longitude == 0.0)) {
        _coordinate = [self.bbox boundingBoxCenter];
    }
    return _coordinate;
}

-(CLLocation *)location {
    if (!_location) {
        _location = [[CLLocation alloc]initWithLatitude:self.coordinate.latitude
                                              longitude:self.coordinate.longitude];
    }
    return _location;
}

-(NSArray *)cornerPoints
{
    if (!_cornerPoints) {
        
        if (!self.geometry) {
            _cornerPoints = @[[[CLLocation alloc] initWithLatitude:[self.bbox[3] doubleValue] longitude:[self.bbox[0] doubleValue]],
                              [[CLLocation alloc] initWithLatitude:[self.bbox[1] doubleValue] longitude:[self.bbox[0] doubleValue]],
                              [[CLLocation alloc] initWithLatitude:[self.bbox[3] doubleValue] longitude:[self.bbox[2] doubleValue]],
                              [[CLLocation alloc] initWithLatitude:[self.bbox[1] doubleValue] longitude:[self.bbox[2] doubleValue]]];
        } else {
            double lowLong = DBL_MAX, lowLat = DBL_MAX;
            double hiLong =  -INFINITY, hiLat =  -INFINITY;
            double arrayOfCorrespondingValues[4] = {0.0,0.0,0.0,0.0};
            
            boundingBoxForArray(self.geometry[@"coordinates"] , &lowLong, &lowLat, &hiLong, &hiLat, arrayOfCorrespondingValues);
            _cornerPoints = @[[[CLLocation alloc] initWithLatitude:arrayOfCorrespondingValues[0] longitude:lowLong],
                              [[CLLocation alloc] initWithLatitude:lowLat longitude:arrayOfCorrespondingValues[1]],
                              [[CLLocation alloc] initWithLatitude:arrayOfCorrespondingValues[2] longitude:hiLong],
                              [[CLLocation alloc] initWithLatitude:hiLat longitude:arrayOfCorrespondingValues[3]]];
        }
        
    }
//    NSLog(@"%@",_cornerPoints);
    return _cornerPoints;
}

- (NSDictionary *)convertToJSONObject
{
    return [NSDictionary dictionaryWithObjects:@[self.type, self.identifier, self.bbox, self.properties, self.geometry]
                                       forKeys:@[@"type", @"id", @"bbox", @"properties", @"geometry"]];
}

#pragma mark - Initialization methods
- (instancetype)init
{
    return [self initWithJSONDictionary:@{}];
}

- (instancetype)initWithJSONDictionary: (NSDictionary *)feature
{
    self = [super init];
    
    if (self) {
        self.type = @"Feature";
        //Commenting this out and forcing a calculation of bbox, CAUSES FUCKALL! FIX THIS SHIT.
        self.bbox = [feature objectForKey:@"bbox"];

        _properties = [feature objectForKey:@"properties"];
        _geometry = [feature objectForKey:@"geometry"];
        _geometryTypeString = feature[@"geometry"][@"type"];
        _identifier = [feature objectForKey:@"id"];
        _name = feature[@"properties"][@"name"];
        if (!_name || [_name isEqual:[NSNull null]]) {
            _name = [feature[@"properties"][@"OFFICIAL_B"] capitalizedString];
            if (!_name || [_name isEqual:[NSNull null]]) {
                _name = feature[@"properties"][@"photo_link"];//amenity
                if (!_name || [_name isEqual:[NSNull null]]) {
                    _name = feature[@"properties"][@"service"];
                    if (!_name || [_name isEqual:[NSNull null]]) {
                        _name = feature[@"properties"][@"highway"];
                        if (!_name || [_name isEqual:[NSNull null]]) {
                            _name = feature[@"properties"][@"waterway"];
                            if (!_name || [_name isEqual:[NSNull null]]) {
                                _name = @"Unknown";
                            }
                        }
                    }
                }
            }
        }
        
        //if self.bbox is not included from file, CALCULATE it!. << potentially intensive.
        if (!self.bbox || [self.bbox isEqual:[NSNull null]]) {
            
            double lowLong = DBL_MAX, lowLat = DBL_MAX;
            double hiLong =  -INFINITY, hiLat =  -INFINITY;
            
            boundingBoxForArray(self.geometry[@"coordinates"] , &lowLong, &lowLat, &hiLong, &hiLat, NULL);
            self.bbox = @[[NSNumber numberWithDouble: lowLong], [NSNumber numberWithDouble: lowLat], [NSNumber numberWithDouble: hiLong], [NSNumber numberWithDouble: hiLat]];
        }
    }
    return self;
}

//Appears in GSNFeatureCollection as well. #QuickFix
//NEEDS TO BE MADE CONCURRENT
static void boundingBoxForArray(NSArray *array, double *lowLong, double *lowLat, double *hiLong, double *hiLat, double *arrayOfCorrespondingValues)
{
    //Variables to capture the corresponding coordinate, for the one put into a bbox.
    //This becomes complicated, because of the recursion and introspection going on.
    //Since Longitudes are read first, we have to save it's value to a temp variable(longitudeForLatitude) and then if an extreme value of
    //latitudes are picked, we assign to the passed array from the temp variable.
    
    //FOR THE SAME REASON(recursion + introspection), we do not need to set either of the flags to NO, as
    //they are popped off the stack at the end of each coordinate pair(& the next recursive call initiates.)
    __block double longitudeForLatitude;
    __block BOOL canCaptureLatitudeForLowLongitude = NO;
    __block BOOL canCaptureLatitudeForHiLongitude = NO;
    
    [array enumerateObjectsUsingBlock:^(id element, NSUInteger idx, BOOL *stop) {
        if (![element isKindOfClass:[NSArray class]]) {
            if ([element isKindOfClass:[NSNumber class]]) {
                if (idx == 0) {
                    double newLon = [element doubleValue];
                    longitudeForLatitude = newLon;

                    if ( newLon < *lowLong) {
                        *lowLong = newLon;
                        canCaptureLatitudeForLowLongitude = YES;
                    }
                    if ( newLon > *hiLong) {
                        *hiLong = newLon;
                        canCaptureLatitudeForHiLongitude = YES;
                    }
                } else if (idx == 1) {
                    double newLat = [element doubleValue];
                    
                    if (arrayOfCorrespondingValues != NULL) {
                        if (canCaptureLatitudeForLowLongitude) {
                            arrayOfCorrespondingValues[0] = newLat;
                        }
                        if (canCaptureLatitudeForHiLongitude) {
                            arrayOfCorrespondingValues[2] = newLat;
                        }
                        if (newLat < *lowLat) {
                            *lowLat = newLat;
                            arrayOfCorrespondingValues[1] = longitudeForLatitude;
                        }
                        if (newLat > *hiLat) {
                            *hiLat = newLat;
                            arrayOfCorrespondingValues[3] = longitudeForLatitude;
                        }

                    } else {
                        if (newLat < *lowLat) {
                            *lowLat = newLat;
                        }
                        if (newLat > *hiLat) {
                            *hiLat = newLat;
                        }
                    }
                }
            }
        } else {
            boundingBoxForArray(element, lowLong, lowLat, hiLong, hiLat, arrayOfCorrespondingValues);
        }
        //return; Why in blazes was this return even here... ?
    }];
}

CLLocationCoordinate2D* cornerPointsToCLLocationCoordinate2DArray(NSArray *cornerPoints)
{
    CLLocationCoordinate2D *returnArray = malloc(sizeof(CLLocationCoordinate2D) * 4);
    for (int i = 0; i < cornerPoints.count; i++) {
        CLLocation *currentLocation = (CLLocation *)cornerPoints[i];
        returnArray[i] = currentLocation.coordinate;
    }
    
    return returnArray;
}

#pragma mark - Object Methods

-(CLLocationDistance)distanceFrom:(GSNFeature *)feature {
    return [self distanceFromLocation: feature.location];
}

-(CLLocationDistance)distanceFromLocation:(CLLocation *)location {
    return [self.location distanceFromLocation: location];
}

- (BOOL)isEqualToFeature: (GSNFeature *)feature
{
    if (self == feature) {
        return YES;
    }
    
    return ([self.type isEqualToString:feature.type] &&
            [self.geometryTypeString isEqualToString:feature.geometryTypeString] &&
            [self.geometry isEqualToDictionary:feature.geometry]);
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if (![super isEqual:other]) {
        return NO;
    } else {
        return ([other isKindOfClass:[GSNFeature class]] &&
        [self isEqualToFeature:(GSNFeature *)other]);
    }
}

- (NSUInteger)hash
{
    return [self.type hash] ^ [self.geometryTypeString hash] ^ [self.geometry hash];
}

@end
