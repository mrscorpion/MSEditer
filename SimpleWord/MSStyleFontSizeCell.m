//
//  MSStyleFontCell.m
//  SimpleWord
//
//  Created by mr.scorpion on 16/5/13.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import "MSStyleFontSizeCell.h"
#import "MSFontSizePickerView.h"

@interface MSStyleFontSizeCell () <MSFontSizePickerViewDataSource, MSFontSizePickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *fontSizeLabel;
@property (weak, nonatomic) IBOutlet MSFontSizePickerView *pickerView;

@end

@implementation MSStyleFontSizeCell
{
    CAShapeLayer *_lineLayer;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    if (!_lineLayer) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.lineDashPattern = @[@5, @2];
        shapeLayer.lineWidth = 1.f;
        _lineLayer = shapeLayer;
        [self.layer addSublayer:_lineLayer];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.pickerView.hidden = !selected;
    _lineLayer.hidden = !selected;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (!self.selected) {
        return;
    }
    
    CGRect layerFrame = rect;
    layerFrame.origin.x = 20.f;
    layerFrame.origin.y = 60.f;
    layerFrame.size.width -= 20.f * 2;
    layerFrame.size.height = 1.f;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0.5f)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(layerFrame), 0.5f)];
    _lineLayer.path = path.CGPath;
    _lineLayer.frame = layerFrame;
}

#pragma mark - 

- (void)setFontSizeNumbers:(NSArray<NSNumber *> *)fontSizeNumbers {
    _fontSizeNumbers = [fontSizeNumbers copy];
    _currentFontSize = fontSizeNumbers.firstObject.integerValue;
    [self.pickerView reloadData];
}

- (void)setCurrentFontSize:(NSInteger)currentFontSize {
    [self.fontSizeNumbers enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.integerValue == currentFontSize) {
            _currentFontSize = currentFontSize;
            self.fontSizeLabel.text = [@(self.currentFontSize).stringValue stringByAppendingString:@"px"];
            [self.pickerView selectIndex:idx animated:NO];
            *stop = YES;
        }
    }];
}

#pragma mark <MSFontSizePickerViewDataSource, MSFontSizePickerViewDelegate>

- (NSInteger)MS_numberOfItemsInPickerView:(MSFontSizePickerView *)pickerView {
    return self.fontSizeNumbers.count;
}

- (NSString *)MS_pickerView:(MSFontSizePickerView *)pickerView titleForItemAtIndex:(NSInteger)index {
    return self.fontSizeNumbers[index].stringValue;
}

- (void)MS_pickerView:(MSFontSizePickerView *)pickerView didSelectIndex:(NSInteger)index {
    _currentFontSize = self.fontSizeNumbers[index].integerValue;
    self.fontSizeLabel.text = [@(self.currentFontSize).stringValue stringByAppendingString:@"px"];
    [self.delegate MS_didChangeStyleSettings:@{MSStyleSettingsFontSizeName: @(self.currentFontSize)}];
}

@end
