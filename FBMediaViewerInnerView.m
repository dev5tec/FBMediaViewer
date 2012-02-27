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

// Inner Views
#import "FBMediaViewerRendererWebView.h"

@interface FBMediaViewerInnerView()
@property (nonatomic, assign) FBMediaViewerView* mediaViewerView;
@property (nonatomic, strong) UIView <FBMediaViewerRenderer> *renderer;
@end


@implementation FBMediaViewerInnerView

// public
@synthesize mediaViewerView;
@synthesize mediaViewerItem;

// private
@synthesize renderer;


#pragma mark -
#pragma mark Basics

- (id)initWithMediaViewerView:(FBMediaViewerView*)view frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mediaViewerView = view;
        self.backgroundColor = [UIColor redColor];
        self.renderer = [[FBMediaViewerRendererWebView alloc] initWithFrame:frame];
        self.renderer.autoresizingMask =
            UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        [self addSubview:self.renderer];
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
}


#pragma mark -
#pragma mark API

- (void)load
{
    [self.mediaViewerView.contentLoader
     loadWithMediaViewerItem:self.mediaViewerItem
                 forceReload:NO
                     loading:^(NSUInteger loadedSize) {

                     }
                  completion:^(BOOL canceled) {
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
