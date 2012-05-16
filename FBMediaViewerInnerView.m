//
//  FBMediaViewerInnerView.m
//  FBMediaViewer
//
//  Created by Hiroshi Hashiguchi on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FBMediaViewerInnerView.h"
#import "FBMediaViewerView.h"
#import "FBMediaViewerItem.h"
#import "FBMediaViewerItemLoader.h"
#import "FBMediaViewerLoadingView.h"
#import "FBMediaViewerView.h"

// Inner Views
#import "FBMediaViewerRendererWebView.h"
#import "FBMediaViewerGenericLoadingView.h"

//--

@interface FBMediaViewerInnerView()
@property (nonatomic, assign) FBMediaViewerView* mediaViewerView;
@property (nonatomic, strong) UIView <FBMediaViewerRenderer> *renderer;
@property (nonatomic, strong) UIView <FBMediaViewerLoadingView> *loadingDialogView;
@property (nonatomic, assign) BOOL displaying;
@end


@implementation FBMediaViewerInnerView

// public
@synthesize mediaViewerView;
@synthesize mediaViewerItem = mediaViewerItem_;

// private
@synthesize renderer;
@synthesize loadingDialogView;
@synthesize displaying;


#pragma mark -
#pragma mark Privates
- (void)_setupRenderWithURL:(NSURL*)url
{
	if (self.renderer) {
		[self.renderer removeFromSuperview];
		self.renderer = nil;
	}

	self.renderer = [[FBMediaViewerRendererWebView alloc] initWithFrame:self.bounds];
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
    if (mediaViewerItem_) {
        [self cancel];
        self.loadingDialogView.hidden = YES;
    }
    
    mediaViewerItem_ = mediaViewerItem;

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
    self.loadingDialogView.title = self.mediaViewerItem.name;
    self.loadingDialogView.progress = 0.0f;
    self.loadingDialogView.hidden = NO;

    [self.renderer clear];

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
    // nothing ?
}

@end
