//
//  AllPhotos.m
//  Juxt-a-pose
//
//  Created by Brandon Phillips on 6/7/13.
//  Copyright (c) 2013 We Are Station. All rights reserved.
//

#import "AllPhotos.h"
#import "PhotoCell.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "DetailView.h"
#import <CoreData/CoreData.h>

@interface AllPhotos ()

@end

@implementation AllPhotos{
    NSMutableArray *_objectChanges;
    NSMutableArray *_sectionChanges;
}

@synthesize name;
@synthesize indexTitle;
@synthesize objects;
@synthesize numberOfObjects;



- (void)awakeFromNib
{
    [super awakeFromNib];
}





- (IBAction)TakePhoto{
    
    NSArray* tmpDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL];
    for (NSString *file in tmpDirectory) {
        NSLog(@"file in temp directory: %@", file);
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), file] error:NULL];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@"first" forKey:@"base_photo"];
    ViewController *addPhotos = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    [[self navigationController] pushViewController:addPhotos animated:NO];

}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)loadView{
    if([[UIScreen mainScreen] bounds].size.height == 568)
    {
        // iPhone 5
        self.view = [[NSBundle mainBundle] loadNibNamed:@"AllPhotos" owner:self options:nil][0];
    }
    else
    {
        self.view = [[NSBundle mainBundle] loadNibNamed:@"AllPhotosFour" owner:self options:nil][0];
    }
}

- (void)viewDidAppear:(BOOL)animated{

}

- (void)viewWillAppear:(BOOL)animated{
    NSString *flag = [[NSUserDefaults standardUserDefaults] stringForKey:@"not_first_run"];
    if(!flag){
        firstOpen.hidden = FALSE;
    }else{
        firstOpen.hidden = TRUE;
        [self.collectionView reloadData];
        //[self.collectionView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshView)
                                                 name:@"reloadAll" object:nil];
    
    albumName = @"Juxt-a-pose";
    library = [[ALAssetsLibrary alloc] init];
    [library addAssetsGroupAlbumWithName:albumName
                             resultBlock:^(ALAssetsGroup *group) {
                                 NSLog(@"added album:%@", albumName);
                                 
                                 NSFileManager *fileManager = [NSFileManager defaultManager];
                                 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                 documentsDirectory = [paths objectAtIndex:0];
                                 contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:nil];
                                 NSString *extension = @"jpg";
                                 NSString *filename;
                                 NSMutableArray *photocheckarray = [[NSMutableArray alloc]init];
                                 for (filename in contents)
                                 {
                                     if ([[filename pathExtension] isEqualToString:extension])
                                     {
                                         [photocheckarray addObject:@"photo"];
                                     }
                                 }
                                 if (photocheckarray.count > 0){
                                     [self saveOldPhotos];
                                     NSLog(@"there are images");
                                 }else{
                                     NSLog(@"there are no images");
                                     [self prepareForCollectionView];
                                 }
                             }
                            failureBlock:^(NSError *error) {
                                NSLog(@"error adding album");
                            }];
    


}

- (void)saveOldPhotos{
    NSString *extension = @"jpg";
    NSString *filename;
    for (filename in contents)
    {
        if ([[filename pathExtension] isEqualToString:extension])
        {
            NSString *imageURL = [documentsDirectory stringByAppendingPathComponent:filename];
            
            //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSURL *urlFormat = [NSURL URLWithString:imageURL];
            NSString *urlString = [[NSString alloc] initWithFormat:@"file://%@", urlFormat];
            NSLog(@"urlstring: %@", urlString);
            [self saveToAlbum:urlString];
        }
    }
    [self prepareForCollectionView];
}

- (void)saveToAlbum:(NSString *)OldUrlString{
    __block ALAssetsGroup* groupToAddTo;
    [library enumerateGroupsWithTypes:ALAssetsGroupAlbum
                           usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                               if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:albumName]) {
                                   NSLog(@"found album %@", albumName);
                                   groupToAddTo = group;
                               }
                           }
                         failureBlock:^(NSError* error) {
                             NSLog(@"failed to enumerate albums:\nError: %@", [error localizedDescription]);
                         }];
    
    
    NSData *pngData = UIImageJPEGRepresentation([UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:OldUrlString]]], 1.0);
    CGImageRef img = [[UIImage imageWithData:pngData] CGImage];
    
    [library writeImageToSavedPhotosAlbum:img
                                 metadata:nil
                          completionBlock:^(NSURL* assetURL, NSError* error) {
                              if (error.code == 0) {
                                  [library assetForURL:assetURL
                                           resultBlock:^(ALAsset *asset) {
                                               [groupToAddTo addAsset:asset];
                                               [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:@"not_first_run"];
                                               NSURL *JXTPurl = [asset valueForProperty:ALAssetPropertyAssetURL];
                                               NSString *NewUrlString = [[NSString alloc] initWithFormat:@"%@", JXTPurl];
                                               NSString *JXTPdate = [NSString stringWithFormat:@"%@", [asset valueForProperty:ALAssetPropertyDate]];
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   NSManagedObject *photoModel = [NSEntityDescription insertNewObjectForEntityForName:@"AFPhotoModel" inManagedObjectContext:managedObjectContext];
                                                   [photoModel setValue:NewUrlString forKey:@"photoImageData"];
                                                   [photoModel setValue:JXTPdate forKey:@"photoName"];

                                                   [[NSFileManager defaultManager] removeItemAtURL:[NSURL URLWithString:OldUrlString] error:NULL];
                                               });
                                           }
                                          failureBlock:^(NSError* error) {
                                              NSLog(@"failed to retrieve image asset:\nError: %@ ", [error localizedDescription]);
                                          }];
                              }
                              else {
                                  NSLog(@"didn't save");
                              }
                          }];
}

