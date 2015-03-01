//
//  UIBadgeView.m
//  UIBadgeView
//
//  Copyright (C) 2011 by Omer Duzyol
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "UIBadgeView.h"

@interface UIBadgeView()




@end


@implementation UIBadgeView

@synthesize  badgeString, parent, badgeColor, badgeColorHighlighted, shadowEnabled;
// from private
@synthesize font;


- (id) initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		self.font = [UIFont boldSystemFontOfSize: 12];
		
		self.backgroundColor = [UIColor clearColor];
	}
	
	return self;
}

- (void) setBadgeString:(NSString *)value{
    if (value != badgeString) {
        badgeString = value;
        [self sizeToFit];
        [self setNeedsDisplay];
    }
}

- (void) setBadgeColor:(UIColor *)value
{
    if (value != badgeColor) {
        badgeColor = value;
        [self setNeedsDisplay];
    }
}

- (void) setShadowEnabled:(BOOL)value{
	shadowEnabled = value;
	
	[self setNeedsDisplay];
}

- (void)sizeToFit
{
    [super sizeToFit];
    NSString *countString = badgeString;
	CGSize numberSize = [countString sizeWithFont: font];
    CGRect textRect = CGRectMake(0, 0, numberSize.width, numberSize.height);
    CGRect bounds = CGRectInset(textRect, -7, -3);
    CGRect rect = CGRectOffset(bounds, 6, 0);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, rect.size.width, rect.size.height);
}

- (void) drawRect:(CGRect)bounds
{
	NSString *countString = badgeString;
	
	CGSize numberSize = [countString sizeWithFont: font];

    CGRect textRect = CGRectMake((bounds.size.width - numberSize.width)/2.0f,(bounds.size.height - numberSize.height)/2.0f, numberSize.width, numberSize.height);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIColor *col;
	if (parent.highlighted || parent.selected) {
		if (self.badgeColorHighlighted) {
			col = self.badgeColorHighlighted;
		} else {
			col = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.000];
		}
	} else {
		if (self.badgeColor) {
			col = self.badgeColor;
		} else {
		
            col = [UIColor colorWithRed:(0xf6/255) green:(0x1f/255) blue:(0x29/255) alpha:1.0];
		}
	}
	
	if (shadowEnabled) {
		// draw shadow first
		CGContextSaveGState(context);
		CGContextClearRect(context, bounds);
        
		CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 2, [[UIColor grayColor] CGColor]);
        
		CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
        
		CGRect shadowRect = CGRectMake(bounds.origin.x + 2,
									   bounds.origin.y + 1,
									   bounds.size.width - 4,
									   bounds.size.height - 3);
        
		[self drawRoundedRect:shadowRect inContext:context withRadius:8];
        
		CGContextDrawPath(context, kCGPathFill);
        
		CGContextRestoreGState(context);
	}
	
	CGContextSaveGState(context);
	//CGContextClearRect(context, bounds);
	CGContextSetAllowsAntialiasing(context, true);
	CGContextSetLineWidth(context, 0.0);
	CGContextSetAlpha(context, 1.0);
	
    //	CGContextSetLineWidth(context, 2.0);
    //
    //
    //
    //	CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
	CGContextSetFillColorWithColor(context, [col CGColor]);
    
	// Draw background
	
	CGFloat backOffset = 2;
	CGRect backRect = CGRectMake(bounds.origin.x + backOffset,
								 bounds.origin.y + backOffset,
								 bounds.size.width - backOffset*2,
								 bounds.size.height - backOffset*2);
	
	[self drawRoundedRect:backRect inContext:context withRadius:8];
    
	CGContextDrawPath(context, kCGPathFillStroke);
	/*
     // Clip Context
     CGRect clipRect = CGRectMake(backRect.origin.x + backOffset-1,
     backRect.origin.y + backOffset-1,
     backRect.size.width - (backOffset-1)*2,
     backRect.size.height - (backOffset-1)*2);
     
     [self drawRoundedRect:clipRect inContext:context withRadius:8];
     CGContextClip (context);
     
     CGContextSetBlendMode(context, kCGBlendModeClear);*/
    
	CGContextRestoreGState(context);
    
	
	CGRect ovalRect = CGRectMake(2, 1, bounds.size.width-4,
								 bounds.size.height /2);
	
	bounds.origin.x = (bounds.size.width - numberSize.width) / 2 + 0.5;
	bounds.origin.y++;
	
	CGContextSetFillColorWithColor(context, [[UIColor whiteColor]  CGColor]);
	
	//[countString drawInRect:bounds withFont:self.font];
	[countString drawInRect:textRect withFont:self.font lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
	CGContextSaveGState(context);
    
	
	//Draw highlight
    //	CGGradientRef glossGradient;
	CGColorSpaceRef rgbColorspace;
    //	size_t num_locations = 9;
    //	CGFloat locations[9] = { 0.0, 0.10, 0.25, 0.40, 0.45, 0.50, 0.65, 0.75, 1.00 };
    //	CGFloat components[8] = { 1.0, 1.0, 1.0, 0.40, 1.0, 1.0, 1.0, 0.06 };
    //	CGFloat components[36] = {
    //		1.0, 1.0, 1.0, 1.00,
    //		1.0, 1.0, 1.0, 0.55,
    //		1.0, 1.0, 1.0, 0.20,
    //		1.0, 1.0, 1.0, 0.20,
    //		1.0, 1.0, 1.0, 0.15,
    //		1.0, 1.0, 1.0, 0.10,
    //		1.0, 1.0, 1.0, 0.10,
    //		1.0, 1.0, 1.0, 0.05,
    //		1.0, 1.0, 1.0, 0.05 };
	rgbColorspace = CGColorSpaceCreateDeviceRGB();
    //	glossGradient = CGGradientCreateWithColorComponents(rgbColorspace,
    //														components, locations, num_locations);
	
	
    //	CGPoint start = CGPointMake(bounds.origin.x, bounds.origin.y);
    //	CGPoint end = CGPointMake(bounds.origin.x, bounds.size.height*2);
	
	CGContextSetAlpha(context, 1.0);
    
	//[self drawRoundedRect:ovalRect inContext:context withRadius:4];
	
	CGContextBeginPath (context);
	
	CGFloat minx = CGRectGetMinX(ovalRect), midx = CGRectGetMidX(ovalRect),
	maxx = CGRectGetMaxX(ovalRect);
	
	CGFloat miny = CGRectGetMinY(ovalRect), midy = CGRectGetMidY(ovalRect),
	maxy = CGRectGetMaxY(ovalRect);
	
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, 8);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, 8);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, 4);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, 4);
	CGContextClosePath(context);
    
	CGContextClip (context);
	
    //	CGContextDrawLinearGradient(context, glossGradient, start, end, 0);
    //	CGContextDrawLinearGradient(context, glossGradient, start, end, 0);
	
    //	CGGradientRelease(glossGradient);
	CGColorSpaceRelease(rgbColorspace);
    
	CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
	
	
	CGContextRestoreGState(context);
	
    
}


- (void) drawRoundedRect:(CGRect) rrect inContext:(CGContextRef) context
			  withRadius:(CGFloat) radius
{
	CGContextBeginPath (context);
	
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect),
	maxx = CGRectGetMaxX(rrect);
	
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect),
	maxy = CGRectGetMaxY(rrect);
	
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
}

@end
