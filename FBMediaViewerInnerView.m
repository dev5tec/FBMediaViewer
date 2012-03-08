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
@property (nonatomic, strong) UIView <FBMediaViewerLoadingView> *loadinDialogView;
@property (nonatomic, assign) BOOL displaying;
@end


@implementation FBMediaViewerInnerView

// public
@synthesize mediaViewerView;
@synthesize mediaViewerItem = mediaViewerItem_;

// private
@synthesize renderer;
@synthesize loadinDialogView;
@synthesize displaying;


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
        [self.loadinDialogView layoutInFrame:self.frame];
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
    if (mediaViewerItem_) {
        [self.renderer clear];
        [self cancel];
        self.loadinDialogView.hidden = YES;
    }
    
    mediaViewerItem_ = mediaViewerItem;

    if (mediaViewerItem) {
        mediaViewerItem.localFileURL = [self.mediaViewerView.itemLoader localFileURLForContentURL:mediaViewerItem.contentURL];

        if (mediaViewerItem.localFileURL) {
            [self.renderer renderContentOfURL:self.mediaViewerItem.localFileURL];
            self.displaying = YES;
        } else {
            self.displaying = NO;
        }
    } else {
        self.displaying = NO;
    }
}


#pragma mark -
#pragma mark API

- (void)loadWithForceReload:(BOOL)forceReload
{
    self.loadinDialogView.title = self.mediaViewerItem.name;
    self.loadinDialogView.progress = 0.0f;
    self.loadinDialogView.hidden = NO;

    [self.renderer clear];

    [self.mediaViewerView.itemLoader
     loadWithMediaViewerItem:self.mediaViewerItem
     forceReload:forceReload
     loading:^(NSUInteger loadedSize) {
         self.loadinDialogView.progress = (CGFloat)loadedSize / (CGFloat)self.mediaViewerItem.size;
     }
     completion:^(BOOL canceled) {
         if (!canceled) {
             self.loadinDialogView.hidden = YES;
             [self.renderer renderContentOfURL:self.mediaViewerItem.localFileURL];

             // do later
//             if ([self.mediaViewerView.delegate respondsToSelector:@selector(mediaViewerView:didLoadMediaViewerItem:)]) {
//                 [self.mediaViewerView.delegate mediaViewerView:self.mediaViewerView didLoadMediaViewerItem:self.mediaViewerItem];
//             }
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
        [self loadWithForceReload:NO];
        self.displaying = YES;
    }
}
- (void)willDisAppear
{
    // nothing ?
}

@end
