//
//  FBMediaViewerInnerView.h
//  FBMediaViewer
//
//  Created by Hiroshi Hashiguchi on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBMediaViewerInnerView : UIWebView <UIWebViewDelegate>

// Properties (public)
@property (nonatomic, strong) NSURL* url;

@end
