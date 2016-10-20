//
//  GSNBuildingFeature.h
//  Guide
//
//  Created by Adi Mathew on 5/5/16.
//  Copyright © 2016 RCPD. All rights reserved.
//

#import "GSNFeature.h"

@interface GSNBuildingFeature : GSNFeature

@property (nonatomic, strong) NSString *buildingID;
@property (nonatomic, strong) NSString *buildingAbbreviation;
@property (nonatomic, strong) NSString *buildingUnit;
@property (nonatomic, strong) NSString *buildingAddress;
@property (nonatomic, strong) NSString *buildingHours;
@property (nonatomic, strong) NSString *additionalInfo;
@property (nonatomic, strong) NSData *thumbnailData;

@end
