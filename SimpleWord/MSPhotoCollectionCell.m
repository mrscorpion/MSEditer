//
//  MSPhotoCollectionCell.m
//  SimpleWord
//
//  Created by mr.scorpion on 16/5/16.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import "MSPhotoCollectionCell.h"

@interface MSPhotoCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;

@end

@implementation MSPhotoCollectionCell

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.selectedImageView.hidden = !selected;
}

@end
