//
//  PhotoLoaderViewController.m
//  PhotoLoader
//
//  Created by Robin Summerhill on 01/09/2010.
//  Copyright Aptogo Limited 2010. All rights reserved.
//

// Modify this to point to your default import location

#import "ImageImporterViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

// USER_HOME is set automatically in build settings ('Preprocessor Definitions')
#ifndef USER_HOME
#define USER_HOME @"/Users/robin/images/"
#endif


@interface ImageImporterViewController ()
- (BOOL)fileIsImage:(NSString *)file;
- (void)importNextImage;
- (void)importImage:(NSString *)file;
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
- (void)updateUI:(BOOL)importing;

@property (nonatomic, retain) UIAlertView *alertView;

@end

@implementation ImageImporterViewController

@synthesize importPathTextField;
@synthesize fileLabel;
@synthesize progressView;
@synthesize alertView;
@synthesize importButton;
@synthesize cancelButton;

- (void)dealloc
{

    [path release];
    [directoryEnumerator release];
    [self viewDidUnload];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    importPathTextField.text = USER_HOME;
}

- (void)viewDidUnload
{
    self.importPathTextField = nil;
    self.fileLabel = nil;
    self.progressView = nil;
    self.alertView = nil;
    self.importButton = nil;
    self.cancelButton = nil;
}

- (IBAction)import
{
    if (path) [path release];
    path = [importPathTextField.text copy];
    
    shouldContinue = YES;
    numImages = 0;
    imagesProcessed = 0;
    progressView.progress = 0.0f;
    
    [self updateUI:YES];
    
    // First count images in import path
    for (NSString *file in [[NSFileManager defaultManager] enumeratorAtPath:path])
    {
        if ([self fileIsImage:file])
            numImages++;
    }
    
    if (numImages == 0)
    {
        self.alertView.message = @"No images found at path";
        [self.alertView show];     
        [self updateUI:NO];
        return;
    }
    
    if (directoryEnumerator) [directoryEnumerator release];
    directoryEnumerator = [[[NSFileManager defaultManager] enumeratorAtPath:path] retain];
    
    [self importNextImage];
}

- (IBAction)cancel
{
    shouldContinue = NO;
}

// Advance directory iterator to next image and import it
- (void)importNextImage
{
    NSString *file;
    while (file = [directoryEnumerator nextObject])
    {
        file = [path stringByAppendingPathComponent:file];
        
        if ([self fileIsImage:file])
            break;
    }
    
    if (file)
    {
        [self importImage:file];
    }
    else
    {
        [self updateUI:NO];
        fileLabel.hidden = NO;
        fileLabel.text = @"Finished!";
    }

}

// Import the specified image
- (void)importImage:(NSString *)file
{
    fileLabel.text = [file lastPathComponent];
    NSData *image = [[[NSData alloc] initWithContentsOfFile:file] autorelease];
    ALAssetsLibrary *al = [[[ALAssetsLibrary alloc] init] autorelease];    
    [al writeImageDataToSavedPhotosAlbum:image metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error)
        {
            self.alertView.message = error.localizedDescription;
            [self.alertView show];
            [self updateUI:NO];
            fileLabel.hidden = NO;
            fileLabel.text = @"Error!";
            return;
        }
        
        imagesProcessed++;
        progressView.progress = (float)imagesProcessed / numImages;
        
        if (shouldContinue)
        {
            [self importNextImage];
        }
        else
        {
            [self updateUI:NO];
            fileLabel.hidden = NO;
            fileLabel.text = @"Cancelled!";
        }
    }];
    
}

// Update UI elements
- (void)updateUI:(BOOL)importing
{
    if (importing)
    {
        fileLabel.hidden = NO;
        progressView.hidden = NO;
        fileLabel.text = @"Progress:";
        importButton.enabled = NO;
        cancelButton.hidden = NO;
    }
    else
    {
        progressView.hidden = YES;
        fileLabel.hidden = YES;
        importButton.enabled = YES;
        cancelButton.hidden = YES;
    }
}

// Return YES if specified file is an image file
- (BOOL)fileIsImage:(NSString *)file
{
    NSString *ext = [[file pathExtension] lowercaseString];
    
    return ([ext isEqualToString:@"jpg"] || [ext isEqualToString:@"png"]);
}

// Getter for alertView - lazy creation
- (UIAlertView*)alertView
{
    if (!alertView)
    {
        alertView = [[UIAlertView alloc] initWithTitle:@"PhotoLoader" 
                                               message:@"Default message" 
                                              delegate:nil 
                                     cancelButtonTitle:@"OK" 
                                     otherButtonTitles:nil];
    }
    
    return alertView;
}

// MARK: UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
