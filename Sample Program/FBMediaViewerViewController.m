//
//  FBMediaViewerViewController.m
//  FBMediaViewer
//
//  Created by Hiroshi Hashiguchi on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FBMediaViewerViewController.h"
#import "FBGenericMediaViewerItem.h"
#import "FBMediaViewerItemLoaderLocal.h"

#import "FBMediaViewerRendererImageView.h"

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
    
    url = [[NSBundle mainBundle] URLForResource:@"sample_small.jpg" withExtension:nil];
    [self.items addObject:[FBGenericMediaViewerItem genericMediaItemWithURL:url]];

    url = [[NSBundle mainBundle] URLForResource:@"sample_large.JPG" withExtension:nil];
    [self.items addObject:[FBGenericMediaViewerItem genericMediaItemWithURL:url]];
    
    url = [[NSBundle mainBundle] URLForResource:@"image01.jpg" withExtension:nil];
    [self.items addObject:[FBGenericMediaViewerItem genericMediaItemWithURL:url]];
    
    url = [[NSBundle mainBundle] URLForResource:@"sample.doc" withExtension:nil];
    [self.items addObject:[FBGenericMediaViewerItem genericMediaItemWithURL:url]];

    url = [[NSBundle mainBundle] URLForResource:@"sample.xls" withExtension:nil];
    [self.items addObject:[FBGenericMediaViewerItem genericMediaItemWithURL:url]];

    url = [[NSBundle mainBundle] URLForResource:@"sample.mov" withExtension:nil];
    [self.items addObject:[FBGenericMediaViewerItem genericMediaItemWithURL:url]];

//    [self.items addObject:[[NSBundle mainBundle] URLForResource:@"sample.mov" withExtension:nil]];
//    [self.items addObject:[FBGenericMediaItem genericMediaItemWithURL:url]];

    self.contentLoader = [FBMediaViewerItemLoaderLocal new];
    self.mediaViewerView.itemLoader = self.contentLoader;
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
