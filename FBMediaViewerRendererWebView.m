//
//  FBMediaViewerWebView.m
//  FBMediaViewer
//
//  Created by Hiroshi Hashiguchi on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FBMediaViewerRendererWebView.h"

@implementation FBMediaViewerRendererWebView

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
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.alpha = 1.0;
                     }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark -
#pragma mark FBMediaViewerRenderer

- (void)renderContentOfURL:(NSURL*)url
{
    self.alpha = 0.0;
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self loadRequest:request];

}


@end
