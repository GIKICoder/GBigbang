//
//  GNewsDetailViewController.m
//  GBigbangExample
//
//  Created by GIKI on 2017/10/23.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GNewsDetailViewController.h"
#import "GCommentCell.h"
@interface GNewsDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray  * datas;

@end

@implementation GNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label;
    [self.view addSubview:({
        label = [UILabel new];
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = [UIColor blackColor];
        label.frame = CGRectMake(0, 0, self.view.bounds.size.width,330);
        label.numberOfLines = 0;
        label;
    })];
    [self setLabelText:label];
    [self.view addSubview:({
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = label;
        _tableView;
    })];
}

- (void)setLabelText:(UILabel*)label
{
    label.text = @"  今天火箭队首次坐阵主场挑战西部弱旅小牛队，恐怕也正如央视主持人说的那样，这支小牛已经不再是当年的那支小牛了，随着时间的推移，它的实力大不如从前，根本不是现在这支火箭队的对手.\n    比赛的情况小编就简介一下，火箭此战保罗因伤休战，但是即便如此火箭依然在哈登的带领下狂虐小牛，本场比赛火箭非常刻意的减少了球队的三分出手数，更多的是开始靠火箭队内的突破。\n    而小牛的功勋诺维斯基的脚步又无法跟上火箭的步伐，怎么打都挡不住对手。而当小牛为了跟上火箭的速度改打小个阵容时，火箭直接就用自己的身高强行欺负小牛。";
}

#pragma mark -- TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    if (!cell) {
        cell = [[GCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell"];
    }
//    if (indexPath.row < self.datas.count) {
//        cell.textLabel.text = self.datas[indexPath.row];
//    }
    
    return cell;
}


#pragma mark -- TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}


@end
