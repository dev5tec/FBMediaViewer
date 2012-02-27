//
//  FBMediaGenericItem.h
//  FBMediaViewer
//

#import <UIKit/UIKit.h>

#import "FBMediaViewerItem.h"

@interface FBGenericMediaViewerItem : NSObject <FBMediaViewerItem>

+ (FBGenericMediaViewerItem*)genericMediaItemWithURL:(NSURL*)url;

@end
