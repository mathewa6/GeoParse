//
//  GSNEntranceFeature.h
//  Guide
//
//  Created by Adi Mathew on 12/4/15.
//  Copyright © 2015 RCPD. All rights reserved.
//

#import "GSNFeature.h"

@interface GSNEntranceFeature : GSNFeature

@property (nonatomic, strong) NSString *equipment;
@property (nonatomic, strong) NSString *floor;
@property (nonatomic, strong) NSString *door;
@property (nonatomic, strong) NSDate *dateLastChecked;
@property (nonatomic, strong) NSString *buildingID;
@property (nonatomic, assign, getter=hasOpener) BOOL opener;
@property (nonatomic, assign, getter=hasRamp) BOOL ramp;
@property (nonatomic, assign, getter=hasStair) BOOL stair;
@property (nonatomic, assign, getter=isHandleAccessible) BOOL handleAccessible;
@property (nonatomic, assign, getter=isInteriorAccessible) BOOL interiorAccessible;
@property (nonatomic, assign, getter=isPublicEntrance) BOOL publicEntrance;
@property (nonatomic, strong) NSURL *imageURL;


- (NSDictionary *)convertToJSONObject;
- (instancetype)initWithJSONDictionary: (NSDictionary *)feature;


@end
