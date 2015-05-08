//
//  myNoteInformation.m
//  footNotes
//
//  Created by chris langer on 1/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "largeObjects.h"
#import "JxtaPic.h"
static largeObjects *sharedMyManager = nil;

@implementation largeObjects

@synthesize JxtaposePicture;
#pragma mark Singleton Methods
+ (id)sharedManager {
    @synchronized(self) {
        if (sharedMyManager == nil)
            sharedMyManager = [[self alloc] init];
    }
    return sharedMyManager;
}
- (id)init {
    if (self = [super init]) {

        JxtaposePicture = [[JxtaPic alloc]init];
    }
    return self;
}
- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end