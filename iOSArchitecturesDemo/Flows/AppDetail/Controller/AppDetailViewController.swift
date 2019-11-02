//
//  AppDetailViewController.swift
//  iOSArchitecturesDemo
//
//  Created by ekireev on 20.02.2018.
//  Copyright © 2018 ekireev. All rights reserved.
//

import UIKit

class ITunesAppAdapter: HeaderInfo {
    private let app: ITunesApp
    private let imageDownloader = ImageDownloader()
    
    
    init(app: ITunesApp) {
        self.app = app
    }
    
    
    func loadImage(completion: @escaping (UIImage?) -> Void ) {
        guard let url = self.app.iconUrl else {
            completion(nil)
            return
        }
        self.imageDownloader.getImage(fromUrl: url) { (image, error) in
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    func title() -> String {
        return app.appName
    }
    
    func description() -> String {
        return app.appDescription ?? ""
    }
}



final class AppDetailViewController: UIViewController {
    
    private var headerViewController: HeaderInfoViewController?
    private var headerView: UIView?
    
    private var updateViewController: UpdateViewController?
    private var updateView: UIView?
    
    private var screenshotsViewController: ScreenshotsViewController?
    private var screenshotsView: UIView?
    
    public var app: ITunesApp? {
        didSet {
            self.updateHeader()
            self.configureUdpateView()
            self.configureScreenshotsView()
        }
    }
    
    private let imageDownloader = ImageDownloader()
    
    private var appDetailView: AppDetailView {
        return self.view as! AppDetailView
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = AppDetailView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationController()
        self.addHeader()
        self.addUpdateView()
        self.addScreenshotsView()
    }
    
    private func configureNavigationController() {
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationItem.largeTitleDisplayMode = .never
    }
}

// MARK: - Add Header
extension AppDetailViewController {
    
    private func addHeader() {
        if nil != headerViewController {
            return
        }
        
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(headerView)
        self.headerView = headerView
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            headerView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)])
        
        headerView.addConstraint( NSLayoutConstraint(item: headerView,
                                                     attribute: .height,
                                                     relatedBy: .equal,
                                                     toItem: nil,
                                                     attribute: .notAnAttribute,
                                                     multiplier: 1,
                                                     constant: 100) )
        
        
        let headerViewController = HeaderInfoViewController()
        self.addChild(headerViewController)
        headerViewController.didMove(toParent: self)
        headerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(headerViewController.view)
        self.headerViewController = headerViewController
        
        NSLayoutConstraint.activate([
            headerViewController.view.topAnchor.constraint(equalTo: headerView.topAnchor),
            headerViewController.view.leftAnchor.constraint(equalTo: headerView.leftAnchor),
            headerViewController.view.rightAnchor.constraint(equalTo: headerView.rightAnchor),
            headerViewController.view.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)])
        
        self.updateHeader()
    }
    
    private func updateHeader() {
        if let app = self.app {
            self.headerViewController?.headerInfo = ITunesAppAdapter(app: app)
        }
    }
    
}

// MARK: - Add UpdateView
extension AppDetailViewController {
    
    private func addUpdateView() {
        if nil != updateViewController {
            return
        }
        
        let updateView = UIView()
        updateView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(updateView)
        self.updateView = updateView
        self.setUpdateViewConstraints()
        
        let updateViewController = UpdateViewController()
        self.addChild(updateViewController)
        updateViewController.didMove(toParent: self)
        updateViewController.view.translatesAutoresizingMaskIntoConstraints = false
        updateView.addSubview(updateViewController.view)
        self.updateViewController = updateViewController
        self.setUpdateViewControllerConstraints()
        
        self.configureUdpateView()
    }
    
    private func configureUdpateView() {
        if let app = self.app {
            self.updateViewController?.presenter = UpdatePresenter(app: app)
        }
    }
    
    
    private func setUpdateViewConstraints() {
        guard let updateView = updateView,
        let headerView = headerView else { return }
        NSLayoutConstraint.activate([
            updateView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            updateView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            updateView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)])
        
        updateView.addConstraint( NSLayoutConstraint(item: updateView,
                                                     attribute: .height,
                                                     relatedBy: .equal,
                                                     toItem: nil,
                                                     attribute: .notAnAttribute,
                                                     multiplier: 1,
                                                     constant: 160))
    }

    private func setUpdateViewControllerConstraints() {
        guard let updateView = self.updateView,
            let updateViewController = self.updateViewController else { return }
        NSLayoutConstraint.activate([
            updateViewController.view.topAnchor.constraint(equalTo: updateView.topAnchor),
            updateViewController.view.leftAnchor.constraint(equalTo: updateView.leftAnchor),
            updateViewController.view.rightAnchor.constraint(equalTo: updateView.rightAnchor),
            updateViewController.view.bottomAnchor.constraint(equalTo: updateView.bottomAnchor)])
    }
    
}

// MARK: - Add ScreenshotsView
extension AppDetailViewController {
    
    private func addScreenshotsView() {
        if nil != screenshotsViewController {
            return
        }
        
        let screenshotsView = UIView()
        screenshotsView.translatesAutoresizingMaskIntoConstraints = false
        screenshotsView.backgroundColor = UIColor.red
        
        self.view.addSubview(screenshotsView)
        self.screenshotsView = screenshotsView
        self.setScreenshotsViewConstraints()
        
        let screenshotsViewController = ScreenshotsViewController()
        self.addChild(screenshotsViewController)
        screenshotsViewController.didMove(toParent: self)
        screenshotsViewController.view.translatesAutoresizingMaskIntoConstraints = false
        screenshotsView.addSubview(screenshotsViewController.view)
        self.screenshotsViewController = screenshotsViewController
        self.setScreenshotsViewControllerConstraints()
        
        self.configureScreenshotsView()
    }
    
    private func configureScreenshotsView() {
        if let app = self.app {
            self.screenshotsViewController?.presenter = ScreenshotsPresenter(app: app)
        }
    }
    
    
    private func setScreenshotsViewConstraints() {
        guard let screenshotsView = screenshotsView,
        let updateView = updateView else { return }
        NSLayoutConstraint.activate([
            screenshotsView.topAnchor.constraint(equalTo: updateView.bottomAnchor),
            screenshotsView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            screenshotsView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
        screenshotsView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)])
        
//        screenshotsView.addConstraint( NSLayoutConstraint(item: screenshotsView,
//                                                     attribute: .height,
//                                                     relatedBy: .equal,
//                                                     toItem: nil,
//                                                     attribute: .notAnAttribute,
//                                                     multiplier: 1,
//                                                     constant: 100))
    }

    private func setScreenshotsViewControllerConstraints() {
        guard let screenshotsView = self.screenshotsView,
            let screenshotsViewController = self.screenshotsViewController else { return }
        NSLayoutConstraint.activate([
            screenshotsViewController.view.topAnchor.constraint(equalTo: screenshotsView.topAnchor),
            screenshotsViewController.view.leftAnchor.constraint(equalTo: screenshotsView.leftAnchor),
            screenshotsViewController.view.rightAnchor.constraint(equalTo: screenshotsView.rightAnchor),
            screenshotsViewController.view.bottomAnchor.constraint(equalTo: screenshotsView.bottomAnchor)])
    }
    
}
