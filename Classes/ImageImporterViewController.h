//
//  PhotoLoaderViewController.h
//  PhotoLoader
//
//  Created by Robin Summerhill on 01/09/2010.
//  Copyright Aptogo Limited 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageImporterViewController : UIViewController <UITextFieldDelegate> {
    UITextField *importPathTextField;
    UILabel *fileLabel;
    UIProgressView *progressView;
    UIAlertView *alertView;
    UIButton *importButton;
    UIButton *cancelButton;
    
    
    NSString *path;
    NSDirectoryEnumerator *directoryEnumerator; 
    BOOL shouldContinue;
    int numImages;
    int imagesProcessed;
}

@property (nonatomic, retain) IBOutlet UITextField *importPathTextField;
@property (nonatomic, retain) IBOutlet UILabel *fileLabel;
@property (nonatomic, retain) IBOutlet UIProgressView *progressView;
@property (nonatomic, retain) IBOutlet UIButton *importButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;

- (IBAction)import;
- (IBAction)cancel;


@end

