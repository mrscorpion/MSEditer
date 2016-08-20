//
//  MSStyleParagraphCell.h
//  SimpleWord
//
//  Created by mr.scorpion on 16/5/13.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSStyleSettings.h"

typedef NS_ENUM(NSUInteger, MSStyleIndentDirection) {
    MSStyleIndentDirectionLeft = -1,
    MSStyleIndentDirectionRight = 1,
};

@protocol MSStyleParagraphCellDelegate <MSStyleSettings>

- (void)MS_paragraphChangeIndentWithDirection:(MSStyleIndentDirection)direction;
- (void)MS_paragraphChangeType:(NSInteger)type;

@end

@interface MSStyleParagraphCell : UITableViewCell

@property (nonatomic, readonly) BOOL isList;
@property (nonatomic, readonly) BOOL isNumberList;
@property (nonatomic, readonly) BOOL isCheckbox;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, weak) id<MSStyleParagraphCellDelegate> delegate;

@end
