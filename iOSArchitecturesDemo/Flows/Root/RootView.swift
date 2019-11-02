//
//  RootView.swift
//  iOSArchitecturesDemo
//
//  Created by Mac on 02.11.2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import UIKit

class RootView: UIViewController {
    
    private let buttonApps = UIButton()
    private let buttonSongs = UIButton()
    
    let buttonAppsText = "Find Apps"
    let buttonSongsText = "Find Songs"
    
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

extension RootView {
    
    internal func showSearchApps() {
        let viewController = SearchViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    internal func showSearchSongs() {
        let viewController = SearchSongView()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension RootView {
    
    @objc func buttonAppsClicked() {
        showSearchApps()
    }
    
    @objc func buttonSongsClicked() {
        showSearchSongs()
    }
    
}

extension RootView {
    
    private func configureUI() {
        self.buttonApps.setTitle(buttonAppsText, for: .normal)
        self.buttonApps.setTitle(buttonAppsText, for: .highlighted)
        self.buttonApps.setTitleColor(UIColor.blue, for: .normal)
        self.buttonApps.setTitleColor(UIColor.lightText, for: .highlighted)
        self.buttonApps.translatesAutoresizingMaskIntoConstraints = false
        self.buttonApps.addTarget(self, action:#selector(self.buttonAppsClicked), for: .touchUpInside)
        self.view.addSubview(buttonApps)

        self.buttonSongs.setTitle(buttonSongsText, for: .normal)
        self.buttonSongs.setTitle(buttonSongsText, for: .highlighted)
        self.buttonSongs.setTitleColor(UIColor.blue, for: .normal)
        self.buttonSongs.setTitleColor(UIColor.lightText, for: .highlighted)
        self.buttonSongs.translatesAutoresizingMaskIntoConstraints = false
        self.buttonSongs.addTarget(self, action:#selector(self.buttonSongsClicked), for: .touchUpInside)
        self.view.addSubview(buttonSongs)
        
        addConstraints()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
        self.buttonApps.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
        self.buttonApps.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
        self.buttonApps.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -35),
        self.buttonApps.heightAnchor.constraint(equalToConstant: 60),
        
        self.buttonSongs.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
        self.buttonSongs.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
        self.buttonSongs.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 35),
        self.buttonSongs.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
