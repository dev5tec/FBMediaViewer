//
//  FBMediaViewerInnerView.h
//  FBMediaViewer
//
//  Created by Hiroshi Hashiguchi on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBMediaViewerRenderer.h"

@protocol FBMediaItem;
@interface FBMediaViewerInnerView : UIView

// API (Properties)
@property (nonatomic, strong) id <FBMediaItem> mediaItem;

// API
- (void)load;
- (void)cancel;

@end
