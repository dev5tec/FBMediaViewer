//
//  FBMediaViewerWebView.h
//  FBMediaViewer
//
//  Created by Hiroshi Hashiguchi on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBMediaViewerRenderer.h"

@interface FBMediaViewerRendererWebView : UIWebView <FBMediaViewerRenderer, UIWebViewDelegate>

@end
