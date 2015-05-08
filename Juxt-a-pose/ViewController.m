//
//  ViewController.m
//  Juxt-a-pose
//
//  Created by Brandon Phillips on 5/25/13.
//  Copyright (c) 2013 We Are Station. All rights reserved.
//

#import "ViewController.h"
#import "SharePhoto.h"
#import "AppDelegate.h"
#import "AllPhotos.h"
#import "JxtaPic.h"
#import "JPic.h"


@interface ViewController ()

@end

@implementation ViewController
//@synthesize sliderValue;

-(void) startCam{
    cameraMode = YES;
    if (sharedObjects.JxtaposePicture && ([newJuxtaposeImage.pictures count] > 0) ){
        [flattenedImage setImage:newJuxtaposeImage.getJxtpImage];
        newImage=[[UIImageView alloc] init];
        [newImage setFrame:CGRectMake(0, 0, 300, 300)];
        [newImage setImage:newJuxtaposeImage.getJxtpImage];
        [newImage setContentMode:UIViewContentModeScaleAspectFill];
        slider.hidden = FALSE;
        transparent.hidden = FALSE;
        opaque.hidden = FALSE;
        slider.value = 0.5;
        sliderValue = slider.value;
    }else{
        slider.hidden = TRUE;
        transparent.hidden = TRUE;
        opaque.hidden = TRUE;
        slider.value = 1.0;
        sliderValue = slider.value;
    }
    
    if(![[NSUserDefaults standardUserDefaults] stringForKey:@"not_first_run"] && ([newJuxtaposeImage.pictures count] > 0)){
        adjustTran.hidden = FALSE;
    }else{
        adjustTran.hidden = TRUE;
    }
    [[NSUserDefaults standardUserDefaults]setObject:@"camera" forKey:@"cameraOrUpload"];
    takePicCover.hidden = FALSE;
    [self startTimer];
    [self presentViewController:picker animated:YES completion:NULL];
    [self OverlayImageOnTop];
}


