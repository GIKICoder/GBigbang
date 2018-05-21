//
//  GWebViewController.m
//  GBigbangExample
//
//  Created by GIKI on 2017/10/20.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GWebViewController.h"
#import "GBigbangBox.h"
#import "GTagFlowContainer.h"
#import "GTagFlowView.h"
@interface GWebView : UIWebView

@property (nonatomic, strong) GTagFlowContainer * container;
@end

@implementation GWebView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        GTagFlowContainer *container = [GTagFlowContainer new];
        self.container = container;
        __weak typeof(self) weakSelf = self;
        self.container.actionBlock = ^(NSString *actionTitle, NSString *newText) {
            [weakSelf clickTitle:actionTitle text:newText];
        };
        [self configNewMenu];
    }
    return self;
}
//%E6%90%9C%E7%8B%97%E7%BF%BB%E8%AF%91
- (void)configNewMenu
{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    UIMenuItem *bigbang = [[UIMenuItem alloc] initWithTitle:@"Bigbang" action:@selector(bigbang:)];
    
    NSArray *mArray = [NSArray arrayWithObjects:bigbang,nil];
    [menuController setMenuItems:mArray];
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if(action == @selector(copy:) || action == @selector(selectAll:)|| action == @selector(bigbang:))
    {
        return YES;
    }
    
    return NO;
}

-(void)bigbang:(id)sender
{
    NSString* selection = [self stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    NSArray * array = [GBigbangBox bigBang:selection];
    __block NSMutableArray *flows = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(GBigbangItem  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GTagFlowItem *layout = [GTagFlowItem tagFlowItemWithText:obj.text];
        [flows addObject:layout];
        if (obj.isSymbolOrEmoji) {
            layout.appearance.backgroundColor = [UIColor grayColor];
            layout.appearance.textColor = [UIColor blackColor];
        }
    }];
    [self.container configDatas:flows.copy];
    [self.container show];
    
}

- (void)clickTitle:(NSString*)title text:(NSString*)text
{
    if ([title isEqualToString:@"翻译"]) {
        text = [self urlString:text EncodeUsingEncoding:NSUTF8StringEncoding];
        NSString * query = [NSString stringWithFormat:@"https://fanyi.sogou.com/?fr=websearch&query=%@",text];
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:query]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:query] options:nil completionHandler:^(BOOL success) {
                
            }];
        }
        
    } else if ([title isEqualToString:@"搜索"]) {
        text = [self urlString:text EncodeUsingEncoding:NSUTF8StringEncoding];
        NSString * query = [NSString stringWithFormat:@"https://www.sogou.com/web?query=%@",text];
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:query]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:query] options:nil completionHandler:^(BOOL success) {
                
            }];
        }
    } else if ([title isEqualToString:@"分享"]) {
        NSArray *activityItems = @[text];
        
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
        __weak typeof(self) weakSelf = self;
        
        [[self getViewController] presentViewController:activityVC animated:YES completion:^{
            
        }];
    }
}

- (UIViewController *)getViewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

-(NSString *)urlString:(NSString*)string EncodeUsingEncoding:(NSStringEncoding)encoding {
    
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)string,NULL,(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(encoding)));
    
}

@end


@interface GWebViewController ()
@property (nonatomic, strong) GWebView * webView;
@end

@implementation GWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[GWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com/home/news/data/newspage?nid=5738560076945486870&n_type=0&p_from=1&dtype=-1"]]];
}



@end
