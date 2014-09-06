//
//  GSNMultiPoint.m
//  JSONStage
//
//  Created by Adi Mathew on 7/1/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import "GSNMultiPoint.h"
#import "GSNPoint.h"

@interface GSNMultiPoint ()

/**
 Mutable array of GSNPoints.
 */
@property (nonatomic, strong) NSMutableArray *pointObjects;

@end

@implementation GSNMultiPoint

- (NSArray *)points
{
    if (!_pointObjects) {
        _pointObjects = [[NSMutableArray alloc] init];
        for (NSArray *position in self.coordinates) {
            [_pointObjects addObject:[GSNPoint createPointWithPosition:[GSNPosition createPositionWithArray:position
                                                                                                      error:NULL]]];
        }
    }
    return [self.pointObjects copy];
}

#pragma mark - Initialization methods
- (instancetype)initWithCoordinates:(NSArray *)coordinates
{
    self = [super init];
    if (self) {
        self.type = @"MultiPoint";
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
+ (instancetype)createMultiPointfromPointArray: (NSArray *)points
{
    NSMutableArray *jsonPoints = [[NSMutableArray alloc] init];
    for (GSNPoint *point in points) {
        if ([point isKindOfClass:[GSNPoint class]]) {
            [jsonPoints addObject:[point convertToJSONObject]];
        }
    }
    return ([jsonPoints count] == [points count]) ? [[GSNMultiPoint alloc] initWithCoordinates:jsonPoints] : nil;
}

#pragma mark - Object Methods
- (BOOL)isEqualToMultiPoint: (GSNMultiPoint *)multiPoint
{
    if (self == multiPoint) {
        return YES;
    }
    
    return ([self.type isEqualToString:multiPoint.type] &&
            [self.coordinates isEqualToArray:multiPoint.coordinates]);
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if (![super isEqual:other]) {
        return NO;
    } else {
        return ([other isKindOfClass:[GSNMultiPoint class]] &&
                [self isEqualToMultiPoint:(GSNMultiPoint *)other]);
    }
}

- (NSUInteger)hash
{
    return [self.type hash] ^ [self.coordinates hash];
}

@end
