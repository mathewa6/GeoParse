//
//  NSDictionary+GSNGeometryType.m
//  JSONStage
//
//  Created by Adi Mathew on 7/5/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import "NSDictionary+GSNObjectMethods.h"

@implementation NSDictionary (GSNObjectMethods)

- (NSUInteger)typeOfObjectContained
{
    NSString *type = [self objectForKey:@"type"];
    
    if ([type isEqualToString:@"Point"]) {
        return kGSNGeometryTypePoint;
    }else if ([type isEqualToString:@"MultiPoint"]) {
        return kGSNGeometryTypeMultiPoint;
    }else if ([type isEqualToString:@"LineString"]) {
        return kGSNGeometryTypeLineString;
    }else if ([type isEqualToString:@"MultiLineString"]) {
        return kGSNGeometryTypeMultiLineString;
    }else if ([type isEqualToString:@"Polygon"]) {
        return kGSNGeometryTypePolygon;
    }else if ([type isEqualToString:@"MultiPolygon"]) {
        return kGSNGeometryTypeMultiPolygon;
    }else if ([type isEqualToString:@"GeometryColletion"]) {
        return kGSNGeometryTypeCollection;
    }else if ([type isEqualToString:@"Feature"]) {
        return kGSNObjectTypeFeature;
    }else if ([type isEqualToString:@"FeatureCollection"]) {
        return kGSNObjectTypeFeatureCollection;
    }
    else {
        NSLog(@"Collection/Unknown Type");
        [self objectTypeString];
    }

    return 0;
}

- (NSString *)objectTypeString {
    return [self objectForKey:@"type"];
}

- (NSArray *)coordinatesOfGeometryContained {
    return [self objectForKey:@"coordinates"];
}

- (NSDictionary *)coordinateReferenceSystem {
    return [self objectForKey:@"crs"];
}

- (NSArray *)boundingBox {
//    INSERT CALL TO JIAO's BBOX METHODS HERE'
//    bbox = bbox();
    return [self objectForKey:@"bbox"];
}

- (NSArray *)geometriesContained {
    return [self objectForKey:@"geometries"];
}

- (NSArray *)featuresContained {
    return [self objectForKey:@"features"];
}

-(NSString *)name {
    return [self objectForKey:@"name"];
}

@end
