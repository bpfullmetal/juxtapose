//
//  PhotoCell.m
//  Juxt-a-pose
//
//  Created by Brandon Phillips on 6/7/13.
//  Copyright (c) 2013 We Are Station. All rights reserved.
//

#import "PhotoCell.h"
#import "AllPhotos.h"
#import "AppDelegate.h"

@implementation PhotoCell

@synthesize imageUrl,imageName,imageView,spinner,url;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"PhotoCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}



-(void)loadImage{

    dispatch_async(dispatch_get_main_queue(), ^{

    [library assetForURL:[NSURL URLWithString:imageUrl] resultBlock:^(ALAsset *asset){
        [imageView setImage: [UIImage imageWithCGImage:asset.aspectRatioThumbnail]];
        NSLog(@"cell making image url: %@", imageUrl);
        
    }
            failureBlock:^(NSError *error){
                
            }];
      });

}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
