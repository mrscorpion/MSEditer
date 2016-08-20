//
//  MSTextStyleController.h
//  SimpleWord
//
//  Created by mr.scorpion on 16/5/12.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSTextStyle;
@class MSParagraphConfig;

@protocol MSStyleSettingsControllerDelegate <NSObject>

- (void)MS_didChangedTextStyle:(MSTextStyle *)textStyle;
- (void)MS_didChangedParagraphIndentLevel:(NSInteger)level;
- (void)MS_didChangedParagraphType:(NSInteger)type;

@end

@interface MSStyleSettingsController : UITableViewController

@property (nonatomic, weak) id<MSStyleSettingsControllerDelegate> delegate;
@property (nonatomic, strong) MSTextStyle *textStyle;

- (void)reload;
- (void)setParagraphConfig:(MSParagraphConfig *)paragraphConfig;

@end
