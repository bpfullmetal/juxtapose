//
//  PhotoCell.h
//  Juxt-a-pose
//
//  Created by Brandon Phillips on 6/7/13.
//  Copyright (c) 2013 We Are Station. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCell : UICollectionViewCell{
}

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) IBOutlet UILabel *url;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong,nonatomic) NSString *imageUrl;
@property (strong,nonatomic) UIImageView *placeholder;

-(void)loadImage;

@end
