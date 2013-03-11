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
#import <QuartzCore/QuartzCore.h>

#import "FBMediaViewerView.h"
#import "FBMediaViewerInnerView.h"
#import "FBMediaViewerItemLoader.h"

#define FB_MEDIA_VIEWER_VIEW_DEFAULT_SPACING_WIDTH	40
#define FB_MEDIA_VIEWER_VIEW_DEFAULT_SPACING_HEIGHT	0
#define FB_MEDIA_VIEWER_VIEW_DEFAULT_MARGIN_HEIGHT	50
#define FB_MEDIA_VIEWER_VIEW_DEFAULT_MARGIN_WIDTH_RATE	0.2

#define FB_MEDIA_VIEWER_VIEW_DEFAULT_TRANSITION_DURATION	0.75

#define FB_MEDIA_VIEWER_VIEW_NUMBER_OF_INNER_VIEW 3
#define FB_MEDIA_VIEWER_VIEW_LENGTH_FROM_CENTER ((FB_MEDIA_VIEWER_VIEW_NUMBER_OF_INNER_VIEW-1)/2)
#define FB_MEDIA_VIEWER_VIEW_INDEX_OF_CURRENT_INNER_VIEW ((FB_MEDIA_VIEWER_VIEW_NUMBER_OF_INNER_VIEW-1)/2)


#pragma Properties (Private)
@interface FBMediaViewerView()
@property (nonatomic, strong) UIScrollView* baseScrollView;
@property (nonatomic, assign) NSInteger contentOffsetIndex;
@property (nonatomic, strong) NSMutableArray* innerViews;
@property (nonatomic, assign) CGSize spacing;
@property (nonatomic, assign) BOOL animatingWithScrolling;
@property (nonatomic, assign) CGSize previousFrameSize;
@property (nonatomic, strong) UIPageControl* pageControl;
@property (nonatomic, strong) FBMediaViewerInnerView* transitionInnerView;

@end

@implementation FBMediaViewerView

#pragma mark -
#pragma mark Privates
- (NSInteger)_numberOfItems
{
	NSInteger numberOfItems = [self.dataSource numberOfItemsInMediaViewerView:self];
	if (numberOfItems < 0) {
		numberOfItems = 0;
	}
	return numberOfItems;
}


- (void)_setItemAtIndex:(NSInteger)index toInnerView:(FBMediaViewerInnerView*)innerView
{
	if (index < 0 || [self _numberOfItems] <= index) {
		innerView.mediaViewerItem = nil;
		return;
	}
	
	innerView.mediaViewerItem = [self.dataSource mediaViewerView:self itemAtIndex:index];
}


- (CGSize)_unitSize
{
	CGSize size = self.bounds.size;
    size.width += self.spacing.width;
	return size;
}	

- (void)_layoutBaseScrollView
{
	CGRect scrollViewFrame = self.bounds;
	scrollViewFrame.origin.x -= self.spacing.width/2.0;
	scrollViewFrame.size.width += self.spacing.width;
	self.baseScrollView.frame =scrollViewFrame;	
}


- (void)_layoutInnerViews
{
	CGRect innerViewFrame = CGRectZero;
	innerViewFrame.size = self.bounds.size;
	innerViewFrame.origin.x = (self.contentOffsetIndex-FB_MEDIA_VIEWER_VIEW_LENGTH_FROM_CENTER) * innerViewFrame.size.width;
    
	for (int index=0; index < FB_MEDIA_VIEWER_VIEW_NUMBER_OF_INNER_VIEW; index++) {
		
		FBMediaViewerInnerView* innerView = [self.innerViews objectAtIndex:index];
        
		innerViewFrame.origin.x += self.spacing.width/2.0;	// left space
		innerView.frame = innerViewFrame;
		innerViewFrame.origin.x += innerViewFrame.size.width; // next
		innerViewFrame.origin.x += self.spacing.width/2.0;	// right space
	}
	
}

