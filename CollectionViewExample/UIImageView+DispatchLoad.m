//
//  UIImage+DispatchLoad.m
//  DreamChannel
//
//  Created by Slava on 3/28/11.
//  Copyright 2011 Alterplay. All rights reserved.
//

#import "UIImageView+DispatchLoad.h"
#import "LImageLoader.h"

@implementation UIImageView (DispatchLoad)

- (void) setImageFromUrl:(NSString*)urlString {
    [self setImageFromUrl:urlString completion:NULL];
}

- (void) setImageFromUrl:(NSString*)urlString 
              completion:(void (^)(void))completion {
    
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
        NSLog(@"Starting: %@", urlString);
        UIImage *avatarImage = nil; 
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *responseData = [NSData dataWithContentsOfURL:url];
        avatarImage = [UIImage imageWithData:responseData];
        NSLog(@"Finishing: %@", urlString);
        
        if (avatarImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = avatarImage;
            });
            dispatch_async(dispatch_get_main_queue(), completion);
        }
        else {
            NSLog(@"-- impossible download: %@", urlString);
        } */
        
        LImageLoader *objMng = [LImageLoader sharedInstance];
        
        [objMng loadImageFromUrl:urlString Key:[NSString stringWithFormat:@"%ld",(long)self.tag] completed:^(NSData *image) {
            //imageView.image = image;
            //[imageView setNeedsDisplay];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = [UIImage imageWithData:image];
            });
            dispatch_async(dispatch_get_main_queue(), completion);
            
            
            //NSString *str = [[NSString alloc] initWithData:image encoding:NSUTF8StringEncoding];
            //NSLog(@"Data is here %@",str);
        } failure:^(NSError *error){
            //imageView.image = nil;
            NSLog(@"displayImageFromUrl error : %@",error);
        }];
        
	});
    
}

@end