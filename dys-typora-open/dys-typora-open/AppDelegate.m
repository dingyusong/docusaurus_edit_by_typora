//
//  AppDelegate.m
//  EditMarkDown
//
//  Created by 丁玉松 on 2018/9/24.
//  Copyright © 2018年 丁玉松. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (weak) IBOutlet NSMenu *statusMenu;
@property (nonatomic, strong) NSStatusItem *statusItem;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
        
    NSStatusItem *statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    statusItem.button.image = [NSImage imageNamed:@"statusIcon"];
    statusItem.menu = self.statusMenu;
    self.statusItem = statusItem;
    
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector(handleURLEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
}

- (void)handleURLEvent:(NSAppleEventDescriptor*)theEvent withReplyEvent:(NSAppleEventDescriptor*)replyEvent {
    NSString* path = [[theEvent paramDescriptorForKeyword:keyDirectObject] stringValue];
    NSURL *url = [NSURL URLWithString:path];
    NSString *orignPath = [url.absoluteString substringFromIndex:18];
    NSString *transString = [orignPath stringByRemovingPercentEncoding];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),transString];
    [self openMDFileWithTypora:filePath];
}

- (NSString *)openMDFileWithTypora:(NSString *)filePath
{
    NSTask *task = [[NSTask alloc] init];

    [task setLaunchPath: @"/usr/bin/open"];
    NSArray *arguments = [NSArray arrayWithObjects: @"-aTypora", filePath, nil];
    [task setArguments: arguments];
    
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    [task launch];
    
    NSData *data = [file readDataToEndOfFile];
    return [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
}


- (IBAction)quit:(id)sender {
    [NSApplication.sharedApplication terminate:self];
}

@end
