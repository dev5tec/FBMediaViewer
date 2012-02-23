//
//  FBMediaViewerView.h
//  FBMediaViewer
//
//  Created by Hiroshi Hashiguchi on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBMediaViewerInnerView.h"

@class FBMediaViewerView;

@protocol FBMediaViewerViewDataSource <NSObject>
- (NSInteger)numberOfItemsInMediaViewerView:(FBMediaViewerView*)mediaViewerView;
- (NSURL*)mediaViewerView:(FBMediaViewerView*)mediaViewerView itemAtIndex:(NSUInteger)index; 
@end


@protocol FBImageViewerViewDelegate <NSObject>
@optional
- (void)mediaViewerView:(FBMediaViewerView*)mediaViewerView willMoveFromIndex:(NSUInteger)index;
- (void)mediaViewerView:(FBMediaViewerView*)mediaViewerView didMoveToIndex:(NSUInteger)index;
- (void)mediaViewerViewDidStopSlideShow:(FBMediaViewerView*)mediaViwerView;

@end

   
@interface FBMediaViewerView : UIView <UIScrollViewDelegate>

// Properties (Public)
@property (nonatomic, assign) IBOutlet id <FBImageViewerViewDelegate> delegate;
@property (nonatomic, assign) IBOutlet id <FBMediaViewerViewDataSource> dataSource;
@property (nonatomic, assign) NSInteger currentIndex;	// start with 0

// API
- (void)reloadData;
- (void)setCurrentIndex:(NSInteger)index animated:(BOOL)animated;

- (void)moveToPreviousItemAnimated:(BOOL)animated;
- (void)moveToNextItemAnimated:(BOOL)animated;


// API (IBAction)
- (IBAction)moveToPreviousItem:(id)sender;
- (IBAction)moveToNextItem:(id)sender;

@end
