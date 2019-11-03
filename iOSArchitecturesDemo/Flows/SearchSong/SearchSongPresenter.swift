//
//  SearchSongPresenter.swift
//  iOSArchitecturesDemo
//
//  Created by Mac on 02.11.2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import UIKit

protocol SearchSongPresenterProtocol: class {
    var itemsCount: Int { get }
    
    init(interactor: SearchSongInteractorProtocol, router: SearchSongRouterProtocol)
    func didSelect(row: Int)
    func didEntered(query: String?)
    func getCellPresenter(for row: Int) -> SongCellPresenterProtocol
    
}

class SearchSongPresenter {
    
    weak var view: SearchSongViewProtocol?
    private var interactor: SearchSongInteractorProtocol!
    private var router: SearchSongRouterProtocol!
    
    private var cellPresenters: [SongCellPresenterProtocol] = []
    
    required init(interactor: SearchSongInteractorProtocol, router: SearchSongRouterProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
}

//MARK: - SearchSongPresenterProtocol
extension SearchSongPresenter: SearchSongPresenterProtocol {
    
    var itemsCount: Int {
        return cellPresenters.count
    }
    
    internal func getCellPresenter(for row: Int) -> SongCellPresenterProtocol {
        return cellPresenters[row]
    }
    
    internal func didEntered(query: String?) {
        guard let query = query,
            query.count != 0 else {
                self.view?.updateSearchBar(true)
                return
        }
        self.requestSongs(with: query)
    }
    
    func didSelect(row: Int) {
        guard row < cellPresenters.count else { return }
        let song = cellPresenters[row].getSong()
        self.router.openPlayer(song: song)
    }
    
}

//MARK: - Private functions
extension SearchSongPresenter {
    
    private func requestSongs(with query: String) {
        self.view?.updateThrobber(isShow: true)
        self.cellPresenters.removeAll()
        self.view?.updateTableView()
        
        self.interactor.getSongs(query: query) { [weak self] (cellPresenters, error) in
            DispatchQueue.main.async {
                if let error = error {
                    self?.view?.show(error: error)
                } else if let cellPresenters = cellPresenters {
                    self?.handleGet(cellPresenters: cellPresenters)
                }
            }
        }
    }
    
    
    private func handleGet(cellPresenters: [SongCellPresenterProtocol]) {
        self.cellPresenters = cellPresenters
        if cellPresenters.count <= 0 {
            self.view?.updateEmptyResults(isHide: false)
        } else {
            self.view?.updateEmptyResults(isHide: true)
            self.view?.updateTableView()
        }
    }
    
}
