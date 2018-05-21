//
//  GPinSegmentationListController.m
//  GBigbangExample
//
//  Created by GIKI on 2017/10/23.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GPinSegmentationListController.h"
#import "GTagFlowView.h"
#import "GBigbangBox.h"

#define PinTagColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface GPinSegmentationListController ()
@property (nonatomic, strong) GTagFlowView * flowView;
@property (nonatomic, strong) GTagFlowAppearance  * appearance;
@end

@implementation GPinSegmentationListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分词列表";
    self.view.backgroundColor = [UIColor whiteColor];
    self.flowView = [[GTagFlowView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.flowView];
    self.flowView.edgeInsets = UIEdgeInsetsMake(20, 20, 0, 20);
   
    
    self.appearance = [GTagFlowAppearance new];
    self.appearance.borderColor = [UIColor blackColor];
    self.appearance.textColor = [UIColor blackColor];
    self.appearance.borderWidth = 1;
    self.appearance.backgroundColor = [UIColor whiteColor];
    self.appearance.selectTextColor = [UIColor redColor];
    self.appearance.selectBorderColor = [UIColor redColor];
    self.appearance.selectBackgroundColor = [UIColor whiteColor];
    
    NSArray *items = [GBigbangBox bigBang:self.string];
    
    NSArray * layouts = [GTagFlowItem factoryFolwLayoutWithItems:items withAppearance:self.appearance];
    self.flowView.flowDatas = layouts;
    [self.flowView reloadDatas];
    
    UIButton * copy = [UIButton buttonWithType:UIButtonTypeCustom];
    [copy setTitle:@"复制" forState:UIControlStateNormal];
    [copy setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [copy setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    copy.backgroundColor = PinTagColor(212, 230, 241);
    copy.frame = CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width/2, 40);
    [copy addTarget:self action:@selector(copy:) forControlEvents:UIControlEventTouchUpInside];
    
    copy.enabled = NO;
    
    UIButton * search = [UIButton buttonWithType:UIButtonTypeCustom];
    [search setTitle:@"搜索" forState:UIControlStateNormal];
    [search setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [search setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    search.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height-40, self.view.frame.size.width/2, 40);
    search.backgroundColor = PinTagColor(212, 230, 241);
    [search addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    search.enabled = NO;
    
    [self.view addSubview:copy];
    [self.view addSubview:search];
    
    
    self.flowView.selectedChangedBlock = ^(BOOL hasSelected) {
        copy.enabled = hasSelected;
        search.enabled = hasSelected;
    };
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.flowView.frame = self.view.bounds;
}

- (void)copy:(UIButton *)btn
{
    [UIPasteboard generalPasteboard].string = [self.flowView getNewTextstring];
    
}

- (void)search:(UIButton *)btn
{
    NSString *string = [self.flowView getNewTextstring];
    
    string = [self urlString:string EncodeUsingEncoding:NSUTF8StringEncoding];
    NSString * query = [NSString stringWithFormat:@"https://www.sogou.com/web?query=%@",string];

    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:query]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:query] options:nil completionHandler:^(BOOL success) {
            
        }];
    }
    
}

-(NSString *)urlString:(NSString*)string EncodeUsingEncoding:(NSStringEncoding)encoding {
    
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)string,NULL,(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(encoding)));
   
}



@end
