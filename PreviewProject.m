//
//  PreviewProject.m
//  Juxt-a-pose
//
//  Created by Brandon Phillips on 11/27/13.
//  Copyright (c) 2013 We Are Station. All rights reserved.
//

#import "PreviewProject.h"
#import "JxtaPic.h"
#import "largeObjects.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "JPic.h"

@interface PreviewProject ()

@end

@implementation PreviewProject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
    {
        // iPhone 5
        self.view = [[NSBundle mainBundle] loadNibNamed:@"PreviewProject" owner:self options:nil][0];
    }
    else
    {
        self.view = [[NSBundle mainBundle] loadNibNamed:@"PreviewProjectFour" owner:self options:nil][0];
        
    }
}

- (void)viewDidLoad
{
    NSLog(@"preview is loading");
    
    sharedObjects = [largeObjects sharedManager];
    activeJxtaPic = [[JxtaPic alloc]init];
    activeJxtaPic = sharedObjects.JxtaposePicture;
    
    [imageSet setImage:activeJxtaPic.getJxtpImageMinusLatest];
    JPic *lastPic =activeJxtaPic.lastImage;
    [lastImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:lastPic.imageurl]]];
    [lastImage setAlpha:lastPic.opacity];
    [lastImage setFrame:lastPic.frame];
    //[lastImage setBounds:lastPic.bounds];
    lastImage.transform = CGAffineTransformRotate(lastImage.transform, lastPic.rotation);
    float transX = lastImage.layer.frame.origin.x-lastPic.frame.origin.x;
    float transY = lastImage.layer.frame.origin.y-lastPic.frame.origin.y;
    lastImage.transform = CGAffineTransformMakeTranslation(transX,transY);
    //NSLog(@"tx:%f,ty:%f",transX,transY);

    //NSLog(@"lastImage Usage this is b:%@ and f:%@",NSStringFromCGRect(lastPic.bounds),NSStringFromCGRect(lastPic.frame));
    //NSLog(@"lastImage Usage this is the layer p: %@ and the layer f: %@", NSStringFromCGPoint(lastImage.layer.position), NSStringFromCGRect(lastImage.layer.frame));
    shareView = [[SharePhoto alloc]init];
    //[activeJxtaPic logImages];
    imageHolders.clipsToBounds = TRUE;
    [super viewDidLoad];
    
    
    [self configureScrollView];
    blendedImage.hidden = true;
    [blendedImage setContentMode:UIViewContentModeScaleAspectFill];
    [imagePreview setContentMode:UIViewContentModeScaleAspectFill];
}


-(void)viewDidDisappear:(BOOL)animated{
    if([[UIScreen mainScreen] bounds].size.height == 568){
    //[iAdBanner removeFromSuperview];
    NSLog(@"preview project viewDidDisAppear");
    }
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"preview project viewDidAppear");
    if([[UIScreen mainScreen] bounds].size.height == 568){
    //iAdBanner = [[ADBannerView alloc]initWithFrame:CGRectMake(0, 55, 320, 50)];
    //[self.view insertSubview:iAdBanner atIndex:10];
    }
    
    if(![[NSUserDefaults standardUserDefaults] stringForKey:@"not_first_run"]){
        addAnother.hidden = FALSE;
        if([activeJxtaPic.pictures count] > 1){
            saveIt.hidden = FALSE;
        }
        chooseBlend.hidden = FALSE;
    }else{
        saveIt.hidden = TRUE;
        addAnother.hidden = TRUE;
        saveBlended.hidden = TRUE;
        chooseBlend.hidden = TRUE;
    }
    
    if([activeJxtaPic.pictures count] > 1){
        saveCover.hidden = TRUE;
    }else{
        saveCover.hidden = FALSE;
    }
    clickTimes = 0;
    
    
    
    
    
}

