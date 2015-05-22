//
//  NetWorkManager.m
//  NetworkApp
//
//  Created by Sandeep Prajapat on 16/05/15.
//  Copyright (c) 2015 Ignatiuz. All rights reserved.
//

#import "NetWorkManager.h"

#define TRVSKVOBlock(KEYPATH, BLOCK) \
[self willChangeValueForKey:KEYPATH]; \
BLOCK(); \
[self didChangeValueForKey:KEYPATH];

@implementation NetWorkManager {
    BOOL _finished;
    BOOL _executing;
}

- (instancetype)initWithSession:(NSURLSession *)session URL:(NSURL *)url completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler {
    if (self = [super init]) {
        __weak typeof(self) weakSelf = self;
        _task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            [weakSelf completeOperationWithBlock:completionHandler data:data response:response error:error];
        }];
    }
    return self;
}

- (instancetype)initWithSession:(NSURLSession *)session request:(NSURLRequest *)request completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler {
    if (self = [super init]) {
        __weak typeof(self) weakSelf = self;
        _task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            [weakSelf completeOperationWithBlock:completionHandler data:data response:response error:error];
        }];
    }
    return self;
}

- (void)cancel {
    [super cancel];
    [self.task cancel];
}

- (void)start {
    if (self.isCancelled) {
        TRVSKVOBlock(@"isFinished", ^{ _finished = YES; });
        return;
    }
    TRVSKVOBlock(@"isExecuting", ^{
        [self.task resume];
        _executing = YES;
    });
}

- (BOOL)isExecuting {
    return _executing;
}

- (BOOL)isFinished {
    return _finished;
}

- (BOOL)isConcurrent {
    return YES;
}

- (void)completeOperationWithBlock:(void (^)(NSData *, NSURLResponse *, NSError *))block data:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error {
    if (!self.isCancelled && block)
        block(data, response, error);
    [self completeOperation];
}

- (void)completeOperation {
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    _executing = NO;
    _finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

@end