- (void)_layoutViewsAnimated:(BOOL)animated
{
	if (animated) {
		[UIView beginAnimations:nil context:nil];
	}
	[self _layoutBaseScrollView];
	[self _layoutInnerViews];

	if (animated) {
		[UIView commitAnimations];
	}
}

- (FBMediaViewerInnerView*)_innerViewWithFrame:(CGRect)innerViewFrame
{
    FBMediaViewerInnerView* innerView =
    [[FBMediaViewerInnerView alloc] initWithMediaViewerView:self
                                                      frame:innerViewFrame];
    innerView.clipsToBounds = YES;
    innerView.backgroundColor = self.backgroundColor;
    
    return innerView;
}


- (void)_setupSubViews
{	
	// initialize vars
	self.spacing = CGSizeMake(
								  FB_MEDIA_VIEWER_VIEW_DEFAULT_SPACING_WIDTH, FB_MEDIA_VIEWER_VIEW_DEFAULT_SPACING_HEIGHT);

	self.baseScrollView.clipsToBounds = NO;

	// setup self view
	//-------------------------
//	self.autoresizingMask =
//        UIViewAutoresizingFlexibleLeftMargin  |
//        UIViewAutoresizingFlexibleWidth       |
//        UIViewAutoresizingFlexibleRightMargin |
//        UIViewAutoresizingFlexibleTopMargin   |
//        UIViewAutoresizingFlexibleHeight      |
//        UIViewAutoresizingFlexibleBottomMargin;
	self.clipsToBounds = YES;
	
	
	// setup base scroll view
	//-------------------------	
	self.baseScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
	
//	self.baseScrollView.delegate = self; ==> move other place
	self.baseScrollView.pagingEnabled = YES;
	self.baseScrollView.showsHorizontalScrollIndicator = NO;
	self.baseScrollView.showsVerticalScrollIndicator = NO;
	self.baseScrollView.scrollsToTop = NO;
	self.baseScrollView.autoresizingMask =
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;
    self.baseScrollView.backgroundColor = self.backgroundColor;
	[self _layoutBaseScrollView];
    
	[self addSubview:self.baseScrollView];

    
	// setup internal scroll views
	//------------------------------
	CGRect innerViewFrame = CGRectZero;
    //	innerViewFrame.size = [self baseFrame].size;
    
	self.innerViews = [NSMutableArray array];
    
	for (int i=0; i < FB_MEDIA_VIEWER_VIEW_NUMBER_OF_INNER_VIEW; i++) {
		
		FBMediaViewerInnerView* innerView = [self _innerViewWithFrame:innerViewFrame];
		[self.baseScrollView addSubview:innerView];
		[self.innerViews addObject:innerView];
	}
	[self _layoutInnerViews];
    
    
    // setup temporary view for slideshow transition
	self.transitionInnerView = [self _innerViewWithFrame:innerViewFrame];
	self.transitionInnerView.hidden = YES;
	[self.baseScrollView addSubview:self.transitionInnerView];
    
    
    // setup page control
	self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
	self.pageControl.autoresizingMask =
        UIViewAutoresizingFlexibleLeftMargin  |
        UIViewAutoresizingFlexibleWidth       |
        UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleTopMargin   |
        UIViewAutoresizingFlexibleHeight      |
        UIViewAutoresizingFlexibleBottomMargin;
	self.pageControl.hidesForSinglePage = NO;
	[self.pageControl addTarget:self
						 action:@selector(_pageControlDidChange:)
			   forControlEvents:UIControlEventValueChanged];
	[self addSubview:self.pageControl];
    
    // re-layout
    self.pageControlPosition = FBMediaViewerViewPageControllerPositionTop;
}


