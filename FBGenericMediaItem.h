//
//  FBMediaGenericItem.h
//  FBMediaViewer
//

#import <UIKit/UIKit.h>

#import "FBMediaItem.h"

@interface FBGenericMediaItem : NSObject <FBMediaItem>

+ (FBGenericMediaItem*)genericMediaItemWithURL:(NSURL*)url;

@end
