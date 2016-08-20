//
//  MSFontSizePickerView.h
//  SimpleWord
//
//  Created by mr.scorpion on 16/5/13.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSFontSizePickerView;

@protocol MSFontSizePickerViewDataSource <NSObject>

- (NSInteger)MS_numberOfItemsInPickerView:(MSFontSizePickerView *)pickerView;
- (NSString *)MS_pickerView:(MSFontSizePickerView *)pickerView titleForItemAtIndex:(NSInteger)index;

@end

@protocol MSFontSizePickerViewDelegate <NSObject>

@optional
- (void)MS_pickerView:(MSFontSizePickerView *)pickerView didSelectIndex:(NSInteger)index;

@end

@interface MSFontSizePickerView : UIView

@property (nonatomic, weak) id<MSFontSizePickerViewDataSource> dataSource;
@property (nonatomic, weak) id<MSFontSizePickerViewDelegate> delegate;

@property (nonatomic, strong) UIFont *normalFont;
@property (nonatomic, strong) UIFont *selectedFont;
@property (nonatomic, strong) UIColor *normalTextColor;
@property (nonatomic, strong) UIColor *selectedTextColor;

@property (nonatomic, assign) CGFloat itemWidth;

@property (nonatomic, readonly) NSInteger numberOfItems;
@property (nonatomic, readonly) NSInteger selectedIndex;

- (void)reloadData;

- (void)selectIndex:(NSInteger)index animated:(BOOL)animated;

@end
