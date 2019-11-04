//
//  SearchSongRouter.swift
//  iOSArchitecturesDemo
//
//  Created by Mac on 03.11.2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import UIKit

protocol SearchSongRouterProtocol: class {
    
    func openPlayer(song: ITunesSong, allSongs: [ITunesSong])
}

class SearchSongRouter: SearchSongRouterProtocol {
    
    weak var view: UIViewController?
    
    internal func openPlayer(song: ITunesSong, allSongs: [ITunesSong]) {
        let viewModel: PlayerViewModelProtocol = PlayerViewModel(song: song, allSongs: allSongs)
        let viewController = PlayerViewController(viewModel: viewModel)
//        appDetaillViewController.app = self.app
        self.push(viewController: viewController)
    }
    
    
    private func push(viewController: UIViewController) {
        view?.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
