//
//  PreferencesViewController.swift
//  Lobsters Bar
//
//  Created by Phuc Le Dien on 1/30/19.
//  Copyright © 2019 phucledien. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {

    @IBOutlet weak var popUpTime: NSPopUpButton!
    @IBOutlet weak var btnAutoStart: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showExistingPrefs()
    }
    
    class func initWithStoryboard() -> PreferencesViewController {
        let vc = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "PreferencesViewController") as! PreferencesViewController
        return vc
    }
    
    private func showExistingPrefs () {
        let selectedTimeInMinutes = Setting.timeToRefresh
        for item in popUpTime.itemArray {
            if item.tag == selectedTimeInMinutes {
                popUpTime.select(item)
                break
            }
        }
        
        let isAutoStartup = Setting.isAutoStart
        btnAutoStart.state = isAutoStartup ? .on : .off
    }
    
    @IBAction func autoStartDidChanged(_ sender: NSButton) {
        switch sender.state {
        case .on:
            Setting.isAutoStart = true
        case .off:
            Setting.isAutoStart = false
        default:
            break
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationCenter.Name.settingDidChanged), object: nil)
    }
    
    @IBAction func popUpDidChanged(_ sender: NSPopUpButton) {
        Setting.timeToRefresh = sender.selectedTag()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationCenter.Name.settingDidChanged), object: nil)
    }
}
