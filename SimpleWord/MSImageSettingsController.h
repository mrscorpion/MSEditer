//
//  MSImageSettingsController.h
//  SimpleWord
//
//  Created by mr.scorpion on 16/5/16.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSImageSettingsController;

@protocol MSImageSettingsControllerDelegate <NSObject>

- (void)MS_imageSettingsController:(MSImageSettingsController *)viewController presentPreview:(UIViewController *)previewController;
- (void)MS_imageSettingsController:(MSImageSettingsController *)viewController insertImage:(UIImage *)image;

- (void)MS_imageSettingsController:(MSImageSettingsController *)viewController presentImagePickerView:(UIViewController *)picker;
//- (void)MS_imageSettingsController:(MSImageSettingsController *)viewController dismissImagePickerView:(UIViewController *)picker;

@end

@interface MSImageSettingsController : UIViewController

@property (nonatomic, weak) id<MSImageSettingsControllerDelegate> delegate;
- (void)reload;

@end
