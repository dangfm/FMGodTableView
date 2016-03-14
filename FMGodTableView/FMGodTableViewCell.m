//
//  FMGodTableViewCell.m
//  FMGodTableView
//
//  Created by dangfm on 16/3/14.
//  Copyright © 2016年 dangfm. All rights reserved.
//

#import "FMGodTableViewCell.h"

@implementation FMGodTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createViews];
    }
    return self;
}

-(void)createViews{
    _mainView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _mainView.contentSize = CGSizeMake(4*_mainView.frame.size.width, 0);
    _mainView.delegate = self;
    _mainView.directionalLockEnabled = YES;
    [self.contentView addSubview:_mainView];
    NSArray * strings = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    float w = _mainView.contentSize.width / strings.count;
    float x = 0;
    for (NSString *str in strings) {
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, w, self.bounds.size.height)];
        [_mainView addSubview:l];
        l.text = str;
        l.textAlignment = NSTextAlignmentCenter;
        l = nil;
        x += w;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:GodCellScrollNotification object:nil];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _isNotification = NO;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (!_isNotification) {
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:GodCellScrollNotification object:self userInfo:@{@"x":@(scrollView.contentOffset.x)}];
    }
    _isNotification = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 避开自己发的通知，只有手指拨动才会是自己的滚动
    if (!_isNotification) {
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:GodCellScrollNotification object:self userInfo:@{@"x":@(scrollView.contentOffset.x)}];
    }
    
    NSArray *views = scrollView.subviews;
    UIView *first = views.firstObject;
    CGRect frame = first.frame;
    frame.origin.x = scrollView.contentOffset.x;
    first.frame = frame;
    _isNotification = NO;
}

-(void)scrollMove:(NSNotification*)notification{
    NSDictionary *xn = notification.userInfo;
    NSObject *obj = notification.object;
    float x = [xn[@"x"] floatValue];
    if (obj!=self) {
        _isNotification = YES;
        [_mainView setContentOffset:CGPointMake(x, 0) animated:NO];
    }else{
        _isNotification = NO;
    }
    obj = nil;
}

@end
