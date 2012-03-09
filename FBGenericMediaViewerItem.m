//
//  FBMediaGenericItem.m
//  FBMediaViewer
//

#import "FBGenericMediaViewerItem.h"

@implementation FBGenericMediaViewerItem
@synthesize name;
@synthesize contentURL;
@synthesize localFileURL;
@synthesize size;
@synthesize modifiedDate;
@synthesize loadWhenAppearing;

+ (FBGenericMediaViewerItem*)genericMediaItemWithURL:(NSURL*)url
{
    FBGenericMediaViewerItem* item = [[self alloc] init];
    item.contentURL = url;
    item.localFileURL = url;
    item.size = 0;  // TODO
    item.modifiedDate = [NSDate date];
    return item;
}

@end
