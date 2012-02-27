//
//  FBMediaViewerViewController.m
//  FBMediaViewer
//
//  Created by Hiroshi Hashiguchi on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FBMediaViewerViewController.h"
#import "FBGenericMediaViewerItem.h"
#import "FBMediaViewerContentLoaderLocal.h"

@interface FBMediaViewerViewController ()

@property (nonatomic, strong) NSMutableArray* items;

@end

@implementation FBMediaViewerViewController
@synthesize mediaViewerView;
@synthesize items;
@synthesize contentLoader;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSURL* url;
    
    self.items = [NSMutableArray array];
    for (int i=0; i < 4; i++) {
        url = [[NSBundle mainBundle] URLForResource:
               [NSString stringWithFormat:@"image%02d.jpg", i+1] withExtension:nil];
        [self.items addObject:[FBGenericMediaViewerItem genericMediaItemWithURL:url]];
    }
    url = [[NSBundle mainBundle] URLForResource:@"sample.doc" withExtension:nil];
    [self.items addObject:[FBGenericMediaViewerItem genericMediaItemWithURL:url]];

    url = [[NSBundle mainBundle] URLForResource:@"sample.xls" withExtension:nil];
    [self.items addObject:[FBGenericMediaViewerItem genericMediaItemWithURL:url]];
    
//    [self.items addObject:[[NSBundle mainBundle] URLForResource:@"sample.mov" withExtension:nil]];
//    [self.items addObject:[FBGenericMediaItem genericMediaItemWithURL:url]];

    self.contentLoader = [FBMediaViewerContentLoaderLocal new];
    self.mediaViewerView.contentLoader = self.contentLoader;
    [self.mediaViewerView reloadData];
}

- (void)viewDidUnload
{
    [self setMediaViewerView:nil];
    self.items = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


#pragma mark -
#pragma mark FBMediaViewerViewDataSource

- (NSInteger)numberOfItemsInMediaViewerView:(FBMediaViewerView*)mediaViewerView
{
    return [self.items count];
}

- (NSURL*)mediaViewerView:(FBMediaViewerView*)mediaViewerView itemAtIndex:(NSUInteger)index
{
    return [self.items objectAtIndex:index];
}



@end
