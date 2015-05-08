//
//  SharePhoto.h
//  Juxt-a-pose
//
//  Created by Brandon Phillips on 6/6/13.
//  Copyright (c) 2013 We Are Station. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
//#import <iAd/iAd.h>
#import "largeObjects.h"


@interface SharePhoto : UIViewController <UIDocumentInteractionControllerDelegate>{
    largeObjects *sharedObjects;

    UIImage *blendedCopy;
    SLComposeViewController *mySLComposerSheet;
    IBOutlet UIImageView *shareIt;
    IBOutlet UIImageView *startNew;
    
    //ADBannerView *iAdBanner;

    
    
}
@property (nonatomic, strong) UIDocumentInteractionController *docController;
@property (nonatomic, strong) NSString *blendedImageURL;
@property (nonatomic, strong) NSString *blendedImageName;
@property (nonatomic, strong) IBOutlet UIImageView *finalImageView;

-(IBAction)goBack;
-(IBAction)share:(id)sender;

@end
