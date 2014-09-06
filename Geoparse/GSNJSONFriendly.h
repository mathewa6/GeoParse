//
//  GSNJSONFriendly.h
//  JSONStage
//
//  Created by Adi Mathew on 6/21/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

@protocol JSONFriendly <NSObject>

-(id<NSObject, NSCopying, NSSecureCoding, NSFastEnumeration, NSMutableCopying>)convertToJSONObject;

@end