//
//  ViewController.h
//  CollectionViewExample
//
//  Created by Sandeep Prajapat on 22/05/15.
//  Copyright (c) 2015 Ignatiuz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate> {
    
}

@property NSArray *SearchData;
@property NSDictionary *tmpDictinory;

@property (nonatomic, strong) IBOutlet UICollectionView *collectionGrid;


@end

