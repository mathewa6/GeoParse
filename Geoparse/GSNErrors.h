//
//  GSNErrors.h
//  JSONStage
//
//  Created by Adi Mathew on 6/30/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const GSNGeometryErrorDomain;

typedef NS_ENUM(NSUInteger, GSNGeometryError) {
    GSNPositionArrayError = 1,
    GSNCoordinatesArrayError,
    GSNPropertiesError,
};

//NOT IMPLEMENTED (probably NOT NEEDED)
extern NSString *const kGSNGeometryErrorString(GSNGeometryError);