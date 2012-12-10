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

#import <QuartzCore/QuartzCore.h>
    
#import "FBMediaViewerRendererWebView.h"

@interface FBMediaViewerRendererWebView()
@property (nonatomic, strong) UIView* waitView;
@end

@implementation FBMediaViewerRendererWebView
@synthesize waitView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scalesPageToFit = YES;
        self.delegate = self;
        self.backgroundColor = [UIColor darkGrayColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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

- (void)_layoutWaitView
{
    if (self.waitView) {
        CGRect waitViewFrame = self.waitView.frame;
        waitViewFrame.origin.x = (self.frame.size.width-waitViewFrame.size.width)/2.0;
        waitViewFrame.origin.y = (self.frame.size.height-waitViewFrame.size.height)/2.0;
        self.waitView.frame = waitViewFrame;
    }    
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self _layoutWaitView];
}


- (void)_displayWaitView
{
    CGRect waitViewFrame = CGRectMake(0, 0, 150, 92);
    self.waitView = [[UIView alloc] initWithFrame:waitViewFrame];
    [self _layoutWaitView];
    CALayer* layer = self.waitView.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 5.0f;
    self.waitView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];

    UIActivityIndicatorView* activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

    [activityIndicatorView startAnimating];
    CGRect frame = activityIndicatorView.frame;
    frame.origin = CGPointMake((waitViewFrame.size.width-frame.size.width)/2.0,
                               (waitViewFrame.size.height-frame.size.height)/2.0);
    activityIndicatorView.frame = frame;
    [self.waitView addSubview:activityIndicatorView];
    [self addSubview:self.waitView];
}

- (void)_hideActivityIndicatorView
{
    if (self.waitView) {
        [self.waitView removeFromSuperview];
        self.waitView = nil;
    }
}

#pragma mark -
#pragma mark FBMediaViewerRenderer

- (void)renderContentOfURL:(NSURL*)url
{
    if (url) {
        [self _hideActivityIndicatorView];
        
        NSString* extension = [url.pathExtension lowercaseString];
        if ([extension isEqualToString:@"txt"]) {
            [self loadData:[NSData dataWithContentsOfURL:url]
                  MIMEType:@"text/plain"
          textEncodingName:@"UTF-8"
                   baseURL:nil];
        } else {
            [self loadRequest:[NSURLRequest requestWithURL:url]];
        }

        [self _displayWaitView];
        
//        
//        if ([extension isEqualToString:@"png"] ||
//            [extension isEqualToString:@"jpg"] ||
//            [extension isEqualToString:@"jpeg"] ||
//            [extension isEqualToString:@"gif"]) {
//
//            NSString *html = [NSString stringWithFormat:@"<html><head>"
//                              "</head><body>"
//                              "<div style=\"display:table-cell;text-align:center;vertical-align:middle;\">"
//                              "<img src=\"%@\" style=\"vertical-align:middle\"/>"
//                              "</div>"
//                              "</body>"
//                              "</html>", url];
//
//            [self loadHTMLString:html baseURL:nil];
//        } else {
//            [self loadRequest:[NSURLRequest requestWithURL:url]];            
//        }
//

    } else {
        [self clear];
    }
}

- (void)clear
{
    [self _hideActivityIndicatorView];
    [self loadHTMLString:@"<html><body bgcolor=\"#555555\"></body></html>"
                 baseURL:nil];
    //   NSURL* blankURL = [NSURL URLWithString:@"about:blank"];
    //    [self loadRequest:[NSURLRequest requestWithURL:blankURL]];
}

- (void)reset
{
    // TODO: should be implemented
}



@end
