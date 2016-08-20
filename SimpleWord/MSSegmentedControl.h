//
//  MSSegmentedControl.h
//  SimpleWord
//
//  Created by mr.scorpion on 16/5/13.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSSegmentedControl;

@protocol MSSegmentedControlDelegate <NSObject>

- (void)MS_segmentedControl:(MSSegmentedControl *)control didTapAtIndex:(NSInteger)index;

@end

@interface MSSegmentedControl : UIControl

@property (nonatomic, weak) id<MSSegmentedControlDelegate> delegate;
@property (nonatomic, assign) BOOL changeSegmentManually;

@property (nonatomic, readonly) NSInteger numberOfSegments;
@property (nonatomic, readonly) NSInteger selectedSegmentIndex;

- (instancetype)initWithItems:(NSArray<UIImage *> *)items;
- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex animated:(BOOL)animated;

@end