- (void) OverlayImageOnTop{
    
    
    // UIView *pickerView = picker.view;
    [overlayView setImage: newJuxtaposeImage.getJxtpImage];
    //[overlayView setContentMode:UIViewContentModeScaleAspectFill];
    if(realOverlayView.subviews.count > 0){
        [realOverlayView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        picker.cameraOverlayView = nil;
    }
    if(sliderHolder.subviews.count > 0){
        [sliderHolder.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [realOverlayView addSubview:overlayView];
    [realOverlayView insertSubview:bigGreen aboveSubview:overlayView];
    [realOverlayView insertSubview:bigOrange aboveSubview:bigGreen];
    [realOverlayView insertSubview:camBG aboveSubview:bigOrange];
    [overlayView setAlpha:.5];
    [sliderHolder addSubview:slider];

    picker.cameraOverlayView = realOverlayView;
    
    flashStatus = [[NSUserDefaults standardUserDefaults] stringForKey:@"flash_mode"];
    if([flashStatus isEqualToString: @"flashAuto"]){
        [picker setCameraFlashMode:UIImagePickerControllerCameraFlashModeAuto];
        [toggleFlashMode setBackgroundImage:[UIImage imageNamed:@"flashAuto.png"] forState:UIControlStateNormal];
    }else if([flashStatus isEqualToString: @"flashOn"]){
        [picker setCameraFlashMode:UIImagePickerControllerCameraFlashModeOn];
        [toggleFlashMode setBackgroundImage:[UIImage imageNamed:@"flashOn.png"] forState:UIControlStateNormal];
    }else if([flashStatus isEqualToString: @"flashOff"]){
        [picker setCameraFlashMode:UIImagePickerControllerCameraFlashModeOff];
        [toggleFlashMode setBackgroundImage:[UIImage imageNamed:@"flashOff.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)chooseCamera{
    [self startCam];
}

- (IBAction)chooseUpload{
    
    [[NSUserDefaults standardUserDefaults]setObject:@"upload" forKey:@"cameraOrUpload"];
    [self presentViewController:uploader animated:YES completion:NULL];
}

-(IBAction)finished{

}

- (IBAction)cameraFlip{
    if( [UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceFront]){
        if(picker.cameraDevice == UIImagePickerControllerCameraDeviceRear){
            
            picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            cameraRotation = 1;
            
        }else{
            picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            cameraRotation = 0;
        }
    }
}

- (IBAction)FlashToggle{
    
    
    UIImagePickerControllerCameraFlashMode flashSet = picker.cameraFlashMode;
    switch(flashSet) {
            
        case UIImagePickerControllerCameraFlashModeOn:
            [picker setCameraFlashMode:UIImagePickerControllerCameraFlashModeAuto];
            [[NSUserDefaults standardUserDefaults] setObject:@"flashAuto" forKey:@"flash_mode"];
            [toggleFlashMode setBackgroundImage:[UIImage imageNamed:@"flashAuto.png"] forState:UIControlStateNormal];
            break;
        case UIImagePickerControllerCameraFlashModeAuto:
            [picker setCameraFlashMode:UIImagePickerControllerCameraFlashModeOff];
            [[NSUserDefaults standardUserDefaults] setObject:@"flashOff" forKey:@"flash_mode"];
            [toggleFlashMode setBackgroundImage:[UIImage imageNamed:@"flashOff.png"] forState:UIControlStateNormal];
            break;
        case UIImagePickerControllerCameraFlashModeOff:
            [picker setCameraFlashMode:UIImagePickerControllerCameraFlashModeOn];
            [[NSUserDefaults standardUserDefaults] setObject:@"flashOn" forKey:@"flash_mode"];
            [toggleFlashMode setBackgroundImage:[UIImage imageNamed:@"flashOn.png"] forState:UIControlStateNormal];
            break;
    }
}



- (IBAction)sliderChanged:(id)sender {
    slider = (UISlider *)sender;
    adjustTran.hidden = TRUE;
    if (cameraMode == YES){
    [overlayView setAlpha:1.0 - slider.value];
    }else{
        [previewImage setAlpha:slider.value];
    }
    sliderValue = slider.value;
}

- (IBAction)home{
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
        imageView.image = NULL;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)cancelPhoto{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)shoot{
    
    adjustTran.hidden = TRUE;
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [bigGreen setTransform:CGAffineTransformMakeTranslation(250, 0)];
        [bigOrange setTransform:CGAffineTransformMakeTranslation(-250, 0)];
    }completion:^(BOOL done){
    }];
    [picker takePicture];
}


- (IBAction)TakePhoto{
    
    [self startCam];
    
}





-(void)startTimer
{
    timer = 0;
    shootTimer = [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(myFunctionForClickImage) userInfo:nil repeats:YES];
}

-(void)myFunctionForClickImage
{
    timer ++;
    if (timer < 1)
    {
        
    }else{
        takePicCover.hidden = TRUE;
    }
}

- (void) imagePickerController:(UIImagePickerController *)pickers didFinishPickingMediaWithInfo:(NSDictionary *)info{
    cameraMode = NO;
    if(pictureTaker.subviews.count > 0){
        [pictureTaker.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    if ([newJuxtaposeImage.pictures count] > 0){
        previewOpaque.hidden = FALSE;
        previewTransparent.hidden = FALSE;
        [pictureTaker addSubview:previewSlider];
        previewSlider.hidden = FALSE;
        [previewSlider setValue:sliderValue];
    }else{
        previewOpaque.hidden = TRUE;
        previewTransparent.hidden = TRUE;
        previewSlider.hidden = TRUE;
    }
    NSLog(@"slider hidden?: %hhd", previewSlider.hidden);
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [bigGreen setTransform:CGAffineTransformMakeTranslation(-250, 0)];
        [bigOrange setTransform:CGAffineTransformMakeTranslation(250, 0)];
    }completion:^(BOOL done){
    }];
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"cameraOrUpload"] isEqualToString:@"camera"]){
        [self scaleAndRotateImage:image];
    }else{
        //[self setRotatedImage:image]; // THIS WILL CHANGE TO POSITION IMAGE
        [chooseYourDestiny removeFromSuperview];
        if([newJuxtaposeImage.pictures count] > 0){
            [flattenedImage setImage:newJuxtaposeImage.getJxtpImage];
            newImage=[[UIImageView alloc] init];
            [newImage setFrame:CGRectMake(0, 0, 300, 300)];
            [newImage setImage:newJuxtaposeImage.getJxtpImage];
            [newImage setContentMode:UIViewContentModeScaleAspectFill];
            slider.hidden = FALSE;
            transparent.hidden = FALSE;
            opaque.hidden = FALSE;
            [previewSlider setValue:0.5];
            slider.value = 0.5;
            sliderValue = slider.value;
            [previewImage setAlpha:sliderValue];
        }else{
           [previewImage setAlpha:1.0];
            sliderValue = 1.0;
        }
        [previewImage setImage:image];
        [previewImage setContentMode:UIViewContentModeScaleAspectFill];
        [self dismissViewControllerAnimated:YES completion:NULL];
        
        
    }
}


- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}



