//
//  SharePhoto.m
//  Juxt-a-pose
//
//  Created by Brandon Phillips on 6/6/13.
//  Copyright (c) 2013 We Are Station. All rights reserved.
//

#import "SharePhoto.h"

#import "AppDelegate.h"
#import "DMActivityInstagram.h"

@interface SharePhoto ()

@end

@implementation SharePhoto

- (void)viewDidAppear:(BOOL)animated{
    /*if([[UIScreen mainScreen] bounds].size.height == 568){
        iAdBanner = [[ADBannerView alloc]initWithFrame:CGRectMake(0, 56, 320, 50)];
        [self.view insertSubview:iAdBanner atIndex:10];
    }*/

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"subviews: %@", self.view.subviews);
    

    sharedObjects = [largeObjects sharedManager];
    
    shareIt.hidden = TRUE;
    NSString *flag = [[NSUserDefaults standardUserDefaults] stringForKey:@"not_first_run"];
    if(!flag){
        shareIt.hidden = FALSE;
        startNew.hidden = TRUE;
    }else{
        shareIt.hidden = TRUE;
        startNew.hidden = FALSE;
    }
    
    [library assetForURL:[NSURL URLWithString:self.blendedImageURL] resultBlock:^(ALAsset *asset){
        //NSLog(@"asset: %@", asset);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.finalImageView.image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
        });
    }
            failureBlock:^(NSError *error){
                
            }];
    
    //NSString *flag = [[NSUserDefaults standardUserDefaults] stringForKey:@"not_first_run"];
    if (!flag) {
        //tutorialOverlay.hidden = FALSE;
    }else{
        //tutorialOverlay.hidden = TRUE;
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidDisappear:(BOOL)animated{
    self.finalImageView.image = nil;
    //[iAdBanner removeFromSuperview];
}

- (IBAction)goBack{
    shareIt.hidden = TRUE;
    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"not_first_run"];
    sharedObjects.JxtaposePicture = Nil;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)share:(id)sender {
    shareIt.hidden = TRUE;
    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"not_first_run"];
    DMActivityInstagram *instagramActivity = [[DMActivityInstagram alloc] init];
    
    NSString *shareText = @"created with Juxt-a-pose #JXTP";
    //NSURL *shareURL = [NSURL URLWithString:@"http://catpaint.info"];
    
    NSArray *activityItems = @[self.finalImageView.image, shareText];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:@[instagramActivity]];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView{
    if([[UIScreen mainScreen] bounds].size.height == 568)
    {
        // iPhone 5
        self.view = [[NSBundle mainBundle] loadNibNamed:@"SharePhoto" owner:self options:nil][0];
    }
    else
    {
        self.view = [[NSBundle mainBundle] loadNibNamed:@"SharePhotoFour" owner:self options:nil][0];
    }
}



- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate
{
    
    
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    interactionController.delegate = self;
    
    return interactionController;
}

- (void)documentInteractionControllerWillPresentOpenInMenu:(UIDocumentInteractionController *)controller
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
