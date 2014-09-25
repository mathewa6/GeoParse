//
//  GSNFeature.m
//  JSONStage
//
//  Created by Adi Mathew on 7/7/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import "GSNFeature.h"

@interface GSNFeature ()

@property (nonatomic, readwrite, getter=isBuilding) BOOL building;

@end

@implementation GSNFeature

- (GSNObject *)geometryObject
{
    return [GSNObject objectFromDictionary:self.geometry];
}

-(GSNGeometryType)geometryType
{
    return [self.geometry typeOfObjectContained];
}

- (NSDictionary *)convertToJSONObject
{
    return [NSDictionary dictionaryWithObjects:@[self.type, self.id, self.bbox, self.properties, self.geometry]
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
        self.bbox = [feature objectForKey:@"bbox"];

        _properties = [feature objectForKey:@"properties"];
        _geometry = [feature objectForKey:@"geometry"];
        _geometryTypeString = feature[@"geometry"][@"type"];
        _id = [feature objectForKey:@"id"];
        _name = feature[@"properties"][@"name"];
        if (!_name || [_name isEqual:[NSNull null]]) {
            _name = feature[@"properties"][@"amenity"];
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
        NSString *building = feature[@"properties"][@"building"];
        _building = ( building && ![building isEqual:[NSNull null]]) ? (([building isEqualToString:@"yes"]) ? YES : NO) : NO;
        
        //if self.bbox is not included from file, CALCULATE it!. << potentially intensive.
        if (!self.bbox || [self.bbox isEqual:[NSNull null]]) {
            double lowLong = DBL_MAX, lowLat = DBL_MAX;
            double hiLong =  -INFINITY, hiLat =  -INFINITY;
            boundingBoxForArray(self.geometry[@"coordinates"] , &lowLong, &lowLat, &hiLong, &hiLat);
            self.bbox = @[[NSNumber numberWithDouble: lowLong], [NSNumber numberWithDouble: lowLat], [NSNumber numberWithDouble: hiLong], [NSNumber numberWithDouble: hiLat]];
        }
    }
    return self;
}

//Appears in GSNFeatureCollection as well. #QuickFix
static void boundingBoxForArray(NSArray *array, double *lowLong, double *lowLat, double *hiLong, double *hiLat)
{
    [array enumerateObjectsUsingBlock:^(id element, NSUInteger idx, BOOL *stop) {
        if (![element isKindOfClass:[NSArray class]]) {
            if ([element isKindOfClass:[NSNumber class]]) {
                if (idx == 0) {
                    double newLon = [element doubleValue];
                    if ( newLon < *lowLong) {
                        *lowLong = newLon;
                    }
                    if ( newLon > *hiLong) {
                        *hiLong = newLon;
                    }
                } else if (idx == 1) {
                    double newLat = [element doubleValue];
                    if (newLat < *lowLat) {
                        *lowLat = newLat;
                    }
                    if (newLat > *hiLat) {
                        *hiLat = newLat;
                    }
                }
            }
        } else {
            boundingBoxForArray(element, lowLong, lowLat, hiLong, hiLat);
        }
        return;
    }];
}

#pragma mark - Object Methods
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
