//
//  JxtaPic.m
//  Juxt-a-pose
//
//  Created by Christopher on 11/19/13.
//  Copyright (c) 2013 We Are Station. All rights reserved.
//

#import "JxtaPic.h"
#import "JPic.h"

@implementation JxtaPic;


@synthesize pictures,blendingMode;


-(id)init{
    self = [super init];
    if (self) {
        pictures = [[NSMutableArray alloc]init];
        blendingMode = Normal;
            picSize = 300;

    }
    return self;
}


-(void)addImage:(JPic*)jpic{
    [pictures addObject:jpic];
    
}






-(JPic *)lastImage{
    JPic *lastPic = [pictures lastObject];
    return lastPic;
}


-(UIImage *)getJxtpImage{
    
    
    switch ([pictures count]) {
        case 0:{
            return nil;
        }
            break;
        case 1:
        {
            UIImageView *baseHolder = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, picSize, picSize)];
            [baseHolder setContentMode:UIViewContentModeScaleAspectFill];
            JPic *onlyPic = [pictures lastObject];
            UIImageView *starterImg = [[UIImageView alloc]initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:onlyPic.imageurl]]];
            [starterImg setContentMode:UIViewContentModeScaleAspectFill];
            [starterImg setFrame:onlyPic.frame];
            //[starterImg setBounds:onlyPic.bounds];
            starterImg.transform = CGAffineTransformRotate(starterImg.transform, onlyPic.rotation);
            [baseHolder addSubview:starterImg];
            UIGraphicsBeginImageContext(baseHolder.frame.size);
            //CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeScreen);
            [baseHolder.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *fI = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return fI;
        }
            break;
            
        default:
        {
        
            UIImageView *bottomImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, picSize, picSize)];
            [bottomImage setContentMode:UIViewContentModeScaleAspectFill];

            for (JPic *jpic in pictures) {

            UIImageView *topView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:jpic.imageurl]]];
            [topView setAlpha:jpic.opacity];
            [topView setContentMode:UIViewContentModeScaleAspectFill];
            [topView setFrame:jpic.frame];
            //[topView setBounds:jpic.bounds];
            topView.transform = CGAffineTransformRotate(topView.transform, jpic.rotation);

            [bottomImage addSubview:topView];
            UIGraphicsBeginImageContext(bottomImage.frame.size);
            //CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeScreen);
            [bottomImage.layer renderInContext:UIGraphicsGetCurrentContext()];
            blendedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            bottomImage.image = blendedImage;
            //blendedImage = img;
            //firstPhoto = @"anotherPhoto";
                
            }
            return blendedImage;

            //Check how big the image is now its been compressed and put into the UIImageView
            
            // *** I made Change here, you were again storing it with Highest Resolution ***
//            NSData *endData = UIImageJPEGRepresentation(blendedImage,0.5f);
//            return [UIImage imageWithData:endData];
            
            
        }
            
            break;
    }
    
    
}

-(CGFloat)getLastPictureOpacity{
    JPic *onlyPic = [pictures lastObject];
    CGFloat opac = onlyPic.opacity;
    return opac;
    
}

-(UIImage *)getJxtpImageMinusLatest{
    
    
    switch ([pictures count]) {
        case 0:{
            return [UIImage imageNamed:@"previewBackground.jpg"];
        }
            break;
        case 1:
        {
            UIImageView *baseHolder = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, picSize, picSize)];
            [baseHolder setContentMode:UIViewContentModeScaleAspectFill];

            UIGraphicsBeginImageContext(baseHolder.frame.size);
            //CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeScreen);
            [baseHolder.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *fI = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return fI;
            
        }
            break;
            
        default:
        {
            UIImageView *bottomImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, picSize, picSize)];
            [bottomImage setContentMode:UIViewContentModeScaleAspectFill];

            int counter = 0;
            for (JPic *jpic in pictures) {
                if(counter == [pictures count]-1){
                    counter++;
                }else{
                    UIImageView *topView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:jpic.imageurl]]];
                    [topView setContentMode:UIViewContentModeScaleAspectFill];
                    [topView setAlpha:jpic.opacity];
                    [topView setFrame:jpic.frame];
                    //[topView setBounds:jpic.bounds];

                    topView.transform = CGAffineTransformRotate(topView.transform, jpic.rotation);

                    [bottomImage addSubview:topView];
                    UIGraphicsBeginImageContext(bottomImage.frame.size);
                    //CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeScreen);
                    [bottomImage.layer renderInContext:UIGraphicsGetCurrentContext()];
                    blendedImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    bottomImage.image = blendedImage;
                    //blendedImage = img;
                    //firstPhoto = @"anotherPhoto";
                    counter++;
                    NSLog(@"JXTP pic %d this is b:%@ and f:%@",counter, NSStringFromCGRect(jpic.bounds),NSStringFromCGRect(jpic.frame));
                    NSLog(@"JXTP pic %d this is the layer p: %@ and the layer f: %@",counter, NSStringFromCGPoint(topView.layer.position), NSStringFromCGRect(topView.layer.frame));
                    
                }
            }
            //NSData *endData = UIImageJPEGRepresentation(blendedImage,1.0f);
            return blendedImage;
        }
            
            break;
    }
    
    
}



