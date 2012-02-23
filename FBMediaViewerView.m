//
//  FBMediaViewerView.m
//  FBMediaViewer
//
//  Created by Hiroshi Hashiguchi on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FBMediaViewerView.h"

#define FB_MEDIA_VIEWER_VIEW_DEFAULT_SPACING_WIDTH	40
#define FB_MEDIA_VIEWER_VIEW_DEFAULT_SPACING_HEIGHT	0
#define FB_MEDIA_VIEWER_VIEW_DEFAULT_MARGIN_HEIGHT	50
#define FB_MEDIA_VIEWER_VIEW_DEFAULT_MARGIN_WIDTH_RATE	0.2


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
@end

@implementation FBMediaViewerView

// public
@synthesize currentIndex;
@synthesize dataSource;
@synthesize delegate;

// private
@synthesize baseScrollView;
@synthesize contentOffsetIndex;
@synthesize innerViews;
@synthesize spacing;
@synthesize animatingWithScrolling;
@synthesize previousFrameSize;


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
		innerView.url = nil;
		return;
	}
	
	innerView.url = [self.dataSource mediaViewerView:self itemAtIndex:index];	
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


- (void)_setupSubViews
{	
	// initialize vars
	self.spacing = CGSizeMake(
								  FB_MEDIA_VIEWER_VIEW_DEFAULT_SPACING_WIDTH, FB_MEDIA_VIEWER_VIEW_DEFAULT_SPACING_HEIGHT);

	self.baseScrollView.clipsToBounds = NO;

	// setup self view
	//-------------------------
	self.autoresizingMask =
        UIViewAutoresizingFlexibleLeftMargin  |
        UIViewAutoresizingFlexibleWidth       |
        UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleTopMargin   |
        UIViewAutoresizingFlexibleHeight      |
        UIViewAutoresizingFlexibleBottomMargin;
	self.clipsToBounds = YES;
	
	
	// setup base scroll view
	//-------------------------	
	self.baseScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
	
	self.baseScrollView.delegate = self;
	self.baseScrollView.pagingEnabled = YES;
	self.baseScrollView.showsHorizontalScrollIndicator = NO;
	self.baseScrollView.showsVerticalScrollIndicator = NO;
	self.baseScrollView.scrollsToTop = NO;
	self.baseScrollView.autoresizingMask =
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;
    self.baseScrollView.backgroundColor = [UIColor blackColor];
	[self _layoutBaseScrollView];
    
	[self addSubview:self.baseScrollView];

    
	// setup internal scroll views
	//------------------------------
	CGRect innerViewFrame = CGRectZero;
    //	innerViewFrame.size = [self baseFrame].size;
    
	self.innerViews = [NSMutableArray array];
    
	for (int i=0; i < FB_MEDIA_VIEWER_VIEW_NUMBER_OF_INNER_VIEW; i++) {
		
		FBMediaViewerInnerView* innerView =
            [[FBMediaViewerInnerView alloc] initWithFrame:innerViewFrame];
		innerView.clipsToBounds = YES;
		innerView.backgroundColor = self.backgroundColor;
		
		[self.baseScrollView addSubview:innerView];
		[self.innerViews addObject:innerView];
	}
	[self _layoutInnerViews];
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
        [self _setupSubViews];
    }
    return self;
}

- (void)dealloc
{
    // public
    self.dataSource = nil;
    self.delegate = nil;

    // private
    self.baseScrollView = nil;
    self.innerViews = nil;

}

- (void)layoutSubviews
{
	[self _layoutSubviewsWithSizeChecking:YES animated:NO];
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
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//	[self stopSlideShow];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGFloat position = scrollView.contentOffset.x / scrollView.bounds.size.width;
	CGFloat delta = position - (CGFloat)self.currentIndex;
	
	if (fabs(delta) >= 1.0f) {
//		FBMediaViewerInnerView* currentInnerlView =
//            [self.innerViews objectAtIndex:FB_MEDIA_VIEWER_VIEW_INDEX_OF_CURRENT_INNER_VIEW];
//		[self _resetZoomScrollView:currentInnerlView];
        
        if ([self.delegate respondsToSelector:@selector(mediaViwerView:willMoveFromIndex:)]) {
            [self.delegate mediaViewerView:self willMoveFromIndex:self.currentIndex];
        }
        
		if (delta > 0) {
			self.currentIndex++;
			self.contentOffsetIndex++;
            [self _scrollToRight];
			
		} else {
			self.currentIndex--;
            self.contentOffsetIndex--;
            [self _scrollToLeft];
		}
		
	}
	
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	self.animatingWithScrolling = NO;
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
}

- (void)setCurrentIndex:(NSInteger)index animated:(BOOL)animated
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
    
    if (index == self.currentIndex) {
		return;
	}
    
	self.currentIndex = index;
	self.contentOffsetIndex = index;
	
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
	[self _scrollToRight];
	[self _movePage:animated];
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
