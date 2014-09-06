//
//  GSNCRSObject.m
//  JSONStage
//
//  Created by Adi Mathew on 6/19/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import "GSNCRSObject.h"

@interface GSNCRSObject ()
/**
 NSString that determines whether the CRSObject is a "name" or "link"
 */
@property (nonatomic, strong) NSString *type;
/**
 NSDictionary containing name,link and/or hint about the CRSObject.
 */
@property (nonatomic, strong) NSDictionary *properties;
/**
 NSURL containing a valid dereferenceable URL. Is set to nil, if URL is invalid.
 */
@property (nonatomic, strong) NSURL *href;
/**
 NSString that should be the format used to represent the CRS parameters located at the "href" property.
 */
@property (nonatomic, strong) NSString *hint;
/**
 TODO : Put in header and test.
 */
@property (nonatomic) GSNCRSType CRSObjectType;
@end

@implementation GSNCRSObject

#pragma mark - Initialization methods
-(instancetype)init
{
    return [self initWithType:@"" properties:nil];
}

-(instancetype)initWithType:(NSString *)type properties:(NSDictionary *)properties
{
    self = [super init];
    if (self) {
        _type = type;
        _properties = properties;
        if ([_type isEqualToString:@"name"]) {
            _CRSObjectType = 0;
            _href = nil;
            _hint = nil;
        }
        else if ([_type isEqualToString:@"link"]) {
            _CRSObjectType = 1;
            _href = [NSURL URLWithString:[_properties objectForKey:@"href"]];
            _hint = [_properties objectForKey:@"type"];
        }
    }
    return self;
}

-(instancetype)initWithMercatorCRS
{
    return [self initWithType:@"link"
                   properties:[NSDictionary dictionaryWithObjects:@[@"http://spatialreference.org/ref/sr-org/6928/ogcwkt/", @"ogcwkt"]
                                                          forKeys:@[@"href", @"type"]]];
}

-(instancetype)initWithGeographicCRS
{
    return [self initWithType:@"link"
                   properties:[NSDictionary dictionaryWithObjects:@[@"http://spatialreference.org/ref/epsg/4326/ogcwkt/", @"ogcwkt"]
                                                          forKeys:@[@"href", @"type"]]];
}

#pragma mark - File write convenience methods
/**
 Returns an NSDictionary that can be passed to NSJSONSerialization.
 */
-(NSDictionary *)convertToJSONObject
{
    if (self) {
        return [NSDictionary dictionaryWithObjects:@[self.type, self.properties]
                                           forKeys:@[@"type", @"properties"]];
    }
    
    return nil;
}

-(NSString *)description
{
    return [[self convertToJSONObject] description];
}

#pragma mark - File Parsing convenience methods
+(instancetype)createLinkCRSWithLink:(NSString *)link andHint:(NSString *)hint
{
    return [[self alloc] initWithType:@"link"
                                   properties:[NSDictionary dictionaryWithObjects:@[link, hint]
                                                                             forKeys:@[@"href", @"type"]]];
}

+(instancetype)createNamedCRSWithName:(NSString *)name
{
    return [[self alloc] initWithType:@"name"
                                   properties:[NSDictionary dictionaryWithObject:name
                                                                             forKey:@"name"]];
}

+(instancetype)createCRSWithDictionary:(NSDictionary *)crs
{
    if (crs) {
        if ([[crs objectForKey:@"type"] isEqualToString:@"name"]) {
            return [self createNamedCRSWithName:[[crs objectForKey:@"properties"] objectForKey:@"name"]];
        }
        else if ([[crs objectForKey:@"type"] isEqualToString:@"link"]) {
            return [self createLinkCRSWithLink:[[crs objectForKey:@"properties"] objectForKey:@"href"]
                                andHint:[[crs objectForKey:@"properties"] objectForKey:@"type"]];
        }
    }
    
    return [[self alloc] init];
}


@end