//
//  LImageCacheManager.m
//  LTMobileLibrary
//
//   25/07/14.
//  Copyright (c) 2014 Ignatiuz. All rights reserved.
//

#import "LImageCacheManager.h"

@interface LImageCacheManager() {
    NSCache *cache;
}

@end

@implementation LImageCacheManager

+ (instancetype)sharedInstance
{
    static LImageCacheManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
        instance->cache = [NSCache new];
        instance->_memoryCacheEnabled = YES;
    });
    return instance;
}

- (UIImage *)imageByKey:(NSString *)key
{
    UIImage *image = nil;
    if (_memoryCacheEnabled) {
        image = [cache objectForKey:key];
    }
    return image;
}

- (NSData *)imageDataByKey:(NSString *)key {
    NSData *image = nil;
    if (_memoryCacheEnabled) {
        image = [cache objectForKey:key];
    }
    return image;
}

- (void)performWithImage:(UIImage *)image andKey:(NSString *)key
{
    if (_memoryCacheEnabled) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            if (image) {
                [cache setObject:image forKey:key];
            }
        });
    }
}

- (void)performWithImageData:(NSData *)imgData andKey:(NSString *)key {
    
    if (_memoryCacheEnabled) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            if (imgData) {
                [cache setObject:imgData forKey:key];
            }
        });
    }
    
}


#pragma mark -
#pragma mark - Cache

- (void)setCacheInMemory:(BOOL)enabled
{
    _memoryCacheEnabled = enabled;
}

@end