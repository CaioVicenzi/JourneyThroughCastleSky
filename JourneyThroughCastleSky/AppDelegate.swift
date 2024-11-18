//
//  AppDelegate.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 11/09/24.
//


import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApplication.shared.windows.first?.toggleFullScreen(nil)
        NSApplication.shared.windows.first?.isMovable = false
        NSApplication.shared.windows.first?.styleMask.remove(.resizable)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
