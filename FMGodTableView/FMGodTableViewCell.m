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
    CGRect screen = [UIScreen mainScreen].bounds;
    _mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, self.bounds.size.height)];
    _mainView.contentSize = CGSizeMake(4*_mainView.frame.size.width, self.bounds.size.height);
    _mainView.delegate = self;
    //_mainView.directionalLockEnabled = YES;
    [self.contentView addSubview:_mainView];
    NSArray * strings = @[@"左边标题",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    float w = _mainView.contentSize.width / (strings.count);
    float x = _mainView.contentSize.width-w;
    for (int i=(int)strings.count-1;i>=0;i--) {
        NSString *str = strings[i];
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, w, self.bounds.size.height)];
        [_mainView addSubview:l];
        l.layer.borderColor = [UIColor colorWithRed:0.01 green:0.01 blue:0.01 alpha:0.3].CGColor;
        l.layer.borderWidth = 0.5;
        l.backgroundColor = [UIColor whiteColor];
        l.text = str;
        l.textAlignment = NSTextAlignmentCenter;
        l = nil;
        x -= w;
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
    UIView *first = views.lastObject;
    CGRect frame = first.frame;
    frame.origin.x = scrollView.contentOffset.x;
    first.frame = frame;
    //[scrollView bringSubviewToFront:first];
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
