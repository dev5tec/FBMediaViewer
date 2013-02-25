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

#import "FBMediaViewerInnerView.h"
#import "FBMediaViewerView.h"
#import "FBMediaViewerItem.h"
#import "FBMediaViewerItemLoader.h"
#import "FBMediaViewerLoadingView.h"
#import "FBMediaViewerView.h"

// Inner Views
#import "FBMediaViewerGenericLoadingView.h"
#import "FBMediaViewerRendererImageView.h"

// Renderers
#import "FBMediaViewerRendererFactory.h"

//--
//#import "FBMediaViewerRendererWebView.h"

@interface FBMediaViewerInnerView()
@property (nonatomic, assign) FBMediaViewerView* mediaViewerView;
@property (nonatomic, strong) UIView <FBMediaViewerRenderer> *renderer;
@property (nonatomic, strong) UIView <FBMediaViewerLoadingView> *loadingDialogView;
@property (nonatomic, assign) BOOL displaying;
@end


@implementation FBMediaViewerInnerView

#pragma mark -
#pragma mark Privates
- (void)_setupRenderWithURL:(NSURL*)url
{
	if (self.renderer) {
		[self.renderer removeFromSuperview];
		self.renderer = nil;
	}
/*
	self.renderer = [[FBMediaViewerRendererWebView alloc] initWithFrame:self.bounds];
//	self.renderer = [[FBMediaViewerRendererImageView alloc] initWithFrame:self.bounds];
*/
    
    self.renderer = [FBMediaViewerRendererFactory rendererForURL:url frame:self.bounds];
    
	self.renderer.autoresizingMask =
		UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self insertSubview:self.renderer belowSubview:self.loadingDialogView];
}


#pragma mark -
#pragma mark Basics

- (id)initWithMediaViewerView:(FBMediaViewerView*)view frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mediaViewerView = view;

        self.loadingDialogView = [FBMediaViewerGenericLoadingView loadingView];
        self.loadingDialogView.hidden = YES;
        [self.loadingDialogView layoutInFrame:self.frame];
        [self addSubview:self.loadingDialogView];
        
        self.frame = frame;
    }
    return self;
}


#pragma mark -
#pragma mark Properites
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    frame.origin = CGPointZero;
    self.renderer.frame = frame;
    [self.loadingDialogView layoutInFrame:frame];
}

- (void)setMediaViewerItem:(id<FBMediaViewerItem>)mediaViewerItem
{
    if (_mediaViewerItem) {
        [self cancel];
        self.loadingDialogView.hidden = YES;
    }
    
    _mediaViewerItem = mediaViewerItem;

	[self _setupRenderWithURL:mediaViewerItem.contentURL];

    if (mediaViewerItem && !mediaViewerItem.loadWhenAppearing) {

        if (mediaViewerItem.localFileURL) {
            [self.renderer renderContentOfURL:self.mediaViewerItem.localFileURL];
            self.displaying = YES;
        } else {
            [self.renderer clear];
            self.displaying = NO;
        }
    } else {
        [self.renderer clear];
        self.displaying = NO;
    }
}


#pragma mark -
#pragma mark API

- (void)loadWithMode:(FBMeditViewerItemLoaderMode)mode
{
    [self.renderer clear];

    if (self.mediaViewerView.itemLoader) {
        self.loadingDialogView.title = self.mediaViewerItem.name;
        self.loadingDialogView.progress = 0.0f;
        self.loadingDialogView.hidden = NO;

        [self.mediaViewerView.itemLoader
         loadWithMediaViewerItem:self.mediaViewerItem
         mode:mode
         loading:^(NSUInteger loadedSize) {
             self.loadingDialogView.progress = (CGFloat)loadedSize / (CGFloat)self.mediaViewerItem.size;
         }
         completion:^(BOOL canceled) {
             if (!canceled) {
                 self.loadingDialogView.hidden = YES;
                 [self.renderer renderContentOfURL:self.mediaViewerItem.localFileURL];
             }
         }
         failed:^{
             
         }];
    } else {
        // nothing
    }
}

- (void)cancel
{
    [self.mediaViewerView.itemLoader
     cancelWithMediaViewerItem:self.mediaViewerItem];
}

- (void)willAppear
{
    if (!self.displaying) {
        [self loadWithMode:FBMeditViewerItemLoaderModeLoadFromCache];
        self.displaying = YES;
    }
}
- (void)willDisAppear
{
    [self.renderer reset];
}

@end
