//
//  GSNLineString.m
//  JSONStage
//
//  Created by Adi Mathew on 7/1/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import "GSNLineString.h"
#import "GSNPoint.h"
#import "GSNErrors.h"
#import "NSArray+Coordinate2D.h"

@interface GSNLineString ()

/**
 Mutable array of GSNPoints.
 */
@property (nonatomic, strong) NSMutableArray *pointsMutable;
@property (nonatomic, readwrite, getter=isLinearRing) BOOL linearRing;
@end

@implementation GSNLineString

- (BOOL)isLinearRing
{
    if (!_linearRing) {
        _linearRing = [self.coordinates count] >=4 && [[self.coordinates firstObject] isEqualToArray:[self.coordinates lastObject]];
    }
    
    return _linearRing;
}

- (NSArray *)points
{
    if (!_pointsMutable) {
        _pointsMutable = [[NSMutableArray alloc] init];
        if ([self.coordinates count] >= 2) {
            for (NSArray *position in self.coordinates) {
                [_pointsMutable addObject:[GSNPoint createPointWithPosition:[GSNPosition createPositionWithArray:position
                                                                                                          error:NULL]]];
            }
        } else {
            NSLog(@"'coordinates' member has less than 2 elements.");
            return nil;
        }
        
    }
    return [_pointsMutable copy];
}


#pragma mark - Initialization methods
- (instancetype)initWithCoordinates:(NSArray *)coordinates
{
    self = [super init];
    if (self) {
        self.type = @"LineString";
//        self.bbox =
        _coordinates = [coordinates count] >=2 ? coordinates : nil;
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
 POSSIBLE ERROR
 */
+ (instancetype)createLineStringfromPointArray:(NSArray *)points
{
    if ([points count] >= 2) {
        NSMutableArray *jsonPoints = [[NSMutableArray alloc] init];
        for (GSNPoint *point in points) {
            if ([point isKindOfClass:[GSNPoint class]]) {
                [jsonPoints addObject:[point.position convertToJSONObject]];
            }
        }
        return ([jsonPoints count] == [points count]) ? [[GSNLineString alloc] initWithCoordinates:jsonPoints] : nil;
    }
    
    return nil;
}

#pragma mark - Object Methods
-(MKShape *)shapeForMapKit
{
    NSUInteger length = 0;
    CLLocationCoordinate2D *coordinates = [self.coordinates coordinate2DArrayWithLength:&length];
    
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:length];
    free(coordinates);
    
    return polyLine;
}

- (BOOL)isEqualToLineString: (GSNLineString *)lineString
{
    if (self == lineString) {
        return YES;
    }
    
    return ([self.type isEqualToString:lineString.type] &&
            [self.coordinates isEqualToArray:lineString.coordinates]);
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if (![super isEqual:other]) {
        return NO;
    } else {
        return ([other isKindOfClass:[GSNLineString class]] &&
                [self isEqualToLineString:(GSNLineString *)other]);
    }
}

- (NSUInteger)hash
{
    return [self.type hash] ^ [self.coordinates hash];
}

@end
