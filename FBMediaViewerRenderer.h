//
//  FBMediaViewerRenderer.h
//  FBMediaViewer
//
//  Created by Hiroshi Hashiguchi on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FBMediaViewerRenderer <NSObject>

// API
- (void)renderContentOfURL:(NSURL*)url;

@end
