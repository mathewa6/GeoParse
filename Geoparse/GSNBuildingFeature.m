//
//  GSNBuildingFeature.m
//  Guide
//
//  Created by Adi Mathew on 5/5/16.
//  Copyright © 2016 RCPD. All rights reserved.
//

#import "GSNBuildingFeature.h"
#import "CNAbbreviationLabel.h"

@implementation GSNBuildingFeature

-(NSData *)thumbnailData {
    if (!_thumbnailData) {
        CGFloat scale = [[UIScreen mainScreen] nativeScale];
        CGRect rect = scale > 2.4 ? CGRectMake(0, 0, 240, 240) : CGRectMake(0, 0, 180, 180);
        CNAbbreviationLabel *thumbnail = [[CNAbbreviationLabel alloc] initWithFrame: rect text: self.buildingAbbreviation];
        thumbnail.color = [UIColor whiteColor];
        _thumbnailData = UIImagePNGRepresentation([self imageWithView:thumbnail]);
    }
    
    return _thumbnailData;
}

// From http://stackoverflow.com/questions/4334233/how-to-capture-uiview-to-uiimage-without-loss-of-quality-on-retina-display
- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
//    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0f);
//    BOOL test = [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
//    NSLog(@"%@", test ? @"YES" : @"NO");
//    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return snapshotImage;
}

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
        self.title = self.name;
        if (!self.name || [self.name isEqual:[NSNull null]]) {
            self.name = [self.properties[@"BUILDINGID"] capitalizedString];
        }
        
        _buildingID = self.properties[@"BUILDING"];
        _buildingAbbreviation = self.properties[@"ABXN"];
        _buildingAbbreviation = _buildingAbbreviation ? _buildingAbbreviation : _buildingID;
        _buildingUnit = self.properties[@"BUILDING_U"];
        _buildingAddress = self.properties[@""];
        _buildingHours = self.properties[@""];
        
        //If the building name contains a " - ", we want to split around it and remove whitespaces.
        NSArray *dashSplitComponents = [self.name componentsSeparatedByString:@"-"];
        if (![dashSplitComponents isEqualToArray:@[self.name]]) {
            //Trim whitespace from name.
            self.name = (NSString *)dashSplitComponents.firstObject;
            NSString *trimmedName = [self.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            self.name = trimmedName;
            //Trim whitespace from info.
            _additionalInfo = (NSString *)dashSplitComponents.lastObject;
            NSString *trimmedInfo = [_additionalInfo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            _additionalInfo = trimmedInfo;
        } else {
            _additionalInfo = nil; //Use Address?
        }
        
    }
    return self;
}

@end
