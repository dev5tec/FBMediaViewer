//
//  FBMediaViewerViewController.h
//  FBMediaViewer
//
//  Created by Hiroshi Hashiguchi on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBMediaViewerView.h"

@interface FBMediaViewerViewController : UIViewController <FBMediaViewerViewDataSource, FBImageViewerViewDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet FBMediaViewerView *mediaViewerView;

@end
