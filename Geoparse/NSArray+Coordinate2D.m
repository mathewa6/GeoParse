//
//  NSArray+Coordinate2D.m
//  JSONStage
//
//  Created by Adi Mathew on 7/30/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import "NSArray+Coordinate2D.h"

@implementation NSArray (Coordinate2D)

-(CLLocationCoordinate2D)coordinate2D
{
    CLLocationCoordinate2D coordinate, emptyCoordinate;
    
    if ([self count] == 2) {
        double latitude = [[self lastObject] doubleValue];
        double longitude = [[self firstObject] doubleValue];
        
        coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        coordinate = CLLocationCoordinate2DIsValid(coordinate) ? coordinate : emptyCoordinate;
    }
    
    return coordinate;
}

//Called in GSNLineString -shapeForMapKit. DO NOT Forget to free() returned pointer.
-(CLLocationCoordinate2D *)coordinate2DArrayWithLength: (NSUInteger *)length
{
    __block BOOL isValidConversionArray = YES;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:[NSArray class]]) {
            if ([(NSArray *)obj count] != 2) {
                isValidConversionArray = NO;
                *stop = YES;
            }
        }
    }];
    
    CLLocationCoordinate2D *coordinate2DArray = NULL;
    
    if (isValidConversionArray) {
        NSUInteger read = 0, space = 10;
        coordinate2DArray = malloc(sizeof(CLLocationCoordinate2D) * space);
        
        for (NSArray *coordinate in self) {
            if (read == space) {
                space *= 2 ;
                coordinate2DArray = realloc(coordinate2DArray, sizeof(CLLocationCoordinate2D) * space);
            }
            coordinate2DArray[read++] = [coordinate coordinate2D];
        }
        
        *length = read;
    }
    
    return coordinate2DArray;
}

static inline double toRadians(CLLocationDegrees degrees)
{
    return (degrees * (M_PI/180.0));
}

static inline double toDegrees(double radians)
{
    return (radians * (180.0/M_PI));
}

static inline NSInteger sgn(double value)
{
    return (NSInteger)(abs(value)/value);
}

static inline CLLocationCoordinate2D geometricCenter(NSArray *array)
{
    if ([array count] == 4) {
        
        return CLLocationCoordinate2DMake(([array[3] doubleValue] + [array[1] doubleValue])/2.0, ([array[2] doubleValue] + [array[0] doubleValue])/2.0);
    }
    
    return CLLocationCoordinate2DMake(0.0, 0.0);
}

static CLLocationCoordinate2D geographicCenter(NSArray *array)
{
    if ([array count] == 4) {
        CLLocationCoordinate2D upperRight = CLLocationCoordinate2DMake([array[3] doubleValue], [array[2] doubleValue]);
        CLLocationCoordinate2D lowerLeft = CLLocationCoordinate2DMake([array[1] doubleValue], [array[0] doubleValue]);
        
        if (CLLocationCoordinate2DIsValid(upperRight) && CLLocationCoordinate2DIsValid(lowerLeft) ){
            if ((upperRight.latitude - lowerLeft.latitude >= 3.0) || (upperRight.longitude - lowerLeft.longitude >= 3.0)) {
                double longitudeDelta = toRadians((upperRight.longitude - lowerLeft.longitude));
                
                double bX = cos(toRadians(upperRight.latitude)) * cos(longitudeDelta);
                double bY = cos(toRadians(upperRight.latitude)) * sin(longitudeDelta);
                
                double midLatitude = atan2(sin(toRadians(lowerLeft.latitude)) + sin(toRadians(upperRight.latitude)), sqrt(pow(cos(toRadians(lowerLeft.latitude)) + bX, 2) + pow(bY, 2)));
                double midLongitude = toRadians(lowerLeft.longitude) + atan2(bY, cos(toRadians(lowerLeft.latitude)) + bX);
                
                return CLLocationCoordinate2DMake(toDegrees(midLatitude), toDegrees(midLongitude));
            }
        }
    }
    return CLLocationCoordinate2DMake(0.0, 0.0);
}

-(CLLocationCoordinate2D)boundingBoxCenter
{
    return geometricCenter(self);
}

-(BOOL)boundingBoxContainsCoordinate2D: (CLLocationCoordinate2D)coordinate
{
    BOOL isWithinLatitudes = NO;
    BOOL isWithinLongitudes = NO;
    
    //for Latitudes
    if ([self[1] doubleValue] < coordinate.latitude && coordinate.latitude <= [self[3] doubleValue]) {
        isWithinLatitudes = YES;
    }
    
    //for Longitudes
    if (sgn([self[2] doubleValue]) == sgn([self[0] doubleValue]) || [self[0] doubleValue] < [self[2] doubleValue]) {
        if ([self[0] doubleValue] < coordinate.longitude && coordinate.longitude <= [self[2] doubleValue]){
            isWithinLongitudes = YES;
        }
    } else {
        if (abs([self[2] doubleValue]) <= abs(coordinate.longitude) && abs(coordinate.longitude) > abs([self[0] doubleValue])) {
            isWithinLongitudes = YES;
        }
    }
    
    return (isWithinLatitudes && isWithinLongitudes);
}

-(double *)boundingBoxAsCDoubleArray
{
    double *returnArray = malloc(sizeof(double) * self.count);
    int i = 0;
    
    for (NSNumber *number in self) {
        returnArray[i] = [number doubleValue];
        i++;
    }
    return returnArray;
}

@end

@implementation NSMutableArray (Coordinate2D)

-(CLLocationCoordinate2D)coordinate2D
{
    NSArray *immutableSelf = [NSArray arrayWithArray:self];
    
    return [immutableSelf coordinate2D];
}

-(CLLocationCoordinate2D *)coordinate2DArrayWithLength: (NSUInteger *)length
{
    NSArray *immutableSelf = [NSArray arrayWithArray:self];
    
    return [immutableSelf coordinate2DArrayWithLength: length];
}

-(CLLocationCoordinate2D)boundingBoxCenter
{
    NSArray *immutableSelf = [NSArray arrayWithArray:self];
    
    return [immutableSelf boundingBoxCenter];
}

-(BOOL)boundingBoxContainsCoordinate2D:(CLLocationCoordinate2D)coordinate
{
    NSArray *immutableSelf = [NSArray arrayWithArray:self];
    
    return [immutableSelf boundingBoxContainsCoordinate2D:coordinate];
}

-(double *)boundingBoxAsCDoubleArray
{
    NSArray *immutableSelf = [NSArray arrayWithArray:self];
    
    return [immutableSelf boundingBoxAsCDoubleArray];
}

@end