- (void)scaleAndRotateImage:(UIImage *)rotatedImage
{
    
    //int kMaxResolution = 640; // Or whatever
    
    CGImageRef imgRef = rotatedImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    bounds = CGRectMake(0, 0, width, height);
    
    
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = rotatedImage.imageOrientation;
    if(cameraRotation == 0){ //rear camera
        switch(orient) {
                
            case UIImageOrientationUp: //EXIF = 1
                boundHeight = bounds.size.height;
                bounds.size.height = bounds.size.width;
                bounds.size.width = boundHeight;
                transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
                transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
                break;
                
            case UIImageOrientationDown: //EXIF = 3
                boundHeight = bounds.size.height;
                bounds.size.height = bounds.size.width;
                bounds.size.width = boundHeight;
                transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
                transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
                break;
                
            case UIImageOrientationLeft: //EXIF = 6
                boundHeight = bounds.size.height;
                bounds.size.height = bounds.size.width;
                bounds.size.width = boundHeight;
                //transform = CGAffineTransformScale(transform, 1.0, -1.0);
                transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
                transform = CGAffineTransformRotate(transform, M_PI_2);
                break;
                
            case UIImageOrientationRight: //EXIF = 8
                boundHeight = bounds.size.height;
                bounds.size.height =bounds.size.width;
                bounds.size.width = boundHeight;
                //transform = CGAffineTransformScale(transform, 1.0, -1.0);
                transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
                transform = CGAffineTransformRotate(transform, M_PI / 2.0);
                break;
                
            default:
                [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
                
        }
        UIGraphicsBeginImageContext(bounds.size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        
        if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
            CGContextScaleCTM(context, -scaleRatio, scaleRatio);
            CGContextTranslateCTM(context, -height, 0);
        }
        else {
            CGContextScaleCTM(context, scaleRatio, -scaleRatio);
            CGContextTranslateCTM(context, 0, -height);
        }
        
        
        CGContextConcatCTM(context, transform);
        
        CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
        imageCopy = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    }else if(cameraRotation == 1){ //front camera
        switch(orient) {
                
            case UIImageOrientationUp: //EXIF = 1
                boundHeight = bounds.size.height;
                bounds.size.height = bounds.size.width;
                bounds.size.width = boundHeight;
                transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.height);
                transform = CGAffineTransformScale(transform, -1.0, 1.0);
                transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
                break;
                
            case UIImageOrientationDown: //EXIF = 3
                boundHeight = bounds.size.height;
                bounds.size.height = bounds.size.width;
                bounds.size.width = boundHeight;
                transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.height);
                transform = CGAffineTransformScale(transform, -1.0, 1.0);
                transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
                break;
                
            case UIImageOrientationLeft: //EXIF = 6 orientation is ok but size is off
                boundHeight = bounds.size.height;
                bounds.size.height = bounds.size.width;
                bounds.size.width = boundHeight;
                transform = CGAffineTransformMakeScale(-1.0, 1.0);
                transform = CGAffineTransformRotate(transform, M_PI_2);
                break;
                
            case UIImageOrientationRight: //EXIF = 8 orientation is good size is off
                boundHeight = bounds.size.height;
                bounds.size.height = bounds.size.width;
                bounds.size.width = boundHeight;
                transform = CGAffineTransformMakeScale(-1.0, 1.0);
                transform = CGAffineTransformRotate(transform, M_PI_2);
                break;
                
            default:
                [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
                
        }
        
        
        UIGraphicsBeginImageContext(bounds.size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        
        if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
            CGContextScaleCTM(context, -scaleRatio, scaleRatio);
            CGContextTranslateCTM(context, -height, 0);
        }
        else {
            CGContextScaleCTM(context, scaleRatio, -scaleRatio);
            CGContextTranslateCTM(context, 0, -height);
        }
        
        
        CGContextConcatCTM(context, transform);
        
        CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
        imageCopy = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
        [self setRotatedImage:imageCopy];
    

    
    //return imageCopy;
}



-(IBAction)cancelPreview{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"cameraOrUpload"] isEqualToString:@"camera"]){
        [self startCam];
    }else{
        [self presentViewController:uploader animated:YES completion:NULL];
    }
}

