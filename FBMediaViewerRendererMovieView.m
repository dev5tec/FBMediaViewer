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

#import "FBMediaViewerRendererMovieView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface FBMediaViewerRendererMovieView()
@property (nonatomic, strong) MPMoviePlayerController* moviePlayerController;
@end

@implementation FBMediaViewerRendererMovieView

#pragma mark -
#pragma mark Basics

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.moviePlayerController = [[MPMoviePlayerController alloc] init];
        [self.moviePlayerController prepareToPlay];
        self.moviePlayerController.shouldAutoplay = NO;
        [self.moviePlayerController.view setFrame:frame];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.moviePlayerController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        [self addSubview:self.moviePlayerController.view];
    }
    return self;
}

#pragma mark -
#pragma mark FBMediaViewerRenderer

- (void)renderContentOfURL:(NSURL*)url
{
    self.moviePlayerController.contentURL = url;
}

- (void)clear
{
    self.moviePlayerController.contentURL = nil;
}

- (void)reset
{
    // TODO: should be implemented
}

@end

