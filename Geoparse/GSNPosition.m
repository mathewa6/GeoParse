//
//  GSNPosition.m
//  JSONStage
//
//  Created by Adi Mathew on 6/21/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import "GSNPosition.h"
#import "GSNErrors.h"

@interface GSNPosition ()

@end

@implementation GSNPosition

#pragma mark - Initialization methods
- (instancetype)initWithLatitude: (NSNumber *)latitude
                      longitude: (NSNumber *)longitude
                       altitude: (NSNumber *)altitude
{
    self = [super init];
    if (self) {
        _coordinate = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
        _altitude = [altitude doubleValue];
    }
    
    return self;
}

- (instancetype)init
{
    return [self initWithLatitude:@0 longitude:@0 altitude:@0];
}

#pragma mark - File write convenience methods
- (NSArray *)convertToJSONObject
{
    if (self.altitude == [@0 doubleValue] || !self.altitude) {
        return @[[NSNumber numberWithDouble:self.coordinate.longitude],
                 [NSNumber numberWithDouble:self.coordinate.latitude]];
    }
    
    return @[[NSNumber numberWithDouble:self.coordinate.longitude],
             [NSNumber numberWithDouble:self.coordinate.latitude],
             [NSNumber numberWithDouble:self.altitude]];
}

#pragma mark - File Parsing convenience methods
+ (instancetype)createPositionWithArray: (NSArray *)coordinates error: (NSError * __autoreleasing *)error
{
    if (coordinates) {
        if ([coordinates count] == 2) {
            return [[GSNPosition alloc] initWithLatitude:(NSNumber *)[coordinates lastObject]
                                               longitude:(NSNumber *)[coordinates firstObject]
                                                altitude:nil];
        } else if ([coordinates count] == 3) {
            return [[GSNPosition alloc] initWithLatitude:(NSNumber *)coordinates[1]
                                               longitude:(NSNumber *)[coordinates firstObject]
                                                altitude:(NSNumber *)[coordinates lastObject]];
        }
        else {
            if (error != NULL) {
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Invalid number of members in a Position element"};
                
                *error = [NSError errorWithDomain:GSNGeometryErrorDomain
                                             code:GSNPositionArrayError
                                         userInfo:userInfo];
            }
            return nil;
        }
    }
    
    return [[GSNPosition alloc] init];
}

+ (instancetype)createPositionWithArray: (NSArray *)coordinates{
    return [self createPositionWithArray:coordinates error:NULL];
}

- (NSString *)description
{
    return [[self convertToJSONObject] description];
}

@end
