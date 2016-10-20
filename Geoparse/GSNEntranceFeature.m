//
//  GSNEntranceFeature.m
//  Guide
//
//  Created by Adi Mathew on 12/4/15.
//  Copyright © 2015 RCPD. All rights reserved.
//

#import "GSNEntranceFeature.h"
#import "GDMashed.h"

@implementation GSNEntranceFeature

- (NSDictionary *)convertToJSONObject
{
    return [NSDictionary dictionaryWithObjects:@[self.type, self.identifier, self.bbox, self.properties, self.geometry]
                                       forKeys:@[@"type", @"id", @"bbox", @"properties", @"geometry"]];
}

#pragma mark - Initialization methods
- (instancetype)init
{
    return [self initWithJSONDictionary:@{}];
}

- (instancetype)initWithJSONDictionary: (NSDictionary *)feature
{
    self = [super initWithJSONDictionary:feature];
    
    if (self) {
        self.type = @"Feature";
//        self.properties = [feature objectForKey:@"properties"];
//        self.geometry = [feature objectForKey:@"geometry"];
//        self.geometryTypeString = feature[@"geometry"][@"type"];
//        self.identifier = [feature objectForKey:@"id"];
        self.name = self.properties[@"equipment"];
        self.title = self.name;
        self.coordinate = [feature[@"geometry"][@"coordinates"] coordinate2D];
        self.bbox = @[@(self.coordinate.longitude), @(self.coordinate.latitude), @(self.coordinate.longitude), @(self.coordinate.latitude)];
        if (!self.name || [self.name isEqual:[NSNull null]]) {
            self.name = [self.properties[@""] capitalizedString];
        }

        _equipment = self.name;//self.properties[@"equipment"];
        _floor = self.properties[@"floor"];
        _door = self.properties[@"door"];
        _buildingID = self.properties[@"building"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        [formatter setLocale: [NSLocale currentLocale]];
        NSString *dateString = self.properties[@"data_checked"];
        _dateLastChecked = [formatter dateFromString: [dateString isEqual:[NSNull null]] ? @"" : dateString];
        
        _opener = [self.properties[@"opener"] isEqualToString:@"Y"] ? YES : NO;
        _ramp = [self.properties[@"ramp"] isEqualToString:@"Y"] ? YES : NO;
        _stair = [self.properties[@"stair"] isEqualToString:@"Y"] ? YES : NO;
        _handleAccessible = [self.properties[@"handle_acc"] isEqualToString:@"Y"] ? YES : NO;
        _interiorAccessible = [self.properties[@"inter_acc"] isEqualToString:@"Y"] ? YES : NO;
        _publicEntrance = [self.properties[@"pub_ent"] isEqualToString:@"Y"] ? YES : NO;
        
        GDMashed *mishmash = [GDMashed sharedMash];//[[GDMashed alloc] init];
        
       //c491068e71ad319a6e553e87582f5fd58074df8a19d9
        NSMutableString *urlString = [[NSMutableString alloc] initWithString:[mishmash saltAndPepperForPhotos]];
        [urlString appendString:self.properties[@"photo_link"]];
        _imageURL = [NSURL URLWithString: urlString];
        
    }
    return self;
}



@end