-(IBAction)cancelNewPhoto{
    if (sharedObjects.JxtaposePicture && ([newJuxtaposeImage.pictures count] > 0) ){
    [self.navigationController pushViewController:PreviewTheImage animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(IBAction)usePhoto{
    CGRect framesy;
    CGRect boundsy;
    
    NSURL *tmpDirURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSDate *date = [[NSDate alloc] init];
    
    NSString *datestring = [dateFormatter stringFromDate:date];
    NSURL *fileURL = [[tmpDirURL URLByAppendingPathComponent:datestring] URLByAppendingPathExtension:@"jpg"];

    NSData *pngData = UIImageJPEGRepresentation(previewImage.image, 1.0);
    [pngData writeToFile:[fileURL path] atomically:YES];
    
    if([[UIScreen mainScreen] bounds].size.height == 568){
        framesy = CGRectMake(previewImage.frame.origin.x-10, previewImage.frame.origin.y-106, previewImage.frame.size.width, previewImage.frame.size.height);
        boundsy = CGRectMake(previewImage.bounds.origin.x-10, previewImage.bounds.origin.y-106,previewImage.bounds.size.width,previewImage.bounds.size.height);
    }else{
        framesy = CGRectMake(previewImage.frame.origin.x-10, previewImage.frame.origin.y-65, previewImage.frame.size.width, previewImage.frame.size.height);
        boundsy = CGRectMake(previewImage.bounds.origin.x-10, previewImage.bounds.origin.y-65,previewImage.bounds.size.width,previewImage.bounds.size.height);
    }
    
    //NSLog(@"USE PHOTO this is b:%@ and f:%@",NSStringFromCGRect(boundsy),NSStringFromCGRect(framesy));
    //NSLog(@"USE PHOTO this is the layer p: %@ and the layer f: %@", NSStringFromCGPoint(previewImage.layer.position), NSStringFromCGRect(previewImage.layer.frame));
    JPic *newPic = [[JPic alloc]initWithOptions:fileURL op:sliderValue bounds:boundsy rot:_lastRotation frame:framesy];

    [newJuxtaposeImage addImage:newPic];
    [sharedObjects setJxtaposePicture:newJuxtaposeImage];
    PreviewTheImage = [[PreviewProject alloc]initWithNibName:@"PreviewProject" bundle:nil];
    [self.navigationController pushViewController:PreviewTheImage animated:YES];
}


- (void)setRotatedImage:(UIImage *)rotatedImage{
    
    UIImage *imageSmall = rotatedImage;
    int imageWidth = rotatedImage.size.width;
    int imageHeight = rotatedImage.size.height;
    
    int fivesxoffset = imageWidth*.03125;
    int fivesyoffset = imageHeight*.25030637;
    int foursxoffset = imageWidth*.072;
    int foursyoffset = imageHeight*.13695988;
    
    //int imageHeight = rotatedImage.size.height;
    if ([[UIDevice currentDevice] systemVersion].floatValue < 7.0){
        if([[UIScreen mainScreen] bounds].size.height == 568)
        {
            // iPhone 5 V 6.0
            img = [self cropImage:imageSmall andFrame:CGRectMake(48, 190, 543, 543)];
        }
        else
        {
            img = [self cropImage:imageSmall andFrame:CGRectMake(18, 110, 600, 600)];
        }
    }else{
        if([[UIScreen mainScreen] bounds].size.height == 568)
        {
            // iPhone 5 V 7.0
            img = [self cropImage:imageSmall andFrame:CGRectMake(fivesxoffset, fivesyoffset, imageWidth - (fivesxoffset *2), imageWidth - (fivesxoffset *2))];
        }
        else
        {
            img = [self cropImage:imageSmall andFrame:CGRectMake(foursxoffset, foursyoffset, imageWidth - (foursxoffset *2), imageWidth - (foursxoffset *2))];
        }
    }
    //[self previewImage:img];
    [chooseYourDestiny removeFromSuperview];
    [previewImage setAlpha:sliderValue];
    [previewImage setImage:img];
    [self dismissViewControllerAnimated:YES completion:NULL];

}




#pragma mark - gesture controls

/*-(void)pinchRotate:(UIRotationGestureRecognizer*)rotate
 {
     NSLog(@"rotate");
     
     
 switch (rotate.state)
 {
 case UIGestureRecognizerStateBegan:
 {
 
 AcuRotation = 0.0;
 
 break;
 
 
 }
 case UIGestureRecognizerStateChanged:
 {
 
 //            CGAffineTransform transform;
 //            [UIView beginAnimations:nil context:NULL];
 //            [UIView setAnimationDuration:1.0];
 //            [UIView setAnimationCurve:UIViewAnimationOptionBeginFromCurrentState];
 //            self.view.alpha = 1;
 //            transform = CGAffineTransformRotate(self.view.transform,0.5*M_PI);
 //            [self.view setUserInteractionEnabled:YES];
 //            self.view.transform = transform;
 //            [UIView commitAnimations];
 
 float thisRotate = rotate.rotation - AcuRotation;
 AcuRotation = rotate.rotation;
 previewImage.transform = CGAffineTransformRotate(previewImage.transform, thisRotate);
 _lastRotation = _lastRotation + thisRotate;
 //NSLog(@"rot:%f",(_lastRotation * 180) / M_PI);
 NSLog(@"rot cos:%f",(cos(_lastRotation*4)+3)/2);
 // NSLog(@"sin:%f",(cos(M_PI)));
 
 break;
 
 
 }
 
 case UIGestureRecognizerStateEnded:
 {
 
 
 break;
 
 
 }
 case UIGestureRecognizerStateFailed:{
 break;
 
 }
 
 default:
 break;
 }
 
 }*/
 
 
 
 -(void)scale:(UIPinchGestureRecognizer*)scaler
 {
     
 switch (scaler.state)
 {
 case UIGestureRecognizerStateBegan:
 
 {
 
 AcuScale = 1.0;
 
 
 break;
 
 }
 case UIGestureRecognizerStateChanged:
 {
 _lastScale = [scaler scale];
 float thisScale = 1 + (scaler.scale-AcuScale);
 AcuScale = scaler.scale;
 previewImage.transform = CGAffineTransformScale(previewImage.transform, thisScale, thisScale);
 
 
 //NSLog(@"this is scale:%f",[scaler scale]);
 //            CGAffineTransform transform;
 //            [UIView beginAnimations:nil context:NULL];
 //            [UIView setAnimationDuration:1.0];
 //            [UIView setAnimationCurve:UIViewAnimationOptionBeginFromCurrentState];
 //            self.view.alpha = 1;
 //            transform = CGAffineTransformRotate(self.view.transform,0.5*M_PI);
 //            [self.view setUserInteractionEnabled:YES];
 //            self.view.transform = transform;
 //            [UIView commitAnimations];
 //_lastRotation = [rotate rotation];
 //[self rotate:[rotate rotation]];
 break;
 
 
 }
 case UIGestureRecognizerStateEnded:
 {
 scaling = FALSE;
 break;
 
 
 
 }
 case UIGestureRecognizerStateFailed:{
 }
 
 default:
 break;
 }
 
 }
 
 -(void)press:(UILongPressGestureRecognizer*)tapper{
 switch (tapper.state)
 {
 case UIGestureRecognizerStateBegan:
 
 {
 break;
 
 }
 case UIGestureRecognizerStateChanged:
 {
 break;
 
 
 
 }
 case UIGestureRecognizerStateEnded:
 {
 
 [self fixTransform];
 break;
 
 
 }
 case UIGestureRecognizerStateFailed:{
 
 }
 
 default:
 break;
 }
 }







 
 -(void)move:(UIPanGestureRecognizer*)pan{

 switch (pan.state)
 {
 case UIGestureRecognizerStateBegan:
 
 {
 movePoint = [pan locationInView:previewView];
 break;
 
 }
 case UIGestureRecognizerStateChanged:
 {
 CGPoint curr = [pan locationInView:previewView];
 
 float diffx = curr.x - movePoint.x;
 float diffy = curr.y - movePoint.y;
 
 CGPoint centre = previewImage.center;
 centre.x += diffx;
 centre.y += diffy;
 previewImage.center = centre;
 movePoint = curr;
//     float newXAnchor = ((0-previewImage.center.x-(previewImage.frame.size.width/2))+10+150)/previewImage.frame.size.width;
//     float newYAnchor = ((0-previewImage.center.y-(previewImage.frame.size.height/2))+106+150)/previewImage.frame.size.height;
//     CGPoint newAnchor = CGPointMake(newXAnchor, newYAnchor);
//     previewImage.layer.anchorPoint = newAnchor;
 
 }
 case UIGestureRecognizerStateEnded:
 {
 
 break;
 
 
 }
 case UIGestureRecognizerStateFailed:{
 
 }
 
 default:
 break;
 }
 }



-(void)transformTheImage{
    //
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationDuration: 0.1];
    //    [UIView setAnimationDelegate:self];
    //    previewImage.contentMode = UIViewContentModeScaleAspectFit;
    //    AcuScale = AcuScale + (_lastScale-AcuScale);
    //    AcuRotation = AcuRotation + _lastRotation;
    //   // NSLog(@"This is scale %f",AcuScale);
    //    //NSLog(@"this is rotate:%f and Scale:%f accum",AcuRotation, AcuScale);
    //    CGAffineTransform rotateit = CGAffineTransformMakeRotation(_lastRotation);
    //    CGAffineTransform scaleit = CGAffineTransformMakeScale(AcuScale, AcuScale);
    //    CGAffineTransform moveit = CGAffineTransformMakeTranslation(movePoint.x, movePoint.y);
    //    //NSLog(@"rot: %f",(cos(_lastRotation*4)+1)/4);
    //    CGAffineTransform allTrans = CGAffineTransformConcat(rotateit, scaleit);
    //    allTrans = CGAffineTransformConcat(allTrans, moveit);
    //    previewImage.transform = allTrans;
    //    [UIView commitAnimations];
    //    previewImage.frame = CGRectMake(movePoint.x, movePoint.y, previewImage.frame.size.width*_lastScale, previewImage.frame.size.height*_lastScale);
    
    
}

-(void)fixTransform{
    
    if(previewImage.frame.size.width<300 || previewImage.frame.size.height<300){
        CGFloat newScale = (300*((cos((_lastRotation-(M_PI/4))*4)+3)/2))/previewImage.frame.size.width;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration: 0.1];
        [UIView setAnimationDelegate:self];
        previewImage.transform = CGAffineTransformScale(previewImage.transform, newScale, newScale);
        [UIView commitAnimations];
    }
    float ix = (previewImage.center.x - (previewImage.frame.size.width/2))-frameX;
    float iy = (previewImage.center.y - (previewImage.frame.size.height/2))-frameY;
    
    if(previewImage.frame.size.width<300 || previewImage.frame.size.height<300){
        
    }else if(ix>0 || iy>0 || (iy+previewImage.frame.size.height < 300) || (ix+previewImage.frame.size.width < 300)){
        CGPoint centre = previewImage.center;
        if(ix>0 || ix+previewImage.frame.size.width < 300){
            centre.x = (previewImage.frame.size.width/2)+frameX;
        }
        if(iy>0 || iy+previewImage.frame.size.height < 300){
            centre.y = (previewImage.frame.size.height/2)+frameY;
        }
        previewImage.center = centre;
        
    }
    
    //    if(AcuScale < 1.55-((cos(AcuRotation*4)+1)/4)){
    //    AcuScale = 1.55-((cos(AcuRotation*4)+1)/4);
    //    previewImage.transform = CGAffineTransformScale(previewImage.transform, AcuScale, thisScale);
    //    }

    

    
}





//-(void)scale:(id)sender {
//
// if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
// _lastScale = 1.0;
// NSLog(@"scaling %f", _lastScale);
// }
// CGFloat scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
//
// CGAffineTransform currentTransform = previewImage.transform;
// CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
//
// [previewImage setTransform:newTransform];
//
// _lastScale = [(UIPinchGestureRecognizer*)sender scale];
// NSLog(@"last Scale %f", _lastScale);
// //[self showOverlayWithFrame:photoImage.frame];
// }



// -(void)move:(id)sender {
//
// CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:previewImage];
//
// if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
// _firstX = [previewImage center].x;
// _firstY = [previewImage center].y;
// NSLog(@"moving x %f", _firstX);
// NSLog(@"moving y %f", _firstY);
// }
//
// translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY+translatedPoint.y);
// NSLog(@"translated Point x %f", translatedPoint.x);
// NSLog(@"translated Point y %f", translatedPoint.y);
// [previewImage setCenter:translatedPoint];
// //[self showOverlayWithFrame:originalPreviewImage.frame];
// }

 - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
     return TRUE;
 }