- (void) prepareForCollectionView{
    
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundSmall.png"]];
    if ([[UIDevice currentDevice] systemVersion].floatValue < 7.0){
        self.collectionView.transform = CGAffineTransformMakeTranslation(0, 42);
    }
    _objectChanges = [NSMutableArray array];
    _sectionChanges = [NSMutableArray array];
    NSMutableArray *arrayOfImages = [[NSMutableArray alloc]init];
    NSString *album = @"Juxt-a-pose";
    __block ALAssetsGroup* groupToAddTo;
    [library enumerateGroupsWithTypes:ALAssetsGroupAlbum
                                usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                    if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:album]) {
                                        groupToAddTo = group;
                                        [groupToAddTo enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
                                         {
                                             if(result == nil)
                                             {
                                                 return;
                                             }
                                             
                                             [arrayOfImages addObject:result];
                                             
                                                 if ((int)arrayOfImages.count == (int)group.numberOfAssets){
                                                     [self putImagesInCollectionView:arrayOfImages];
                                                 };
                                         }];
                                    }
                                }
                              failureBlock:^(NSError* error) {
                                  NSLog(@"failed to enumerate albums:\nError: %@", [error localizedDescription]);
                              }];
}

- (void)putImagesInCollectionView:(NSMutableArray *)cvImages{
    int imageCount = 0;
    for(ALAsset *asset in cvImages){
        NSURL *JXTPurl = [asset valueForProperty:ALAssetPropertyAssetURL];
        NSString *JXTPdate = [NSString stringWithFormat:@"%@", [asset valueForProperty:ALAssetPropertyDate]];
        // MAKE NEW MANAGED OBJECT
        NSString *urlString = [[NSString alloc] initWithFormat:@"%@", JXTPurl];
        
        NSManagedObject *photoModel = [NSEntityDescription insertNewObjectForEntityForName:@"AFPhotoModel" inManagedObjectContext:self.managedObjectContext];
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

        NSLog(@"This photo date: %@", JXTPdate);
        [photoModel setValue:urlString forKey:@"photoImageData"];
        [photoModel setValue:JXTPdate forKey:@"photoName"];
        imageCount ++;
        if (imageCount == cvImages.count){
            self.collectionView.delegate = self;
            self.collectionView.dataSource = self;
            
        }
    }
   // self.collectionView.delegate = self;
   // self.collectionView.dataSource = self;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section

{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
    
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{


    [self.collectionView registerNib:[UINib nibWithNibName:@"PhotoCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    PhotoCell *cellWithImages = (PhotoCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    self.collectionView.showsVerticalScrollIndicator=NO;
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];

    [library assetForURL:[NSURL URLWithString:[object valueForKey:@"photoImageData"]] resultBlock:^(ALAsset *asset){
        [cellWithImages.imageView setImage: [UIImage imageWithCGImage:asset.aspectRatioThumbnail]];
        
    }
     
            failureBlock:^(NSError *error){
                
            }];

    NSLog(@"photo Name: %@", [object valueForKey:@"photoImageData"]);
    return cellWithImages;

}


-(void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    DetailView *details = [[DetailView alloc] initWithNibName:@"DetailView" bundle:nil];
    details.detailItem = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[object valueForKey:@"photoImageData"]]]];
    details.itemString = [object valueForKey:@"photoImageData"];
    [details setDetailItem:object];
    [[self navigationController] pushViewController:details animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*------------------START COREDATA--------------------*/


- (NSFetchedResultsController *)fetchedResultsController
{

    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AFPhotoModel" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"photoName" ascending:NO];
    NSLog(@"date: %@", self.managedObjectContext.insertedObjects);
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
    
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    NSMutableDictionary *change = [NSMutableDictionary new];
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = @[@(sectionIndex)];
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = @[@(sectionIndex)];
            break;
    }
    
    [_sectionChanges addObject:change];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    NSMutableDictionary *change = [NSMutableDictionary new];
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = newIndexPath;
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeUpdate:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeMove:
            change[@(type)] = @[indexPath, newIndexPath];
            break;
    }
    [_objectChanges addObject:change];
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if ([_sectionChanges count] > 0)
    {
        [self.collectionView performBatchUpdates:^{
            
            for (NSDictionary *change in _sectionChanges)
            {
                [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
                    
                    NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                    switch (type)
                    {
                        case NSFetchedResultsChangeInsert:
                            [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                        case NSFetchedResultsChangeDelete:
                            [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                        case NSFetchedResultsChangeUpdate:
                            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                    }
                }];
            }
        } completion:nil];
    }
    
    if ([_objectChanges count] > 0 && [_sectionChanges count] == 0)
    {
        [self.collectionView performBatchUpdates:^{
            
            for (NSDictionary *change in _objectChanges)
            {
                [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
                    
                    NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                    switch (type)
                    {
                        case NSFetchedResultsChangeInsert:
                            [self.collectionView insertItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeDelete:
                            [self.collectionView deleteItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeUpdate:
                            [self.collectionView reloadItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeMove:
                            [self.collectionView moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
                            break;
                    }
                }];
            }
        } completion:nil];
    }
    
    [_sectionChanges removeAllObjects];
    [_objectChanges removeAllObjects];
}



@end
