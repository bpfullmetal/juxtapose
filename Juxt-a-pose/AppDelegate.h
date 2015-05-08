//
//  AppDelegate.h
//  Juxt-a-pose
//
//  Created by Brandon Phillips on 5/25/13.
//  Copyright (c) 2013 We Are Station. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

UIImage* blendedImage;
UIImage *finalBlendedImage;
UIImage *img;
NSMutableArray *imagesArray;
float sliderValue;
UIImage *image;
NSString *documentsDirectory;
NSPersistentStoreCoordinator *persistentStoreCoordinator;
NSManagedObjectModel *managedObjectModel;
NSManagedObjectContext *managedObjectContext;
NSMutableData *receivedData;
NSString *albumName;
ALAssetsLibrary *library;

@class AllPhotos;
@class FirstOpenView;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) AllPhotos *allPhotos;

@property (strong, nonatomic) FirstOpenView *firstOpen;


@end
