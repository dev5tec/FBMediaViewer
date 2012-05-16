//
//  FBMediaViewerView.h
//  FBMediaViewer
//
//  Created by Hiroshi Hashiguchi on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBMediaViewerItemLoader.h"

@class FBMediaViewerView;
@protocol FBMediaViewerItem;

//------------------------------------------------------------------------------
@protocol FBMediaViewerViewDataSource <NSObject>
- (NSInteger)numberOfItemsInMediaViewerView:(FBMediaViewerView*)mediaViewerView;
- (id <FBMediaViewerItem>)mediaViewerView:(FBMediaViewerView*)mediaViewerView itemAtIndex:(NSUInteger)index; 
@end

//------------------------------------------------------------------------------
@protocol FBImageViewerViewDelegate <NSObject>
@optional
- (void)mediaViewerView:(FBMediaViewerView*)mediaViewerView willMoveFromIndex:(NSUInteger)index;
- (void)mediaViewerView:(FBMediaViewerView*)mediaViewerView didMoveToIndex:(NSUInteger)index;
- (void)mediaViewerViewDidStopSlideShow:(FBMediaViewerView*)mediaViewerView;
@end

//------------------------------------------------------------------------------

@protocol FBMediaViewerItemLoader;
@interface FBMediaViewerView : UIView <UIScrollViewDelegate>

// Properties (Public)
@property (nonatomic, assign) IBOutlet id <FBImageViewerViewDelegate> delegate;
@property (nonatomic, assign) IBOutlet id <FBMediaViewerViewDataSource> dataSource;
@property (nonatomic, assign) IBOutlet id <FBMediaViewerItemLoader> itemLoader;
@property (nonatomic, assign) NSInteger currentIndex;	// start with 0

// API
- (void)reloadData;
- (void)moveToIndex:(NSInteger)index animated:(BOOL)animated;

- (void)reloadCurrentItemWithMode:(FBMeditViewerItemLoaderMode)mode;
- (id <FBMediaViewerItem>)currentItem;
   
- (void)moveToPreviousItemAnimated:(BOOL)animated;
- (void)moveToNextItemAnimated:(BOOL)animated;


// API (IBAction)
- (IBAction)moveToPreviousItem:(id)sender;
- (IBAction)moveToNextItem:(id)sender;

@end
