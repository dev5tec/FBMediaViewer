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

#import "FBMediaViewerGenericLoadingView.h"
#import "FBMediaViewerProgressView.h"

@interface FBMediaViewerGenericLoadingView()
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* progressLabel;
@property (nonatomic, strong) FBMediaViewerProgressView* progressView;
@end

@implementation FBMediaViewerGenericLoadingView

@synthesize progress = progress_;
@synthesize title = title_;

@synthesize titleLabel;
@synthesize progressLabel;
@synthesize progressView;


#pragma mark -
#pragma mark Privates

#pragma mark -
#pragma mark Basics


#define FB_MEDIA_VIEWER_GENERIC_LOADING_VIEW_WIDTH  1000

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, FB_MEDIA_VIEWER_GENERIC_LOADING_VIEW_WIDTH, 130);
//        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        self.backgroundColor = [UIColor clearColor];
        
        self.titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 5, FB_MEDIA_VIEWER_GENERIC_LOADING_VIEW_WIDTH, 40)];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];

        self.progressLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 80, FB_MEDIA_VIEWER_GENERIC_LOADING_VIEW_WIDTH, 30)];
        self.progressLabel.textAlignment = UITextAlignmentCenter;
        self.progressLabel.textColor = [UIColor whiteColor];
        self.progressLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.progressLabel];
        
        self.progressView = [[FBMediaViewerProgressView alloc] initWithFrame:CGRectMake(40, 50, 240, 26)];
        self.progressView.progressViewStyle = FBMediaViewerProgressViewStyleWhite;
        self.progressView.lineWidth = 3.0;
        [self addSubview:self.progressView];
    }
    return self;
}


#pragma mark -
#pragma mark Properties
- (void)setProgress:(CGFloat)progress
{
    progress_ = progress;
    self.progressLabel.text = [NSString stringWithFormat:@"%d%%", (NSUInteger)(progress*100.0)];
    self.progressView.progress = progress;
}

- (void)setTitle:(NSString *)title
{
    title_ = title;
    self.titleLabel.text = title;
}

#pragma mark -
#pragma mark FBMediaViewerLoadingView

+ (UIView <FBMediaViewerLoadingView> *)loadingView
{
    return [[self alloc] init];
}

- (void)layoutInFrame:(CGRect)frame
{
    CGRect newFrame = self.frame;
    newFrame.origin.y = (frame.size.height - newFrame.size.height) / 2.0f;
    self.frame = newFrame;
    
    newFrame = self.titleLabel.frame;
    newFrame.size.width = frame.size.width;
    self.titleLabel.frame = newFrame;
    
    newFrame = self.progressLabel.frame;
    newFrame.size.width = frame.size.width;
    self.progressLabel.frame = newFrame;
    
    newFrame = self.progressView.frame;
    newFrame.origin.x = (frame.size.width - newFrame.size.width) / 2.0f;
    self.progressView.frame = newFrame;
}


@end
