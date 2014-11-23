//
//  ViewController.m
//  ProgressiveDownload
//
//  Created by Anders Hafreager on 22/11/14.
//  Copyright (c) 2014 Anders Hafreager. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *sampleURL = [NSURL URLWithString:@"http://folk.uio.no/anderhaf/video.mp4"];
    movieFile = [[GPUImageMovie alloc] initWithProgressiveDownloadableURL:sampleURL];
    GPUImageView *view = (GPUImageView *)self.view;
    [movieFile addTarget:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
