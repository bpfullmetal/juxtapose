//
//  ViewController.h
//  Juxt-a-pose
//
//  Created by Brandon Phillips on 5/25/13.
//  Copyright (c) 2013 We Are Station. All rights reserved.
//


#import <UIKit/UIKit.h>
//#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
//#import <MediaPlayer/MediaPlayer.h>
//#import <iAd/iAd.h>
#import "PreviewProject.h"
#import "largeObjects.h"

@class JxtaPic, JPic;


@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate>{

    //ADBannerView *iAdBanner;
    
    /*-------Juxtapose Objects-------*/
    JxtaPic *newJuxtaposeImage;
    largeObjects *sharedObjects;
    
    /*-------PREVIEW IMAGE------*/
    
    CGFloat lastScale;
    UIImageView *coverBg;
    float senderScale;
    NSTimer *shootTimer;
    
    //IBOutlet UIView *coverPreview;
    
    //IBOutlet UIImageView *previewTransparent;
    //IBOutlet UIImageView *previewOpaque;
    
    /*---------TUTORIAL---------*/
    
    
    UIImagePickerController *picker;
    UIImagePickerController *uploader;
    
    BOOL cameraMode;
    
    IBOutlet UIView *sliderHolder;
    IBOutlet UIImageView *adjustTran;
    
    /*----------CAMERA----------*/
    
    IBOutlet UIView *pictureTaker;
    PreviewProject *PreviewTheImage;
    
    IBOutlet UIView *imageHolder;
    UIImageView *bigGreen;
    UIImageView *bigOrange;
    UIImageView *newImage;
    UIImageView *overlayView;
    //NSData *pngData;
    UIView *realOverlayView;
    CGRect bounds;
    NSString *flashStatus;
    int cameraRotation;
    
    IBOutlet UIButton *flipCam;
    IBOutlet UIView *touchView;
    IBOutlet UISlider *slider;
    IBOutlet UISlider *previewSlider;
    IBOutlet UIImageView *transparent;
    IBOutlet UIImageView *opaque;
    
    IBOutlet UIImageView *previewTransparent;
    IBOutlet UIImageView *previewOpaque;
    
    IBOutlet UIView *camBG;
    IBOutlet UIView *previewView;
    IBOutlet UIImageView *previewImage;
    IBOutlet UIImageView *flattenedImage;
    IBOutlet UIView *takePicCover;
    
    __weak IBOutlet UIButton *toggleFlashMode;
    UIImage *imageCopy;
    float timer;
    
    /*---------MAIN VIEW--------*/
    
    UIImage *image;
    
    IBOutlet UIImageView *imageView;
    IBOutlet UIView *chooseYourDestiny;
    
    /*-------------MANIPULATE-------------*/
    
    //UIPinchGestureRecognizer *pinch;
    //UIRotationGestureRecognizer *rotation;
    //UIPanGestureRecognizer *pan;
    
   
    
    CGFloat _lastScale;
    CGFloat _lastRotation;
    CGFloat _firstX;
    CGFloat _firstY;
    CGPoint movePoint;
    
    CGFloat AcuScale;
    CGFloat AcuRotation;
    CGPoint AcuPoint;
    CGPoint AcuSize;
    CGFloat PosX;
    CGFloat PosY;
    
    bool rotating;
    bool scaling;
    bool moving;
    
    CGFloat frameX;
    CGFloat frameY;
    
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;



//-(IBAction)home;
-(IBAction)cancelPhoto;
-(IBAction)cameraFlip;
//-(IBAction)finished;
-(IBAction)usePhoto;
//-(IBAction)TakePhoto;
-(IBAction)FlashToggle;
//-(IBAction)photosPage;
-(IBAction)sliderChanged:(id)sender;
-(IBAction)shoot;
-(IBAction)cancelPreview;
//- (IBAction)rotateGesture:(UIRotationGestureRecognizer *)sender;


//- (IBAction)pinchGesture:(UIPinchGestureRecognizer *)sender;
//- (IBAction)panGesture:(UIPanGestureRecognizer *)sender;



/*---------------------------------------------START NEW STUFF----------------------------------------------*/

- (IBAction)chooseCamera;
- (IBAction)chooseUpload;

- (IBAction)cancelNewPhoto;



/*---------------------------------------------END NEW STUFF------------------------------------------------*/

//@property (nonatomic, retain) IBOutlet UILabel *sliderValue;
@property (nonatomic) BOOL showsCameraControls;

//- (UIImage *)fixOrientation;
@end
