//
//  PhotoLoaderAppDelegate.h
//  PhotoLoader
//
//  Created by Robin Summerhill on 01/09/2010.
//  Copyright Aptogo Limited 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageImporterViewController;

@interface ImageImporterAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ImageImporterViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ImageImporterViewController *viewController;

@end

