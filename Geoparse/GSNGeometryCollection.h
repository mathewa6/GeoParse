//
//  GSNGeometryCollection.h
//  JSONStage
//
//  Created by Adi Mathew on 7/8/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import "GSNObject.h"

@interface GSNGeometryCollection : GSNObject <JSONFriendly>

@property (nonatomic, strong) NSArray *geometries;

@property (nonatomic, strong, readonly) NSArray *geometryObjects;

- (instancetype)initWithGeometryArray: (NSArray *)geometries;

- (NSDictionary *)convertToJSONObject;

@end
