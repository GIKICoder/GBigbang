//
//  GPinHistoryViewController.m
//  GBigbangExample
//
//  Created by GIKI on 2017/10/23.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GPinHistoryViewController.h"
#import "GPinSegmentationListController.h"
#define kHistoryPasteboardKey @"kHistoryPasteboardKey"

@interface GPinHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITextView * textView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray  * datas;
@end

@implementation GPinHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:({
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 64, self.view.frame.size.width-30, 150)];
        _textView.layer.borderWidth = 1;
        _textView.layer.cornerRadius =  3;
        _textView.layer.masksToBounds = YES;
        _textView.font = [UIFont systemFontOfSize:18];
        _textView.text = @"可长按文字选择复制文本.体验分词效果.也可输入文字,体验分词效果";
        _textView;
    })];
    [self.view addSubview:({
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_textView.frame), self.view.frame.size.width, self.view.frame.size.height -CGRectGetMaxY(_textView.frame) ) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView;
     })];
    
    self.datas = [[NSUserDefaults standardUserDefaults] objectForKey:kHistoryPasteboardKey];
   
    NSString *string = UIPasteboard.generalPasteboard.string;
  
    if (string) {
        if (![string isEqualToString:[self.datas lastObject]]) {
            NSMutableArray * array = [NSMutableArray arrayWithArray:self.datas];
            [array insertObject:string atIndex:0];
            self.datas = array.copy;
            [[NSUserDefaults standardUserDefaults] setObject:self.datas forKey:kHistoryPasteboardKey];
        }
       
    }
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PasteboardChanged:) name:UIPasteboardChangedNotification object:nil];
}

- (void)PasteboardChanged:(NSNotification*)notif
{
    UIPasteboard *board = notif.object;
    NSString *string = board.string;
    if (string) {
        NSMutableArray * array = [NSMutableArray arrayWithArray:self.datas];
        [array insertObject:string atIndex:0];
        self.datas = array.copy;
        [[NSUserDefaults standardUserDefaults] setObject:self.datas forKey:kHistoryPasteboardKey];
    }
    [self.tableView reloadData];
    NSLog(@"test %@",board.string);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell"];
    }
    if (indexPath.row < self.datas.count) {
        cell.textLabel.text = self.datas[indexPath.row];
    }
    
    return cell;
}


#pragma mark -- TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GPinSegmentationListController *vc = [GPinSegmentationListController new];
    vc.string = self.datas[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
     [self.textView resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.textView resignFirstResponder];
}
@end
