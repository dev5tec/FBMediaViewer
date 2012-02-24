//
//  FBMediaGenericItem.m
//  FBMediaViewer
//

#import "FBGenericMediaItem.h"

@implementation FBGenericMediaItem
@synthesize contentURL;
@synthesize localFileURL;
@synthesize size;
@synthesize modifiedDate;

+ (FBGenericMediaItem*)genericMediaItemWithURL:(NSURL*)url
{
    FBGenericMediaItem* item = [[self alloc] init];
    item.contentURL = url;
    item.localFileURL = url;
    item.size = 0;  // TODO
    item.modifiedDate = [NSDate date];
    return item;
}

- (void)loadWithLoading:(void (^)(NSUInteger loadedSize))loading
             completion:(void (^)(BOOL canceled, id <FBMediaItem> mediaItem))completion
                 failed:(void (^)(void))failed
{
    completion(NO, self);
}

@end
