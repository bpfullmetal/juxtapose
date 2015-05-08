//
//  DetailView.m
//  Juxt-a-pose
//
//  Created by Brandon Phillips on 6/18/13.
//  Copyright (c) 2013 We Are Station. All rights reserved.
//

#import "DetailView.h"
#import "AllPhotos.h"
#import "AppDelegate.h"
#import "DMActivityInstagram.h"

@interface DetailView ()

@end

@implementation DetailView


- (void)setDetailItem:(id)newDetailItem
{

        _detailItem = newDetailItem;

}

- (void)configureView
{
    
    if (self.detailItem)
    {
        [library assetForURL:[NSURL URLWithString:[self.detailItem valueForKey:@"photoImageData"]] resultBlock:^(ALAsset *asset){
            NSLog(@"asset: %@", asset);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.detailImageView.image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
            });
        }
                failureBlock:^(NSError *error){
                    
                }];
    }
}

- (IBAction)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

/*- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Cancel"])
    {
    }
    else if([title isEqualToString:@"Delete"])
    {
        [self removePhoto];
    }
}*/

/*-(void)removePhoto{
    
    [managedObjectContext deleteObject:self.detailItem];
    [[NSFileManager defaultManager] removeItemAtURL:[NSURL URLWithString:[self.detailItem valueForKey:@"photoImageData"]] error:NULL];
    [self.navigationController popViewControllerAnimated:YES];
} */


- (IBAction)share:(id)sender {
    DMActivityInstagram *instagramActivity = [[DMActivityInstagram alloc] init];
    
    NSString *shareText = @"created with Juxt-a-pose #JXTP";
    //NSURL *shareURL = [NSURL URLWithString:@"http://catpaint.info"];
    
    NSArray *activityItems = @[self.detailImageView.image, shareText];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:@[instagramActivity]];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (IBAction)takeNew{
    
    blendedImage = NULL;
    [[NSUserDefaults standardUserDefaults] setObject:@"new" forKey:@"base_photo"];
    [self dismissViewControllerAnimated:NO completion:NULL];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    if([[UIScreen mainScreen] bounds].size.height == 568)
    {
        // iPhone 5
        self.view = [[NSBundle mainBundle] loadNibNamed:@"DetailView" owner:self options:nil][0];
    }
    else
    {
        self.view = [[NSBundle mainBundle] loadNibNamed:@"DetailViewFour" owner:self options:nil][0];
    }
    [self configureView];
    
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