-(UIImage *)getJxtpImageMinusLatestLarge{
    
    
    switch ([pictures count]) {
        case 0:{
            return [UIImage imageNamed:@"previewBackground.jpg"];
        }
            break;
        case 1:
        {
            UIImageView *baseHolder = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1200, 1200)];
            [baseHolder setContentMode:UIViewContentModeScaleAspectFill];
            
            UIGraphicsBeginImageContext(baseHolder.frame.size);
            //CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeScreen);
            [baseHolder.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *fI = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return fI;
            
        }
            break;
            
        default:
        {
            UIImageView *bottomImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1200, 1200)];
            [bottomImage setContentMode:UIViewContentModeScaleAspectFill];
            
            int counter = 0;
            for (JPic *jpic in pictures) {
                if(counter == [pictures count]-1){
                    counter++;
                }else{
                    UIImageView *topView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:jpic.imageurl]]];
                    [topView setContentMode:UIViewContentModeScaleAspectFill];
                    [topView setAlpha:jpic.opacity];

                    
                    CGRect newFrame = CGRectMake(jpic.frame.origin.x*4,jpic.frame.origin.y*4, jpic.frame.size.width*4, jpic.frame.size.height*4);
                    
                    [topView setFrame:newFrame];
                    //[topView setBounds:jpic.bounds];
                    
                    topView.transform = CGAffineTransformRotate(topView.transform, jpic.rotation);
                    
                    [bottomImage addSubview:topView];
                    UIGraphicsBeginImageContext(bottomImage.frame.size);
                    //CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeScreen);
                    [bottomImage.layer renderInContext:UIGraphicsGetCurrentContext()];
                    blendedImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    bottomImage.image = blendedImage;
                    //blendedImage = img;
                    //firstPhoto = @"anotherPhoto";
                    counter++;
                    NSLog(@"JXTP pic %d this is b:%@ and f:%@",counter, NSStringFromCGRect(jpic.bounds),NSStringFromCGRect(newFrame));
                    NSLog(@"JXTP pic %d this is the layer p: %@ and the layer f: %@",counter, NSStringFromCGPoint(topView.layer.position), NSStringFromCGRect(topView.layer.frame));
                    
                }
            }
            //NSData *endData = UIImageJPEGRepresentation(blendedImage,1.0f);
            return blendedImage;
        }
            
            break;
    }
    
    
}




-(void)logImages{
    for (JPic *jpic in pictures) {
        NSLog(@"image=%f", jpic.opacity);
    }
}

-(void)removeImage{
    
    
}


-(void)editImage{
    
}

