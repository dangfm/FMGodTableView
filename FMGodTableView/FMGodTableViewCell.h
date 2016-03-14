//
//  FMGodTableViewCell.h
//  FMGodTableView
//
//  Created by dangfm on 16/3/14.
//  Copyright © 2016年 dangfm. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *GodCellScrollNotification = @"GodCellScrollNotification";
@interface FMGodTableViewCell : UITableViewCell<UIScrollViewDelegate>

@property (nonatomic,retain) UIScrollView *mainView;
@property (nonatomic,assign) BOOL isNotification;
@property (nonatomic,retain) NSNotification *notification;

@end