- (IBAction)ifClicked{
    clickTimes++;
    if (clickTimes == 3){
        clickTimes = 0;
        clickBlink.alpha = 0.2f;
        [UIView animateWithDuration:0.5f
                              delay:0.0f
                            options:UIViewAnimationOptionAutoreverse
                         animations:^
         {
             [UIView setAnimationRepeatCount:6.0f/3.0f];
             clickBlink.alpha = 1.0f;
         }
                         completion:^(BOOL finished)
         {
             
         }];
        
    }
}


- (void)configureScrollView {
    
    CGSize size = blendScrollView.bounds.size;
    blendScrollView.frame = CGRectMake(0, 0, size.width, size.height);
    [blendScroll addSubview:blendScrollView];
    blendScroll.contentSize = size;
    blendScroll.delegate = self;
    // If you don't use self.contentView anywhere else, clear it here.
    blendScrollView = nil;
    
    imagePreview = [[UIImageView alloc] initWithImage:activeJxtaPic.getJxtpImageMinusLatest];
    JPic *lastPic =activeJxtaPic.lastImage;
    blendTheTopView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:lastPic.imageurl]]];
    [blendTheTopView setContentMode:UIViewContentModeScaleAspectFill];

    [blendTheTopView setAlpha:activeJxtaPic.getLastPictureOpacity];
    [blendTheTopView setFrame:lastPic.frame];
    //[blendTheTopView setBounds:lastPic.bounds];
    //blendTheTopView.bounds = lastPic.bounds;
    blendTheTopView.transform = CGAffineTransformRotate(blendTheTopView.transform, lastPic.rotation);

    
    [imagePreview addSubview:blendTheTopView];
    [self blendNormal];
    // If you use it elsewhere, clear it in `dealloc` and `viewDidUnload`.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    arrow.hidden = TRUE;
    chooseBlend.hidden = TRUE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelBlendMode{
    [self blendNormal];
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        [buttonUnderline setTransform:CGAffineTransformMakeTranslation(3, 0)];
    }completion:^(BOOL done){
    }];
    [blendScroll scrollRectToVisible:CGRectMake(0, 0, blendScroll.frame.size.width, blendScroll.frame.size.height) animated:YES];
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

            [blendContainer setTransform:CGAffineTransformMakeTranslation(0, 0)];
        
    }completion:^(BOOL done){
        //some completion handler
        //[sender setEnabled:YES];
    }];
}

- (IBAction)saveJXTP{
    saveIt.hidden = TRUE;
    addAnother.hidden = TRUE;
    blendedImage.hidden = FALSE;
    [UIView transitionWithView:blendContainer
                      duration:0.2
                       options:UIViewAnimationOptionCurveLinear //any animation
                    animations:^ {
                        if (blendContainer.transform.ty == 0) {
                            blendContainer.transform = CGAffineTransformMakeTranslation(0, blendContainer.frame.size.height *-1);
                        }else{
                            blendContainer.transform = CGAffineTransformMakeTranslation(0, 0);
                        }
                       
                    }
                        
                    completion:nil];
    
}

#pragma mark - blend Modes


-(IBAction)blendIt{
    loadingText.hidden = false;
    loadingText.alpha = 1.0;
    spinner.hidden = false;
    [spinner startAnimating];
    [self finished];
}

