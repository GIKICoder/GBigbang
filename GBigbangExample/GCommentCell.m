//
//  GCommentCell.m
//  GBigbangExample
//
//  Created by GIKI on 2017/10/23.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GCommentCell.h"
#import "GBigbangBox.h"
#import "GTagFlowContainer.h"
typedef void(^GLabelBigBang) (NSString *text);
@interface GLabel : UILabel
@property (nonatomic, copy) GLabelBigBang bigbangBlock;
@end

@implementation GLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        [self addGestureRecognizer:longPress];
    }
    return self;
}

- (void)longPressAction:(UIGestureRecognizer *)recognizer {
    [self becomeFirstResponder];
    self.backgroundColor = [UIColor lightGrayColor];
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"bigBang" action:@selector(bigbang:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyItem, nil]];
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

// 使label能够成为响应事件
- (BOOL)canBecomeFirstResponder {
    return YES;
}
// 控制响应的方法
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return action == @selector(bigbang:);
}
- (void)bigbang:(id)sender {
    self.backgroundColor = [UIColor clearColor];
    if (self.bigbangBlock) {
        self.bigbangBlock(self.text);
    }
}

- (void)dealloc
{
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}
@end


@interface GCommentCell()
@property (nonatomic, strong) UIImageView * avatar;
@property (nonatomic, strong) GLabel * commentLabel;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) GTagFlowContainer * container;
@end

@implementation GCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:({
            _avatar = [UIImageView new];
            _avatar.image = [UIImage imageNamed:@"avatar.png"];
            _avatar;
        })];
        [self.contentView addSubview:({
            _nameLabel = [UILabel new];
            _nameLabel.font = [UIFont systemFontOfSize:16];
            _nameLabel.textColor = [UIColor blueColor];
            _nameLabel.text = @"GIKI";
            _nameLabel;
        })];
        [self.contentView addSubview:({
            _commentLabel = [GLabel new];
            _commentLabel.font = [UIFont systemFontOfSize:14];
            _commentLabel.textColor = [UIColor grayColor];
            _commentLabel.numberOfLines = 0;
            _commentLabel.text = @"隆多表示这么多年都过来了.新秀允许犯错误,曝光率肯定高.威少在第四节暴走，三分、中投和突破应有尽有，最后时刻他传球给安东尼命中三分，反超比分，但最终还是被威金斯反绝杀，雷霆遭到两连败。";
            __weak typeof(self) weakSelf = self;
            _commentLabel.bigbangBlock = ^(NSString *text) {
                [weakSelf bigbang:text];
            };
            _commentLabel;
        })];
        [self.contentView addSubview:({
            _timeLabel = [UILabel new];
            _timeLabel.font = [UIFont systemFontOfSize:12];
            _timeLabel.textColor = [UIColor blueColor];
            _timeLabel.text = @"2小时前";
            _timeLabel;
        })];
        GTagFlowContainer *container = [GTagFlowContainer new];
        self.container = container;
        [self.container.flowView configTagCollectionViewLayout];
        self.container.actionBtnItems = @[@"复制",@"举报",@"错别字"];
//        __weak typeof(self) weakSelf = self;
        self.container.actionBlock = ^(NSString *actionTitle, NSString *newText) {
            NSLog(@"点击了 -- %@, 选择的文字 -- %@",actionTitle,newText);
        };
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _avatar.frame = CGRectMake(12, 12 , 34, 34);
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_avatar.frame)+12, CGRectGetMinY(_avatar.frame), self.frame.size.width, 22);
    _commentLabel.frame = CGRectMake(_nameLabel.frame.origin.x, CGRectGetMaxY(_nameLabel.frame)+5, self.frame.size.width-24-CGRectGetMaxX(_avatar.frame), 75);
    _timeLabel.frame =CGRectMake(_nameLabel.frame.origin.x, CGRectGetMaxY(_commentLabel.frame)+5, _commentLabel.frame.size.width, 20);
}

- (void)bigbang:(NSString*)text
{
    NSArray *items = [GBigbangBox bigBang:text];
    
    NSArray * layouts = [GTagFlowItem factoryFolwLayoutWithItems:items withAppearance:nil];
    [self.container configDatas:layouts];
    [self.container show];
}
@end
