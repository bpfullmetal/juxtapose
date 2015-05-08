//
//  AllPhotos.h
//  Juxt-a-pose
//
//  Created by Brandon Phillips on 6/7/13.
//  Copyright (c) 2013 We Are Station. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoCell.h"
#import <CoreData/CoreData.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface AllPhotos : UIViewController<UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate, NSFetchedResultsSectionInfo>{
    NSMutableArray *pngFiles;
    NSMutableArray *imageUrls;
    NSArray *contents;
    IBOutlet UIView *firstOpen;
    PhotoCell *cellWithImage;
    ALAssetsLibrary *photoLibrary;
}
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


-(IBAction)TakePhoto;

@end
