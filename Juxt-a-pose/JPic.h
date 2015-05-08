//
//  JPic.h
//  Juxt-a-pose
//
//  Created by Christopher on 11/19/13.
//  Copyright (c) 2013 We Are Station. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPic : NSObject{

    
}

@property (nonatomic,retain)NSURL *imageurl;
@property (nonatomic)CGFloat opacity;
@property (nonatomic)CGRect bounds;
@property (nonatomic)CGRect frame;
@property (nonatomic)CGSize size;
@property (nonatomic)CGFloat rotation;


- (id)initWithOptions:(NSURL*)urls
                   op:(CGFloat)opacitys
                  bounds:(CGRect)boundsy
                  rot:(CGFloat)rotations
                 frame:(CGRect)frames;




@end
