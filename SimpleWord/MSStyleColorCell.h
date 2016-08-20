//
//  MSStyleColorCell.h
//  SimpleWord
//
//  Created by mr.scorpion on 16/5/13.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSStyleSettings.h"

@interface MSStyleColorCell : UITableViewCell

@property (nonatomic, weak) id<MSStyleSettings> delegate;

@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, copy) NSArray *colors;

@end
