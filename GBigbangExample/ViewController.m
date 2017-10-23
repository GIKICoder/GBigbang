//
//  ViewController.m
//  GBigbangExample
//
//  Created by GIKI on 2017/10/20.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "ViewController.h"
#import "GWebViewController.h"
#import "GPinHistoryViewController.h"
#import "GNewsDetailViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView  * tableView;
@property (nonatomic, strong) NSArray * titles;
@end
#define PUSHVC(VC)  [self.navigationController pushViewController:[[VC alloc] init] animated:YES];
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GBigbang";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.titles = @[@"粘贴板分词(PIN 界面)",
                    @"网页文字选中bigbang(UC浏览器分词)",
                    @"新闻详情评论页"];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark -- TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}


#pragma mark -- TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        PUSHVC(GWebViewController);
    } else if (indexPath.row == 0) {
        PUSHVC(GPinHistoryViewController);
    } else if (indexPath.row == 2) {
        PUSHVC(GNewsDetailViewController);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


@end
