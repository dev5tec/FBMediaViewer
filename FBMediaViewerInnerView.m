//
//  FBMediaViewerInnerView.m
//  FBMediaViewer
//
//  Created by Hiroshi Hashiguchi on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FBMediaViewerInnerView.h"
#import "FBMediaItem.h"

// Inner Views
#import "FBMediaViewerRendererWebView.h"

@interface FBMediaViewerInnerView()
@property (nonatomic, strong) UIView <FBMediaViewerRenderer> *renderer;
@end


@implementation FBMediaViewerInnerView

// public
@synthesize mediaItem;

// private
@synthesize renderer;


#pragma mark -
#pragma mark Basics

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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
    [self.mediaItem
     loadWithLoading:^(NSUInteger loadedSize) {
         NSLog(@"%s|loadedSize=%d", __PRETTY_FUNCTION__, loadedSize);
     }
     completion:^(BOOL canceled, id <FBMediaItem> item) {
         [self.renderer renderContentOfURL:item.localFileURL];
     }
     failed:^{
         NSLog(@"%s|%@", __PRETTY_FUNCTION__, @"failed");
     }];
}

- (void)cancel
{
    NSLog(@"%s|%@", __PRETTY_FUNCTION__, nil);
}


@end
