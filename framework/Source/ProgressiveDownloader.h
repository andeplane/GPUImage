//
//  ProgressiveDownloader.h
//  GPUImage
//
//  Created by Anders Hafreager on 22/11/14.
//  Copyright (c) 2014 Brad Larson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol ProgressiveDownloaderDelegate
@required
-(void) videoReadyToDecode;
-(void) newBytesAvailable;
-(void) dowloadFinished;

@end

@interface ProgressiveDownloader : NSObject <NSURLSessionDataDelegate>

@property(retain) NSURL *url;
@property(retain) NSURLConnection *connection;
@property(retain) AVURLAsset *asset;
@property(retain) NSURL *fileURL;
@property(retain) NSFileHandle *file;
@property(assign) NSInteger bytesSoFar;
@property(retain) id<ProgressiveDownloaderDelegate> delegate;

+(id) progressiveDownloaderWithURL:(NSURL*)url  delegate:(id<ProgressiveDownloaderDelegate>)delegate;
-(id) initWithURL:(NSURL*)url delegate:(id<ProgressiveDownloaderDelegate>)delegate;
-(void) openTempFile;
-(BOOL) tryOpenAsset;


#pragma mark NASURLSessionDataDelegate methods
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end

