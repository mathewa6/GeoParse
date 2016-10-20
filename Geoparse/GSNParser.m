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

-(void)parseFile:(NSString *)filename // withDelegate:(id<GSNParserDelegate>)delegate
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
                [self callDelegateWithDictionary:object];
            });
            
        });
    } else {
        NSLog(@"Error Domain: %@, Error Code: %lu", error.domain, (unsigned long)error.code);
    }
}

-(void)parseURL:(NSString *)url // withDelegate:(id<GSNParserDelegate>)delegate
{
    NSURL *jsonURL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:jsonURL];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
                                                    completionHandler:^(NSURL *localFile, NSURLResponse *response, NSError *error) {
                                                        if (!error) {
                                                            NSError *errorData = nil;
                                                            NSData *data = [NSData dataWithContentsOfURL:localFile
                                                                                                 options:NSDataReadingUncached
                                                                                                   error:&errorData];
                                                            NSError *errorJSON = nil;
                                                            NSDictionary *object = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                   options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments
                                                                                                                     error:&errorJSON];
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [self callDelegateWithDictionary:object];
                                                                
                                                            });
                                                        }
                                                    }];
    [task resume];
}

-(void)callDelegateWithDictionary: (NSDictionary *)dictionary
{
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(GSNParserDelegate)]) {
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            [self.delegate didParseGeoJSONObject:[GSNObject objectFromDictionary:dictionary]];
        } else {
            [self.delegate didParseGeoJSONObject:nil];
        }
    }
}

@end
