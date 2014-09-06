//
//  GSNGeometries.h
//  JSONStage
//
//  Created by Adi Mathew on 7/4/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

/**
 Imported in GSNObject.h
 Helps import all objects that conform to GSNGeometry protocol.
 */
#ifndef __GSNGEOMETRIES__
#define __GSNGEOMETRIES__

typedef NS_ENUM(NSUInteger, GSNObjectType) {
    kGSNObjectTypeFeature = 8,
    kGSNObjectTypeFeatureCollection
};

typedef NS_ENUM(NSUInteger, GSNGeometryType) {
    kGSNGeometryTypePoint = 1,
    kGSNGeometryTypeMultiPoint,
    kGSNGeometryTypeLineString,
    kGSNGeometryTypeMultiLineString,
    kGSNGeometryTypePolygon,
    kGSNGeometryTypeMultiPolygon,
    kGSNGeometryTypeCollection
    
};

#endif