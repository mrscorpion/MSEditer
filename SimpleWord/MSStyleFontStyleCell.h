//
//  MSStyleFontStyleCell.h
//  SimpleWord
//
//  Created by mr.scorpion on 16/5/13.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSStyleSettings.h"

@interface MSStyleFontStyleCell : UITableViewCell

@property (nonatomic, weak) id<MSStyleSettings> delegate;

@property (nonatomic, assign) BOOL bold;
@property (nonatomic, assign) BOOL italic;
@property (nonatomic, assign) BOOL underline;

@end
