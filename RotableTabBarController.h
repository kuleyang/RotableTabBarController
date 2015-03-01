//
//  RotableTabBarController.h
//  PrettyCard
//
//  Created by sugar chen on 12-5-10.
//  Copyright (c) 2012年 NULL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RotableTabBarController : UITabBarController
{
@public
    UIView                      *backgroundView;
	UIImageView					*selectionView;
    NSMutableArray              *buttonArray;
}

- (void)clean:(UIView*)aView backgroundColor:(UIColor*)color;
- (void)setButton:(UIControl *)btn atIndex:(NSInteger)index;
- (UIButton *)buttonAtIndex:(int) index;
- (void)addNewTipAtIndex:(NSInteger)index;
- (void)removeTipAtIdnex:(NSInteger)index;
- (void)setBadgeString:(NSString *)str atIndex:(int)index;
@property (nonatomic, retain) UIView * backgroundView;
@property (nonatomic, retain) UIImageView * selectionView;
@property (nonatomic, assign) float tarBarHeight;
@end