- (void) finished{
    
    __block ALAssetsGroup* groupToAddTo;
    [library enumerateGroupsWithTypes:ALAssetsGroupAlbum
                                usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                    if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:albumName]) {
                                        groupToAddTo = group;
                                    }
                                }
                              failureBlock:^(NSError* error) {
                                  NSLog(@"failed to enumerate albums:\nError: %@", [error localizedDescription]);
                              }];
    
    /*NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSDate *date = [[NSDate alloc] init];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:date];*/
    NSData *pngData = UIImageJPEGRepresentation(activeJxtaPic.exportedImage, 1.0);
    CGImageRef img = [[UIImage imageWithData:pngData] CGImage];
    /*NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *fileName = [NSString stringWithFormat:@"image_%@.jpg", formattedDateString];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName]; //Add the file name
    [pngData writeToFile:filePath atomically:YES]; //Write the file*/
    
    [library writeImageToSavedPhotosAlbum:img
                                      metadata:nil
                                      completionBlock:^(NSURL* assetURL, NSError* error) {
        if (error.code == 0) {
            [library assetForURL:assetURL
                resultBlock:^(ALAsset *asset) {
                    [groupToAddTo addAsset:asset];
                    [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:@"not_first_run"];
                        NSURL *JXTPurl = [asset valueForProperty:ALAssetPropertyAssetURL];
                        NSString *urlString = [[NSString alloc] initWithFormat:@"%@", JXTPurl];
                    NSString *JXTPdate = [NSString stringWithFormat:@"%@", [asset valueForProperty:ALAssetPropertyDate]];
                        shareView.blendedImageURL = urlString;
                    NSManagedObject *photoModel = [NSEntityDescription insertNewObjectForEntityForName:@"AFPhotoModel" inManagedObjectContext:managedObjectContext];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    [photoModel setValue:urlString forKey:@"photoImageData"];
                                    [photoModel setValue:JXTPdate forKey:@"photoName"];
                                    SharePhoto *share = [[SharePhoto alloc] initWithNibName:@"SharePhoto" bundle:nil];
                                    share.blendedImageURL = urlString;
                                    share.blendedImageName = urlString;
                                    sharedObjects.JxtaposePicture = Nil;
                                    
                                    [self.navigationController pushViewController:shareView animated:YES];
                                    [UIImageView transitionWithView:loadingText
                                                           duration:0.2
                                                            options:UIViewAnimationOptionCurveLinear //any animation
                                                         animations:^ {
                                                             
                                                             loadingText.alpha = 0.0;
                                                             loadingText.hidden = true;
                                                             [spinner stopAnimating];
                                                             spinner.hidden = true;
                                                         }
                                     
                                                         completion:nil];
                                    //newImage.image = NULL;
                                    });
                    
                                        }
                                                    failureBlock:^(NSError* error) {
                                                        NSLog(@"failed to retrieve image asset:\nError: %@ ", [error localizedDescription]);
                                                    }];
                                   }
                                   else {

                                   }
                               }];
    NSLog(@"shared: %@", sharedObjects);
    
    //NSString *urlString = [[NSString alloc] initWithFormat:@"file://%@", filePath];
    
    
    /*SharePhoto *share = [[SharePhoto alloc] initWithNibName:@"SharePhoto" bundle:nil];
    share.blendedImageURL = urlString;
    share.blendedImageName = fileName;
    
    newImage.image = NULL;*/
    
    
}

- (void)blendNormal{
    UIGraphicsBeginImageContext(imagePreview.frame.size);
    //CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
    [imagePreview.layer renderInContext:UIGraphicsGetCurrentContext()];
    [blendedImage setImage: UIGraphicsGetImageFromCurrentImageContext()];
    UIGraphicsEndImageContext();
    activeJxtaPic.blendingMode = Normal;
}

- (IBAction)blendBackToNormal{
    UIGraphicsBeginImageContext(imagePreview.frame.size);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
    [imagePreview.layer renderInContext:UIGraphicsGetCurrentContext()];
    [blendedImage setImage: UIGraphicsGetImageFromCurrentImageContext()];
    UIGraphicsEndImageContext();
    activeJxtaPic.blendingMode = Normal;
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        [buttonUnderline setTransform:CGAffineTransformMakeTranslation(3, 0)];
    }completion:^(BOOL done){
    }];
}

- (IBAction)blendMultiply{
    UIGraphicsBeginImageContext(imagePreview.frame.size);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeMultiply);
    [imagePreview.layer renderInContext:UIGraphicsGetCurrentContext()];
    [blendedImage setImage: UIGraphicsGetImageFromCurrentImageContext()];
    UIGraphicsEndImageContext();
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        [buttonUnderline setTransform:CGAffineTransformMakeTranslation(60, 0)];
    }completion:^(BOOL done){
    }];
    activeJxtaPic.blendingMode = Multiply;
    if(![[NSUserDefaults standardUserDefaults] stringForKey:@"not_first_run"]){
    saveBlended.hidden = FALSE;
    chooseBlend.hidden = TRUE;
    }
}

