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

#import "FBMediaViewerRendererFactory.h"
@implementation FBMediaViewerRendererFactory

static Class _defaultRendererClass = nil;
static NSMutableDictionary* _rendererClassMap = nil;

+ (void)_setup
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:
                              [[NSBundle mainBundle] pathForResource:@"FBMediaViewer"
                                                              ofType:@"plist"]];
        _defaultRendererClass = NSClassFromString([dict objectForKey:@"DefaultRenderer"]);
        if (_defaultRendererClass == nil) {
            NSLog(@"[ERROR] Loading DefaultRender failed");
        }
        _rendererClassMap = [NSMutableDictionary dictionary];

        NSDictionary* renderers = [dict objectForKey:@"Renderers"];

        for (NSString* rendererName in [renderers allKeys]) {
            Class clz = NSClassFromString(rendererName);
            if (clz == nil) {
                NSLog(@"[ERROR] Loading '%@' failed", rendererName);
                continue;
            }
            
            for (NSString* extensions in [renderers objectForKey:rendererName]) {
                [_rendererClassMap setObject:clz forKey:extensions];
            }
        }
//        NSLog(@"%s|%@", __PRETTY_FUNCTION__, _defaultRendererClass);
//        NSLog(@"%s|%@", __PRETTY_FUNCTION__, _rendererClassMap);
    });
}

+ (UIView <FBMediaViewerRenderer> *)rendererForURL:(NSURL*)url frame:(CGRect)frame
{
    if (url == nil) {
        return nil;
    }

    [self _setup];
    
    Class clz = [_rendererClassMap objectForKey:url.pathExtension.lowercaseString];
    if (clz == nil) {
        clz = _defaultRendererClass;
    }
    return [[clz alloc] initWithFrame:frame];
}


@end