- (void)_layoutSubviewsWithSizeChecking:(BOOL)checking animated:(BOOL)animated
{
	CGSize newSize = self.bounds.size;
	CGSize oldSize = self.previousFrameSize;

	if (checking && CGSizeEqualToSize(newSize, oldSize)) {
		return;
	}
    
	self.previousFrameSize = newSize;
	CGSize newSizeWithSpace = newSize;
	newSizeWithSpace.width += self.spacing.width;
	
	// set new origin and size to innerViews
	CGFloat x = (self.contentOffsetIndex-FB_MEDIA_VIEWER_VIEW_LENGTH_FROM_CENTER) * newSizeWithSpace.width;
	for (FBMediaViewerInnerView* innerView in self.innerViews) {
		x += self.spacing.width/2.0;	// left space
		
		innerView.frame = CGRectMake(x, 0, newSize.width, newSize.height);
		x += newSize.width;
		x += self.spacing.width/2.0;	// right space
	}
	
	
	// adjust content size and offset of base scrollView
	//--
	self.baseScrollView.contentSize = CGSizeMake(
                                             [self _numberOfItems]*newSizeWithSpace.width,
                                             newSize.height);
	[self.baseScrollView setContentOffset:CGPointMake(
                                                  self.contentOffsetIndex*newSizeWithSpace.width, 0)
							 animated:animated];

    [self._currentInnerView willAppear];
}

- (FBMediaViewerInnerView*)_currentInnerView
{
    return [self.innerViews objectAtIndex:FB_MEDIA_VIEWER_VIEW_INDEX_OF_CURRENT_INNER_VIEW];
}


-(void)_pageControlDidChange:(id)sender
{
    [self moveToIndex:self.pageControl.currentPage animated:YES];
}


#pragma mark -
#pragma mark Basics

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self _setupSubViews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor blackColor];
        [self _setupSubViews];
    }
    return self;
}

- (void)dealloc
{
    // cleanup
    [self.itemLoader cancelAllItems];

    // public
    self.dataSource = nil;
    self.delegate = nil;
    self.itemLoader = nil;

    // private
    self.baseScrollView = nil;
    self.innerViews = nil;

}

- (void)layoutSubviews
{
	[self _layoutSubviewsWithSizeChecking:YES animated:NO];
    if (self.baseScrollView.delegate == nil) {
        self.baseScrollView.delegate = self;
    }
}

#pragma mark -
#pragma mark Privates (Control Scroll)

-(void)_scrollToLeft
{
	FBMediaViewerInnerView* rightView =
        [self.innerViews objectAtIndex:FB_MEDIA_VIEWER_VIEW_NUMBER_OF_INNER_VIEW-1];
	FBMediaViewerInnerView* leftView = [self.innerViews objectAtIndex:0];
    
	CGRect frame = leftView.frame;
	frame.origin.x -= frame.size.width + self.spacing.width;
	rightView.frame = frame;
    
	[self.innerViews removeObjectAtIndex:FB_MEDIA_VIEWER_VIEW_NUMBER_OF_INNER_VIEW-1];
	[self.innerViews insertObject:rightView atIndex:0];
	[self _setItemAtIndex:self.currentIndex-FB_MEDIA_VIEWER_VIEW_LENGTH_FROM_CENTER
              toInnerView:rightView];
    
}

-(void)_scrollToRight
{
	FBMediaViewerInnerView* rightView =
        [self.innerViews objectAtIndex:FB_MEDIA_VIEWER_VIEW_NUMBER_OF_INNER_VIEW-1];
	FBMediaViewerInnerView* leftView = [self.innerViews objectAtIndex:0];
	
	CGRect frame = rightView.frame;
	frame.origin.x += frame.size.width + self.spacing.width;
	leftView.frame = frame;
	
	[self.innerViews removeObjectAtIndex:0];
	[self.innerViews addObject:leftView];
	[self _setItemAtIndex:self.currentIndex+FB_MEDIA_VIEWER_VIEW_LENGTH_FROM_CENTER
              toInnerView:leftView];
    
}


