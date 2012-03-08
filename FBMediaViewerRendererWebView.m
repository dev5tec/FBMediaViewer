//
//  FBMediaViewerWebView.m
//  FBMediaViewer
//
//  Created by Hiroshi Hashiguchi on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FBMediaViewerRendererWebView.h"

@interface FBMediaViewerRendererWebView()
@property (nonatomic, strong) UIActivityIndicatorView* activityIndicatorView;
@end

@implementation FBMediaViewerRendererWebView
@synthesize activityIndicatorView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scalesPageToFit = YES;
        self.delegate = self;
    }
    return self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self _hideActivityIndicatorView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self _hideActivityIndicatorView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)_displayActivityIndicatorView
{
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activityIndicatorView startAnimating];
    CGRect frame = self.activityIndicatorView.frame;
    CGRect baseFrame = self.frame;
    frame.origin = CGPointMake((baseFrame.size.width-frame.size.width)/2.0,
                               (baseFrame.size.height-frame.size.height)/2.0);
    self.activityIndicatorView.frame = frame;
    [self addSubview:self.activityIndicatorView];
}
- (void)_hideActivityIndicatorView
{
    if (self.activityIndicatorView) {
        [self.activityIndicatorView removeFromSuperview];
        self.activityIndicatorView = nil;
    }
}

#pragma mark -
#pragma mark FBMediaViewerRenderer

- (void)renderContentOfURL:(NSURL*)url
{
    if (url) {
        [self _hideActivityIndicatorView];
        [self loadRequest:[NSURLRequest requestWithURL:url]];
        [self _displayActivityIndicatorView];

    } else {
        [self clear];
    }
}

- (void)clear
{
    [self _hideActivityIndicatorView];
    NSURL* blankURL = [NSURL URLWithString:@"about:blank"];
    [self loadRequest:[NSURLRequest requestWithURL:blankURL]];
}


@end
