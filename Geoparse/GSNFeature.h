//
//  GSNFeature.h
//  JSONStage
//
//  Created by Adi Mathew on 7/7/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import "GSNObjectClasses/GSNObject.h"

@interface GSNFeature : GSNObject <JSONFriendly>

/**
 NSDictionary containing a geometry.
 */
@property (nonatomic, strong) NSDictionary *geometry;
/**
 NSDictionary of properties specific to the Feature. "name", "building", etc.
 */
@property (nonatomic, strong) NSDictionary *properties;
/**
 String member to be used as identifier.
 */
@property (nonatomic, strong) NSString *id;

/**
 GSNObject containing a geometry type.
 */
@property (nonatomic, strong, readonly) GSNObject *geometryObject;
/**
 NSString with geometry type. Skips initialization of a new GSNObject, for typechecking.
 */
@property (nonatomic, strong) NSString *geometryType;
/**
 Name of the feature. 
 Can be accessed directly from properties[@"name"], if available.
 */
@property (nonatomic, strong) NSString *name;
/**
 Determines whether the feature is a building or not. 
 Can be accessed directly from properties[@"building"], if available.
 */
@property (nonatomic, readonly, getter=isBuilding) BOOL building;

- (NSDictionary *)convertToJSONObject;
- (instancetype)initWithJSONDictionary: (NSDictionary *)feature;

@end
