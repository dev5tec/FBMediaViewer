//
//  FBMediaViewerProgressView.h
//  FBMediaViewerProgressView
//
//  Created by Hiroshi Hashiguchi on 11/03/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    FBMediaViewerProgressViewStyleDefault = 0,
    FBMediaViewerProgressViewStyleGray,
    FBMediaViewerProgressViewStyleWhite
} FBMediaViewerProgressViewStyle;

@interface FBMediaViewerProgressView : UIView
    
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) FBMediaViewerProgressViewStyle progressViewStyle;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) BOOL hidesUntilStart;

@end
