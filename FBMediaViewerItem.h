//
//  FBMediaItem.h
//  FBMediaViewer
//
//  Created by Hiroshi Hashiguchi on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FBMediaViewerItem <NSObject>

// API (Properties)
@property (nonatomic, retain) NSURL* contentURL;
@property (nonatomic, retain) NSURL* localFileURL;
@property (nonatomic, assign) NSUInteger size;
@property (nonatomic, retain) NSDate* modifiedDate;


@end
