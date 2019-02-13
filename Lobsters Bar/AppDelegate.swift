//
//  AppDelegate.swift
//  Lobsters Bar
//
//  Created by Phuc Le Dien on 1/24/19.
//  Copyright © 2019 phucledien. All rights reserved.
//

import Cocoa
import ServiceManagement

extension Notification.Name {
    static let killLauncher = Notification.Name("killLauncher")
}


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {

        // Check launcher is running
        let launcherAppId = "com.dwarvesf.LauncherApplication"
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == launcherAppId }.isEmpty
        
        SMLoginItemSetEnabled(launcherAppId as CFString, Setting.isAutoStart)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: NotificationCenter.Name.settingDidChanged), object: nil, queue: nil) { (notification) in
            SMLoginItemSetEnabled(launcherAppId as CFString, Setting.isAutoStart)
        }
        
        if isRunning {
            DistributedNotificationCenter.default().post(name: .killLauncher,
                                                         object: Bundle.main.bundleIdentifier!)
        }
        
        // Setup statusItem
        if let button = statusItem.button {
            button.image = #imageLiteral(resourceName: "StatusBarButtonImage")
            button.action = #selector(self.doSomeAction(sender:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        // Setup popover
        popover.appearance = NSAppearance(named: NSAppearance.Name.aqua)
        popover.contentViewController = MainViewController.initWithStoryboard()
        
        // Setup event monitor
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover(sender: event)
            }
        }
        
        // Show preferences window in the first time start app
        let isFirstTimeStart = UserDefaults.standard.value(forKey: UserDefaults.Name.isFirstTimeStart) as? Bool ?? true
        if isFirstTimeStart {
            showPreferencesWindow()
            UserDefaults.standard.set(false, forKey: UserDefaults.Name.isFirstTimeStart)
        }
        
        // Observe pref open so close the popover
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: NotificationCenter.Name.preferencesOpened), object: nil, queue: nil) { [weak self] (notification) in
            self?.closePopover(sender: self)
        }
    }
    
    @objc func doSomeAction(sender: NSStatusItem) {

        let event = NSApp.currentEvent!
        if event.type == NSEvent.EventType.rightMouseUp{
            // Right button click
            togglePopover(self)
        } else {
            // Left button click
            togglePopover(self)
        }
    }
    
    func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            eventMonitor?.start()
            button.highlight(true)
        }
    }
    
    func closePopover(sender: Any?) {

        popover.performClose(sender)
        eventMonitor?.stop()
        if let button = statusItem.button {
            button.highlight(false)
        }
    }
    
    func showPreferencesWindow() {
        let vc = PreferencesViewController.initWithStoryboard()
        let window = NSWindow(contentViewController: vc)
        window.title = "Preferences"
        window.backgroundColor = #colorLiteral(red: 0.2392156863, green: 0.2392156863, blue: 0.2666666667, alpha: 1)
        window.setFrameOrigin(NSPoint(x: 480, y: 305))
        window.styleMask = [.titled, .closable, .miniaturizable]
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.makeKeyAndOrderFront(self)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