- (void)_movePage:(BOOL)animated
{
	self.animatingWithScrolling = YES;
	[self.baseScrollView setContentOffset:CGPointMake(
                                                      self.contentOffsetIndex*[self _unitSize].width, 0)
							 animated:animated];
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!scrollView.dragging) {
        return;
    }
    
	CGFloat position = scrollView.contentOffset.x / scrollView.bounds.size.width;
	CGFloat delta = position - (CGFloat)self.currentIndex;
	
	if (fabs(delta) >= 1.0f) {

        if ([self.delegate respondsToSelector:@selector(mediaViewerView:willMoveFromIndex:)]) {
            [self.delegate mediaViewerView:self willMoveFromIndex:self.currentIndex];
        }

		if (delta > 0) {
            if (self.currentIndex < self._numberOfItems-1) {
                [self._currentInnerView willDisAppear];
                self.currentIndex++;
                self.contentOffsetIndex++;
                [self _scrollToRight];
                [self._currentInnerView willAppear];
                self.pageControl.currentPage = self.currentIndex;
            }
		} else {
            if (self.currentIndex >= 1) {
                [self._currentInnerView willDisAppear];
                self.currentIndex--;
                self.contentOffsetIndex--;
                [self _scrollToLeft];
                [self._currentInnerView willAppear];
                self.pageControl.currentPage = self.currentIndex;
            }
		}
	}
	
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	self.animatingWithScrolling = NO;
}


#pragma mark -
#pragma mark Properties
- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    if ([self.delegate respondsToSelector:@selector(mediaViewerView:didMoveToIndex:)]) {
        [self.delegate mediaViewerView:self didMoveToIndex:currentIndex];
    }
}

- (void)_setPageControlHidden:(BOOL)hidden
{
    CGFloat alpha = hidden ? 0.0 : 1.0;
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.pageControl.alpha = alpha;
                     }];
}

- (void)_refreshPageControlPostion
{
    CGFloat y;
    switch (_pageControlPosition) {
        case FBMediaViewerViewPageControllerPositionTop:
            y = 0;
            break;
            
        case FBMediaViewerViewPageControllerPositionBottom:
        default:
            y = self.bounds.size.height-FB_MEDIA_VIEWER_VIEW_DEFAULT_MARGIN_HEIGHT;
            break;
    }
	self.pageControl.frame = CGRectMake(0, y + self.pageControlOffset, self.bounds.size.width, FB_MEDIA_VIEWER_VIEW_DEFAULT_MARGIN_HEIGHT);
}

- (void)setPageControlPosition:(FBMediaViewerViewPageControllerPosition)pageControlPosition
{
    _pageControlPosition = pageControlPosition;
    [self _refreshPageControlPostion];
}

- (void)setPageControlOffset:(CGFloat)pageControlOffset
{
    _pageControlOffset = pageControlOffset;
    [self _refreshPageControlPostion];
}
- (void)setPageControlHidden:(BOOL)hidden
{
	_pageControlHidden = hidden;
    if ([self _numberOfItems] <= 1) {
        [self _setPageControlHidden:YES];
    } else {
        [self _setPageControlHidden:hidden];
    }
}


#pragma mark -
#pragma mark API
- (void)reloadData
{
	NSInteger numberOfItems = [self _numberOfItems];
	if (self.currentIndex >= numberOfItems) {
		if (numberOfItems == 0) {
			self.currentIndex = 0;
		} else {
			self.currentIndex = numberOfItems-1;
		}
	}
	
	for (int index=0; index < FB_MEDIA_VIEWER_VIEW_NUMBER_OF_INNER_VIEW; index++) {
		[self _setItemAtIndex:self.currentIndex + index - FB_MEDIA_VIEWER_VIEW_LENGTH_FROM_CENTER
                  toInnerView:[self.innerViews objectAtIndex:index]];
	}
    
    self.pageControl.numberOfPages = numberOfItems;
	self.pageControl.currentPage = self.currentIndex;
    
    if (numberOfItems <= 1) {
        [self _setPageControlHidden:YES];
    } else {
        [self _setPageControlHidden:self.pageControlHidden];
    }
}

- (void)reloadCurrentItemWithMode:(FBMeditViewerItemLoaderMode)mode
{
    [[self _currentInnerView] loadWithMode:mode];
}

