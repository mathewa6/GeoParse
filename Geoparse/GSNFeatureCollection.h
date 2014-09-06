//
//  GSNFeatureCollection.h
//  JSONStage
//
//  Created by Adi Mathew on 7/7/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import "GSNObjectClasses/GSNObject.h"

@interface GSNFeatureCollection : GSNObject <JSONFriendly>

@property (nonatomic, strong) NSArray *features;

@property (nonatomic, strong, readonly) NSArray *featureObjects;

- (instancetype)initWithFeaturesArray: (NSArray *)features withBBox: (NSArray *)bbox;

- (NSDictionary *)convertToJSONObject;

@end
