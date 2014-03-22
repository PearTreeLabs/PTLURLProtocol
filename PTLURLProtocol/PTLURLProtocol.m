//
//  PTLURLProtocol.m
//  PTLURLProtocol
//
//  Created by Brian Partridge on 7/7/13.
//  Copyright (c) 2013 Brian Partridge. All rights reserved.
//

#import "PTLURLProtocol.h"

NSString * const PTLURLProtocolErrorDomain = @"com.peartreelabs.PTLURLProtocol";
NSString * const kPTLURLProtocolErrorOriginalRequest = @"com.peartreelabs.PTLURLProtocol.originalrequest";

@implementation PTLURLProtocol

#pragma mark - Boiler Plage

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void)startLoading {
    NSURLResponse *response = [[self class] responseForRequest:self.request];
    if (response == nil) {
        NSError *error = [NSError errorWithDomain:PTLURLProtocolErrorDomain
                                             code:PTLURLProtocolErrorUnableToCreateResponse
                                         userInfo:@{ kPTLURLProtocolErrorOriginalRequest : self.request }];
        [self.client URLProtocol:self didFailWithError:error];
        return;
    }
    [self.client URLProtocol:self didReceiveResponse:response
          cacheStoragePolicy:NSURLCacheStorageNotAllowed];

    NSData *data = [[self class] dataForRequest:self.request];
    if (data != nil) {
        [self.client URLProtocol:self didLoadData:data];
    }

    [self.client URLProtocolDidFinishLoading:self];
}

- (void)stopLoading {
    //Implementation is required by abstract parent class
}

+ (NSURLResponse *)responseForRequest:(NSURLRequest *)request {
    return nil;
}

+ (NSData *)dataForRequest:(NSURLRequest *)request {
    return nil;
}

#pragma mark - Registration Helpers

+ (void)registerProtocol {
    [self registerClass:self];
}

+ (void)unregisterProtocol {
    [self unregisterClass:self];
}

@end
