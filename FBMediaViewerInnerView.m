//
//  FBMediaViewerInnerView.m
//  FBMediaViewer
//
//  Created by Hiroshi Hashiguchi on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FBMediaViewerInnerView.h"

@implementation FBMediaViewerInnerView
@synthesize url = url_;

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
    if (self.url) {
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.alpha = 1.0;
                         }];
    } else {
        self.alpha = 0.0;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setUrl:(NSURL *)url
{
    url_ = url;
    self.alpha = 0.0;
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self loadRequest:request];
}

@end
