//
//  MSImageSettingsController.m
//  SimpleWord
//
//  Created by mr.scorpion on 16/5/16.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import "MSImageSettingsController.h"
#import "MSPhotoCollectionCell.h"
#import "MSImagePreviewController.h"

@import Photos;

@interface MSImageSettingsController () <UICollectionViewDataSource, UICollectionViewDelegate, MSImagePreviewControllerDelegate, PHPhotoLibraryChangeObserver, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;

@property (nonatomic, strong) UIViewController *previewController;

@property (nonatomic, assign) BOOL selecting;

@property (nonatomic, strong) PHFetchResult *photosResult;
@property (nonatomic, strong) NSMutableDictionary *photos;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation MSImageSettingsController

- (void)awakeFromNib {
    self.selecting = NO;
    
    self.button1.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.button2.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selecting = NO;
    self.button1.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.button2.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self fetchPhotos];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat height = CGRectGetHeight(self.collectionView.frame);
    layout.itemSize = CGSizeMake(height * 0.8, height);
    [self.collectionView setNeedsLayout];
}

- (void)setSelecting:(BOOL)selecting {
    _selecting = selecting;
    
    if (selecting){
        [self.button1 setImage:[UIImage imageNamed:@"photo_preview_icon"] forState:UIControlStateNormal];
        [self.button2 setImage:[UIImage imageNamed:@"photo_send_icon"] forState:UIControlStateNormal];
        [self.button1 setTitle:@"预览" forState:UIControlStateNormal];
        [self.button2 setTitle:@"发送" forState:UIControlStateNormal];
        [self.button2 setTitleColor:[UIColor colorWithRed:93/255.f green:150/255.f blue:209/255.f alpha:1.f] forState:UIControlStateNormal];
    }
    else {
        [self.button1 setImage:[UIImage imageNamed:@"photo_take_icon"] forState:UIControlStateNormal];
        [self.button2 setImage:[UIImage imageNamed:@"photo_gallery_icon"] forState:UIControlStateNormal];
        [self.button1 setTitle:@"拍照" forState:UIControlStateNormal];
        [self.button2 setTitle:@"相册" forState:UIControlStateNormal];
        [self.button2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

- (void)fetchPhotos {
    PHFetchOptions *nearestPhotosOptions = [[PHFetchOptions alloc] init];
    nearestPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    nearestPhotosOptions.fetchLimit = 20;
    self.photosResult = [PHAsset fetchAssetsWithOptions:nearestPhotosOptions];
    self.photos = [NSMutableDictionary dictionary];
}

- (void)reload {
    self.selecting = NO;
    self.selectedIndexPath = nil;
    [self.collectionView reloadData];
}

- (IBAction)buttonAction:(UIButton *)sender {
    
    if (self.selecting) {
        if (sender == self.button1) {
            // 预览
            MSImagePreviewController *previewController = [self.storyboard instantiateViewControllerWithIdentifier:@"preview"];
            previewController.delegate = self;
            previewController.asset = self.photosResult[self.selectedIndexPath.item];;
            UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:previewController];
            [self.delegate MS_imageSettingsController:self presentPreview:naviController];;
        }
        else {
            // 发送
            PHAsset *asset = self.photosResult[self.selectedIndexPath.item];
            CGSize targetSize = [UIScreen mainScreen].bounds.size;
            targetSize.width *= 2;
            targetSize.height *= 2;
            [[PHImageManager defaultManager] requestImageForAsset:asset
                                                       targetSize:targetSize
                                                      contentMode:PHImageContentModeAspectFit
                                                          options:nil
                                                    resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                        // 会调用两次，第一次先给预览图片，用PHImageResultIsDegradedKey的值判断
                                                        BOOL isDegraded = [info[PHImageResultIsDegradedKey] boolValue];
                                                        if (!isDegraded) {
                                                            [self.delegate MS_imageSettingsController:self insertImage:result];
                                                        }
                                                    }];
        }
    }
    else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        if (sender == self.button1) {
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {
                // 拍照
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                //设置拍照后的图片可被编辑
                picker.allowsEditing = YES;
                // 如果自定义可以在加上旋转屏幕的图标
//                picker.cameraViewTransform = CGAffineTransformMakeRotation(M_PI*45/180);
//                picker.cameraViewTransform = CGAffineTransformMakeScale(1.5, 1.5);
                // 设置拍照时的下方的工具栏是否显示，如果需要自定义拍摄界面，则可把该工具栏隐藏
//                picker.showsCameraControls  = NO;
            } else {
                NSLog(@"模拟器无法打开照相机,请在真机中使用");
            }
        }
        else {
            // 相册
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        picker.delegate = self;
        [self.delegate MS_imageSettingsController:self presentImagePickerView:picker];
    }
}

#pragma mark - <PHPhotoLibraryChangeObserver>

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    [self fetchPhotos];
}

#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photosResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MSPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    UIImage *image = self.photos[indexPath];
    if (image) {
        cell.imageView.image = image;
    }
    else {
        cell.imageView.image = nil;
        PHAsset *asset = self.photosResult[indexPath.item];
        CGSize targetSize = CGSizeMake(200, 200);
        [[PHImageManager defaultManager] requestImageForAsset:asset
                                                   targetSize:targetSize
                                                  contentMode:PHImageContentModeAspectFit
                                                      options:nil
                                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                    
                                                    self.photos[indexPath] = result;
                                                    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                                                }];
    }
    cell.selected = ([indexPath isEqual:self.selectedIndexPath]);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath isEqual:self.selectedIndexPath]) {
        self.selectedIndexPath = nil;
        self.selecting = NO;
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    }
    else {
        self.selectedIndexPath = indexPath;
        self.selecting = YES;
    }
}

#pragma mark - <MSImagePreviewControllerDelegate>

- (void)MS_previewController:(MSImagePreviewController *)previewController dismissPreviewWithCancel:(BOOL)cancel {
    if (!cancel) {
        [self.delegate MS_imageSettingsController:self insertImage:self.photos[self.selectedIndexPath]];
    }
}

#pragma mark - 

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 这里原来的改为获取裁剪后的图，允许用户编辑
//    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    //获取图片裁剪的图
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    /*//获取照片的原图
    UIImage* original = [info objectForKey:UIImagePickerControllerOriginalImage];
    //获取图片裁剪的图
    UIImage* edit = [info objectForKey:UIImagePickerControllerEditedImage];
    //获取图片裁剪后，剩下的图
    UIImage* crop = [info objectForKey:UIImagePickerControllerCropRect];
    //获取图片的url
    NSURL* url = [info objectForKey:UIImagePickerControllerMediaURL];
    //获取图片的metadata数据信息
    NSDictionary* metadata = [info objectForKey:UIImagePickerControllerMediaMetadata];
    //如果是拍照的照片，则需要手动保存到本地，系统不会自动保存拍照成功后的照片
    UIImageWriteToSavedPhotosAlbum(edit, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);*/
    
    CGSize targetSize = [UIScreen mainScreen].bounds.size;
    targetSize.width *= 2;
    targetSize.height = targetSize.width * originalImage.size.height / originalImage.size.width;
    
    UIGraphicsBeginImageContext(targetSize);
    [originalImage drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.delegate MS_imageSettingsController:self insertImage:scaledImage];
}
// 取消照相机的回调
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
// 保存照片成功后的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    NSLog(@"saved..");
}
@end
