//
// Copyright (c) 2012 Five-technology Co.,Ltd.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "FBMediaViewerRendererImageView.h"

@interface FBMediaViewerRendererImageView()
@property (nonatomic, strong) UIImageView* imageView;
@end

@implementation FBMediaViewerRendererImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		// setup scrollview
		self.delegate = self;
		self.minimumZoomScale = 1.0;
		self.maximumZoomScale = 5.0;
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;
		self.backgroundColor = [UIColor clearColor];
		self.clipsToBounds = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
		// setup imageview
		self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
		self.imageView.autoresizingMask =
            UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.backgroundColor = [UIColor clearColor];
		[self addSubview:self.imageView];
    }
    return self;
}


#pragma mark -
#pragma mark Privates
- (void)_setupContentMode
{
    CGRect rect = CGRectZero;
    rect.size = self.imageView.image.size;
    if (CGRectContainsRect(self.bounds, rect)) {
        self.imageView.contentMode = UIViewContentModeCenter;
    } else {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
}


#pragma mark -
#pragma mark FBMediaViewerRenderer

- (void)renderContentOfURL:(NSURL*)url
{
    self.imageView.image = [UIImage imageWithContentsOfFile:url.path];
    [self _setupContentMode];
}

- (void)clear
{
    self.imageView.image = nil;
}

- (void)reset
{
    [self setZoomScale:1.0 animated:NO];
}


#pragma mark -
#pragma mark Events

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch* touch = [touches anyObject];
	if ([touch tapCount] == 2) {
        if (self.zoomScale == 1.0) {
            [self setZoomScale:2.0 animated:YES];
        } else {
            [self setZoomScale:1.0 animated:YES];
        }
    }
}


#pragma mark -
#pragma mark UIScrollViewDelegate
-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


@end
