//
//  UIButton+Vertical.h
//  CouponCard
//
//  Created by sugar chen on 12-6-2.
//  Copyright (c) 2012年 NULL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIBadgeView;
//@interface VerticalButton:UIButton @end

@interface VerticalButton : UIControl
{
	UIColor * tilteColor;
	UIColor * selectTitleColor;
	NSString * title;
	UIImage * selectedImage;
	UIImage * normalImage;
	UIFont  * titleFont;
    UIColor * badgeStringColor;
}

@property(nonatomic,retain)UIImage  * normalImage;
@property(nonatomic,retain)UIImage  * selectedImage;
@property(nonatomic,retain)UIImage  * selectedBackgroudImage;
@property(nonatomic,retain)NSString * title;
@property(nonatomic,retain)UIColor * titleColor;
@property(nonatomic,retain)UIColor * selectTitleColor;
@property(nonatomic,retain)UIFont  * titleFont;
@property(nonatomic,retain)UIImage * badgeImage;
@property(nonatomic,assign)CGFloat  imageOffsetY; // 图片上间距
@property(nonatomic,assign)CGFloat  fontGap; // 字体上间距
@property(nonatomic,retain)NSString *badgeStr;
@property(nonatomic,retain)UIColor  *badgeStringColor;
- (void)setBadgeStringColor:(UIColor *)color;
@end