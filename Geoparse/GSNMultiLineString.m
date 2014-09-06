//
//  GSNMultiLineString.m
//  JSONStage
//
//  Created by Adi Mathew on 7/1/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import "GSNMultiLineString.h"
#import "GSNLineString.h"

@interface GSNMultiLineString ()

/**
 Mutable array of GSNLinestrings
 */
@property (nonatomic, strong) NSMutableArray *lineStringsMutable;

@end

@implementation GSNMultiLineString

- (NSArray *)lineStrings
{
    if (!_lineStringsMutable) {
        _lineStringsMutable = [[NSMutableArray alloc] init];
        for (NSArray *lineString in self.coordinates) {
            [_lineStringsMutable addObject:[[GSNLineString alloc] initWithCoordinates:lineString]];
        }
    }
    return [_lineStringsMutable copy];
}

#pragma mark - Initialization methods
- (instancetype)initWithCoordinates:(NSArray *)coordinates
{
    self = [super init];
    if (self) {
        self.type = @"MultiLineString";
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
/**
 POSSIBLE ERROR
 + Do deeper checking for lineString's member count being > 2
 */
+ (instancetype)createMultiLineStringFromLineStringArray:(NSArray *)lines
{
    NSMutableArray *jsonLines = [[NSMutableArray alloc] init];
    for (GSNLineString *line in lines) {
        if ([line isKindOfClass:[GSNLineString class]]) {
            [jsonLines addObject:line.coordinates];
        }
    }
    return ([jsonLines count] == [lines count]) ? [[GSNMultiLineString alloc] initWithCoordinates:jsonLines] : nil;
}

#pragma mark - Object Methods
- (BOOL)isEqualToLineString: (GSNMultiLineString *)multiLineString
{
    if (self == multiLineString) {
        return YES;
    }
    
    return ([self.type isEqualToString:multiLineString.type] &&
            [self.coordinates isEqualToArray:multiLineString.coordinates]);
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if (![super isEqual:other]) {
        return NO;
    } else {
        return ([other isKindOfClass:[GSNMultiLineString class]] &&
                [self isEqualToLineString:(GSNMultiLineString *)other]);
    }
}

- (NSUInteger)hash
{
    return [self.type hash] ^ [self.coordinates hash];
}


@end
