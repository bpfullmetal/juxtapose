//
//  largeObjects.h
//
//
//  Created by chris langer on 1/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JxtaPic.h"

@interface largeObjects : NSObject{
    JxtaPic *JxtaposePicture;
}

@property (nonatomic, retain) JxtaPic *JxtaposePicture;

+ (id)sharedManager;


@end
