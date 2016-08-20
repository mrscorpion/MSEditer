//
//  MSColorPickerView.h
//  MSColorPickerView
//
//  Created by mr.scorpion on 16/5/14.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSColorPickerView;

@protocol MSColorPickerViewDataSource <NSObject>

- (NSInteger)MS_numberOfColorsInColorPickerView:(MSColorPickerView *)pickerView;
- (UIColor *)MS_colorPickerView:(MSColorPickerView *)pickerView colorForItemAtIndex:(NSInteger)index;

@end

@protocol MSColorPickerViewDelegate <NSObject>

@optional
- (void)MS_colorPickerView:(MSColorPickerView *)pickerView didSelectIndex:(NSInteger)index;
- (void)MS_colorPickerView:(MSColorPickerView *)pickerView didSelectColor:(UIColor *)color;

@end

@interface MSColorPickerView : UIView

@property (nonatomic, weak) id<MSColorPickerViewDataSource> dataSource;
@property (nonatomic, weak) id<MSColorPickerViewDelegate> delegate;

@property (nonatomic, assign) NSInteger spacingBetweenColors; // default is 20.f

@property (nonatomic, readonly) NSInteger numberOfColors;
@property (nonatomic, readonly) NSInteger selectedIndex;

- (void)reloadData;
- (void)selectIndex:(NSInteger)index;

@end
