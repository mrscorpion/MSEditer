//
//  MSImagePreviewController.h
//  SimpleWord
//
//  Created by mr.scorpion on 16/5/16.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSImagePreviewController;
@class PHAsset;

@protocol MSImagePreviewControllerDelegate <NSObject>

- (void)MS_previewController:(MSImagePreviewController *)previewController dismissPreviewWithCancel:(BOOL)cancel;

@end

@interface MSImagePreviewController : UIViewController

@property (nonatomic, weak) id<MSImagePreviewControllerDelegate> delegate;
@property (nonatomic, strong) PHAsset *asset;

@end
