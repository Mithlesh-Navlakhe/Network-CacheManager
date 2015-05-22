//
//  LImageLoader.m
//  LTMobileLibrary
//
//   25/07/14.
//  Copyright (c) 2014 Ignatiuz. All rights reserved.
//

#import "LImageLoader.h"
#import "NetWorkManager.h"
#import "LTError.h"
#import "LImageCacheManager.h"

@interface LImageLoader()

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) LImageCacheManager *cacheManager;

@end

@implementation LImageLoader

+ (LImageLoader *)sharedInstance
{
    static LImageLoader* instance;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[self alloc] init];
        instance.operationQueue = [[NSOperationQueue alloc] init];
        //instance.operationQueue.maxConcurrentOperationCount = 5;
        instance.cacheManager =  [LImageCacheManager sharedInstance];
    });
    return instance;
}

- (void)loadImageFromUrl:(NSString *)urlString Key:(NSString*)key completed:(void (^)(NSData *))completed failure:(void (^)(NSError *))failure
{
    if (!urlString || [urlString isEqualToString:@""]) {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:@"blank url" forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:LTErrorDomain code:LTErrorRequiredError userInfo:userInfo];
        if (failure) failure(error);
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *cachedImage = [self.cacheManager imageDataByKey:urlString];
        if (cachedImage) {
            
            NSLog(@"cachedImage %@",urlString);
            
            if (completed) completed(cachedImage);
            return;
        }
    });
    
    
    //_session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSOperation *operObj = [[NetWorkManager alloc] initWithSession:self.URLSession URL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                //UIImage *image = [UIImage imageWithData:data];
                [self.cacheManager performWithImageData:data andKey:urlString];
                if (completed) completed(data);
            } else if (error){
                NSLog(@"DLImageLoader data loading canceled");
                if (failure) failure(error);
            }
        });
    }];
    
    [operObj setName:key];
    
    [[self operationQueue] addOperation:operObj];
    
}

- (void)displayImageFromUrl:(NSString *)urlString Key:(NSString*)key
{
    //imageView.image = nil;
    [self loadImageFromUrl:urlString Key:key completed:^(NSData *image) {
        //imageView.image = image;
        //[imageView setNeedsDisplay];
        NSString *str = [[NSString alloc] initWithData:image encoding:NSUTF8StringEncoding];
        NSLog(@"Data is here %@",str);
    } failure:^(NSError *error){
        //imageView.image = nil;
        NSLog(@"displayImageFromUrl error : %@",error);
    }];
}

- (void)stopDataLoading:(NSString*)key
{
    for (NetWorkManager *operation in self.operationQueue.operations) {
        if ([operation.name isEqualToString:key]) {
            [operation cancel];
        }
    }
}

@end

@implementation LImageLoader (Subclassing)

- (NSURLSession*)URLSession
{
    return [NSURLSession sharedSession];
}

@end