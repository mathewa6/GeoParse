//
//  GSNFeatureCollection.h
//  JSONStage
//
//  Created by Adi Mathew on 7/7/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import "GSNObject.h"

#import "GSNFeature.h"
#import "GSNBuildingFeature.h"
#import "GSNEntranceFeature.h"

@interface GSNFeatureCollection : GSNObject <JSONFriendly>

typedef NS_ENUM(NSUInteger, GSNFeatureCollectionType) {
    kGSNFeatureCollectionTypeBuilding = 0,
    kGSNFeatureCollectionTypeEntrance
};

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *features;

@property (nonatomic, strong, readonly) NSArray *featureObjects;

- (instancetype)initWithFeaturesArray: (NSArray *)features withBBox: (NSArray *)bbox named: (NSString *)name;

- (NSDictionary *)convertToJSONObject;

@end
