//
//  main.m
//  ProgressiveDownload
//
//  Created by Anders Hafreager on 22/11/14.
//  Copyright (c) 2014 Anders Hafreager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <GPUImageView.h>

int main(int argc, char * argv[]) {
    @autoreleasepool {
        [GPUImageView class];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
