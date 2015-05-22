//
//  LImageLoader.h
//  LTMobileLibrary
//
//   25/07/14.
//  Copyright (c) 2014 Ignatiuz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LImageLoader : NSObject {
    
}

/**
 Instance method
 @return shared instance.
 */
+ (LImageLoader *)sharedInstance;


/**
 Load image from url
 @param urlString The url of image.
 @param completed Completed is a completion block that will call after image loading.
 @param canceled Canceled is a block that will if loading opedation was calceled.
 */
- (void)loadImageFromUrl:(NSString *)urlString Key:(NSString*)key completed:(void(^)(NSData *image))completed
failure:(void(^)(NSError *error))failure;

/**
 Load image from url
 @param urlString The url of image.
 @param imageView UIImageView in which will display image.
 */
- (void)displayImageFromUrl:(NSString *)urlString Key:(NSString*)key;

/**
 Stop all active operations
 */
- (void)stopDataLoading:(NSString*)key;

@end

@interface LImageLoader (Subclassing)

/**
 Returns the URL sessions used to download the image. Override to use a custom session. Uses sharedSession by default.
 */
@property (nonatomic, readonly) NSURLSession *URLSession;

@end