-(UIImage *)exportedImage{
    CGRect newFrame = CGRectMake([self lastImage].frame.origin.x*4,[self lastImage].frame.origin.y*4, [self lastImage].frame.size.width*4, [self lastImage].frame.size.height*4);
    
    UIImageView *imagePreview = [[UIImageView alloc]initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[self lastImage].imageurl]]];
    [imagePreview setContentMode:UIViewContentModeScaleAspectFill];
    [imagePreview setFrame:newFrame];
    imagePreview.transform = CGAffineTransformRotate(imagePreview.transform, [self lastImage].rotation);
    //[imagePreview setBounds:[self lastImage].bounds];

    [imagePreview setAlpha:[self getLastPictureOpacity]];
    
    UIImageView *blendedImages = [[UIImageView alloc]initWithImage:[self getJxtpImageMinusLatestLarge]];
    [blendedImages setFrame:CGRectMake(0,0,1200,1200)];
    [blendedImages setContentMode:UIViewContentModeScaleAspectFill];

    [blendedImages addSubview:imagePreview];
    UIGraphicsBeginImageContext(blendedImages.frame.size);

    switch (blendingMode) {
        case Normal:
        {
            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
        }
            break;
        case Multiply:
        {
            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeMultiply);

        }
            
            break;
        case ColorBurn:
        {
           CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeColorBurn);

        }
            break;
            case Darker:
        {
           CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModePlusDarker);

        }
            break;
        case Lighter:{
           CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModePlusLighter);

        }
            break;
        case Difference:
        {
           CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeDifference);
        }
            break;
        case Exclusion:
        {
           CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeExclusion);

        }
            break;
        case Overlay:
        {
           CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeOverlay);

        }
            break;
        case Screen:
    {
            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeScreen);

        }
            break;
        case Hardlight:
        {
            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeHardLight);

        }
            break;
        case Saturation:
        {
       CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeSaturation);

        }
            break;
        case Luminosity:
        {
            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeLuminosity);
            
        }
            break;
            
        case Colordodge:
        {
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeColorDodge);
  
        }
            break;
        case SoftLight:
        {
         CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeSoftLight);

        }
            break;
        case Hue:
        {
         CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeHue);

        }break;
        case Color:
        {
         CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeColor);

        }
        break;
            
        default:
            break;
    }
    
   [blendedImages.layer renderInContext:UIGraphicsGetCurrentContext()];
    blendedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return blendedImage;
    
}

//-(UIImage *)exportedImage{
//    
//    UIImageView *imagePreview = [[UIImageView alloc]initWithImage:[self lastImage].image];
//    [imagePreview setContentMode:UIViewContentModeScaleAspectFill];
//    [imagePreview setFrame:[self lastImage].frame];
//    imagePreview.transform = CGAffineTransformRotate(imagePreview.transform, [self lastImage].rotation);
//    //[imagePreview setBounds:[self lastImage].bounds];
//    
//    [imagePreview setAlpha:[self getLastPictureOpacity]];
//    
//    UIImageView *blendedImages = [[UIImageView alloc]initWithImage:[self getJxtpImageMinusLatest]];
//    [blendedImages setFrame:CGRectMake(0,0,300,300)];
//    [blendedImages setContentMode:UIViewContentModeScaleAspectFill];
//    
//    [blendedImages addSubview:imagePreview];
//    UIGraphicsBeginImageContext(blendedImages.frame.size);
//    
//    switch (blendingMode) {
//        case Normal:
//        {
//            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
//        }
//            break;
//        case Multiply:
//        {
//            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeMultiply);
//            
//        }
//            
//            break;
//        case ColorBurn:
//        {
//            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeColorBurn);
//            
//        }
//            break;
//        case Darker:
//        {
//            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModePlusDarker);
//            
//        }
//            break;
//        case Lighter:{
//            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModePlusLighter);
//            
//        }
//            break;
//        case Difference:
//        {
//            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeDifference);
//        }
//            break;
//        case Exclusion:
//        {
//            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeExclusion);
//            
//        }
//            break;
//        case Overlay:
//        {
//            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeOverlay);
//            
//        }
//            break;
//        case Screen:
//        {
//            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeScreen);
//            
//        }
//            break;
//        case Hardlight:
//        {
//            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeHardLight);
//            
//        }
//            break;
//        case Saturation:
//        {
//            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeSaturation);
//            
//        }
//            break;
//        case Luminosity:
//        {
//            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeLuminosity);
//            
//        }
//            break;
//            
//        case Colordodge:
//        {
//            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeColorDodge);
//            
//        }
//            break;
//        case SoftLight:
//        {
//            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeSoftLight);
//            
//        }
//            break;
//        case Hue:
//        {
//            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeHue);
//            
//        }break;
//        case Color:
//        {
//            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeColor);
//            
//        }
//            break;
//            
//        default:
//            break;
//    }
//    
//    [blendedImages.layer renderInContext:UIGraphicsGetCurrentContext()];
//    blendedImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return blendedImage;
//    
//}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
