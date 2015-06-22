//
//  FSOperation.m
//  Foursquare2
//
//  Created by Constantine Fry on 16/02/14.
//
//  Added New Foursquare Trending API

#import "FSOperation.h"

@interface FSOperation ()

@property (nonatomic, copy) Foursquare2Callback callbackBlock;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic) dispatch_queue_t callbackQueue;

@end

@implementation FSOperation

- (id)initWithRequest:(NSURLRequest *)request
            callback:(Foursquare2Callback)block
       callbackQueue:(dispatch_queue_t)callbackQueue {
    self = [super init];
    if (self) {
        self.callbackBlock = block;
        self.request = request;
        self.callbackQueue = callbackQueue;
    }
    return self;
}

- (void)main {
    NSError *error;
    id result;
    
    NSURLResponse *response;
    
    if ([self isCancelled]) {
        return;
    }
    
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:self.request
                                                 returningResponse:&response
                                                             error:&error];
    
    if ([self isCancelled]) {
        return;
    }
    
    if (receivedData) {
        result = [NSJSONSerialization JSONObjectWithData:receivedData
                                                 options:0
                                                   error:&error];
        if (result) {
            if ([result isKindOfClass:[NSError class]]) {
                error = result;
            } else if ([result valueForKeyPath:@"meta.errorDetail"]) {
                NSString *detail = [result valueForKeyPath:@"meta.errorDetail"];
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey:detail};
                error = [NSError errorWithDomain:@"Foursquare2"
                                            code:[result[@"meta"][@"code"] integerValue]
                                        userInfo:userInfo];
            }
        }
    }
    
    if ([self isCancelled]) {
        return;
    }
   
   dispatch_async(self.callbackQueue, ^{ 
   // dispatch_async(dispatch_get_main_queue(), ^{
       //chaged erro to [error isKindOfClass:[NSError class]]
        if ([error isKindOfClass:[NSError class]]) {
            self.callbackBlock(NO, error);
        } else {
            self.callbackBlock(YES, result);
        }
    });
}

- (BOOL)isConcurrent {
    return YES;
}

@end
