//
//  GSNMultiPolygon.m
//  JSONStage
//
//  Created by Adi Mathew on 7/1/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import "GSNMultiPolygon.h"
#import "GSNPolygon.h"

@interface GSNMultiPolygon ()

@property (nonatomic, strong) NSMutableArray *polygonsMutable;

@end

@implementation GSNMultiPolygon

- (NSArray *)polygons
{
    if (!_polygonsMutable) {
        _polygonsMutable = [[NSMutableArray alloc] init];
        for (NSArray *polygon in self.coordinates) {
            [_polygonsMutable addObject:[[GSNPolygon alloc] initWithCoordinates:polygon]];
        }
    }
    return [_polygonsMutable copy];
}

#pragma mark - Initialization methods
- (instancetype)initWithCoordinates:(NSArray *)coordinates
{
    self = [super init];
    if (self) {
        self.type = @"MultiPolygon";
//        self.bbox =
        _coordinates = coordinates;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithCoordinates:@[]];
}

#pragma mark - File write convenience methods
- (NSDictionary *)convertToJSONObject
{
    return [NSDictionary dictionaryWithObjects:@[self.type, self.coordinates]
                                       forKeys:@[@"type", @"coordinates"]];
}

#pragma mark - File Parsing convenience methods
+ (instancetype)createMultiPolygonFromPolygonArray:(NSArray *)polygons
{
    NSMutableArray *jsonPolygons = [[NSMutableArray alloc] init];
    for (GSNPolygon *polygon in polygons) {
        if ([polygon isKindOfClass:[GSNPolygon class]]) {
            [jsonPolygons addObject:polygon.coordinates];
        }
    }
    return ([jsonPolygons count] == [polygons count] ? [[GSNMultiPolygon alloc] initWithCoordinates:jsonPolygons] : nil);
}

#pragma mark - Object Methods
-(NSArray *)shapeForMapKit
{
    NSMutableArray *polygons = [[NSMutableArray alloc] init];
    
    for (GSNPolygon *polygon in self.polygons) {
        [polygons addObject:[polygon shapeForMapKit]];
    }
    
    return polygons;
}

- (BOOL)isEqualToPolygon: (GSNMultiPolygon *)multiPolygon
{
    if (self == multiPolygon) {
        return YES;
    }
    
    return ([self.type isEqualToString:multiPolygon.type] &&
            [self.coordinates isEqualToArray:multiPolygon.coordinates]);
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if (![super isEqual:other]) {
        return NO;
    } else {
        return ([other isKindOfClass:[GSNMultiPolygon class]] &&
                [self isEqualToPolygon:(GSNMultiPolygon *)other]);
    }
}

- (NSUInteger)hash
{
    return [self.type hash] ^ [self.coordinates hash];
}


@end
