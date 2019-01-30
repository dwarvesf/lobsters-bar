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
    
    override func viewWillAppear() {
        super.viewWillAppear()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    private func setupUI() {
        progressIndicator.wantsLayer = true
        progressIndicator.layer?.backgroundColor = NSColor.clear.cgColor
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
            self?.fetchDataBackground()
        }
        timer.resume()
    }
    
    @objc private func openPreferences() {
        let vc = PreferencesViewController.initWithStoryboard()
        let window = NSWindow(contentViewController: vc)
        window.title = "Preferences"
        window.styleMask = [.titled, .closable, .miniaturizable]
        window.makeKeyAndOrderFront(self)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    private func fetchDataBackground() {
        NetworkAdapter.getFrontpage()
            .subscribe(onNext: { [weak self] posts in
                guard let strongSelf = self else {return}
                strongSelf.dataSource = posts
                strongSelf.tableView.reloadData()
            }, onError: { error in
                print(error.description())
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchData() {
        progressIndicator.isHidden = false
        progressIndicator.startAnimation(self)
        NetworkAdapter.getFrontpage()
            .subscribe(onNext: { [weak self] posts in
                guard let strongSelf = self else {return}
                strongSelf.progressIndicator.isHidden = true
                strongSelf.dataSource = posts
                strongSelf.tableView.reloadData()
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
