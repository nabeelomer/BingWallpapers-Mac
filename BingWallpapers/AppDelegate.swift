//
//  AppDelegate.swift
//  BingWallpapers
//
//  Created by Nabeel Omer on 06/05/18.
//  Copyright © 2018 Nabeel Omer. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let popover = NSPopover()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("Image"))
            button.action = #selector(buttonHandler(_:))
        }
        popover.contentViewController = BingViewController.freshController()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func buttonHandler(_ Sender: Any?) {
        if !popover.isShown {
            popover.show(relativeTo: statusItem.button!.bounds, of: statusItem.button!, preferredEdge: NSRectEdge.minY)
        } else {
            popover.performClose(Sender)
        }
    }
}
