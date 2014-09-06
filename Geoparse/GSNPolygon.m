//
//  GSNPolygon.m
//  JSONStage
//
//  Created by Adi Mathew on 7/1/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import "GSNPolygon.h"
#import "GSNLineString.h"
#import "NSArray+Coordinate2D.h"

@interface GSNPolygon ()

@property (nonatomic, strong) NSMutableArray *linearRingsMutable;

@property (nonatomic, readwrite, getter=hasHoles) BOOL holes;

@property (nonatomic, getter=islegalPolygon) BOOL legalPolygon;

@end

@implementation GSNPolygon

@synthesize innerHoles = _innerHoles;

-(NSArray *)innerHoles
{
    if (!_innerHoles) {
        _innerHoles = [self.coordinates subarrayWithRange:NSMakeRange(1, [self.coordinates count] - 1)];
    }
    
    return _innerHoles;
}

- (NSMutableArray *)linearRings
{
    if (!_linearRingsMutable) {
        _linearRingsMutable = [[NSMutableArray alloc] init];
        for (NSArray *ring in self.coordinates) {
            [_linearRingsMutable addObject:[[GSNLineString alloc] initWithCoordinates:ring]];
        }
    }
    return [_linearRingsMutable copy];
}

- (BOOL)hasHoles
{
    if (!_holes) {
        _holes = !([self.coordinates count] == 1);
    }
    return _holes;
}

#pragma mark - Initialization methods
- (instancetype)initWithCoordinates:(NSArray *)coordinates
{
    self = [super init];
    if (self) {
        self.type = @"Polygon";
//        self.bbox =
        _legalPolygon = YES;
        for (NSArray *line in coordinates) {
            if (!([line count] >=4 && [[line firstObject] isEqualToArray:[line lastObject]])) {
                _legalPolygon = NO;
//                NSERROR HERE
                break;
            }
        }
        _coordinates = _legalPolygon ? coordinates : nil;
        
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
/**
 POSSIBLE  ERROR
 */
+(instancetype)createPolygonFromLinearRingArray:(NSArray *)rings
{
    NSMutableArray *jsonRings = [[NSMutableArray alloc] init];
    for (GSNLineString *ring in rings) {
        if ([ring isKindOfClass:[GSNLineString class]]) {
            [jsonRings addObject:ring.coordinates];
        }
    }
    
    return ([jsonRings count] == [rings count] ? [[GSNPolygon alloc] initWithCoordinates:jsonRings] : nil);
}

#pragma mark - Object Methods
-(MKShape *)shapeForMapKit
{
    NSMutableArray *innerPolygons = nil;
    if (self.hasHoles) {
        innerPolygons = [[NSMutableArray alloc] init];
        for (NSArray *innerHole in self.innerHoles) {
            CLLocationCoordinate2D *coordinate2DArray = NULL;
            NSUInteger coordinateArrayLength = 0;
            arrayToCoordinate2DArray(innerHole, &coordinate2DArray, &coordinateArrayLength);
            
            [innerPolygons addObject:[MKPolygon polygonWithCoordinates:coordinate2DArray count:coordinateArrayLength]];
            free(coordinate2DArray);
        }
    }
    
    CLLocationCoordinate2D *coordinate2DArray = NULL;
    NSUInteger coordinateArrayLength = 0;
    arrayToCoordinate2DArray(self.coordinates[0], &coordinate2DArray, &coordinateArrayLength);
    MKPolygon *polygon = [MKPolygon polygonWithCoordinates:coordinate2DArray count:coordinateArrayLength interiorPolygons:innerPolygons];
    free(coordinate2DArray);
    
    return polygon;
}

//Redundant function found in NSArray+Coordinate2D.h, that includes array element type checking.
static void arrayToCoordinate2DArray(NSArray *array, CLLocationCoordinate2D **coordinate2DArray, NSUInteger *length)
{
    NSUInteger read = 0, space = 10;
    CLLocationCoordinate2D *coordinates = malloc(sizeof(CLLocationCoordinate2D) * space);
    
    for (NSArray *coordinate in array) {
        if (read == space) {
            space *= 2;
            coordinates = realloc(coordinates, sizeof(CLLocationCoordinate2D)*space);
        }
        
        coordinates[read++] = [coordinate coordinate2D];
    }
    
    *coordinate2DArray = coordinates;
    *length = read;
    
}

- (BOOL)isEqualToPolygon: (GSNPolygon *)polygon
{
    if (self == polygon) {
        return YES;
    }
    
    return ([self.type isEqualToString:polygon.type] &&
            [self.coordinates isEqualToArray:polygon.coordinates]);
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if (![super isEqual:other]) {
        return NO;
    } else {
        return ([other isKindOfClass:[GSNPolygon class]] &&
                [self isEqualToPolygon:(GSNPolygon *)other]);
    }
}

- (NSUInteger)hash
{
    return [self.type hash] ^ [self.coordinates hash];
}

@end