- (void)moveToIndex:(NSInteger)index animated:(BOOL)animated
{
	NSInteger numberOfItems = [self _numberOfItems];
    
    if (numberOfItems == 0) {
        return;
    }
    
	if (index < 0) {
		index = 0;
	} else if (index >= numberOfItems) {
		index = numberOfItems - 1;
	}
    
	self.currentIndex = index;
	self.contentOffsetIndex = index;
    self.pageControl.currentPage = index;

	for (int i=0; i < FB_MEDIA_VIEWER_VIEW_NUMBER_OF_INNER_VIEW; i++) {
        [self _setItemAtIndex:self.currentIndex + i - FB_MEDIA_VIEWER_VIEW_LENGTH_FROM_CENTER
                  toInnerView:[self.innerViews objectAtIndex:i]];
	}
    
	[self _layoutViewsAnimated:NO];
	[self _layoutSubviewsWithSizeChecking:NO animated:animated];
}

- (void)moveToPreviousItemAnimated:(BOOL)animated
{
	if (self.animatingWithScrolling || self.currentIndex <= 0) {
		// do nothing
		return;
	}
	
	self.currentIndex--;
	self.contentOffsetIndex--;
	self.pageControl.currentPage--;
	[self _scrollToLeft];
	[self _movePage:animated];
}

- (void)moveToNextItemAnimated:(BOOL)animated
{
	if (self.animatingWithScrolling || self.currentIndex >= [self _numberOfItems]-1) {
		// do nothing
		return;
	}
    
	self.currentIndex++;
	self.contentOffsetIndex++;
	self.pageControl.currentPage++;
	[self _scrollToRight];
	[self _movePage:animated];
}

- (void)moveToLastItemAnimated:(BOOL)animated
{
    [self moveToIndex:9999999 animated:animated];
}


- (id <FBMediaViewerItem>)currentItem
{
    return self._currentInnerView.mediaViewerItem;
}


- (void)removeCurrentIndexAimated:(BOOL)animated
{
	NSInteger numberOfItems = [self _numberOfItems];
    
	NSInteger transitionIndex = self.currentIndex;
	if (numberOfItems == 0) {
		transitionIndex = -1;
	} else if (numberOfItems == self.currentIndex) {
		transitionIndex--;
	} else {
	}
	
	// [1] setup transitionView
    [self _setItemAtIndex:transitionIndex
              toInnerView:self.transitionInnerView];
	
	FBMediaViewerInnerView* currentInnerScrollView =
        [self.innerViews objectAtIndex:FB_MEDIA_VIEWER_VIEW_INDEX_OF_CURRENT_INNER_VIEW];
	
	self.transitionInnerView.frame = currentInnerScrollView.frame;
	
	// [2] do transition
    if (animated) {
        CATransition* transition = [CATransition animation];
        transition.duration = FB_MEDIA_VIEWER_VIEW_DEFAULT_TRANSITION_DURATION;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        //		transition.delegate = self;
        
        [self.baseScrollView.layer addAnimation:transition forKey:nil];
    }
    
    currentInnerScrollView.hidden = YES;
    self.transitionInnerView.hidden = NO;
    
    [self.innerViews replaceObjectAtIndex:FB_MEDIA_VIEWER_VIEW_INDEX_OF_CURRENT_INNER_VIEW
                                     withObject:self.transitionInnerView];
    self.transitionInnerView = currentInnerScrollView;
	
	// [3] re-layout subviews
	[self _layoutSubviewsWithSizeChecking:NO animated:NO];
    
    // [4] notify
    if (numberOfItems &&
        [self.delegate respondsToSelector:@selector(mediaViewerView:didMoveToIndex:)]) {
        [self.delegate mediaViewerView:self didMoveToIndex:self.currentIndex];
    }

}


#pragma mark -
#pragma mark API (IBActions)

- (IBAction)moveToPreviousItem:(id)sender
{
    [self moveToPreviousItemAnimated:YES];
}
- (IBAction)moveToNextItem:(id)sender
{
    [self moveToNextItemAnimated:YES];
}


@end
