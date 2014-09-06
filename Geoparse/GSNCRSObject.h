//
//  GSNCRSObject.h
//  JSONStage
//
//  Created by Adi Mathew on 6/19/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSNJSONFriendly.h"

@interface GSNCRSObject : NSObject <JSONFriendly>

/**
 TODO : Add a CRSObjectType property
 */
typedef NS_ENUM(NSInteger, GSNCRSType) {
    GSNCRSTypenName = 0,
    GSNCRSTypeLink
};

#pragma mark - Initialization methods
/**
 Create a default CRSObject containing a GeographicCRS.
 */
-(instancetype)initWithGeographicCRS;
/**
 Create a default CRSObject containing a MercatorCRS.
 */
-(instancetype)initWithMercatorCRS;
/**
 Designated initializer.
 */
-(instancetype)initWithType:(NSString *)type properties:(NSDictionary *)properties NS_DESIGNATED_INITIALIZER;

#pragma mark - File write convenience methods
/**
 Returns an NSDictionary that can be passed to NSJSONSerialization.
 */
-(NSDictionary *)convertToJSONObject;

#pragma mark - File Parsing convenience methods
/**
 Manually create a CRSObject of type "link".
 */
+(instancetype)createLinkCRSWithLink: (NSString *)link andHint:(NSString *)hint ;
/**
 Manually create a CRSObject of type "name".
 */
+(instancetype)createNamedCRSWithName: (NSString *)name ;
/**
 Use if parsing from GeoJSON and CRS "type" is unknown.
 */
+(instancetype)createCRSWithDictionary: (NSDictionary *)crs;


@end
