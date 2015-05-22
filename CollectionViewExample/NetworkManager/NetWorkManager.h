//
//  NetWorkManager.h
//  NetworkApp
//
//  Created by Sandeep Prajapat on 16/05/15.
//  Copyright (c) 2015 Ignatiuz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkManager : NSOperation

/** Creates a data task to retrieve the contents of the given URL.
 @param session instance of session.
 @param url url to api call.
 @param completionHandler completion block with data/response/error.
 */

- (instancetype)initWithSession:(NSURLSession *)session URL:(NSURL *)url completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

/** Creates a data task with the given request.  The request may have a body stream.
 @param session instance of session.
 @param request request to api call with header body.
 @param completionHandler completion block with data/response/error.
 */

- (instancetype)initWithSession:(NSURLSession *)session request:(NSURLRequest *)request completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

@property (nonatomic, strong, readonly) NSURLSessionDataTask *task;

@end