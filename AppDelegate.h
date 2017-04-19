//
//  AppDelegate.h
//  Emoticam
//
//  Created by Dan Sakamoto on 10/16/12.
//  Copyright (c) 2012 Dan Sakamoto. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PhotoGrabber;
@class EmotionFinder;

@interface AppDelegate : NSObject <NSApplicationDelegate>{
    NSStatusItem *myStatusItem;
    IBOutlet NSMenu *myStatusMenu;
    IBOutlet NSMenuItem *myMenuStatusItem;
}


@property (assign) IBOutlet NSWindow *window;
@property (strong) PhotoGrabber *theGrabber;
@property (strong) EmotionFinder *emotionFinder;

@end