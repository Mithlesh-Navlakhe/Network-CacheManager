//
//  LImageCacheManager.h
//  LTMobileLibrary
//
//   25/07/14.
//  Copyright (c) 2014 Ignatiuz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface LImageCacheManager : NSObject

/**
 memory cache
 @param memoryCacheEnabled by default is YES
 **/
@property (nonatomic, readonly, getter = isMemoryCacheEnabled) BOOL memoryCacheEnabled;


+ (instancetype)sharedInstance;

- (void)setCacheInMemory:(BOOL)enabled;

- (UIImage *)imageByKey:(NSString *)key;

- (void)performWithImage:(UIImage *)image andKey:(NSString *)key;

- (NSData *)imageDataByKey:(NSString *)key;

- (void)performWithImageData:(NSData *)imgData andKey:(NSString *)key;

@end
