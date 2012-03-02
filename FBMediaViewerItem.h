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
@property (nonatomic, strong, readonly) NSString* name; 
@property (nonatomic, strong) NSURL* contentURL;
@property (nonatomic, strong) NSURL* localFileURL;
@property (nonatomic, assign) NSUInteger size;
@property (nonatomic, strong) NSDate* modifiedDate;


@end
