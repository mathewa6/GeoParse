//
//  GSNParserDelegate.h
//  JSONStage
//
//  Created by Adi Mathew on 7/16/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

@protocol GSNParserDelegate <NSObject>

- (void)didParseGeoJSONObject: (id)object;

@end