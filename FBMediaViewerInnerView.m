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
#import "FBMediaViewerContentLoader.h"
#import "FBMediaViewerLoadingView.h"

// Inner Views
#import "FBMediaViewerRendererWebView.h"
#import "FBMediaViewerGenericLoadingView.h"

//--

@interface FBMediaViewerInnerView()
@property (nonatomic, assign) FBMediaViewerView* mediaViewerView;
@property (nonatomic, strong) UIView <FBMediaViewerRenderer> *renderer;
@property (nonatomic, strong) UIView <FBMediaViewerLoadingView> *loadinDialogView;
@end


@implementation FBMediaViewerInnerView

// public
@synthesize mediaViewerView;
@synthesize mediaViewerItem = mediaViewerView_;

// private
@synthesize renderer;
@synthesize loadinDialogView;


#pragma mark -
#pragma mark Basics

- (id)initWithMediaViewerView:(FBMediaViewerView*)view frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mediaViewerView = view;
        self.backgroundColor = [UIColor redColor];
        // TODO
        self.renderer = [[FBMediaViewerRendererWebView alloc] initWithFrame:CGRectZero];
        self.renderer.autoresizingMask =
            UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.renderer];
        
        self.loadinDialogView = [FBMediaViewerGenericLoadingView loadingView];
        self.loadinDialogView.hidden = YES;
        [self addSubview:self.loadinDialogView];
        
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
    [self.loadinDialogView layoutInFrame:frame];
}

- (void)setMediaViewerItem:(id<FBMediaViewerItem>)mediaViewerItem
{
    mediaViewerView_ = mediaViewerItem;
    self.renderer.hidden = (mediaViewerView_ == nil);
}


#pragma mark -
#pragma mark API

- (void)loadWithForceReload:(BOOL)forceReload
{
    self.loadinDialogView.title = self.mediaViewerItem.name;
    self.loadinDialogView.hidden = NO;

    [self.mediaViewerView.contentLoader
     loadWithMediaViewerItem:self.mediaViewerItem
     forceReload:forceReload
     loading:^(NSUInteger loadedSize) {
         self.loadinDialogView.progress = (CGFloat)loadedSize / (CGFloat)self.mediaViewerItem.size;
     }
     completion:^(BOOL canceled) {
         self.loadinDialogView.hidden = YES;
         [self.renderer renderContentOfURL:self.mediaViewerItem.localFileURL];
     }
     failed:^{
         
     }];
}

- (void)cancel
{
    [self.mediaViewerView.contentLoader
     cancelWithMediaViewerItem:self.mediaViewerItem];
}


@end
