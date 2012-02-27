//
//  FBMediaViewerContentLoaderLocal.m
//  FBMediaViewer
//
//  Created by Hiroshi Hashiguchi on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FBMediaViewerContentLoaderLocal.h"

@implementation FBMediaViewerContentLoaderLocal

- (void)loadWithMediaViewerItem:(id <FBMediaViewerItem>)mediaViewerItem
                    forceReload:(BOOL)forceReload
                        loading:(FBMediaViewerContentLoaderLoadingBlock)loadingBlock
                     completion:(FBMediaViewerContentLoaderCompletionBlock)completionBlock
                         failed:(FBMediaViewerContentLoaderFailedBlock)failedBlock
{
    completionBlock(NO);
}

- (void)cancelWithMediaViewerItem:(id <FBMediaViewerItem>)mediaViewerItem
{
    NSLog(@"%s|canceled: %@", __PRETTY_FUNCTION__, mediaViewerItem);
}

@end
