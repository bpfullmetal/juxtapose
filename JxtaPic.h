//
//  JxtaPic.h
//  Juxt-a-pose
//
//  Created by Christopher on 11/19/13.
//  Copyright (c) 2013 We Are Station. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JPic;

typedef enum{
    Normal = 0,
    Multiply = 1,
    ColorBurn = 2,
    Darker = 3,
    Lighter = 4,
    Difference = 5,
    Exclusion = 6,
    Overlay = 7,
    Screen= 8,
    Hardlight=9,
    Saturation=10,
    Colordodge=11,
    SoftLight=12,
    Hue=13,
    Color=14,
    Luminosity=15,
} blendType;



@interface JxtaPic : NSObject{
    UIImage *blendedImage;
    int picSize;
   
    
}

@property (nonatomic) blendType blendingMode;
@property (nonatomic, strong) NSMutableArray *pictures;

-(void)addImage:(JPic*)jpic;
-(UIImage*)exportedImage;
-(void)removeImage;
-(void)editImage;
-(UIImage*)getJxtpImage;
-(UIImage*)getJxtpImageMinusLatest;
-(JPic*)lastImage;
-(void)logImages;
-(CGFloat)getLastPictureOpacity;


@end
