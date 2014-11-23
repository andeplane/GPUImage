//
//  ProgressiveDownloader.m
//  GPUImage
//
//  Created by Anders Hafreager on 22/11/14.
//  Copyright (c) 2014 Brad Larson. All rights reserved.
//

#import "ProgressiveDownloader.h"

@implementation ProgressiveDownloader

+(id) progressiveDownloaderWithURL:(NSURL*)url delegate:(id<ProgressiveDownloaderDelegate>)delegate
{
    ProgressiveDownloader *obj = [[ProgressiveDownloader alloc] initWithURL:url delegate:delegate];
    
    return obj;
}

-(id) initWithURL:(NSURL*)url delegate:(id<ProgressiveDownloaderDelegate>)delegate
{
    if(self = [super init]) {
        NSLog(@"Progressive downloader init with url: %@", url);
        self.url = url;
        self.delegate = delegate;
        self.connection = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:self.url] delegate:self];
        self.bytesSoFar = 0;
        self.asset = nil;
        
        [self openTempFile];
    }
    
    return self;
}

-(void) openTempFile
{
    NSURL *tmpDirURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    self.fileURL = [[tmpDirURL URLByAppendingPathComponent:@"temp"] URLByAppendingPathExtension:@"mp4"];
    [[NSFileManager defaultManager] createFileAtPath:[self.fileURL path] contents:nil attributes:nil];
    self.file = [NSFileHandle fileHandleForWritingToURL:self.fileURL error:nil];
}

-(void) start
{
    NSLog(@"Starting downloading...");
    [self.connection start];
}

-(BOOL) tryOpenAsset
{
    NSDictionary *inputOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    self.asset = [[AVURLAsset alloc] initWithURL:self.fileURL options:inputOptions];
    
    if(self.asset.isReadable && self.asset.isPlayable) {
        NSLog(@"Asset is readable");
        return YES;
    }
    
    NSLog(@"Asset is not readable");
    self.asset = nil;
    return NO;
}

#pragma mark NASURLSessionDataDelegate methods
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.file writeData:data];
    self.bytesSoFar += data.length;
    NSLog(@"Got data: %ld (%ld bytes so far)", data.length, self.bytesSoFar);
    if(!self.asset) {
        NSLog(@"Trying to open asset...");
        if([self tryOpenAsset]) {
            [self.delegate videoReadyToDecode];
        }
    }
    
    [self.delegate newBytesAvailable];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.file closeFile];
    [self.delegate dowloadFinished];
}

@end