- (IBAction)blendColorBurn{
    UIGraphicsBeginImageContext(imagePreview.frame.size);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeColorBurn);
    [imagePreview.layer renderInContext:UIGraphicsGetCurrentContext()];
    [blendedImage setImage: UIGraphicsGetImageFromCurrentImageContext()];
    UIGraphicsEndImageContext();
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        [buttonUnderline setTransform:CGAffineTransformMakeTranslation(122, 0)];
    }completion:^(BOOL done){
    }];
    activeJxtaPic.blendingMode = ColorBurn;
    if(![[NSUserDefaults standardUserDefaults] stringForKey:@"not_first_run"]){
        saveBlended.hidden = FALSE;
        chooseBlend.hidden = TRUE;
    }
}
 
 - (IBAction)blendDarker{
 UIGraphicsBeginImageContext(imagePreview.frame.size);
 CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModePlusDarker);
 [imagePreview.layer renderInContext:UIGraphicsGetCurrentContext()];
 [blendedImage setImage: UIGraphicsGetImageFromCurrentImageContext()];
 UIGraphicsEndImageContext();
 [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
 [buttonUnderline setTransform:CGAffineTransformMakeTranslation(180, 0)];
 }completion:^(BOOL done){
 }];
     activeJxtaPic.blendingMode = Darker;
     if(![[NSUserDefaults standardUserDefaults] stringForKey:@"not_first_run"]){
         saveBlended.hidden = FALSE;
         chooseBlend.hidden = TRUE;
     }
 }
 
 - (IBAction)blendLighter{
 UIGraphicsBeginImageContext(imagePreview.frame.size);
 CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModePlusLighter);
 [imagePreview.layer renderInContext:UIGraphicsGetCurrentContext()];
 [blendedImage setImage: UIGraphicsGetImageFromCurrentImageContext()];
 UIGraphicsEndImageContext();
 [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
 [buttonUnderline setTransform:CGAffineTransformMakeTranslation(240, 0)];
 }completion:^(BOOL done){
 }];
     activeJxtaPic.blendingMode = Lighter;
     if(![[NSUserDefaults standardUserDefaults] stringForKey:@"not_first_run"]){
         saveBlended.hidden = FALSE;
         chooseBlend.hidden = TRUE;
     }
 }
 
 
 - (IBAction)blendDifference{
 UIGraphicsBeginImageContext(imagePreview.frame.size);
 CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeDifference);
 [imagePreview.layer renderInContext:UIGraphicsGetCurrentContext()];
 [blendedImage setImage: UIGraphicsGetImageFromCurrentImageContext()];
 UIGraphicsEndImageContext();
 [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
 [buttonUnderline setTransform:CGAffineTransformMakeTranslation(300, 0)];
 }completion:^(BOOL done){
 }];
     activeJxtaPic.blendingMode = Difference;
     if(![[NSUserDefaults standardUserDefaults] stringForKey:@"not_first_run"]){
         saveBlended.hidden = FALSE;
         chooseBlend.hidden = TRUE;
     }
 }
 
 - (IBAction)blendExclusion{
 UIGraphicsBeginImageContext(imagePreview.frame.size);
 CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeExclusion);
 [imagePreview.layer renderInContext:UIGraphicsGetCurrentContext()];
 [blendedImage setImage: UIGraphicsGetImageFromCurrentImageContext()];
 UIGraphicsEndImageContext();
 [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
 [buttonUnderline setTransform:CGAffineTransformMakeTranslation(360, 0)];
 }completion:^(BOOL done){
 }];
     activeJxtaPic.blendingMode = Exclusion;
     if(![[NSUserDefaults standardUserDefaults] stringForKey:@"not_first_run"]){
         saveBlended.hidden = FALSE;
         chooseBlend.hidden = TRUE;
     }
 }

 
 - (IBAction)blendOverlay{
 UIGraphicsBeginImageContext(imagePreview.frame.size);
 CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeOverlay);
 [imagePreview.layer renderInContext:UIGraphicsGetCurrentContext()];
 [blendedImage setImage: UIGraphicsGetImageFromCurrentImageContext()];
 UIGraphicsEndImageContext();
 [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
 [buttonUnderline setTransform:CGAffineTransformMakeTranslation(419, 0)];
 }completion:^(BOOL done){
 }];
     activeJxtaPic.blendingMode = Overlay;
     if(![[NSUserDefaults standardUserDefaults] stringForKey:@"not_first_run"]){
         saveBlended.hidden = FALSE;
         chooseBlend.hidden = TRUE;
     }
 }

 - (IBAction)blendScreen{
 UIGraphicsBeginImageContext(imagePreview.frame.size);
 CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeScreen);
 [imagePreview.layer renderInContext:UIGraphicsGetCurrentContext()];
 [blendedImage setImage: UIGraphicsGetImageFromCurrentImageContext()];
 UIGraphicsEndImageContext();
 [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
 [buttonUnderline setTransform:CGAffineTransformMakeTranslation(480, 0)];
 }completion:^(BOOL done){
 }];
     activeJxtaPic.blendingMode = Screen;
     if(![[NSUserDefaults standardUserDefaults] stringForKey:@"not_first_run"]){
         saveBlended.hidden = FALSE;
         chooseBlend.hidden = TRUE;
     }
 }
 
