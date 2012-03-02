//
//  FBMediaViewerLoadingView.h
//  FBMediaViewer
//
//  Created by Hiroshi Hashiguchi on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FBMediaViewerLoadingView <NSObject>

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, copy) NSString* title;

+ (UIView <FBMediaViewerLoadingView> *)loadingView;
- (void)layoutInFrame:(CGRect)frame;

@end
