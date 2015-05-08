//
//  DetailView.h
//  Juxt-a-pose
//
//  Created by Brandon Phillips on 6/18/13.
//  Copyright (c) 2013 We Are Station. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllPhotos.h"

@interface DetailView : UIViewController<UIDocumentInteractionControllerDelegate, UIAlertViewDelegate>{
    
}
@property (nonatomic, strong) UIDocumentInteractionController *docController;
@property (strong, nonatomic) UIImage *detailImage;
@property (strong, nonatomic) NSString *itemString;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (strong, nonatomic) id detailItem;


-(IBAction)goBack;
-(IBAction)share:(id)sender;

@end