- (IBAction)blendHardlight{
    UIGraphicsBeginImageContext(imagePreview.frame.size);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeHardLight);
    [imagePreview.layer renderInContext:UIGraphicsGetCurrentContext()];
    [blendedImage setImage: UIGraphicsGetImageFromCurrentImageContext()];
    UIGraphicsEndImageContext();
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        [buttonUnderline setTransform:CGAffineTransformMakeTranslation(540, 0)];
    }completion:^(BOOL done){
    }];
    activeJxtaPic.blendingMode = Hardlight;
    if(![[NSUserDefaults standardUserDefaults] stringForKey:@"not_first_run"]){
        saveBlended.hidden = FALSE;
        chooseBlend.hidden = TRUE;
    }
}

- (IBAction)blendSaturation{
    UIGraphicsBeginImageContext(imagePreview.frame.size);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeSaturation);
    [imagePreview.layer renderInContext:UIGraphicsGetCurrentContext()];
    [blendedImage setImage: UIGraphicsGetImageFromCurrentImageContext()];
    UIGraphicsEndImageContext();
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        [buttonUnderline setTransform:CGAffineTransformMakeTranslation(600, 0)];
    }completion:^(BOOL done){
    }];
    activeJxtaPic.blendingMode = Saturation;
    if(![[NSUserDefaults standardUserDefaults] stringForKey:@"not_first_run"]){
        saveBlended.hidden = FALSE;
        chooseBlend.hidden = TRUE;
    }
}
 
 - (IBAction)blendColorDodge{
 UIGraphicsBeginImageContext(imagePreview.frame.size);
 CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeColorDodge);
 [imagePreview.layer renderInContext:UIGraphicsGetCurrentContext()];
 [blendedImage setImage: UIGraphicsGetImageFromCurrentImageContext()];
 UIGraphicsEndImageContext();
 [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
 [buttonUnderline setTransform:CGAffineTransformMakeTranslation(660, 0)];
 }completion:^(BOOL done){
 }];
     activeJxtaPic.blendingMode = Colordodge;
     if(![[NSUserDefaults standardUserDefaults] stringForKey:@"not_first_run"]){
         saveBlended.hidden = FALSE;
         chooseBlend.hidden = TRUE;
     }
 }
 
 - (IBAction)blendLuminosity{
 UIGraphicsBeginImageContext(imagePreview.frame.size);
 CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeLuminosity);
 [imagePreview.layer renderInContext:UIGraphicsGetCurrentContext()];
 [blendedImage setImage: UIGraphicsGetImageFromCurrentImageContext()];
 UIGraphicsEndImageContext();
 [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
 [buttonUnderline setTransform:CGAffineTransformMakeTranslation(720, 0)];
 }completion:^(BOOL done){
 }];
     activeJxtaPic.blendingMode = Luminosity;
     if(![[NSUserDefaults standardUserDefaults] stringForKey:@"not_first_run"]){
         saveBlended.hidden = FALSE;
         chooseBlend.hidden = TRUE;
     }
 }
 
 - (IBAction)blendSoftLight{
 UIGraphicsBeginImageContext(imagePreview.frame.size);
 CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeSoftLight);
 [imagePreview.layer renderInContext:UIGraphicsGetCurrentContext()];
 [blendedImage setImage: UIGraphicsGetImageFromCurrentImageContext()];
 UIGraphicsEndImageContext();
 [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
 [buttonUnderline setTransform:CGAffineTransformMakeTranslation(780, 0)];
 }completion:^(BOOL done){
 }];
     activeJxtaPic.blendingMode = SoftLight;
     if(![[NSUserDefaults standardUserDefaults] stringForKey:@"not_first_run"]){
         saveBlended.hidden = FALSE;
         chooseBlend.hidden = TRUE;
     }
 }

