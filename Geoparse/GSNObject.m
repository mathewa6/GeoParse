//
//  GSNObject.m
//  JSONStage
//
//  Created by Adi Mathew on 6/19/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import "GSNObject.h"
#import "GSNAllGeometries.h"

@interface GSNObject ()

@end

@implementation GSNObject

+ (id)objectFromDictionary:(NSDictionary *)dictionary
{
    if (dictionary) {
        
        switch ([dictionary typeOfObjectContained]) {
            case kGSNGeometryTypePoint:
                return [[GSNPoint alloc] initWithCoordinates:[dictionary coordinatesOfGeometryContained]];
                break;
                
            case kGSNGeometryTypeMultiPoint:
                return [[GSNMultiPoint alloc] initWithCoordinates:[dictionary coordinatesOfGeometryContained]];
                break;
                
            case kGSNGeometryTypeLineString:
                return [[GSNLineString alloc] initWithCoordinates:[dictionary coordinatesOfGeometryContained]];
                break;
                
            case kGSNGeometryTypeMultiLineString:
                return [[GSNMultiLineString alloc] initWithCoordinates:[dictionary coordinatesOfGeometryContained]];
                break;
                
            case kGSNGeometryTypePolygon:
                return [[GSNPolygon alloc] initWithCoordinates:[dictionary coordinatesOfGeometryContained]];
                break;
                
            case kGSNGeometryTypeMultiPolygon:
                return [[GSNMultiPolygon alloc] initWithCoordinates:[dictionary coordinatesOfGeometryContained]];
                break;
                
            case kGSNGeometryTypeCollection:
                return [self objectFromArray:[dictionary geometriesContained] ofType:kGSNGeometryTypeCollection withBBox:nil];
                break;
                
            case kGSNObjectTypeFeature:
                return [[GSNFeature alloc] initWithJSONDictionary:dictionary];
                break;
                
            case kGSNObjectTypeFeatureCollection:
                return [self objectFromArray:[dictionary featuresContained] ofType:kGSNObjectTypeFeatureCollection withBBox:[dictionary boundingBox]];
                
            default:
                return [[GSNObject alloc] initWithType:[dictionary objectTypeString]
                                                   crs:[dictionary coordinateReferenceSystem]
                                                  bbox:[dictionary boundingBox]];
                break;
        }
        
        
    }
    
    return [[GSNObject alloc]init];
}

- (id<NSObject,NSCopying,NSSecureCoding,NSFastEnumeration,NSMutableCopying>)convertToJSONObject
{
    
//    TEST
    if ([self conformsToProtocol:@protocol(JSONFriendly)]) {
        return [self convertToJSONObject];
    }
    
    return nil;
    
}

+ (id)objectFromArray:(NSArray *)array ofType:(NSUInteger)type withBBox: (NSArray *)bbox
{
    
    if (array) {
        switch (type) {
            case kGSNGeometryTypeCollection:
                return [[GSNGeometryCollection alloc] initWithGeometryArray:array];
                break;
                
            case kGSNObjectTypeFeatureCollection:
                return [[GSNFeatureCollection alloc] initWithFeaturesArray:array withBBox: bbox];
                break;
                
            default:
                NSLog(@"Not a collection type");
                break;
        }
    }
    
    return [[GSNObject alloc]init];
}

- (instancetype)init
{
    self = [self initWithType:@""
                          crs:nil
                         bbox:nil];
    
    return self;
}

- (instancetype)initWithType:(NSString *)type crs:(NSDictionary *)crs bbox:(NSArray *)bbox
{
    self = [super init];
    if (self) {
        _type = type;
        _crs = crs;
        _bbox = bbox;
    }
    
    return self;
}

- (BOOL)isObjectOfType:(NSString *)type
{
    return [self.type isEqualToString:type];
}

//IMPLEMENT EQUALS,HASH,CONVERTTOJSONOBJECT.

@end
