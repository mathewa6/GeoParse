//
//  GSNPoint.m
//  JSONStage
//
//  Created by Adi Mathew on 6/21/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import "GSNPoint.h"

@interface GSNPoint ()

@end

@implementation GSNPoint

- (GSNPosition *)position
{
    if (!_position) {
        _position = [GSNPosition createPositionWithArray:self.coordinates
                                                   error:NULL];
    }
    return _position;
}

#pragma mark - Initialization methods
- (instancetype)initWithCoordinates: (NSArray *)coordinates
{
    self = [super init];
    if (self) {
        self.type = @"Point";
        if ([coordinates count] <=3 && [coordinates count] >1) {
            // Used @[_position], however, this is more intuitive and reduces the need to use GSNPosition
            _coordinates = coordinates; //@[@(_position.coordinate.latitude), @(_position.coordinate.longitude)];
        }
    }
    
    return self;
}

- (instancetype)init
{
    return [self initWithCoordinates:@[@(0.0),@(0.0)]];
}

#pragma mark - File write convenience methods
- (NSDictionary *)convertToJSONObject
{
    if (self) {
        return [NSDictionary dictionaryWithObjects:@[self.type, self.coordinates]
                                           forKeys:@[@"type", @"coordinates"]];
    }
    
    return nil;
}

#pragma mark - File Parsing convenience methods
+ (instancetype)createPointWithPosition:(GSNPosition *)position
{
    return [[GSNPoint alloc] initWithCoordinates:[position convertToJSONObject]];
}

#pragma mark - Object Methods
/**
 Returns a CLLocationCoordinate2D struct representing the point. Works ONLY if coordinates member has 2 elements: [longitude, latitude].
 */
- (CLLocationCoordinate2D)coordinate2D
{
    if ([self.coordinates count] == 2) {
        CLLocationCoordinate2D coordinate;
        double latitude = [[self.coordinates lastObject] doubleValue];
        double longitude = [[self.coordinates firstObject] doubleValue];
        coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        return coordinate;
    }
    
    return CLLocationCoordinate2DMake(0.0, 0.0);
}

- (MKShape *)shapeForMapKit
{
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = [self coordinate2D];
    
    return annotation;
}

- (NSString *)description
{
    return [[self convertToJSONObject] description];
}

- (BOOL)isEqualToPoint: (GSNPoint *)point
{
    if (self == point) {
        return YES;
    }
    
    return ([self.type isEqualToString:point.type] &&
            [self.coordinates isEqualToArray:point.coordinates]);
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[GSNPoint class]]) {
        return NO;
    }
    
    return [self isEqualToPoint:(GSNPoint *)object];
}

- (NSUInteger)hash
{
    return [self.coordinates hash] ^ [self.type hash] ;
}

@end
