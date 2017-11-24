//
//  GTagCollectionViewLayout.m
//  GBigbangExample
//
//  Created by GIKI on 2017/11/23.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GTagCollectionViewLayout.h"
#import "GTagFlowLayout.h"

@interface UICollectionViewLayoutAttributes (GTagFlow)

- (void)leftAlignFrameWithSectionInset:(UIEdgeInsets)sectionInset;

@end

@implementation UICollectionViewLayoutAttributes (GTagFlow)

- (void)leftAlignFrameWithSectionInset:(UIEdgeInsets)sectionInset {
    CGRect frame = self.frame;
    frame.origin.x = sectionInset.left;
    self.frame = frame;
}

@end

@protocol UICollectionViewDelegateLeftAlignedLayout <UICollectionViewDelegateFlowLayout>

@end

@interface GTagCollectionViewLayout()
@property (nonatomic, strong)NSMutableArray<UICollectionViewLayoutAttributes*> *arrayItemAtts;   //!<
@property (nonatomic, assign)CGSize contentSizeNeed;   //!<

@property (nonatomic, assign)CGRect boundsPrevious;   //!<前一次的bounds
@end

@implementation GTagCollectionViewLayout
- (void)prepareLayout
{
    [super prepareLayout];
    self.delegate = (id)self.collectionView.delegate;
    NSInteger numOfItems = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
    UIEdgeInsets insetsOfCollectionViewSection = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:0];
    CGFloat minimumLineSpacingForSection = [self.delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:0];
    CGFloat minimumInteritemSpacingForSection = [self.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:0];
    
    CGFloat widthMaxOfLine = [self.delegate maxWidthOfLine_BookBangCollectionViewLayout];
    NSInteger lineCurrent = 0; //当前行
    NSInteger rowCurrent = 0; //当前列
    CGFloat widthCurrent = 0.0; //当前行的宽度
    CGFloat xCurrent = 0.0;  //当前x坐标
    CGFloat yCurrent = 0.0;  //当前y坐标
    
    self.arrayItemAtts = [NSMutableArray arrayWithCapacity:numOfItems];
    for (NSInteger i = 0; i < numOfItems; i++)
    {
        NSIndexPath *indexPathCurrent = [NSIndexPath indexPathForItem:i inSection:0];
        CGSize sizeOfItemCurrent = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPathCurrent];
        if (rowCurrent == 0)
        {
            //此时无论当前的cell 多宽都放进去
            xCurrent = insetsOfCollectionViewSection.left;
            yCurrent = insetsOfCollectionViewSection.top + sizeOfItemCurrent.height*lineCurrent + lineCurrent*minimumLineSpacingForSection;
            UICollectionViewLayoutAttributes *itemLayout = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPathCurrent];
            if (
                sizeOfItemCurrent.width > widthMaxOfLine||
                sizeOfItemCurrent.width+xCurrent > widthMaxOfLine||
                sizeOfItemCurrent.width+xCurrent + minimumInteritemSpacingForSection > widthMaxOfLine||
                sizeOfItemCurrent.width+xCurrent + insetsOfCollectionViewSection.right > widthMaxOfLine
                )
            {
                itemLayout.frame = CGRectMake(xCurrent, yCurrent, widthMaxOfLine - insetsOfCollectionViewSection.left - insetsOfCollectionViewSection.right, sizeOfItemCurrent.height);
            }
            else
            {
                itemLayout.frame = CGRectMake(xCurrent, yCurrent, sizeOfItemCurrent.width, sizeOfItemCurrent.height);
                
            }
            widthCurrent = xCurrent + itemLayout.frame.size.width;
            itemLayout.size = itemLayout.frame.size;
            [self.arrayItemAtts addObject:itemLayout];
        }
        else
        {
            xCurrent = widthCurrent + minimumInteritemSpacingForSection;
            yCurrent = insetsOfCollectionViewSection.top + sizeOfItemCurrent.height*lineCurrent + lineCurrent*minimumLineSpacingForSection;
            UICollectionViewLayoutAttributes *itemLayout = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPathCurrent];
            itemLayout.frame = CGRectMake(xCurrent, yCurrent, sizeOfItemCurrent.width, sizeOfItemCurrent.height);
            itemLayout.size = sizeOfItemCurrent;
            [self.arrayItemAtts addObject:itemLayout];
            widthCurrent = xCurrent + sizeOfItemCurrent.width;
        }
        //立即对下一个cell是否能在第一行进行判断
        if (i + 1 < numOfItems)
        {
            NSIndexPath *indexPathNext = [NSIndexPath indexPathForItem:i+1 inSection:0];
            CGSize sizeOfItemNext = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPathNext];
            if (
                widthCurrent + minimumInteritemSpacingForSection > widthMaxOfLine ||
                widthCurrent + minimumInteritemSpacingForSection + sizeOfItemNext.width> widthMaxOfLine ||
                widthCurrent + minimumInteritemSpacingForSection + sizeOfItemNext.width + insetsOfCollectionViewSection.right> widthMaxOfLine ||
                widthCurrent + insetsOfCollectionViewSection.right>widthMaxOfLine
                )
            {
                //--此时折行
                rowCurrent = 0;
                lineCurrent ++;
                widthCurrent = 0.0;
            }
            else
            {
                rowCurrent ++;
            }
        }
        else
        {
            //--此时已经是最后一个,最后一个完成布局了,就不需要在判断是否需要折行了
        }
        if (i == numOfItems - 1)
        {
            CGFloat heightTotal = yCurrent + sizeOfItemCurrent.height + insetsOfCollectionViewSection.bottom;
            self.contentSizeNeed = CGSizeMake(0, heightTotal);
        }
        
    }

}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return  self.arrayItemAtts;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    if (CGRectEqualToRect(self.boundsPrevious, newBounds))
    {
        self.boundsPrevious = newBounds;
        return NO;
    }
    self.boundsPrevious = newBounds;
    return YES;
}

- (CGSize)collectionViewContentSize
{
    return self.contentSizeNeed;
}

@end
