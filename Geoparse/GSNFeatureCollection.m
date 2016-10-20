//
//  GSNFeatureCollection.m
//  JSONStage
//
//  Created by Adi Mathew on 7/7/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import "GSNFeatureCollection.h"

@interface GSNFeatureCollection ()

@property (nonatomic, assign) GSNFeatureCollectionType collectionType;
@property (nonatomic, strong) NSMutableArray *featureObjectsMutable;

@end

@implementation GSNFeatureCollection

- (NSArray *)featureObjects
{
    if (!_featureObjectsMutable) {
        _featureObjectsMutable = [[NSMutableArray alloc] init];
        switch (_collectionType) {
            case kGSNFeatureCollectionTypeBuilding:
                for (NSDictionary *feature in self.features) {
                    [_featureObjectsMutable addObject:[[GSNBuildingFeature alloc] initWithJSONDictionary:feature]];
                }
                break;
                
            case kGSNFeatureCollectionTypeEntrance:
                for (NSDictionary *feature in self.features) {
                    [_featureObjectsMutable addObject:[[GSNEntranceFeature alloc] initWithJSONDictionary:feature]];
                }
                break;
                
            default:
                for (NSDictionary *feature in self.features) {
                    [_featureObjectsMutable addObject:[[GSNFeature alloc] initWithJSONDictionary:feature]];
                }
                break;
        }
        
    }
    
    return _featureObjectsMutable;
}

- (instancetype)initWithFeaturesArray:(NSArray *)features withBBox:(NSArray *)bbox named:(NSString *)name
{
    self = [super init];
    if (self) {
        self.type = @"FeatureCollection";
        self.bbox = bbox;
        _name = name;
        if ([name isEqualToString:@"buildings"]) {
            _collectionType = kGSNFeatureCollectionTypeBuilding;
        } else if ([name isEqualToString:@"entrances"]) {
            _collectionType = kGSNFeatureCollectionTypeEntrance;
        }
        _features = features;
        
        //if self.bbox is not included from file, CALCULATE it!. << potentially intensive.
        if (!self.bbox || [self.bbox isEqual:[NSNull null]]) {
            double lowLong = DBL_MAX, lowLat = DBL_MAX;
            double hiLong =  -INFINITY, hiLat =  -INFINITY;
            for (NSDictionary *feature in features) {
                boundingBoxForArray(feature[@"geometry"][@"coordinates"], &lowLong, &lowLat, &hiLong, &hiLat);
            }
            self.bbox = @[[NSNumber numberWithDouble: lowLong], [NSNumber numberWithDouble: lowLat], [NSNumber numberWithDouble: hiLong], [NSNumber numberWithDouble: hiLat]];

        }
    }
    return self;
}

//Appears in GSNFeature as well. #QuickFix
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

- (instancetype)init
{
    return [self initWithFeaturesArray:@[] withBBox:@[] named:@""];
}

- (NSDictionary *)convertToJSONObject
{
    return [NSDictionary dictionaryWithObjects:@[self.type, self.features]
                                       forKeys:@[@"type", @"features"]];
}

#pragma mark - Object Methods
- (BOOL)isEqualToFeatureCollection: (GSNFeatureCollection *)featureCollection
{
    if (self == featureCollection) {
        return YES;
    }
    
    return ([self.type isEqualToString:featureCollection.type] &&
            [self.features isEqualToArray:featureCollection.features]);
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if (![super isEqual:other]) {
        return NO;
    } else {
        return ([other isKindOfClass:[GSNFeatureCollection class]] &&
                [self isEqualToFeatureCollection:(GSNFeatureCollection *)other]);
    }
}

- (NSUInteger)hash
{
    return [self.type hash] ^ [self.features hash];
}

@end
