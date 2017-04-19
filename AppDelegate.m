//
//  AppDelegate.m
//  Emoticam
//
//

#import "AppDelegate.h"
#import "PhotoGrabber.h"
#import "EmotionFinder.h"
#import <Cocoa/Cocoa.h>
#import <QTKit/QTkit.h>
#import <ApplicationServices/ApplicationServices.h>

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    
    
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
   [alert addButtonWithTitle:@"Quit Emoticam"];
    [alert setMessageText:@"Emoticam"];
    [alert setInformativeText:@"Fair warning: Emoticam will open at login, run in the background, and will occasionally upload webcam images to emoticam.net."];
    [alert setAlertStyle:NSWarningAlertStyle];
    
    if ([alert runModal] == NSAlertSecondButtonReturn) {
        // OK clicked, delete the record
        //[self deleteRecord:currentRec];
        [[NSApplication sharedApplication] terminate:nil];
        
    }
    //[alert release];
    

    
    // Get the path of the app
    NSURL *bundleURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    
    // Get the list you want to add the path to
    LSSharedFileListRef loginItemsListRef = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    
    // Set the app to be hidden on launch
    NSDictionary *properties = @{@"com.apple.loginitem.HideOnLaunch": @YES};
    
    // Add the item to the list
    LSSharedFileListItemRef itemRef = LSSharedFileListInsertItemURL(loginItemsListRef, kLSSharedFileListItemLast, NULL, NULL, (__bridge CFURLRef)bundleURL, (__bridge CFDictionaryRef)properties,NULL);
    
    
    

    if (AXIsProcessTrustedWithOptions != NULL) {
        // 10.9 and later
        
        /*
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"Continue"];
        [alert setMessageText:@"Authorization"];
        [alert setInformativeText:@"To authorize Emoticam to monitor keystrokes, please add it to the list of apps allowed to control your computer. Afterwards, quit the app from the menu bar and reopen it to allow authorization to take effect."];
        [alert setAlertStyle:NSWarningAlertStyle];
        
        if ([alert runModal] == NSAlertSecondButtonReturn) {
            // OK clicked, delete the record
            //[self deleteRecord:currentRec];
            [[NSApplication sharedApplication] terminate:nil];
            
        }
        //[alert release];
  */
        
        
        const void * keys[] = { kAXTrustedCheckOptionPrompt };
        const void * values[] = { kCFBooleanTrue };
        
        CFDictionaryRef options = CFDictionaryCreate(
                        kCFAllocatorDefault,
                         keys,
                         values,
                        sizeof(keys) / sizeof(*keys),
                         &kCFCopyStringDictionaryKeyCallBacks,
                         &kCFTypeDictionaryValueCallBacks);
        
        AXIsProcessTrustedWithOptions(options);
        

    }
    

      
    
    myStatusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    
    NSImage *statusImage = [NSImage imageNamed:@"icon.tif"];
    [myStatusItem setImage:statusImage];
    [myStatusItem setHighlightMode:YES];
    
    [myStatusItem setMenu:myStatusMenu];
    
    PhotoGrabber *grabber = [[PhotoGrabber alloc] init];
    self.theGrabber = grabber;
    
    EmotionFinder *emotionFinder = [[EmotionFinder alloc] init];
    self.emotionFinder = emotionFinder;
    
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyDownMask handler:^(NSEvent *event) {
        if([self.emotionFinder processKeyInput:[event keyCode] x: [event characters] mod: [event modifierFlags]])
            [self.theGrabber grabPhoto:self.emotionFinder.confirmedEmotion];
    }];
    
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSLeftMouseUp handler:^(NSEvent *event) {
        if([self.emotionFinder processMouseInput])
            [self.theGrabber grabPhoto:self.emotionFinder.confirmedEmotion];
    }];
    
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSRightMouseUp handler:^(NSEvent *event) {
        if([self.emotionFinder processMouseInput])
            [self.theGrabber grabPhoto:self.emotionFinder.confirmedEmotion];
    }];
    
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSOtherMouseUp handler:^(NSEvent *event) {
        if([self.emotionFinder processMouseInput])
            [self.theGrabber grabPhoto:self.emotionFinder.confirmedEmotion];
    }];
    
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSLeftMouseDragged handler:^(NSEvent *event) {
        if([self.emotionFinder processMouseInput])
            [self.theGrabber grabPhoto:self.emotionFinder.confirmedEmotion];
    }];
    
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSRightMouseDragged handler:^(NSEvent *event) {
        if([self.emotionFinder processMouseInput])
            [self.theGrabber grabPhoto:self.emotionFinder.confirmedEmotion];
    }];
    
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSOtherMouseDragged handler:^(NSEvent *event) {
        if([self.emotionFinder processMouseInput])
            [self.theGrabber grabPhoto:self.emotionFinder.confirmedEmotion];
    }];
    
    

}

@end
