//
//  AppDelegate.swift
//  Clipeus
//
//  Created by lucky on 13.07.2022.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    private var statusItem: NSStatusItem!
    private var menu: NSMenu!
    private var nc: NotificationCenter!
    private var dnc: NotificationCenter!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupMenu()
        setupNotificationCenter()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        nc.removeObserver(self)
        dnc.removeObserver(self)
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication)
        -> Bool { return true }

    func setupMenu() {
        statusItem = NSStatusBar
            .system
            .statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(named: "MenuImage")
            button.action = #selector(actionClick(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
            
        }
        menu = NSMenu()
        menu.delegate = self
        menu.addItem(NSMenuItem(
            title: "Quit",
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "q"
        ))
    }
    
    func setupNotificationCenter() {
        nc = NSWorkspace.shared.notificationCenter
        nc.addObserver(
            self,
            selector: #selector(screenEvent),
            name: NSWorkspace.screensDidSleepNotification,
            object: nil
        )
        dnc = DistributedNotificationCenter.default()
        dnc.addObserver(
            self,
            selector: #selector(screenEvent),
            name: .init("com.apple.screenIsLocked"),
            object: nil
        )
    }
    
    @objc func actionClick(_ sender: NSStatusBarButton) {
        let event = NSApp.currentEvent!
        if event.type == .rightMouseUp {
            statusItem.menu = menu
            statusItem.button?.performClick(nil)
        } else { clearClipboard() }
    }
    
    @objc func menuDidClose(_ menu: NSMenu) { statusItem.menu = nil }
    @objc func screenEvent() { clearClipboard() }
    func clearClipboard() { NSPasteboard.general.clearContents() }
}
