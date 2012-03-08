//
//  FBMediaViewerGenericLoadingView.m
//  FBMediaViewer
//
//  Created by Hiroshi Hashiguchi on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
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
        self.titleLabel.textColor = [UIColor grayColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];

        self.progressLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 80, FB_MEDIA_VIEWER_GENERIC_LOADING_VIEW_WIDTH, 30)];
        self.progressLabel.textAlignment = UITextAlignmentCenter;
        self.progressLabel.textColor = [UIColor grayColor];
        self.progressLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.progressLabel];
        
        self.progressView = [[FBMediaViewerProgressView alloc] initWithFrame:CGRectMake(40, 50, 240, 26)];
        self.progressView.progressViewStyle = FBMediaViewerProgressViewStyleGray;
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
