//
//  FBMediaViewerContentLoaderLocal.m
//  FBMediaViewer
//
//  Created by Hiroshi Hashiguchi on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FBMediaViewerItemLoaderLocal.h"

@implementation FBMediaViewerItemLoaderLocal

- (void)loadWithMediaViewerItem:(id <FBMediaViewerItem>)mediaViewerItem
                    forceReload:(BOOL)forceReload
                        loading:(FBMediaViewerContentLoaderLoadingBlock)loadingBlock
                     completion:(FBMediaViewerContentLoaderCompletionBlock)completionBlock
                         failed:(FBMediaViewerContentLoaderFailedBlock)failedBlock
{
    completionBlock(NO);
}

- (NSURL*)localFileURLForContentURL:(NSURL*)contentURL
{
    return nil;
}

- (void)cancelWithMediaViewerItem:(id <FBMediaViewerItem>)mediaViewerItem
{
    NSLog(@"%s|canceled: %@", __PRETTY_FUNCTION__, mediaViewerItem);
}

- (void)cancelAllItems
{
    NSLog(@"%s|%@", __PRETTY_FUNCTION__, nil);
}

@end
