//
//  UIButton+Vertical.m
//  CouponCard
//
//  Created by sugar chen on 12-6-2.
//  Copyright (c) 2012年 NULL. All rights reserved.
//

#import "UIButton+Vertical.h"
#import "UIBadgeView.h"

@implementation VerticalButton
@synthesize normalImage,selectedImage,selectedBackgroudImage,title,titleColor,selectTitleColor,titleFont,imageOffsetY;
@synthesize badgeImage;
@synthesize fontGap;
@synthesize badgeStr;
@synthesize badgeStringColor;
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:a]
- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		self.backgroundColor = [UIColor clearColor];
		self.titleFont = [UIFont systemFontOfSize:12];
		self.selectTitleColor = RGBACOLOR(26,	149,	230,	1);//[UIColor whiteColor];
        self.titleColor = RGBACOLOR(153,	153,	153,    1);
        self.badgeStringColor = [UIColor blackColor];
	}
	return self;
}

- (void)setBadgeStringColor:(UIColor *)color
{
    UIBadgeView * badgeView = (UIBadgeView *)[self viewWithTag:'b'];
    [badgeView setBadgeColor:color];
    if (badgeStringColor!=color)
    {
        badgeStringColor = color;
    }
}

- (void)setSelectTitleColor:(UIColor *)color
{
    if (selectTitleColor!=color) {
        selectTitleColor = color;
        [self setNeedsDisplay];
    }
}

- (void)setTitleColor:(UIColor *)color
{
    if (titleColor!=color) {
        titleColor = color;
        [self setNeedsDisplay];
    }
}

- (void)setBadgeStr:(NSString *)str
{
    UIBadgeView * badgeView = (UIBadgeView *)[self viewWithTag:'b'];
    if ([str length] > 0)
    {
        if (!badgeView)
        {
            badgeView = [[UIBadgeView alloc] initWithFrame:CGRectMake(self.center.x+5, 0, 40, 16)];
            badgeView.tag = 'b';
            badgeView.badgeColor = self.badgeStringColor;
            [self addSubview:badgeView];
        }
        badgeView.badgeString = str;
    }else{
        
        if (badgeView)
        {
            [badgeView removeFromSuperview];
        }
    }
}

- (void)drawRect:(CGRect)rect
{
	if (self.selected)
	{
        if (self.selectedBackgroudImage) {
            CGRect bgImageRect = CGRectMake((self.bounds.size.width-self.selectedBackgroudImage.size.width)/2, 0, self.selectedBackgroudImage.size.width, self.selectedBackgroudImage.size.height);
            [self.selectedBackgroudImage drawInRect:bgImageRect];
        }

        
		CGRect imageRect = CGRectMake((self.bounds.size.width - selectedImage.size.width)/2,
                                      (self.bounds.size.height - selectedImage.size.height)/2 - self.imageOffsetY,
                                      selectedImage.size.width ,selectedImage.size.height);
        
		CGRect titleRect = CGRectMake(0, imageRect.origin.y+imageRect.size.height+self.fontGap, rect.size.width, self.titleFont.lineHeight);
        
		[selectedImage drawInRect:imageRect];

		[selectTitleColor set];
		[title drawInRect:titleRect withFont:self.titleFont lineBreakMode:UILineBreakModeClip
                alignment:UITextAlignmentCenter];
	}else {
		CGRect imageRect = CGRectMake((self.bounds.size.width - normalImage.size.width)/2,
									  (self.bounds.size.height - normalImage.size.height)/2 - self.imageOffsetY,
									  normalImage.size.width ,normalImage.size.height);
		CGRect titleRect = CGRectMake(0, imageRect.origin.y+imageRect.size.height+self.fontGap, rect.size.width, self.titleFont.lineHeight);

		[normalImage drawInRect:imageRect];
		[titleColor set];
        [title drawInRect:titleRect withFont:self.titleFont lineBreakMode:UILineBreakModeClip
                alignment:UITextAlignmentCenter];
	}
    if (self.badgeImage)
    {
        CGSize sz = self.badgeImage.size;
        [badgeImage drawInRect:CGRectMake(rect.size.width - sz.width - 5, 5, sz.width, sz.height)];
    }
}

- (void)setSelected:(BOOL)selected
{
	[super setSelected:selected];
	[self setNeedsDisplay];
}


@end

