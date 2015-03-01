//
//  RotableTabBarController.m
//  PrettyCard
//
//  Created by sugar chen on 12-5-10.
//  Copyright (c) 2012年 NULL. All rights reserved.
//

#import "RotableTabBarController.h"
#import "UIButton+Vertical.h"
#import <QuartzCore/QuartzCore.h>

#define TAB_BAR_HEI 50
#if 0
@interface UITabBar  (sugar)


@end
@implementation UITabBar (sugar)

//-(void)drawRect:(CGRect)rect
//{
//    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7 && ![UIApplication sharedApplication].statusBarHidden)
//    {
//        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - TAB_BAR_HEI - [UIApplication sharedApplication].statusBarFrame.size.height,[UIScreen mainScreen].applicationFrame.size.width, TAB_BAR_HEI);
//    }else
//    {
//        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - TAB_BAR_HEI,[UIScreen mainScreen].applicationFrame.size.width, TAB_BAR_HEI);
//    }
//    
//	UIView * superView = [self superview];
//	for (UIView * v in superView.subviews)
//	{
//		//MLOG(@"%@",v);
//		if ([[v description] hasPrefix:@"<UITransitionView"]) {
//			CGRect f = v.frame ;
//			f.size.height = self.frame.origin.y;
//			v.frame = f;
//		}
//	}
//    
//    for (UIView * view in self.subviews)
//    {
//        if([view isKindOfClass:NSClassFromString(@"UITabBarButton")])
//        {
//            [view removeFromSuperview];
//        }
//    }
//    self.backgroundImage = nil;
//    self.backgroundColor = [UIColor clearColor];
//}

@end
#endif
@implementation RotableTabBarController
@synthesize backgroundView;
@synthesize selectionView;

- (void)dealloc
{
    self.backgroundView = nil;
    self.selectionView  = nil;
}



- (void)clean:(UIView*)aView backgroundColor:(UIColor*)color
{
	aView.backgroundColor = color ;
	for(UIView * aview in [aView subviews])
    {
		aview.backgroundColor = color ;
		[self clean:aview backgroundColor:color];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    buttonArray = [[NSMutableArray alloc] initWithCapacity:4];
    
    selectionView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.tabBar.frame.size.height - 14, 0, 9)];
    
    selectionView.image  = nil;
    
    UIView* transitionView = (super.view.subviews)[0];
	[transitionView setClipsToBounds:YES];
    [self clean:transitionView.superview backgroundColor:[UIColor clearColor]];
    
}


- (void)setBackgroundView:(UIView *)bg
{
    if (self.backgroundView)
    {
        [backgroundView removeFromSuperview];
        backgroundView = nil;
    }
    
    [self.tabBar addSubview:bg];
	self.tabBar.clipsToBounds = NO;
    backgroundView = bg;
    [self.tabBar drawRect:CGRectZero];
    backgroundView.frame = CGRectInset(self.tabBar.bounds, 0, 0);
    
    
}



-(void)setViewControllers:(NSArray*)viewControllers animated:(BOOL)animated
{
    
	[super setViewControllers:viewControllers animated:animated];
    
    if ([viewControllers count] <= 0) return;
    
    
    
    if (selectionView != nil )
    {
        CGFloat width = self.tabBar.frame.size.width/[viewControllers count];
        CGRect f = selectionView.frame;
        f.size.width = width;
        f.origin.x = self.selectedIndex * width;
        selectionView.frame = f;
        
        [self.tabBar insertSubview:selectionView aboveSubview:backgroundView];
    }
    [self.tabBar drawRect:CGRectZero];
    
}


- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    
    int currentIndex = self.selectedIndex;
    
    
    [super setSelectedIndex:selectedIndex];
    
    if ([buttonArray count] > selectedIndex && [buttonArray count] > currentIndex)
    {
        UIButton * currentBtn = buttonArray[currentIndex];
        UIButton * selectBtn  = buttonArray[selectedIndex];
        selectBtn.userInteractionEnabled = NO;
        currentBtn.userInteractionEnabled = YES;
        
        currentBtn.selected = NO;
        selectBtn.selected = YES;
    }
    if ([self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)] && selectedIndex > 0 && selectedIndex < [buttonArray count])
    {
        [self.delegate tabBarController:self didSelectViewController:self.viewControllers[selectedIndex]];
    }
    
}

- (void)animateSelectionToItemAtIndex:(NSUInteger)itemIndex;
{
#define kTabSelectionAnimationDuration 0.3
	CGRect f = selectionView.frame;
	
	f.origin.x = self.selectedIndex * f.size.width;
	
	
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:(CGRectIsEmpty(selectionView.frame) ? 0. : kTabSelectionAnimationDuration)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    selectionView.frame = f;
    [UIView commitAnimations];
    
}

- (void)setButton:(UIButton *)btn atIndex:(NSInteger)index
{
    assert(btn!=nil);
    if ([buttonArray count] > index)
    {
        [buttonArray removeObjectAtIndex:index];
    }
    [buttonArray insertObject:btn atIndex:index];
    assert([self.viewControllers count]> 0);
    CGFloat  width = self.tabBar.frame.size.width/[self.viewControllers count];
    
    btn.frame = CGRectMake(index*width, 0, width, self.tabBar.frame.size.height);
    
	
    [self.tabBar addSubview:btn];
    btn.tag = index + 100;
    [btn addTarget:self action:@selector(ActionClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (UIButton *)buttonAtIndex:(int) index
{
    int tag = index + 100;
    return  (UIButton *)[self.tabBar viewWithTag:tag];
}

- (void)addNewTipAtIndex:(NSInteger)index
{
    assert(index < [buttonArray count]);
    VerticalButton * btn = buttonArray[index];
    btn.badgeImage = [UIImage imageNamed:@"new_notify"];
    [btn setNeedsDisplay];
}

- (void)removeTipAtIdnex:(NSInteger)index
{
    assert(index < [buttonArray count]);
    VerticalButton * btn = buttonArray[index];
    btn.badgeImage = nil;
    [btn setNeedsDisplay];
}

- (void)setBadgeString:(NSString *)str atIndex:(int)index
{
    assert(index < [buttonArray count]);
    VerticalButton * btn = buttonArray[index];
    btn.badgeStr = str;
    [btn setNeedsDisplay];
    
    if  ([self.delegate respondsToSelector:@selector(tabBar:didChangeBadgeText:)])
    {
        //[self.delegate tabBar:self didChangeBadgeText:str];
        [self.delegate performSelector:@selector(tabBar:didChangeBadgeText:) withObject:self withObject:str];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kNotif_MsgAtmCountUpdate" object:nil userInfo:[NSDictionary dictionaryWithObject:str?str:@"0" forKey:@"kNotif_MsgAtmCountUpdate_UserInfo"]];
    
}

- (void)ActionClick:(UIButton *)btn
{
    self.selectedIndex = btn.tag - 100;
}

@end
