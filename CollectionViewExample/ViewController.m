//
//  ViewController.m
//  CollectionViewExample
//
//  Created by Sandeep Prajapat on 22/05/15.
//  Copyright (c) 2015 Ignatiuz. All rights reserved.
//

#import "ViewController.h"
#import "GridCell.h"
#import "UIImageView+DispatchLoad.h"
#import "LImageLoader.h"


@interface ViewController ()

@end

@implementation ViewController

@synthesize collectionGrid;
@synthesize SearchData, tmpDictinory;

-(void)viewDidLoad{
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self.collectionGrid.collectionViewLayout;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(10,10, 10, 10);
    
    [super viewDidLoad];
    [self fetchDataTest];
}


-(void) fetchDataTest {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://jsonplaceholder.typicode.com/photos"]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSError* JSerror;
                               SearchData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&JSerror];
                               [self.collectionGrid reloadData];
                               
                           }];
}



-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  [self.SearchData count];
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Select_Picture" forIndexPath:indexPath];
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    NSDictionary *tmpDic;
    NSMutableString *ShowThumb;
    NSMutableString *FullPath;
    
    tmpDic = [SearchData objectAtIndex:indexPath.row];
    
    cell.SearchImageView.tag = indexPath.row;
    
    ShowThumb = [NSMutableString stringWithFormat:@"%@",[tmpDic objectForKey:@"thumbnailUrl"]];
    FullPath = [NSMutableString stringWithFormat:@"%@",[tmpDic objectForKey:@"thumbnailUrl"]];
    
    cell.Activity.hidden = FALSE;
    [cell.Activity startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        LImageLoader *objMng = [LImageLoader sharedInstance];
        
        [objMng loadImageFromUrl:ShowThumb Key:[NSString stringWithFormat:@"%ld",(long)indexPath.row] completed:^(NSData *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell.SearchImageView setImage:[UIImage imageWithData:image]];
                [cell.Activity stopAnimating];
                cell.Activity.hidden = TRUE;
            });
        } failure:^(NSError *error){
            NSLog(@"displayImageFromUrl error : %@",error);
        }];
        
    });
    
    
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
