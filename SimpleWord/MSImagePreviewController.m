//
//  MSImagePreviewController.m
//  SimpleWord
//
//  Created by mr.scorpion on 16/5/16.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import "MSImagePreviewController.h"

@import Photos;

@interface MSImagePreviewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *toolbarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (nonatomic, strong) UIImage *image;

@end

@implementation MSImagePreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"图片预览";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    self.imageView.image = self.image;
}

- (void)setAsset:(PHAsset *)asset {
    _asset = asset;
    CGSize targetSize = [UIScreen mainScreen].bounds.size;
    targetSize.width *= 2;
    targetSize.height *= 2;
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:targetSize
                                              contentMode:PHImageContentModeAspectFit
                                                  options:nil
                                            resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                self.image = result;
                                            }];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    BOOL hidden = !self.navigationController.isNavigationBarHidden;
    [self.navigationController setNavigationBarHidden:hidden animated:YES];
    
    self.bottomConstraint.constant = hidden ? - CGRectGetHeight(self.toolbarView.frame) : 0;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutSubviews];
    }];
    
}

- (IBAction)doneAction {    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.delegate MS_previewController:self dismissPreviewWithCancel:NO];
}

- (void)cancelAction {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.delegate MS_previewController:self dismissPreviewWithCancel:YES];
}

@end