#pragma mark - edit Image Functions



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (UIImage *)cropImage:(UIImage*)cropped andFrame:(CGRect)rect {
    
    
    rect = CGRectMake(rect.origin.x*cropped.scale,
                      rect.origin.y*cropped.scale,
                      rect.size.width*cropped.scale,
                      rect.size.height*cropped.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([cropped CGImage], rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef
                                          scale:cropped.scale
                                    orientation:cropped.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}


#pragma mark - View Methods


- (void)addDestiny{
   [self.view addSubview:chooseYourDestiny];
}

- (void)viewDidLoad
{
    AcuPoint = CGPointMake(0, 0);
    AcuSize = CGPointMake(300, 300);
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addDestiny)
                                                 name:@"addImage" object:nil];
    
    /*AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if([device hasTorch])
    {
        toggleFlashMode.hidden = FALSE;
    }else{
        toggleFlashMode.hidden = TRUE;
    }*/
    
    if( [UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceFront]){
        flipCam.hidden = FALSE;
    }else{
        flipCam.hidden = TRUE;
    }
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    picker.showsCameraControls = NO;
    picker.navigationBarHidden = YES;
    picker.toolbarHidden = YES;
    picker.allowsEditing = NO;
    picker.toolbar.hidden = YES;
    
    realOverlayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    imageCopy = [[UIImage alloc]init];
    
    uploader = [[UIImagePickerController alloc] init];
    uploader.delegate = self;
    [uploader setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    
    [self.view addSubview:chooseYourDestiny];
    
    AcuRotation = 0;
    AcuScale = 1;
    cameraRotation = 0;
    PosX = 0;
    PosY = 0;
    frameX = 10;
    frameY = 106;
    
    imageHolder.clipsToBounds = true;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    
    sharedObjects = [largeObjects sharedManager];
    if(sharedObjects.JxtaposePicture){
        newJuxtaposeImage = sharedObjects.JxtaposePicture;
        
        
    }else{
        newJuxtaposeImage = [[JxtaPic alloc]init];
    }
    
        if([[UIScreen mainScreen] bounds].size.height == 568)
        {
            // iPhone 5
            overlayView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 106, 300, 300)];
        }
        else
        {
            overlayView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 65, 300, 300)];
        }
    slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 254, 16)];
    previewSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 254, 16)];

    
    UIImage *minImage = [[UIImage imageNamed:@"sliderbgMax.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    UIImage *maxImage = [[UIImage imageNamed:@"sliderbgMin.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    UIImage *thumbImage = [UIImage imageNamed:@"sliderThumb.png"];
    UIImageView *thumbButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [thumbButton setImage: thumbImage];
    [[UISlider appearance] setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    [[UISlider appearance] setMinimumTrackImage:minImage forState:UIControlStateNormal];
    [[UISlider appearance] setThumbImage:thumbButton.image forState:UIControlStateNormal];
    [[UISlider appearance] setThumbImage:thumbButton.image forState:UIControlStateHighlighted];
    [[UISlider appearance] setThumbImage:thumbButton.image forState:UIControlStateSelected];
    [slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [previewSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    slider.minimumValue = 0.05;
    slider.maximumValue = 0.95;
    slider.continuous = YES;
    
    previewSlider.minimumValue = 0.05;
    previewSlider.maximumValue = 0.95;
    previewSlider.continuous = YES;
    
    if([[UIScreen mainScreen] bounds].size.height == 568) // iPhone 5 V 6.0
    {
        bigGreen = [[UIImageView alloc]initWithFrame:CGRectMake(-400, 60, 400, 400)];
        bigGreen.image = [UIImage imageNamed:@"bigGreen.png"];
        bigOrange = [[UIImageView alloc]initWithFrame:CGRectMake(320, 60, 400, 400)];
        bigOrange.image = [UIImage imageNamed:@"bigOrange.png"];
    }else{
        bigGreen = [[UIImageView alloc]initWithFrame:CGRectMake(-400, 0, 400, 400)];
        bigGreen.image = [UIImage imageNamed:@"bigGreen.png"];
        bigOrange = [[UIImageView alloc]initWithFrame:CGRectMake(320, 0, 400, 400)];
        bigOrange.image = [UIImage imageNamed:@"bigOrange.png"];
    }
    
    
    
    UILongPressGestureRecognizer *longpressSingle = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(press:)];
     [longpressSingle setNumberOfTouchesRequired:1];
     [longpressSingle setMinimumPressDuration:.01];
     [longpressSingle setDelegate:self];
     [touchView addGestureRecognizer:longpressSingle];
     
     UILongPressGestureRecognizer *longpressDouble = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(press:)];
     [longpressDouble setNumberOfTouchesRequired:2];
     [longpressDouble setMinimumPressDuration:.01];
     [longpressDouble setDelegate:self];
     [touchView addGestureRecognizer:longpressDouble];
    
     UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
     [pinchRecognizer setDelegate:self];
     [touchView addGestureRecognizer:pinchRecognizer];
     
     /*UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(pinchRotate:)];
     [rotationRecognizer setDelegate:self];
     [touchView addGestureRecognizer:rotationRecognizer];*/
     
     UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
     [panRecognizer setMinimumNumberOfTouches:1];
     [panRecognizer setMaximumNumberOfTouches:1];
     [panRecognizer setDelegate:self];
     [touchView addGestureRecognizer:panRecognizer];
     
     touchView.multipleTouchEnabled = YES;
     [pictureTaker addSubview:previewSlider];
    //previewSlider.hidden = TRUE;
    
    
}

-(void)viewDidDisappear:(BOOL)animated{
    if([[UIScreen mainScreen] bounds].size.height == 568){
    //[iAdBanner removeFromSuperview];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    if([[UIScreen mainScreen] bounds].size.height == 568){
   // iAdBanner = [[ADBannerView alloc]initWithFrame:CGRectMake(0, 56, 320, 50)];
   // [self.view insertSubview:iAdBanner atIndex:10];
    }
    flashStatus = [[NSUserDefaults standardUserDefaults] stringForKey:@"flash_mode"];
    if([flashStatus isEqualToString: @"flashAuto"]){
        [picker setCameraFlashMode:UIImagePickerControllerCameraFlashModeAuto];
        [toggleFlashMode setBackgroundImage:[UIImage imageNamed:@"flashAuto.png"] forState:UIControlStateNormal];
    }else if([flashStatus isEqualToString: @"flashOn"]){
        [picker setCameraFlashMode:UIImagePickerControllerCameraFlashModeOn];
        [toggleFlashMode setBackgroundImage:[UIImage imageNamed:@"flashOn.png"] forState:UIControlStateNormal];
    }else if([flashStatus isEqualToString: @"flashOff"]){
        [picker setCameraFlashMode:UIImagePickerControllerCameraFlashModeOff];
        [toggleFlashMode setBackgroundImage:[UIImage imageNamed:@"flashOff.png"] forState:UIControlStateNormal];
    }
    
   
}

- (void)loadView
{
    if([[UIScreen mainScreen] bounds].size.height == 568)
    {
        // iPhone 5
        self.view = [[NSBundle mainBundle] loadNibNamed:@"ViewController" owner:self options:nil][0];
    }
    else
    {
        self.view = [[NSBundle mainBundle] loadNibNamed:@"ViewControllerFour" owner:self options:nil][0];
        
    }
}



- (void) topLayerToBlend:(UIImage *)topBlend topLayerAlpha:(float)alpha bottomLayerToBlend:(UIImage *)bottomBlend{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*- (void) finishedPressed{
 
 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
 [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
 
 NSDate *date = [[NSDate alloc] init];
 
 NSString *formattedDateString = [dateFormatter stringFromDate:date];
 pngData = UIImageJPEGRepresentation(blendedImage, 1.0);
 
 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
 NSString *fileName = [NSString stringWithFormat:@"image_%@.jpg", formattedDateString];
 NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName]; //Add the file name
 [pngData writeToFile:filePath atomically:YES]; //Write the file
 NSString *urlString = [[NSString alloc] initWithFormat:@"file://%@", filePath];
 SharePhoto *share = [[SharePhoto alloc] initWithNibName:@"SharePhoto" bundle:nil];
 share.blendedImageURL = urlString;
 share.blendedImageName = fileName;
 
 newImage.image = NULL;
 [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
 [buttonUnderline setTransform:CGAffineTransformMakeTranslation(3, 0)];
 }completion:^(BOOL done){
 }];
 [blendScroll scrollRectToVisible:CGRectMake(0, 0, blendScroll.frame.size.width, blendScroll.frame.size.height) animated:YES];
 [self presentViewController:share animated:YES completion:NULL];
 }*/

/*- (IBAction)videoButton{
 [UIView transitionWithView:videoView
 duration:0.5
 options:UIViewAnimationOptionCurveLinear //any animation
 animations:^ { videoView.transform = CGAffineTransformMakeTranslation(0, -182); }
 completion:nil];
 
 picker.mediaTypes =[NSArray arrayWithObject:(NSString *)kUTTypeMovie];
 
 }
 
 - (IBAction)backToImageCapture{
 [UIView transitionWithView:videoView
 duration:0.5
 options:UIViewAnimationOptionCurveLinear //any animation
 animations:^ { videoView.transform = CGAffineTransformMakeTranslation(0, 0); }
 completion:nil];
 
 picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
 
 }
 
 - (IBAction)startVideo{
 NSLog(@"starting");
 time = 0.00;
 videoTimeAmount = 0;
 videoTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(stopVideoWhenTimeIsUp) userInfo:nil repeats:YES];
 [picker startVideoCapture];
 }
 
 -(IBAction)stopVideo{
 if (videoTimeAmount < 5.00){
 NSLog(@"stopped");
 [picker stopVideoCapture];
 }
 
 }
 
 -(void)stopVideoWhenTimeIsUp
 {
 videoTimeAmount = videoTimeAmount+ 0.1;
 if (videoTimeAmount < 5.000000)
 
 {
 NSLog(@"video time amount: %f", videoTimeAmount);
 }else{
 
 [picker stopVideoCapture];
 [videoTimer invalidate];
 }
 }
 
 - (void)previewImage: (UIImage *)imagePreview{
 
 pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
 [pinch setDelegate:self];
 [previewImage addGestureRecognizer:pinch];
 if (blendedImage){
 originalPreviewImage.hidden = FALSE;
 originalPreviewImage.image = blendedImage;
 [originalPreviewImage setAlpha:1.0 - sliderValue];
 }
 
 previewImage.transform = CGAffineTransformMakeRotation(M_PI * 2.0);
 previewView.tag = 7;
 [realOverlayView insertSubview:previewView aboveSubview:slider];
 takenPhoto = imagePreview;
 if ([firstPhoto isEqual: @"first"]) {
 [previewImage setAlpha:1.0];
 //UIImageView *coverBgWhite = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320,480)];
 //coverBgWhite.backgroundColor = [UIColor whiteColor];
 //coverBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 320, 460)];
 //coverBg.image = [UIImage imageNamed:@"camBgFour.png"];
 //[coverPreview addSubview:coverBgWhite];
 //[coverPreview insertSubview:coverBg aboveSubview:coverBgWhite];
 }else if([firstPhoto isEqual: @"new"]) {
 [previewImage setAlpha:1.0];
 }else{
 overlayAlpha = overlayView.alpha;
 [overlayView setAlpha:1.0];
 //[previewImage setAlpha:slider.value];
 slider.hidden = TRUE;
 transparent.hidden = TRUE;
 opaque.hidden = TRUE;
 
 }
 
 [previewImage setImage:imagePreview];
 //imageCopy = imagePreview;
 //img = imagePreview;
 //[coverPreview insertSubview:previewImage belowSubview:coverBg];
 }*/

@end
