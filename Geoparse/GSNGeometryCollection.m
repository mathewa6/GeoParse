//
//  GSNGeometryCollection.m
//  JSONStage
//
//  Created by Adi Mathew on 7/8/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import "GSNGeometryCollection.h"

@interface GSNGeometryCollection ()

@property (nonatomic, strong) NSMutableArray *geometryObjectsMutable;

@end

@implementation GSNGeometryCollection

- (NSArray *)geometryObjects
{
    if (!_geometryObjectsMutable) {
        _geometryObjectsMutable = [[NSMutableArray alloc] init];
        for (NSDictionary *geometry in self.geometries) {
            [_geometryObjectsMutable addObject:[GSNObject  objectFromDictionary:geometry]];
        }
    }
    return [_geometryObjectsMutable copy];
}

- (instancetype)initWithGeometryArray:(NSArray *)geometries
{
    self = [super init];
    if (self) {
        self.type = @"GeometryCollection";
//        self.bbox =
        _geometries = geometries;
    }
    return self;
}

- (NSDictionary *)convertToJSONObject
{
    return [NSDictionary dictionaryWithObjects:@[self.type, self.geometries]
                                       forKeys:@[@"type", @"geometries"]];
}

#pragma mark - Object Methods
- (BOOL)isEqualToGeometryCollection: (GSNGeometryCollection *)geometryCollection
{
    if (self == geometryCollection) {
        return YES;
    }
    
    return ([self.type isEqualToString:geometryCollection.type] &&
            [self.geometries isEqualToArray:geometryCollection.geometries]);
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if (![super isEqual:other]) {
        return NO;
    } else {
        return ([other isKindOfClass: [GSNGeometryCollection class]] &&
                [self isEqualToGeometryCollection:(GSNGeometryCollection *)other]);
    }
}

- (NSUInteger)hash
{
    return [self.type hash] ^ [self.geometries hash];
}

@end
