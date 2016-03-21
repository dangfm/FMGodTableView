//
//  ViewController.m
//  FMGodTableView
//
//  Created by dangfm on 16/3/14.
//  Copyright © 2016年 dangfm. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) UIScrollView *scrollView;
@property (nonatomic,retain) FMGodTableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createViews{
    [self createScrollViews];
}

-(void)createScrollViews{
//    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:_scrollView];
//    _scrollView.delegate = self;
//    _scrollView.contentSize = CGSizeMake(0, _scrollView.frame.size.height);
//    
    [self createTableViews];
}

-(void)createTableViews{
    _tableView = [[FMGodTableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    // 注册一个
    extern NSString *GodCellScrollNotification;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:GodCellScrollNotification object:nil];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentify = @"cell";
    FMGodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[FMGodTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        
    }
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:GodCellScrollNotification object:self userInfo:@{@"x":@(_CellLastScrollX)}];
}

-(void)scrollMove:(NSNotification*)notification{
    NSDictionary *xn = notification.userInfo;
    NSObject *obj = notification.object;
    float x = [xn[@"x"] floatValue];
    _CellLastScrollX = x;
    obj = nil;
}
@end
