//
//  JPic.m
//  Juxt-a-pose
//
//  Created by Christopher on 11/19/13.
//  Copyright (c) 2013 We Are Station. All rights reserved.
//

#import "JPic.h"



@implementation JPic

@synthesize imageurl,opacity,frame,rotation,bounds;

- (id)initWithOptions:(NSURL*)urls
                   op:(CGFloat)opacitys
                  bounds:(CGRect)boundsy
                  rot:(CGFloat)rotations
                 frame:(CGRect)frames
{
    self = [super init];
    if (self) {
        // Initialization code
        opacity = opacitys;
        imageurl = urls;
        bounds = boundsy;
        rotation = rotations;
        frame = frames;
    }
    return self;
}





@end
