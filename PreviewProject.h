//
//  PreviewProject.h
//  Juxt-a-pose
//
//  Created by Brandon Phillips on 11/27/13.
//  Copyright (c) 2013 We Are Station. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "largeObjects.h"
#import "JxtaPic.h"
#import "AllPhotos.h"
#import "SharePhoto.h"
//#import <iAd/iAd.h>

@interface PreviewProject : UIViewController<UIScrollViewDelegate>{
    
    IBOutlet UIImageView *loadingText;
    IBOutlet UIActivityIndicatorView *spinner;
    
    largeObjects *sharedObjects;
    JxtaPic *activeJxtaPic;
    SharePhoto *shareView;
    
    //ADBannerView *iAdBanner;
    
    
    UIImageView *imagePreview;
    UIImageView *blendTheTopView;
    int clickTimes;
    
    IBOutlet UIView *imageHolders;
    IBOutlet UIImageView *imageSet;
    IBOutlet UIImageView *lastImage;
    IBOutlet UIScrollView *blendScroll;
    IBOutlet UIView *blendScrollView;
    IBOutlet UIView *blendContainer;
    IBOutlet UIView *saveCover;
    
    
    /*---------TUTORIAL----------*/
    
    IBOutlet UIImageView *saveIt;
    IBOutlet UIButton *addAnother;
    IBOutlet UIView *clickBlink;
    IBOutlet UIImageView *chooseBlend;
    IBOutlet UIImageView *saveBlended;
    
    /*----------BLENDS-----------*/
    IBOutlet UIButton *blendBackToNormal;
    IBOutlet UIButton *blendMultiply;
    IBOutlet UIButton *blendColorBurn;
    IBOutlet UIButton *blendColorDodge;
    IBOutlet UIButton *blendLuminosity;
    IBOutlet UIButton *blendDifference;
    IBOutlet UIButton *blendExclusion;
    IBOutlet UIButton *blendHardlight;
    IBOutlet UIButton *blendOverlay;
    IBOutlet UIButton *blendScreen;
    IBOutlet UIButton *blendSaturation;
    IBOutlet UIButton *blendHue;
    IBOutlet UIButton *blendColor;
    IBOutlet UIButton *blendDarker;
    IBOutlet UIButton *blendLighter;
    IBOutlet UIButton *blendSoftLight;
    IBOutlet UIView *buttonUnderline;
    IBOutlet UIView *arrow;
    IBOutlet UIImageView *blendedImage;

}

- (IBAction)ifClicked;

- (IBAction)saveJXTP;
- (IBAction)quit;

- (IBAction)blendColorDodge;
- (IBAction)blendLuminosity;
- (IBAction)blendIt;
- (IBAction)blendBackToNormal;
- (IBAction)blendMultiply;
- (IBAction)blendColorBurn;
- (IBAction)blendDifference;
- (IBAction)blendExclusion;
- (IBAction)blendHardlight;
- (IBAction)blendOverlay;
- (IBAction)blendScreen;
- (IBAction)blendSaturation;
- (IBAction)blendHue;
- (IBAction)blendColor;
- (IBAction)blendDarker;
- (IBAction)blendLighter;
- (IBAction)blendSoftLight;
- (IBAction)cancelBlendMode;



@end
