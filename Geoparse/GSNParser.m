//
//  GSNParser.m
//  JSONStage
//
//  Created by Adi Mathew on 7/15/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

#import "GSNParser.h"

#define kBGQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation GSNParser

-(void)parseFile:(NSString *)filename
{
    NSArray *filenameComponents = [filename componentsSeparatedByString:@"."];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[filenameComponents firstObject]
                                                         ofType:[filenameComponents lastObject]];
    
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:filePath
                                          options:NSDataReadingUncached
                                            error:&error];
    
    if (data) {
        
        __block NSError *error = nil;
        
        //dispatch_queue_t parsequeue = dispatch_queue_create("edu.msu.rcpd.parsequeue", NULL);
        
        __block NSDictionary *object = [[NSDictionary alloc] init];
        
        dispatch_async(kBGQueue, ^{
            object = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments
                                                              error:&error];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.delegate && [self.delegate conformsToProtocol:@protocol(GSNParserDelegate)]) {
                    if ([object isKindOfClass:[NSDictionary class]]) {
                        [self.delegate didParseGeoJSONObject:[GSNObject objectFromDictionary:object]];
                    } else {
                        [self.delegate didParseGeoJSONObject:nil];
                    }
                }
            });
            
        });
    } else {
        NSLog(@"Error Domain: %@, Error Code: %lu", error.domain, (unsigned long)error.code);
    }
}

@end