- (IBAction)blendHue{
    UIGraphicsBeginImageContext(imagePreview.frame.size);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeHue);
    [imagePreview.layer renderInContext:UIGraphicsGetCurrentContext()];
    [blendedImage setImage: UIGraphicsGetImageFromCurrentImageContext()];
    UIGraphicsEndImageContext();
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        [buttonUnderline setTransform:CGAffineTransformMakeTranslation(841, 0)];
    }completion:^(BOOL done){
    }];
    activeJxtaPic.blendingMode = Hue;
    if(![[NSUserDefaults standardUserDefaults] stringForKey:@"not_first_run"]){
        saveBlended.hidden = FALSE;
        chooseBlend.hidden = TRUE;
    }
}

- (IBAction)blendColor{
    UIGraphicsBeginImageContext(imagePreview.frame.size);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeColor);
    [imagePreview.layer renderInContext:UIGraphicsGetCurrentContext()];
    [blendedImage setImage: UIGraphicsGetImageFromCurrentImageContext()];
    UIGraphicsEndImageContext();
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        [buttonUnderline setTransform:CGAffineTransformMakeTranslation(900, 0)];
    }completion:^(BOOL done){
    }];
    activeJxtaPic.blendingMode = Color;
    if(![[NSUserDefaults standardUserDefaults] stringForKey:@"not_first_run"]){
        saveBlended.hidden = FALSE;
        chooseBlend.hidden = TRUE;
    }
}


- (void)blendUnderlinePosition:(float)xPosition blendUnderlineWidth:(float)buttonWidth{
    
    //float underlineWidth = buttonUnderline.frame.size.width;
    //float additionalDistance = (buttonWidth / 2) - (underlineWidth /2);
    //float underlinePosition = buttonUnderline.frame.origin.x;
    //float distanceToMove = (xPosition + additionalDistance) - underlinePosition;
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        [buttonUnderline setTransform:CGAffineTransformMakeTranslation(((xPosition) *2)-8, 0)];
    }completion:^(BOOL done){
    }];

}

- (IBAction)addANewPhoto:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addImage" object:self];
    NSMutableArray *controllers = [self.navigationController.viewControllers mutableCopy];
    NSLog(@"these are the views: %@", controllers);
    [controllers removeLastObject];
    self.navigationController.viewControllers = controllers;
    NSLog(@"%@", self.navigationController.viewControllers);
    
}

- (IBAction)quit{
    [self goHomeOrcancel];
}

- (void)goHomeOrcancel{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:Nil
                                                      message:@"This will delete your current juxt-a-pose"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Delete", nil];
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Cancel"])
    {
    }
    else if([title isEqualToString:@"Delete"])
    {
        sharedObjects.JxtaposePicture = Nil;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
