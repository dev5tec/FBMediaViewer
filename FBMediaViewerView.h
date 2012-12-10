//
// Copyright (c) 2012 Five-technology Co.,Ltd.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
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
