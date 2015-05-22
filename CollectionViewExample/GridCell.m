//
//  GridCell.m
//  CollectionViewExample
//
//  Created by Sandeep Prajapat on 22/05/15.
//  Copyright (c) 2015 Ignatiuz. All rights reserved.
//

#import "GridCell.h"
#import "LImageLoader.h"

@implementation GridCell

@synthesize SearchImageView, Activity;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        SearchImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        SearchImageView.clipsToBounds = YES;
        SearchImageView.contentMode = UIViewContentModeScaleAspectFill;
        SearchImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:SearchImageView];
    }
    return self;
}

- (void)prepareForReuse
{
    NSLog(@"Tag id is %ld",(long)SearchImageView.tag);
    //[self.SearchImageView hnk_cancelSetImage];
    LImageLoader *objMng = [LImageLoader sharedInstance];
    [objMng stopDataLoading:[NSString stringWithFormat:@"%ld",(long)self.SearchImageView.tag]];
    self.SearchImageView.image = nil;
}

@end
