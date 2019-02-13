//
//  ViewController.swift
//  Lobsters Bar
//
//  Created by Phuc Le Dien on 1/24/19.
//  Copyright © 2019 phucledien. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa
import SnapKit

class MainViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet weak var boxHeader: NSBox!
    @IBOutlet weak var lblUpdateTime: NSTextField!
    
    @IBAction func btnMenuDidPressed(_ sender: NSButton) {
        let p = NSPoint(x: sender.frame.origin.x, y: sender.frame.origin.y - (sender.frame.height / 2))
        appMenu.popUp(positioning: nil, at: p, in: sender.superview)
    }
    
    @IBAction func btnRefreshDidPressed(_ sender: Any) {
        fetchData()
    }
    
    private var dataSource: [Post] = []
    private let disposeBag = DisposeBag()
    private var timer = RepeatingTimer(timeInterval: 60*10) // every 10 mins
    private let appMenu = NSMenu()
    private var prefWindowIsOpen = false
    private var updateDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupMenu()
        updateTimer()
        tableView.delegate = self
        tableView.dataSource = self
        fetchData()
        handleNotification()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        setupLabelTime()
    }
    
    private func setupLabelTime() {
        lblUpdateTime.stringValue = updateDate.timeAgoDisplay()
    }

    private func setupUI() {
        progressIndicator.wantsLayer = true
        progressIndicator.layer?.backgroundColor = NSColor.clear.cgColor
        view.wantsLayer = true
        view.layer?.backgroundColor = .white
        let headerGradientLayer = CAGradientLayer()
        headerGradientLayer.colors = [#colorLiteral(red: 0.9294117647, green: 0.9254901961, blue: 0.9294117647, alpha: 1), #colorLiteral(red: 0.8235294118, green: 0.8196078431, blue: 0.8235294118, alpha: 1)]
        headerGradientLayer.type = .axial
        headerGradientLayer.frame = boxHeader.bounds
        let customView = NSView()
        customView.frame = boxHeader.bounds
        customView.layer = headerGradientLayer
        customView.wantsLayer = true
        boxHeader.addSubview(customView)
    }
    
    private func setupMenu() {
        appMenu.addItem(NSMenuItem(title: "Preferences", action: #selector(openPreferences), keyEquivalent: "p"))
        appMenu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApp.terminate(_:)), keyEquivalent: "q"))
    }
    
    private func handleNotification() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: NotificationCenter.Name.settingDidChanged), object: nil, queue: nil) { [weak self] (notification) in
            self?.updateTimer()
        }
    }
    
    private func updateTimer() {
        let time = Setting.timeToRefresh
        timer = RepeatingTimer(timeInterval: 60 * Double(time))
        timer.eventHandler = { [weak self] in
            self?.fetchData(inBackground: true)
        }
        timer.resume()
    }
    
    func isPrefOpened() -> Bool {
        let options = CGWindowListOption(arrayLiteral: .excludeDesktopElements, .optionOnScreenOnly)
        let windowsListInfo = CGWindowListCopyWindowInfo(options, CGWindowID(0))
        let infoList = windowsListInfo as! [[String:Any]]
        let names = infoList.map { dict in
            return dict["kCGWindowOwnerName"] as? String
            }.filter({ (name) -> Bool in
                name == "Lobsters Bar"
            })
        return names.count == 3
    }
    
    @objc private func openPreferences() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationCenter.Name.preferencesOpened), object: nil)
        if isPrefOpened() { return }
        let vc = PreferencesViewController.initWithStoryboard()
        let window = NSWindow(contentViewController: vc)
        window.title = "Preferences"
        window.setFrameOrigin(NSPoint(x: 480, y: 305))
        window.backgroundColor = #colorLiteral(red: 0.2392156863, green: 0.2392156863, blue: 0.2666666667, alpha: 1)
        window.styleMask = [.titled, .closable, .miniaturizable]
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.makeKeyAndOrderFront(self)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    private func fetchData(inBackground: Bool = false) {
        // foreground
        if !inBackground {
            progressIndicator.isHidden = false
            progressIndicator.startAnimation(self)
        }
        NetworkAdapter.getFrontpage()
            .subscribe(onNext: { [weak self] posts in
                guard let strongSelf = self else {return}
                if !inBackground {
                    strongSelf.progressIndicator.isHidden = true
                    strongSelf.setupLabelTime()
                }
                strongSelf.dataSource = posts
                strongSelf.tableView.reloadData()
                strongSelf.updateDate = Date()
                }, onError: { error in
                    print(error.description())
            })
            .disposed(by: disposeBag)
    }
}

extension MainViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dataSource.count
    }
}

extension MainViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "PostTableCellView"), owner: self) as! PostTableRowView
        cell.set(post: dataSource[row])
        return cell
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        if let url = URL(string: dataSource[row].url) {
            NSWorkspace.shared.open(url)
        }
        tableView.deselectRow(row)
        return true
    }
}

extension MainViewController {
    // MARK: Storyboard instantiation
    static func initWithStoryboard() -> MainViewController {
        let vc = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "MainViewController") as! MainViewController
        return vc
    }
}
